# Einrichtung

Diese Anleitung führt durch die ersten Schritte mit OpenTofu und Ansible. Am Ende läuft eine Test-VM mit Debian 13 und der Basisrolle.

## Voraussetzungen

- Zugang zu OpenNebula mit Benutzername und Passwort
- Eine Vorlage mit Debian 13 in OpenNebula, zum Beispiel aus dem Marketplace importiert
- Die Namen der Hosts in OpenNebula und des Netzes, das sie gemeinsam nutzen
- Ein öffentlicher SSH-Schlüssel auf GitHub für jeden Admin in [admins.yml](../ansible/group_vars/all/admins.yml)
- VS Code mit Devcontainer oder ein Rechner mit OpenTofu und Ansible

## 1 Devcontainer öffnen

Das Repo in VS Code öffnen und im Devcontainer neu öffnen. Beim ersten Start installiert [post-create.sh](../.devcontainer/post-create.sh) OpenTofu, just, Ansible, ansible-lint und die benötigten Collections. Alle Befehle stehen als Rezepte im [Justfile](../Justfile). In VS Code stehen sie zusätzlich als Tasks im Menü Terminal unter Task ausführen, definiert in [tasks.json](../.vscode/tasks.json). Eine Übersicht im Terminal zeigt:

```bash
just
```

## 2 Geheimnisse setzen

Zugangsdaten gehören nie ins Repo. Sie liegen in Vaultwarden und lokal in Dateien, die in der .gitignore stehen.

```bash
just setup
```

Das legt tofu/.env und tofu/terraform.tfvars aus den Vorlagen an, falls sie fehlen. In tofu/.env tragt ihr die Zugangsdaten zu OpenNebula und die Passphrase für den State ein, die mindestens 16 Zeichen lang sein muss. Statt des Passworts für OpenNebula nehmt ihr besser einen [Login-Token](https://docs.opennebula.io/7.4/product/cloud_system_administration/multitenancy/manage_users/) mit Ablaufzeit und auf eure Gruppe beschränkt, erzeugt mit `oneuser token-create --time <sekunden> --group <gruppe>`. Er lässt sich jederzeit mit `oneuser token-delete` widerrufen. In tofu/terraform.tfvars stehen der Name der Debian-Vorlage und die Standorte. Ein Standort fasst Hosts zusammen, die dasselbe Netz nutzen. Jede VM in vms.tf verweist auf einen Standort und landet nur auf dessen Hosts. Die Datei enthält keine Geheimnisse und wird committet. Das Passwort für den Ansible Vault legt ihr als Datei ansible/.vault_pass ab.

Die Rezepte laden tofu/.env über [env.sh](../tofu/env.sh) und richten dabei die Verschlüsselung des State ein. Die Namen pbkdf2.main und aes_gcm.main in env.sh dürfen nach dem ersten Lauf nicht mehr geändert werden, sonst lässt sich der State nicht mehr lesen.

Was es in OpenNebula gibt, zeigt eine Übersicht über die API. Sie nutzt dieselben Zugangsdaten aus tofu/.env und ändert nichts.

```bash
just overview
just overview cluster netze
```

Daraus übernehmt ihr die Namen von Vorlage, Clustern und Netzen in tofu/terraform.tfvars.

## 3 Test-VM anlegen

```bash
just init
just plan
just apply
```

[vms.tf](../tofu/vms.tf) enthält zunächst nur die VM test. Die SSH-Schlüssel der Admins holt OpenTofu von GitHub und übergibt sie über die Contextualization von OpenNebula an root. `just apply` fragt vorher nach, prüft danach, dass der State verschlüsselt ist, und committet und pusht State, Lock-Datei und Inventar. Die IP-Adressen zeigt:

```bash
just ips
```

## 4 Basisrolle ausrollen

Der erste Lauf geht als root, weil es die Konten der Admins noch nicht gibt.

```bash
just bootstrap
```

Danach prüft jeder Admin, dass er sich mit dem eigenen Konto anmelden und sudo nutzen kann.

```bash
ssh <benutzer>@<ip>
sudo -v
```

Erst wenn das für alle klappt, wird in group_vars `base_disable_root_login: true` gesetzt und die Basisrolle noch einmal mit dem eigenen Konto ausgerollt. Ein Probelauf zeigt vorher die Änderungen.

```bash
just check <benutzer>
just deploy <benutzer>
```

Mit einem zweiten Argument lässt sich der Lauf auf einen Host oder eine Gruppe begrenzen, zum Beispiel `just deploy igami test`.

## 5 State synchronisieren

Der State von OpenTofu liegt verschlüsselt als tofu/terraform.tfstate im Repo. Weil versions.tf unverschlüsselte States verweigert, kann ohne die Passphrase kein Klartext entstehen. Eine Sperre gegen gleichzeitige Änderungen gibt es dabei nicht. Deshalb gilt:

1. Vor `just apply` im Admin-Chat Bescheid geben, dass man gerade OpenTofu ausführt.
2. Änderungen an den .tf-Dateien vorher committen.
3. `just plan` und `just apply` holen vorher den neuesten Stand, `just apply` pusht den State direkt danach.

Ob der State verschlüsselt ist, prüft auch einzeln:

```bash
just state-check
```

Kommt es doch zu einem Konflikt im State, wird er nicht von Hand zusammengeführt. Stattdessen nimmt man den Stand vom Server und führt `just apply` erneut aus.

## 6 Prüfen und aufräumen

Vor jedem Commit prüft `just lint` die Formatierung und die Konfiguration von OpenTofu und Ansible, `just fmt` formatiert die .tf-Dateien.

Eine VM wird gelöscht, indem man ihren Eintrag aus [vms.tf](../tofu/vms.tf) entfernt und `just apply` ausführt. Der Plan zeigt dann genau diese VM als zu löschen an, alle anderen bleiben unberührt. Ein Rezept für `tofu destroy` gibt es bewusst nicht, weil es alle VMs auf einmal löschen würde.

## Offene Punkte

- **Backend mit Sperre.** Sobald die Verwaltungs-VM steht, zieht der State in ein S3-Backend mit Sperre über `use_lockfile`, zum Beispiel mit Garage oder MinIO. Dann kann auch die CI OpenTofu ausführen.
- **Rechte in OpenNebula.** Für OpenTofu lohnt sich ein eigener Benutzer in OpenNebula, der nur die VMs dieses Repos verwalten darf.
