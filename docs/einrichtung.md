# Einrichtung

Diese Anleitung führt durch die ersten Schritte mit OpenTofu und Ansible. Am Ende läuft eine Test-VM mit Debian 13 und der Basisrolle.

## Voraussetzungen

- Zugang zu OpenNebula mit Benutzername und Passwort
- Eine Vorlage mit Debian 13 in OpenNebula, zum Beispiel aus dem Marketplace importiert
- Der Name des virtuellen Netzes für die VMs
- Ein öffentlicher SSH-Schlüssel auf GitHub für jeden Admin in [admins.yml](../ansible/group_vars/all/admins.yml)
- VS Code mit Devcontainer oder ein Rechner mit OpenTofu und Ansible

## 1 Devcontainer öffnen

Das Repo in VS Code öffnen und im Devcontainer neu öffnen. Beim ersten Start installiert [post-create.sh](../.devcontainer/post-create.sh) OpenTofu, Ansible, ansible-lint und die benötigten Collections.

## 2 Geheimnisse setzen

Zugangsdaten gehören nie ins Repo. Sie kommen als Umgebungsvariablen aus Vaultwarden.

```bash
export OPENNEBULA_ENDPOINT="https://<opennebula>:2633/RPC2"
export OPENNEBULA_USERNAME="<benutzer>"
export OPENNEBULA_PASSWORD="<passwort>"
```

Der State von OpenTofu wird verschlüsselt. Die Passphrase liegt in Vaultwarden und muss mindestens 16 Zeichen lang sein. Die Namen pbkdf2.main und aes_gcm.main dürfen nach dem ersten Lauf nicht mehr geändert werden, sonst lässt sich der State nicht mehr lesen.

```bash
export TOFU_STATE_PASSPHRASE="<passphrase aus vaultwarden>"
export TF_ENCRYPTION=$(cat <<EOT
key_provider "pbkdf2" "main" {
  passphrase = "${TOFU_STATE_PASSPHRASE}"
}
method "aes_gcm" "main" {
  keys = key_provider.pbkdf2.main
}
state {
  method = method.aes_gcm.main
}
plan {
  method = method.aes_gcm.main
}
EOT
)
```

Das Passwort für den Ansible Vault legt ihr als Datei ansible/.vault_pass ab. Sie steht in der .gitignore.

## 3 Test-VM anlegen

```bash
cd tofu
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

[vms.tf](../tofu/vms.tf) enthält zunächst nur die VM test. Die SSH-Schlüssel der Admins holt OpenTofu von GitHub und übergibt sie über die Contextualization von OpenNebula an root. Nach dem Lauf steht die IP in der Ausgabe und das Inventar für Ansible in ansible/inventory/hosts.yml. Die Datei .terraform.lock.hcl wird committet.

## 4 Basisrolle ausrollen

Der erste Lauf geht als root, weil es die Konten der Admins noch nicht gibt.

```bash
cd ../ansible
ansible-playbook site.yml -u root
```

Danach prüft jeder Admin, dass er sich mit dem eigenen Konto anmelden und sudo nutzen kann.

```bash
ssh <benutzer>@<ip>
sudo -v
```

Erst wenn das für alle klappt, wird in group_vars `base_disable_root_login: true` gesetzt und die Basisrolle noch einmal mit dem eigenen Konto ausgerollt.

```bash
ansible-playbook site.yml -u <benutzer>
```

## 5 State synchronisieren

Der State von OpenTofu liegt verschlüsselt als tofu/terraform.tfstate im Repo. Weil versions.tf unverschlüsselte States verweigert, kann ohne TF_ENCRYPTION kein Klartext entstehen. Eine Sperre gegen gleichzeitige Änderungen gibt es dabei nicht. Deshalb gilt:

1. Vor jedem `tofu plan` oder `tofu apply` den neuesten Stand holen.
2. Im Admin-Chat Bescheid geben, dass man gerade OpenTofu ausführt.
3. Direkt nach `tofu apply` den State zusammen mit den Änderungen an den .tf-Dateien und dem Inventar committen und pushen.

```bash
git pull
cd tofu
tofu apply
git add terraform.tfstate .terraform.lock.hcl ../ansible/inventory/hosts.yml *.tf
git commit -m "apply tofu"
git push
```

Vor dem Commit lässt sich prüfen, dass der State wirklich verschlüsselt ist. Ein verschlüsselter State enthält den Schlüssel encrypted_data.

```bash
grep -q encrypted_data terraform.tfstate && echo verschlüsselt
```

Kommt es doch zu einem Konflikt im State, wird er nicht von Hand zusammengeführt. Stattdessen nimmt man den Stand vom Server und führt `tofu apply` erneut aus.

## 6 Aufräumen

Die Test-VM wieder löschen, wenn alles funktioniert.

```bash
cd ../tofu
tofu destroy
```

## Offene Punkte

- **Backend mit Sperre.** Sobald die Verwaltungs-VM steht, zieht der State in ein S3-Backend mit Sperre über `use_lockfile`, zum Beispiel mit Garage oder MinIO. Dann kann auch die CI OpenTofu ausführen.
- **Rechte in OpenNebula.** Für OpenTofu lohnt sich ein eigener Benutzer in OpenNebula, der nur die VMs dieses Repos verwalten darf.
