# Plan für den Neuaufbau der IT

Dieser Plan beschreibt den Neuaufbau der IT des Makerspace Gütersloh. Er ist aus dem Projekt [MANUEL](https://github.com/makerspace-gt/MANUEL/blob/main/PLAN.md) entstanden, geht aber weit darüber hinaus. Bestehende VMs übernehmen wir nicht, alles wird neu aufgesetzt. Die Quellen der eingesetzten Dienste liegen als Submodule unter `upstream/`.

## Grundsätze

- **Öffentlich nur über den NetBird-Proxy, Kritisches nur per VPN.** Dienste für Mitglieder und Gäste sind über den Reverse Proxy von NetBird erreichbar, bei Bedarf mit Anmeldung über authentik. Kritische Dienste sind nur per VPN erreichbar. SSH mit Schlüssel bleibt direkt möglich und ist damit auch der Notzugang. Details stehen im Abschnitt zur Erreichbarkeit.
- **Auf den VMs nur Docker und der NetBird-Client.** Kein Dienst auf einer VM ist direkt aus dem Internet erreichbar, außer SSH. Alle Weboberflächen laufen über den Proxy auf der Zugangs-VM.
- **Alles ist Code.** VMs, Hosts und Dienste entstehen aus diesem Repo. Geheimnisse liegen verschlüsselt im Ansible Vault.
- **Sensible Dienste getrennt von Inhalten der Gäste.** Zugänge und Passwörter liegen nicht auf derselben VM wie Dienste, die E-Mails und Anhänge von außen verarbeiten.

## Entscheidungen

| Frage | Empfehlung | Alternative |
|---|---|---|
| Betrieb von NetBird | Management, Signal, Relay und der [Reverse Proxy von NetBird](https://github.com/netbirdio/netbird/blob/main/proxy/README.md) auf der Zugangs-VM nach der [Anleitung zum Selbsthosten](https://docs.netbird.io/selfhosted/selfhosted-quickstart). Der Proxy ist der einzige öffentliche Einstieg für Weboberflächen. Alle übrigen VMs und der Mini-PC bekommen nur den Client | NetBird Cloud im kostenlosen Tarif |
| Updates der Container | [Arcane](https://getarcane.app) statt watchtower auf allen Hosts. Ein zentraler Arcane-Server verwaltet die Docker-Hosts über Agenten, die sich [ausgehend verbinden](https://github.com/getarcaneapp/arcane/tree/main/docker/examples) und keine offenen Ports brauchen. Arcane erkennt neue Images, aktualisiert nach Zeitplan, meldet per Signal und kann sich an authentik anmelden. Es steht unter BSD-3-Clause. Der Arcane-Server steuert Docker auf allen Hosts und gehört deshalb auf eine gehärtete VM, erreichbar nur über NetBird. Die Compose-Dateien bleiben in Ansible, die GitOps-Funktion von Arcane nutzen wir nicht, damit nicht zwei Werkzeuge dieselben Dateien schreiben. Zammad aktualisieren wir nicht automatisch, sondern nach Hinweis von Arcane von Hand, weil Datenbankmigrationen und unsere Anpassungen geprüft werden müssen | watchtower wie bisher |
| Überwachung der Ressourcen | [Beszel](https://beszel.dev) mit einem Hub neben Uptime Kuma auf der Monitoring-VM und einem Agenten auf jedem Host. Uptime Kuma meldet, ob Dienste erreichbar sind, Beszel meldet volle Platten, knappen Speicher, hohe Last, Temperaturen und SMART-Werte. Die Agenten können sich per WebSocket ausgehend mit dem Hub verbinden. Auf dem Mini-PC liest Beszel auch die [AMD-GPU](https://beszel.dev/guide/gpu) aus. Benachrichtigungen gehen über Shoutrrr, also auch per Signal, und die Anmeldung kann über [OAuth mit authentik](https://beszel.dev/guide/oauth) laufen. Beszel steht unter MIT | Nur Uptime Kuma wie bisher |
| Zentrale Nutzerverwaltung | [authentik](https://github.com/goauthentik/authentik) liegt als Submodul unter upstream/. Es steht weitgehend unter MIT, ein Unternehmensteil unter eigener Lizenz. Laut [Doku zu Integrationen](https://docs.goauthentik.io/integrations/) lassen sich viele unserer Dienste per OpenID Connect oder SAML anbinden. Für MANUEL betrifft das vor allem NetBird, n8n, Open WebUI und Zammad. NetBird kann authentik [als Identity Provider nutzen](https://docs.netbird.io/selfhosted/identity-providers/authentik). NetBird richten wir gleich mit authentik ein statt mit dem eingebauten Dex | Jeder Dienst mit eigenen Konten |
| Wiki | Wiki.js nicht neu aufsetzen. Reparaturanleitungen kommen in die Wissensdatenbank von Zammad, Vereinswissen wie Maschinen, Kenntnisse und Abläufe in [Wiki-Beiträge in Discourse](https://meta.discourse.org/t/what-is-a-wiki-post/30801), wo der KI-Bot sie für Antworten nutzt. Doku zur IT liegt als Markdown in den Repos in Forgejo neben dem Code. Für den Umzug exportiert Wiki.js alle Seiten per [Git-Speicher](https://docs.requarks.io/storage/git) als Markdown. [Wiki.js](https://github.com/Requarks/wiki) wird aktiv entwickelt, Version 3 ist aber seit Jahren im Beta-Stadium | Wiki.js 2 neu aufsetzen und später auf Version 3 umsteigen |
| Testinstanz für Zammad | Test-VM, die OpenTofu nur bei Bedarf anlegt | Direkt im Echtsystem mit eigener Testgruppe |
| Betriebssystem der VMs | [Debian 13](https://www.debian.org/releases/trixie/) aus dem offiziellen [Cloud-Image](https://cloud.debian.org/images/cloud/) für alle Server. Es passt zu unseren apt-Rollen, und Sicherheitsupdates kommen per [unattended-upgrades](https://wiki.debian.org/UnattendedUpgrades). Nur der Mini-PC von MANUEL läuft auf uCore, weil er den neuesten Kernel für die GPU braucht | Ein Image auf Basis von uCore auch für die Server |

## Erreichbarkeit

Dienste sind auf zwei Wegen erreichbar. Kein Dienst öffnet selbst Ports für das Web ins Internet, der öffentliche Verkehr läuft allein über den Proxy auf der Zugangs-VM.

- **Öffentlich über den NetBird-Proxy.** Der [Reverse Proxy von NetBird](https://github.com/netbirdio/netbird/blob/main/proxy/README.md) nimmt Anfragen aus dem Internet an und leitet sie über NetBird an die VM weiter, auf der der Dienst läuft. Pro Dienst lässt sich eine Anmeldung verlangen, bei uns per OIDC über authentik. Einzelne Pfade können ohne Anmeldung durchgereicht oder gesperrt werden, etwa das Webformular von Zammad. Die Zertifikate holt der Proxy selbst per ACME.
- **Nur per VPN.** Kritische Dienste sind nur mit verbundenem NetBird-Client erreichbar. Ihr Name zeigt im öffentlichen DNS auf eine Anleitungsseite, die erklärt, wie man NetBird verbindet. Mit NetBird löst derselbe Name über eine [DNS-Zone von NetBird](https://github.com/netbirdio/netbird/blob/main/shared/management/http/api/openapi.yml) auf die interne Adresse auf. So gilt für jeden Dienst nur eine Adresse. Die Zone wird nur an berechtigte Gruppen verteilt, die Gruppen kommen aus authentik.

Vorschlag für die Zuordnung:

| Dienst | Adresse | Erreichbarkeit | Anmeldung |
|---|---|---|---|
| authentik | auth | Öffentlich direkt, weil die Anmeldung vor dem Tunnel stattfindet. Die Verwaltung nur per VPN | |
| NetBird Management, Signal, Relay, Proxy | netbird | Öffentlich direkt | authentik |
| Zammad | helpdesk | Proxy | authentik für Engagierte, Webformular und Wissensdatenbank ohne Anmeldung |
| Open WebUI | | Proxy | authentik |
| Nextcloud | cloud | Proxy | authentik, öffentliche Freigaben und Kalender ohne Anmeldung |
| Discourse | forum | Proxy | Lesen öffentlich, Anmeldung über authentik |
| Immich | fotos | Proxy | authentik |
| Vikunja | | Proxy | authentik |
| Vaultwarden | vault | Proxy ohne Anmeldung am Proxy, weil die Apps von Bitwarden keine Anmeldung per OIDC vor dem Dienst können. Die Verwaltung unter /admin sperrt der Proxy | Anmeldung über authentik und zusätzlich lokal, laut [Konfiguration](https://github.com/dani-garcia/vaultwarden/blob/main/.env.template) mit `SSO_ENABLED=true` und `SSO_ONLY=false`. Neue Konten nur per Einladung, Zwei-Faktor-Anmeldung für lokale Anmeldung als Pflicht |
| Forgejo | git | Proxy ohne Anmeldung am Proxy, damit öffentliche Repos lesbar bleiben und Git über HTTPS funktioniert | Anmeldung in Forgejo über authentik |
| Uptime Kuma | status | Proxy, die Statusseite ohne Anmeldung, die Verwaltung mit authentik | authentik |
| n8n, Arcane, Dependency-Track, Beszel | | Nur per VPN | authentik, wo möglich |
| LanguageTool | | Nur per VPN, weil die Browser-Erweiterung keine Anmeldung per OIDC kann | |
| Ollama | | Nur per VPN für die Helpdesk-VM und Open WebUI | |
| SSH | | Direkt mit Schlüssel | |

Dafür braucht es:

- **Den Proxy auf der Zugangs-VM.** Er meldet sich laut README per Machine-to-Machine-OAuth beim Management-Server an. Dafür bekommt er in authentik einen eigenen Client.
- **Auf den VMs nur der NetBird-Client.** Die Dienste auf den VMs binden ihre Ports nur an die NetBird-Adresse der VM. Der Proxy erreicht sie über den Tunnel, der den Verkehr ohnehin verschlüsselt. Weiterleitung, Anmeldung und Zertifikate für alle Weboberflächen übernimmt der Proxy, öffentliche wie private. Ein eigenes Traefik braucht keine VM außer der Zugangs-VM. Weil Docker die Firewall des Hosts umgeht, binden die Compose-Stacks Ports ausdrücklich an die NetBird-Adresse, und NetBird startet vor Docker.
- **Zugriff nach Gruppen.** Die [Zugriffsregeln von NetBird](https://docs.netbird.io/manage/access-control) legen fest, welche Gruppe welchen Dienst per VPN erreicht. Admins erreichen alles, Engagierte nur, was sie brauchen.
- **Traefik und CrowdSec als Teil von NetBird.** Die Installation von NetBird bringt Traefik mit und kann CrowdSec zur Prüfung der IP-Adressen zuschalten. Beide laufen auf der Zugangs-VM vor dem Proxy.
- **Private Dienste im Proxy.** Der Proxy kennt Dienste, die nur für NetBird-Teilnehmer erreichbar sind. Darüber laufen die Dienste, die nur per VPN erreichbar sein sollen. Das prüfen wir in Schritt 1 von NetBird.

Für einen Ausfall von NetBird bleibt der Weg über SSH mit Portweiterleitung, damit Admins weiter an Vaultwarden und die übrigen Dienste kommen.

Der Reverse Proxy ist ein noch junger Teil von NetBird. In Schritt 1 und 2 für NetBird prüfen wir, ob er mit authentik und unseren Diensten zuverlässig funktioniert, auch für private Dienste. Falls nicht, bekommen die VMs doch ein eigenes Traefik mit Zertifikaten per [DNS-Challenge](https://doc.traefik.io/traefik/https/acme/) über lima-city, das lego [unterstützt](https://go-acme.github.io/lego/dns/limacity/).

## Angepasste ticket.rb

Die bisherige Rolle zammad im alten Repo docker-compose-server ersetzt die komplette [ticket.rb](https://github.com/makerspace-gt/docker-compose-server/blob/main/roles/zammad/files/app/models/ticket.rb) von Zammad. Die Datei ist eine Kopie aus Zammad 7.1.0 bis 7.1.2 mit rund 770 Zeilen. Gegenüber der [Originaldatei](https://github.com/zammad/zammad/blob/7.1.2/app/models/ticket.rb) ist nur eine Zeile geändert. In der Methode reset_pending_time ist `self.pending_time = nil` auskommentiert. Damit bleibt die Wartezeit eines Tickets erhalten, wenn es den Status warten verlässt. Vermutlich nutzen wir sie als Termin im Repair Café.

Das Problem ist die Kopie, nicht die Änderung. Bei jedem Update von Zammad muss die ganze Datei neu abgeglichen werden. Die [aktuelle ticket.rb](https://github.com/zammad/zammad/blob/develop/app/models/ticket.rb) weicht schon an mehreren Stellen ab, zum Beispiel bei Rechten, Live-Nutzern und dem Zusammenführen von Tickets. Eine veraltete Kopie kann neue Funktionen wie die KI-Agenten still stören.

Beim Neuaufbau übernehmen wir die Kopie nicht. Es gibt zwei bessere Lösungen:

1. **Eigenes Datumsfeld Termin.** Ein Feld vom Typ Datum und Uhrzeit über die [Objektverwaltung](https://admin-docs.zammad.org/en/latest/system/objects.html) braucht gar keinen Patch. Übersichten, Trigger und n8n können es nutzen, und die Terminvorschläge schreiben direkt hinein. Die Wartezeit funktioniert dann wieder wie vorgesehen. Beim Umzug der Daten übernehmen wir bestehende Wartezeiten einmalig per Rails-Konsole in das neue Feld. Das empfehlen wir.
2. **Nur die eine Methode überschreiben.** Statt der ganzen Datei binden wir einen kleinen Initializer in die Container zammad-railsserver und zammad-scheduler ein. Er muss nur angepasst werden, wenn Zammad die Methode umbenennt.

```ruby
# config/initializers/zz_keep_pending_time.rb
# Keep the pending time when a ticket leaves a pending state
Rails.application.config.to_prepare do
  Ticket.class_eval do
    private

    def reset_pending_time
      true
    end
  end
end
```

## Aufteilung und Größe der VMs

Die Aufteilung folgt drei Regeln. Sensible Dienste liegen getrennt von Inhalten der Gäste, was zusammen ausfällt, darf zusammen liegen, und Abhängigkeiten zeigen nur von Fachanwendungen zu Zugang und Monitoring. Die Größen sind Schätzungen für den laufenden Betrieb, nicht die Summe aller Speichergrenzen. Pro VM rechnen wir etwa 1 GB für Betriebssystem, Docker, NetBird-Client, resticker und die Agenten von Arcane und Beszel ein.

| VM | Dienste | RAM | vCPU | Lokale Platte | Grundlage |
|---|---|---|---|---|---|
| Zugang, neu | authentik, NetBird mit Proxy, Traefik und CrowdSec, Vaultwarden | 6 GB | 2 | 30 GB | authentik braucht laut [Installationsanleitung](https://github.com/goauthentik/authentik/blob/main/website/docs/install-config/install/docker-compose.mdx) mindestens 2 GB. NetBird mit Proxy, Traefik und CrowdSec ist der einzige öffentliche Einstieg und bekommt Reserve |
| Verwaltung, neu | Forgejo, Runner, Arcane-Server, Dependency-Track | 10 GB | 4 | 80 GB | Der Runner braucht Platz für Jobs mit Ansible, OpenTofu, Docker und syft. Dependency-Track braucht empfohlen 8 GB, im Verbund reichen etwa 4 GB |
| Helpdesk, neu | Zammad, n8n | 16 GB | 4 | 80 GB | Die [Zammad-Rolle](https://github.com/makerspace-gt/docker-compose-server/blob/main/roles/zammad/templates/.env.j2) erlaubt zusammen rund 13 GB, davon 4 GB für Elasticsearch. Dazu kommt n8n mit 1 bis 2 GB. Zammad speichert Anhänge in der Datenbank, und Elasticsearch hält künftig auch die Vektoren der semantischen Suche |
| Kollaboration, neu | Nextcloud, Vikunja, LanguageTool | 6 GB | 3 | 40 GB | Die Dateien von Nextcloud liegen auf der Storagebox, lokal liegen nur Programme und Datenbanken. Wiki.js entfällt, dafür kommt LanguageTool dazu |
| Fotos, neu | Immich | 6 GB | 4 | 30 GB plus Vorschaubilder | Laut [Anforderungen](https://github.com/immich-app/immich/blob/main/docs/docs/install/requirements.md) mindestens 6 GB und 2 Kerne. Die Datenbank muss auf lokaler SSD liegen und nie auf einem Netzlaufwerk, die Originale können auf die Storagebox |
| Forum, neu | Discourse | 4 GB | 2 | 40 GB | Laut [Installationsanleitung](https://github.com/discourse/discourse/blob/main/docs/INSTALL-cloud.md) mindestens 1 GB mit Swap, empfohlen 2 GB und mehr. Mit discourse-ai und Embeddings eher 4 GB |
| Monitoring, neu | Uptime Kuma, Beszel-Hub, signal-cli-rest-api | 2 GB | 2 | 20 GB | Alle drei sind klein, signal-cli braucht als Java-Programm etwa 0,5 GB |
| Test, bei Bedarf | Testinstanz von Zammad | 8 GB | 2 | 40 GB | Nur bei Bedarf per OpenTofu anlegen und danach wieder löschen |
| Mini-PC | Ollama, Open WebUI, optional Machine Learning für Immich | 64 GB | 12 Kerne | 1 TB | Sprachmodell mit 24 GB, Embedding-Modell, Varianten für den Benchmark |

Zusammen brauchen die dauerhaften VMs etwa 50 GB Arbeitsspeicher und 21 vCPU, mit der Testinstanz 58 GB.

- **Immich kann den Mini-PC mitnutzen.** Immich trennt das Machine Learning für Gesichter und Suche vom Server und kann es [auf einem anderen Rechner](https://github.com/immich-app/immich/blob/main/docs/docs/guides/remote-machine-learning.md) laufen lassen. Mit ROCm nutzt es auch AMD-GPUs, das Image dafür braucht laut [Doku](https://github.com/immich-app/immich/blob/main/docs/docs/features/ml-hardware-acceleration.md) aber 35 GB Platz. Dann bleibt die Immich-VM schlanker, und die Fotos werden trotzdem ausgewertet.
- **Die Storagebox ist ein Netzlaufwerk.** Für die Dateien von Nextcloud und die Originale von Immich ist das in Ordnung. Datenbanken und die Vorschaubilder von Immich gehören auf die lokale Platte. Die Vorschaubilder belegen erfahrungsgemäß einen Bruchteil der Originale, die genaue Größe hängt von der Bibliothek ab.
- **Die Zahlen prüfen wir mit Beszel.** Nach einigen Wochen Betrieb passen wir die Größen an den tatsächlichen Verbrauch an. Mit OpenTofu ist das eine Änderung in Git.

### Neuaufbau

Alle VMs entstehen neu, die Namen der Hosts legen wir beim Anlegen per OpenTofu fest. Die Daten der bestehenden Dienste ziehen trotzdem um, vor allem Tickets aus Zammad, Passwörter aus Vaultwarden, Dateien und Kalender aus Nextcloud, Seiten aus Wiki.js, die je nach Inhalt in Discourse, die Wissensdatenbank von Zammad oder Forgejo wandern, Aufgaben aus Vikunja und Beiträge aus Discourse. Dafür nutzen wir die Backups von resticker und die Aufgaben zur Wiederherstellung, die die Rollen für Zammad, Vaultwarden und Discourse schon mitbringen. Jeder Umzug ist zugleich ein Test der Wiederherstellung. Die alten VMs bleiben bis zur erfolgreichen Prüfung der neuen Dienste stehen.

## Infrastruktur als Code

Langfristig soll die gesamte Infrastruktur aus Git entstehen, von der VM bis zum Dienst. Die Bausteine dafür greifen in drei Schichten ineinander.

| Schicht | Werkzeug | Aufgabe |
|---|---|---|
| VMs | [OpenTofu](https://github.com/opentofu/opentofu) mit dem [Provider für OpenNebula](https://search.opentofu.org/provider/opennebula/opennebula/latest) | VMs mit CPU, Arbeitsspeicher, Platten, Netz und SSH-Schlüsseln in [OpenNebula](https://docs.opennebula.io/stable/) anlegen |
| Hosts und Dienste | Ansible in diesem Repo | Grundsystem, NetBird-Client, Agenten von Arcane und Beszel und die Compose-Stacks der Dienste |
| Updates im Betrieb | Arcane | Neue Images erkennen und nach Regeln aktualisieren |

- **Ein Repo für VMs und Dienste.** Der Code für OpenTofu kommt als Ordner tofu/ in dieses Repo. So ändert ein Commit eine VM und die Dienste darauf gemeinsam. OpenTofu schreibt die Inventardatei für Ansible, alternativ liest Ansible die VMs direkt über das [Inventory-Plugin für OpenNebula](https://github.com/ansible-collections/community.general/blob/main/plugins/inventory/opennebula.py).
- **Der Zustand von OpenTofu enthält Geheimnisse.** Wir verschlüsseln ihn mit der eingebauten [Verschlüsselung des State](https://opentofu.org/docs/language/state/encryption/) und legen den Schlüssel im Ansible Vault ab.
- **Ansible läuft bei jedem Commit.** Ein Runner von [Forgejo Actions](https://forgejo.org/docs/latest/user/actions/overview/) führt die Playbooks aus. Bei einem Pull Request laufen ansible-lint, `ansible-playbook --check --diff` und `tofu plan`. Nach dem Merge auf main laufen nur die Playbooks, deren Rollen sich geändert haben. `tofu apply` und das Playbook für Zammad starten wir von Hand, weil sie VMs löschen oder Datenbanken migrieren können. Bis Forgejo steht, geht dasselbe mit einem [eigenen Runner für GitHub Actions](https://docs.github.com/en/actions/hosting-your-own-runners).
- **Der Runner läuft bei uns, nicht in der Cloud.** Er braucht den SSH-Schlüssel für alle Hosts, das Passwort für den Ansible Vault und den Zugang zu OpenNebula. Diese Geheimnisse gehören nicht zu einem fremden Anbieter. Der [selbst gehostete Runner](https://forgejo.org/docs/latest/admin/actions/runner-installation/) erreicht die Hosts über NetBird.
- **Eigene Forgejo-Instanz.** [Forgejo](https://codeberg.org/forgejo/forgejo) steht unter GPL-3.0 und ist über den Proxy erreichbar, damit Mitglieder und andere Initiativen öffentliche Repos lesen können. Die Anmeldung läuft über [authentik](https://docs.goauthentik.io/integrations/services/forgejo/). Öffentliche Repos wie MANUEL spiegeln wir per [Push-Mirror](https://forgejo.org/docs/latest/user/repo-mirror/) weiter nach GitHub oder Codeberg, damit andere Initiativen sie finden.
- **Eine Verwaltungs-VM für Forgejo, Runner und Arcane-Server.** Alle drei steuern die übrigen Hosts. Sie liegen getrennt von der Zugangs-VM mit authentik, NetBird und Vaultwarden, weil der Runner fremden Code aus Repos ausführt.
- **Henne und Ei.** Die Verwaltungs-VM und Forgejo richten wir einmalig von einem Admin-Rechner aus mit OpenTofu und Ansible ein. Danach übernimmt die CI alle übrigen Hosts. Änderungen an der Verwaltungs-VM selbst laufen weiter von Hand.

## Software-Stückliste

Für den Überblick, welche Bibliotheken in welchem Dienst stecken und unter welcher Lizenz sie stehen, erzeugen wir für jedes laufende Image eine Software-Stückliste, kurz SBOM, im Format [CycloneDX](https://cyclonedx.org/).

| Baustein | Werkzeug | Aufgabe |
|---|---|---|
| Erzeugen | [syft](https://github.com/anchore/syft) | Liest aus jedem Container-Image alle Pakete und Bibliotheken samt Lizenzen und schreibt eine SBOM. syft ist im Devcontainer von Universal Blue schon enthalten |
| Sammeln und auswerten | [Dependency-Track](https://github.com/DependencyTrack/dependency-track) | Zeigt über alle Dienste hinweg, welche Komponente wo verwendet wird, welche Lizenzen vorkommen und welche Schwachstellen bekannt sind. Mit Regeln für Lizenzen, zum Beispiel einer Warnung bei unbekannten oder unerwünschten Lizenzen |
| Schwachstellen im Betrieb | Arcane | Arcane scannt die laufenden Images schon mit [Trivy](https://github.com/aquasecurity/trivy) und meldet Funde |

- **Gemessen wird, was wirklich läuft.** Die SBOM entsteht aus den Images mit ihrem Digest, wie sie auf den Hosts laufen, nicht aus den Quellen in upstream/. So deckt sie auch Abhängigkeiten ab, die erst beim Bauen der Images dazukommen.
- **Der Runner erzeugt die SBOMs automatisch.** Ein nächtlicher Job von Forgejo Actions liest die laufenden Images aus, erzeugt mit syft je eine SBOM und lädt sie nach Dependency-Track hoch. Nach jedem Update durch Arcane ist die Übersicht damit spätestens am nächsten Morgen aktuell.
- **Dependency-Track läuft auf der Verwaltungs-VM.** Der API-Server braucht laut [Doku](https://docs.dependencytrack.org/getting-started/deploy-docker/) mindestens 2 GB und empfohlen 8 GB Arbeitsspeicher, das Frontend ist klein. Die Verwaltungs-VM wächst dadurch auf 10 GB.
- **Eigene Repos kennzeichnen wir nach [REUSE](https://reuse.software/).** Jede Datei bekommt eine SPDX-Angabe zu Lizenz und Urheber. Das betrifft vor allem gemischt lizenzierte Repos wie MANUEL mit CC0 und den Apache-Dateien aus dem image-template.

## Weitere Dienste

- **Discourse als Wissensbasis und Chatbot.** Für das Forum gibt es im alten Repo die Rolle [discourse](https://github.com/makerspace-gt/docker-compose-server/tree/main/roles/discourse). Das mitgelieferte Plugin [discourse-ai](https://github.com/discourse/discourse/tree/main/plugins/discourse-ai) kann Ollama [direkt ansprechen](https://github.com/discourse/discourse/blob/main/plugins/discourse-ai/lib/completions/endpoints/ollama.rb). Es bringt einen KI-Bot mit eigenen Rollen und hinterlegten Dokumenten, Zusammenfassungen, semantische Suche und ähnliche Themen per Embedding mit. Ein Bot im Forum könnte Fragen zu Kenntnissen der Mitglieder und zu Werkzeugen beantworten, gestützt auf Beiträge und Dokumente des Vereins.
- **Signal als Kanal für Benachrichtigungen.** Für [signal-cli-rest-api](https://github.com/bbernhard/signal-cli-rest-api) auf Basis von [signal-cli](https://github.com/AsamK/signal-cli) gibt es im alten Repo die Rolle [signal-cli-rest-api](https://github.com/makerspace-gt/docker-compose-server/tree/main/roles/signal-cli-rest-api). n8n könnte darüber Engagierte an Termine erinnern oder über neue Anmeldungen informieren. Später wäre auch ein Signal-Bot denkbar, der Fragen an MANUEL weiterleitet. Gäste schreiben wir nur mit ihrer Einwilligung an.
- **Vikunja für Aufgaben aus dem Repair Café.** Für [Vikunja](https://vikunja.io/docs/) gibt es im alten Repo die Rolle [vikunja](https://github.com/makerspace-gt/docker-compose-server/tree/main/roles/vikunja). n8n könnte aus vertagten Reparaturen Aufgaben anlegen, etwa für die Besorgung von Ersatzteilen, und fehlendes Werkzeug aus der Statistik als Wunschliste für Anschaffungen sammeln.
- **LanguageTool für Rechtschreibung und Grammatik.** Ein eigener [LanguageTool-Server](https://dev.languagetool.org/http-server) prüft Texte, ohne dass sie an einen fremden Dienst gehen. Engagierte binden ihn in die Browser-Erweiterung ein und nutzen ihn dann in Zammad, Discourse, Nextcloud und Forgejo. [LanguageTool](https://github.com/languagetool-org/languagetool) steht unter LGPL-2.1 und läuft auf der Kollaborations-VM. Als Java-Programm braucht es 1 bis 2 GB Arbeitsspeicher, die optionalen [N-Gramm-Daten](https://dev.languagetool.org/finding-errors-using-n-gram-data) für bessere Ergebnisse brauchen zusätzlich mehrere GB Platte. Ein Teil davon überschneidet sich mit den Textwerkzeugen von Zammad, LanguageTool funktioniert aber in allen Diensten und ohne Sprachmodell.

## Datenschutz

Mit dem Neuaufbau gehen wir auch den Datenschutz nach DSGVO an. Öffentlich dokumentiert sind [Daten und Aufbewahrung](docs/datenschutz/verarbeitungen.md), die [Verarbeitungstätigkeiten](docs/datenschutz/verarbeitungstaetigkeiten.md), die [Auftragsverarbeitung](docs/datenschutz/auftragsverarbeitung.md), die [technischen und organisatorischen Maßnahmen](docs/datenschutz/toms.md) und die [Abläufe](docs/datenschutz/ablaeufe.md) für Anfragen und Datenpannen. Vorlagen für den [Hinweis an Gäste](docs/datenschutz/vorlagen/hinweis-gaeste.md) und die [Verpflichtung auf Vertraulichkeit](docs/datenschutz/vorlagen/verpflichtung-vertraulichkeit.md) liegen daneben. Privat bleiben Namen und Kontakte der Verantwortlichen, die unterschriebenen Verträge im Gruppenordner des Vorstands in Nextcloud sowie Anfragen von Betroffenen und Datenpannen in einer eigenen Gruppe in Zammad. Die meisten Bausteine sind Dokumente, die beschreiben, was wir ohnehin tun. Das ist keine Rechtsberatung, im Zweifel holen wir uns Rat beim Landesdatenschutz oder bei einem Dachverband.

| Baustein | Inhalt |
|---|---|
| [Verzeichnis von Verarbeitungstätigkeiten](https://dsgvo-gesetz.de/art-30-dsgvo/) | Für jeden Dienst festhalten, welche Daten zu welchem Zweck, auf welcher Rechtsgrundlage und wie lange verarbeitet werden. Dazu gehören Zammad mit den Gästedaten des Repair Cafés, Nextcloud, Vaultwarden, Discourse, Immich, Signal, der Newsletter, die Mitgliederverwaltung und MANUEL als KI-Verarbeitung |
| [Rechtsgrundlagen](https://dsgvo-gesetz.de/art-6-dsgvo/) | Terminvereinbarung im Repair Café als Vertragsanbahnung, Newsletter nur mit Einwilligung per Double-Opt-in, Statistik als berechtigtes Interesse und möglichst nur mit anonymisierten Daten |
| [Datenschutzhinweise](https://dsgvo-gesetz.de/art-13-dsgvo/) | Kurzer Hinweis für Gäste bei Anmeldung und Laufzettel, einschließlich der Unterstützung durch ein lokales Sprachmodell. Die Datenschutzerklärung der Webseite an die tatsächlichen Dienste anpassen |
| Löschkonzept | Fristen für Gästedaten in Zammad, zum Beispiel Kontaktdaten einige Monate nach dem letzten Termin löschen und Reparaturdaten anonymisiert behalten. Zammad bringt dafür [Löschaufträge](https://admin-docs.zammad.org/en/latest/system/data-privacy.html) und [zeitgesteuerte Aktionen](https://admin-docs.zammad.org/en/latest/manage/scheduler.html) mit. Die Backups von resticker halten Daten bis zu zwölf Monate, das gehört ins Konzept |
| [Auftragsverarbeitung](https://dsgvo-gesetz.de/art-28-dsgvo/) | Verträge mit dem Anbieter der VMs, mit lima-city und mit dem Anbieter der Storagebox. An reparatur-initiativen.org gehen ohne Alter und Geschlecht der Gäste keine personenbezogenen Daten |
| [Technische und organisatorische Maßnahmen](https://dsgvo-gesetz.de/art-32-dsgvo/) | Aufschreiben, was es gibt oder geplant ist, also öffentliche Dienste nur über den Proxy mit Anmeldung, kritische nur per VPN, verschlüsselte Backups, verschlüsselte SSD des Mini-PCs, Rechte nach Gruppen aus authentik und Zwei-Faktor-Anmeldung |
| Betroffenenrechte | Festlegen, wer Anfragen auf [Auskunft](https://dsgvo-gesetz.de/art-15-dsgvo/) und [Löschung](https://dsgvo-gesetz.de/art-17-dsgvo/) bearbeitet. Die Löschaufträge von Zammad helfen dabei |
| [Datenpannen](https://dsgvo-gesetz.de/art-33-dsgvo/) | Ablauf, wer eine Panne bewertet und sie binnen 72 Stunden meldet |
| Vertraulichkeit | Alle Engagierten mit Zugriff auf Gästedaten unterschreiben eine kurze Verpflichtung auf Vertraulichkeit |
| [Datenschutzbeauftragter](https://www.gesetze-im-internet.de/bdsg_2018/__38.html) | Pflicht erst, wenn mindestens 20 Personen ständig personenbezogene Daten automatisiert verarbeiten. Bei uns wahrscheinlich nicht der Fall, wir prüfen und notieren das trotzdem |
| [KI-Verordnung](https://artificialintelligenceact.eu/article/50/) | MANUEL arbeitet intern und spricht nicht mit Gästen. Ein späterer Chatbot im Forum oder über Signal muss klar als KI erkennbar sein |

Die Dokumente liegen nicht in einem öffentlichen Repo, soweit sie interne Abläufe oder Namen enthalten. Für das Verzeichnis und das Löschkonzept fangen wir mit Zammad an, weil MANUEL dort mit echten Gästedaten arbeitet.

## Bedienung und Gestaltung

Der Neuaufbau soll für Engagierte einfacher werden, nicht nur für Admins. Zwei Ziele stehen im Vordergrund. Zwischen den Diensten soll man leicht wechseln können, und alle Dienste sollen einheitlich aussehen.

**Einfach wechseln**

- **Eine Startseite für alles.** Das [Anwendungs-Dashboard von authentik](https://docs.goauthentik.io/add-secure-apps/applications/manage_apps/) zeigt jedem Mitglied genau die Dienste, für die es freigeschaltet ist, mit Logo und Link. Es ist die Startseite für alle Engagierten.
- **Einmal anmelden.** Dank Single Sign-on über authentik wechselt man ohne neue Anmeldung von Zammad zu Nextcloud oder Discourse. Ausnahmen sind Vaultwarden, das bewusst eigenständig bleibt, und n8n, das OIDC nur in der Enterprise-Version anbietet.
- **Sprechende Adressen.** Ein einheitliches Schema unter makerspace-gt.de macht Adressen leicht merkbar, zum Beispiel auth für authentik, netbird, vault für Vaultwarden, helpdesk, cloud, forum und fotos.
- **Zurück zur Startseite.** Wo ein Dienst eigene Links in Kopfzeile oder Menü erlaubt, verweist einer auf die Startseite.
- **Anleitungsseite für VPN-Dienste.** Wer ohne NetBird einen Dienst aufruft, der nur per VPN erreichbar ist, landet auf einer Seite, die erklärt, wie man NetBird verbindet, mit Link zur Anleitung. Sie liegt öffentlich hinter dem Proxy und gehört zur Gestaltungsvorlage.
- **NetBird ohne Hürde.** Der Client verbindet sich nach der [Installation](https://docs.netbird.io/get-started/install) automatisch beim Start. Die Anleitung für Engagierte zeigt die Einrichtung auf Laptop und Smartphone Schritt für Schritt.

**Einheitlich aussehen**

- **Eine Gestaltungsvorlage im Repo.** Logo, Favicon, Farben und Schrift liegen einmal unter branding/ und werden per Ansible in alle Dienste verteilt.
- **Gestaltung pro Dienst.** Fast alle Dienste lassen sich anpassen, etwa [authentik](https://docs.goauthentik.io/customize/branding/), [Zammad](https://admin-docs.zammad.org/en/latest/settings/branding.html), [Nextcloud](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/theming.html), [Discourse](https://meta.discourse.org/t/beginners-guide-to-using-discourse-themes/91966) und [Forgejo](https://forgejo.org/docs/latest/admin/customization/). Wo nur Logo und Farbe gehen, reicht das.
- **Deutsch als Standard.** Alle Dienste starten auf Deutsch, Begriffe wie Termin, Gerät und Reparatur heißen überall gleich.
- **Barrierearm.** Ausreichende Kontraste und gut lesbare Schriften nach den [WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) gelten für die Farben der Vorlage.

**Mit Engagierten testen**

- **Kurze Tests vor dem Umstellen.** Bevor ein Dienst umzieht, probieren zwei oder drei Engagierte ohne IT-Hintergrund typische Aufgaben aus, zum Beispiel ein Ticket beim Repair Café anlegen oder ein Dokument in Nextcloud finden.
- **Auch auf dem Smartphone.** Beim Repair Café arbeiten Engagierte oft mit Tablet oder Smartphone, deshalb testen wir auch dort.

## Härtung der Server

Jede VM wird über die Basisrolle gehärtet, damit sie nach dem ersten Lauf von Ansible gleich abgesichert ist. Den größten Teil übernimmt eine gepflegte Collection, eigener Code ist nur für Firewall, Docker und unsere Ausnahmen nötig.

- **Grundhärtung mit [devsec.hardening](https://github.com/dev-sec/ansible-collection-hardening).** Die Collection unterstützt laut README Debian 12 und 13 und folgt den DevSec-Baselines. os_hardening setzt sichere Kernel-Einstellungen, Rechte, Mount-Optionen und entfernt unsichere Pakete. ssh_hardening erlaubt nur moderne Algorithmen und Schlüssel. Docker braucht IP-Forwarding, das os_hardening standardmäßig abschaltet. Diese Ausnahme setzen wir in der Basisrolle ausdrücklich.
- **SSH als einziger öffentlicher Zugang.** Nur Schlüssel, Root-Login nach dem ersten Lauf aus, Anmeldung nur für die Gruppe sudo über `AllowGroups`. Die Konfiguration prüfen wir mit [ssh-audit](https://github.com/jtesta/ssh-audit). Gegen massenhafte Anmeldeversuche läuft auf jeder VM CrowdSec statt fail2ban. Ein Agent liest die Anmeldungen von SSH aus dem [Journal](https://docs.crowdsec.net/docs/next/log_processor/data_sources/journald/), der [Firewall-Bouncer](https://docs.crowdsec.net/u/bouncers/firewall/) sperrt auffällige IP-Adressen per nftables. Alle Agenten melden an die [Local API](https://docs.crowdsec.net/docs/local_api/intro/) von CrowdSec auf der Zugangs-VM, die ohnehin für den NetBird-Proxy läuft. Eine Sperre auf einer VM gilt so für alle.
- **Firewall mit nftables.** Eingehend ist alles gesperrt außer SSH, dem UDP-Port von NetBird und ICMP. Auf der Zugangs-VM kommen HTTPS und die Ports für STUN und Relay dazu. Weil Docker die Firewall umgeht, binden die Compose-Stacks Ports nur an die NetBird-Adresse.
- **Docker.** In der daemon.json stehen neben den Logs auch `no-new-privileges` und `live-restore`. Container laufen wo möglich mit nur lesbarem Dateisystem, entzogenen Capabilities und Grenzen für Speicher und CPU. Geheimnisse kommen als Dateien statt als Umgebungsvariablen, weil `docker inspect` diese im Klartext zeigt. Die Agenten von Arcane und Beszel greifen auf den Docker-Socket zu, was Root-Rechten entspricht, deshalb sind sie nur über NetBird erreichbar.
- **Updates.** unattended-upgrades mit Neustart um 02:00 und needrestart für Dienste nach Updates von Bibliotheken. Container aktualisiert Arcane nach den vereinbarten Regeln, Zammad von Hand.
- **Regelmäßige Prüfung.** [Lynis](https://cisofy.com/lynis/) gibt es als Debian-Paket. Ein Rezept im Justfile und später ein nächtlicher Job in der CI erstellen einen Bericht, neue Warnungen fallen so auf.
- **Grenzen.** Der Betreiber von OpenNebula hat Zugriff auf unsere VMs. Eine Verschlüsselung der Platten innerhalb der VM schützt davor kaum, wichtiger sind die verschlüsselten Backups mit restic. OpenNebula 5.12 bekommt keine Updates mehr und bietet die API nur unverschlüsselt an. Dieses Risiko kann nur der Betreiber beheben.

Reihenfolge der Umsetzung:

1. devsec.hardening mit der Ausnahme für Docker in die Basisrolle aufnehmen
2. Firewall mit nftables und CrowdSec mit Firewall-Bouncer
3. Einstellungen für Docker
4. Lynis als Prüfung

## Backups

Jeder Dienst wird nach dem Vorgehen pro Dienst gesichert. Die Backups liegen in drei Kopien an zwei Orten, eine davon offline.

| Kopie | Ort | Wie |
|---|---|---|
| 1 | Die Daten auf der VM selbst | Laufender Betrieb |
| 2 | Storagebox | resticker auf jeder VM sichert per rclone in ein verschlüsseltes restic-Repository |
| 3 | Festplatte an einem Raspberry Pi | Der Pi holt die Snapshots selbst von der Storagebox |

- **Der Pi holt, die Server liefern nicht.** Ein kompromittierter Server kann die Kopie auf der Festplatte so weder erreichen noch löschen.
- **Nur lesender Zugang.** Der Pi bekommt für die Storagebox einen eigenen Unterzugang, der nur lesen darf.
- **Eigenes Repository.** Der Pi überträgt die Snapshots mit `restic copy` in ein eigenes restic-Repository auf der Festplatte, mit eigenem Passwort und eigenen Regeln zur Aufbewahrung. Ein einfaches Spiegeln würde Löschungen auf der Storagebox mitmachen.
- **Wirklich offline.** Die Festplatte ist nur für den Abgleich eingeschaltet, zum Beispiel einmal pro Woche per Zeitschaltung. Der Abgleich meldet seinen Erfolg an Uptime Kuma.
- **Wiederherstellung von beiden Orten.** Schritt 2 im Vorgehen pro Dienst prüft die Wiederherstellung von der Storagebox. Einmal im Jahr prüfen wir zusätzlich eine Wiederherstellung von der Festplatte.

## Vorgehen pro Dienst

Jeder Dienst wird in drei Schritten aufgesetzt. Erst wenn ein Schritt vollständig erfüllt ist, beginnt der nächste. So ist die Wiederherstellung zweimal geprüft, bevor echte Daten davon abhängen, und der Umzug der produktiven Daten ist nichts anderes als eine bereits erprobte Wiederherstellung.

| Schritt | Ziel | Fertig, wenn |
|---|---|---|
| 1 Läuft mit Backup | Der Dienst läuft auf der neuen VM und wird gesichert | Die Rolle richtet den Dienst ohne Handarbeit ein. Er ist über NetBird erreichbar, bei Bedarf mit Anmeldung über authentik. Uptime Kuma und Beszel überwachen ihn. Das Backup per resticker läuft und meldet seinen Erfolg an Uptime Kuma |
| 2 Läuft mit Restore | Die Wiederherstellung ist erprobt | Die Daten des Dienstes werden gelöscht oder eine frische VM angelegt. Die Aufgabe zur Wiederherstellung der Rolle stellt alles aus dem Backup von Schritt 1 wieder her. Testdaten sind danach vollständig vorhanden. Die Schritte und die benötigte Zeit stehen in der Anleitung des Dienstes |
| 3 Produktiv aus Restore | Der Dienst geht mit echten Daten in Betrieb | Die produktiven Daten werden genau auf dem Weg aus Schritt 2 wiederhergestellt, bei bestehenden Diensten aus dem Backup des alten Systems, bei neuen Diensten aus dem Backup der geprüften Einrichtung. Engagierte prüfen typische Aufgaben, danach wird der DNS-Eintrag umgestellt und das alte System bleibt bis zur Freigabe stehen |

Jede Rolle bringt dafür dieselben Bausteine mit:

- **Einrichtung.** Die Aufgaben in tasks/main.yml richten den Dienst vollständig ein.
- **Backup.** Ein resticker-Container sichert die Daten, bei Datenbanken vorher als Dump, und meldet sich bei Uptime Kuma.
- **Restore.** Die Aufgaben in tasks/restore.yml stellen den Dienst aus einem gewählten Snapshot wieder her. Sie laufen nur mit dem Tag restore, also nie aus Versehen. Die alten Rollen für Zammad, Vaultwarden und Discourse in docker-compose-server dienen als Vorlage.
- **Anleitung.** Eine Datei docs/dienste/<dienst>.md beschreibt Zweck, Zugang, Backup und Wiederherstellung.

Für Schritt 3 bei bestehenden Diensten brauchen wir lesenden Zugriff auf die alten Backups, also das alte restic-Passwort und die alte rclone-Konfiguration aus dem Vault von docker-compose-server. Sie kommen nur für den Umzug in den neuen Vault und werden danach entfernt.

## Stufen

Für [MANUEL](https://github.com/makerspace-gt/MANUEL/blob/main/PLAN.md) muss bis zum 31.12.2026 nur ein Teil stehen, der Rest folgt danach. Die Aufwände sind Schätzungen für ehrenamtliche Arbeit.

| Stufe | Zeitraum | Inhalt | Aufwand |
|---|---|---|---|
| 1 | bis 31.12.2026 | Zugangs-VM mit authentik, NetBird und Vaultwarden, Helpdesk-VM mit Zammad und Umzug der Tickets, Gestaltungsvorlage und Startseite in authentik | 20 bis 30 Stunden |
| 2 | Januar bis März 2027 | n8n auf der Helpdesk-VM, Monitoring-VM mit Uptime Kuma, Beszel und signal-cli-rest-api, Verzeichnis von Verarbeitungstätigkeiten, Löschkonzept und Datenschutzhinweise für Zammad und MANUEL | 20 bis 30 Stunden |
| 3 | ab Frühjahr 2027 | Datenschutz für alle übrigen Dienste, Verwaltungs-VM mit Forgejo, Runner, OpenTofu, Arcane und Dependency-Track, Umzug von Nextcloud, Vikunja und Discourse, Aufteilung des Wikis, Immich und LanguageTool | 70 bis 120 Stunden |

Die VMs legen wir von Anfang an mit OpenTofu an, gestartet vom Rechner eines Admins mit verschlüsseltem State. Für zwei VMs ist das wenig Aufwand und erspart den späteren Import. Forgejo und der Runner übernehmen das Ausführen erst in Stufe 3.

## Erste Schritte

Die Reihenfolge folgt den Abhängigkeiten. Was früher kommt, brauchen die späteren Schritte.

1. **Grundlagen klären.** Zugang zu OpenNebula mit Kontingent für die VMs, Netz und öffentliche IPs, Zugang zur DNS-Verwaltung bei lima-city, Namensschema für die Hosts.
2. **Rollen übernehmen.** Aus dem alten Repo [docker-compose-server](https://github.com/makerspace-gt/docker-compose-server) nur die bewährten Rollen kopieren, also compose_deploy, resticker und die Rollen für Zammad, Vaultwarden und Discourse mit ihren Aufgaben zur Wiederherstellung. Übernommene Dateien behalten ihre Lizenz CC BY 4.0 und werden nach REUSE gekennzeichnet. Ein Playbook site.yml mit Gruppen je VM anlegen und die Liste der Admins mit ihren SSH-Schlüsseln nur an einer Stelle in group_vars führen. Alle Geheimnisse mit einem neuen Vault-Passwort neu anlegen. Danach docker-compose-server archivieren
3. **Basisrolle schreiben.** Locale, Zeitzone, Admin-Benutzer mit sudo statt root, SSH nur mit Schlüssel, unattended-upgrades, Logs mit 7 Tagen Aufbewahrung, Docker, NetBird-Client und resticker. Jede VM bekommt diese Rolle zuerst.
4. **OpenTofu einrichten.** Provider für OpenNebula, Vorlage für Debian 13 mit SSH-Schlüssel über die Contextualization, verschlüsselter State. Die Inventardatei für Ansible schreibt OpenTofu.
5. **Zugangs-VM aufbauen.** Basisrolle, dann authentik, dann NetBird mit Proxy, Traefik und CrowdSec und Anmeldung über authentik, dann Vaultwarden per Wiederherstellung aus dem Backup. Admins testen den NetBird-Client auf ihren Rechnern.
6. **Helpdesk-VM aufbauen.** Basisrolle, NetBird-Client, Zammad in aktueller Version, Tickets aus dem Backup wiederherstellen, Termin als Datumsfeld, Prüfung durch Engagierte und erst dann den DNS-Eintrag umstellen.
7. **Mini-PC anbinden.** Sobald er geliefert ist, folgt der MANUEL-Plan ab Phase 1. Ollama wird über NetBird für die Helpdesk-VM freigegeben.

Die alten VMs laufen weiter, bis der jeweilige Dienst auf der neuen VM geprüft ist. Jeder Schritt endet mit einem Commit, damit der Stand jederzeit nachvollziehbar ist.

## Stufe 1 Zugangs-VM

Vorbereitung:

- [ ] Zugangs-VM mit öffentlicher IP per OpenTofu anlegen und DNS-Eintrag setzen
- [ ] Grundsystem per Ansible einrichten
- [ ] Basisrolle um Härtung nach dem Abschnitt Härtung der Server erweitern und mit Lynis prüfen
- [ ] Rollen netbird_client und resticker schreiben, resticker mit Ziel Storagebox per rclone. Die Rolle netbird_client kommt in die Basisrolle aller VMs
- [ ] Raspberry Pi mit Festplatte einrichten, der die Snapshots per `restic copy` von der Storagebox holt
- [ ] Firewall für HTTPS und die UDP-Ports von STUN und Relay öffnen
- [ ] Gestaltungsvorlage mit Logo, Favicon, Farben und Schrift unter branding/ anlegen

authentik unter auth.makerspace-gt.de nach der [Installationsanleitung](https://github.com/goauthentik/authentik/blob/main/website/docs/install-config/install/docker-compose.mdx) mit PostgreSQL, Server und Worker:

- [ ] Schritt 1 Läuft mit Backup, inklusive Startseite mit allen Diensten und angepasster Gestaltung
- [ ] Schritt 2 Läuft mit Restore
- [ ] Schritt 3 Produktiv aus Restore der geprüften Einrichtung

NetBird unter netbird.makerspace-gt.de mit Management, Signal, Relay und Dashboard. Als Vorlage dienen [getting-started.sh](https://github.com/netbirdio/netbird/blob/main/infrastructure_files/getting-started.sh) und die Compose-Vorlage für Traefik in upstream/netbird:

- [ ] Schritt 1 Läuft mit Backup, inklusive [Anmeldung über authentik](https://docs.netbird.io/selfhosted/identity-providers/authentik) und Monitor in Uptime Kuma, weil ohne Management und Relay keine neuen Verbindungen zustande kommen
- [ ] Reverse Proxy von NetBird mit eigenem OAuth-Client in authentik einrichten und mit einem ersten Dienst testen
- [ ] DNS-Zonen in NetBird für die Dienste anlegen, die nur per VPN erreichbar sind, und die Anleitungsseite hinter den Proxy legen
- [ ] Schritt 2 Läuft mit Restore, weil ohne die Datenbank des Management-Servers alle Peers und Regeln neu angelegt werden müssen
- [ ] Schritt 3 Produktiv aus Restore der geprüften Einrichtung
- [ ] Anleitung für Engagierte zum Einrichten des NetBird-Clients schreiben

Vaultwarden unter vault.makerspace-gt.de über den Proxy, damit auch Mitglieder einen Passwortmanager nutzen können. Anmeldung über authentik und zusätzlich lokal, damit Vaultwarden auch bei einem Ausfall von authentik nutzbar bleibt. Das Master-Passwort bleibt in beiden Fällen nötig, weil es den Tresor entschlüsselt. Neue Konten nur per Einladung, Zwei-Faktor-Anmeldung für die lokale Anmeldung als Pflicht und die Verwaltung unter /admin am Proxy gesperrt:

- [ ] Schritt 1 Läuft mit Backup
- [ ] Schritt 2 Läuft mit Restore
- [ ] Schritt 3 Produktiv aus Restore des Backups vom alten Vaultwarden

Danach:

- [ ] Festlegen, welche Teile von Zammad, Discourse und Nextcloud für Gäste öffentlich bleiben
- [ ] Dienste nach der Tabelle im Abschnitt Erreichbarkeit über den Proxy oder nur per VPN erreichbar machen und Zugriffsregeln nach Gruppen aus authentik anlegen

## Stufe 1 Helpdesk-VM

Vorbereitung:

- [ ] Helpdesk-VM per OpenTofu anlegen und Grundsystem per Ansible einrichten
- [ ] NetBird-Client installieren und testen, dass die Zammad-Container das NetBird-Netz über den Host erreichen

Zammad in einer Version mit Ollama-Anbieter, Ticket Categorizer, Ticket Text Extractor und Embeddings für die Wissensdatenbank, ohne die angepasste ticket.rb:

- [ ] Schritt 1 Läuft mit Backup, inklusive Gestaltung aus der Vorlage und Anmeldung über authentik
- [ ] Schritt 2 Läuft mit Restore
- [ ] Schritt 3 Produktiv aus Restore des Backups vom alten Zammad, dabei Wartezeiten in das neue Datumsfeld Termin überführen
- [ ] Ansichten für das Repair Café vor der Umstellung mit Engagierten testen, auch auf Tablet und Smartphone
- [ ] Unter Einstellungen, System, Dienste den Geo Location Service auf - stellen. Standardmäßig schickt Zammad die Adressfelder von Kunden an Nominatim von OpenStreetMap. Wir füllen diese Felder nicht, abgeschaltet bleibt das auch so, wenn jemand sie doch einmal füllt, siehe [performs_geo_lookup.rb](https://github.com/zammad/zammad/blob/develop/app/models/user/performs_geo_lookup.rb), Karten nutzen wir nicht
- [ ] Gruppe Datenschutz nur für den Vorstand anlegen und die neue Adresse datenschutz@makerspace-gt.de bei lima-city einrichten und in Zammad dieser Gruppe zuordnen, siehe [Abläufe](docs/datenschutz/ablaeufe.md)
- [ ] Zeitgesteuerte Aktionen mit Löschauftrag anlegen, Repair Café 3 Jahre nach Abschluss, Anfragen ohne Erscheinen nach 3 Monaten, übrige Tickets 3 Jahre nach Abschluss, mit steuerlich relevanten Belegen 10 Jahre, siehe [Daten und Aufbewahrung](docs/datenschutz/verarbeitungen.md)

## Upstream-Submodule

| Submodul | Lizenz |
|---|---|
| upstream/zammad | AGPL-3.0 |
| upstream/zammad-docker-compose | AGPL-3.0 |
| upstream/n8n | Sustainable Use License |
| upstream/netbird | BSD-3-Clause, Server-Teile AGPL-3.0 |
| upstream/signal-cli | GPL-3.0 |
| upstream/signal-cli-rest-api | MIT |
| upstream/discourse | GPL-2.0 |
| upstream/vikunja | AGPL-3.0 |
| upstream/authentik | MIT, Unternehmensteil mit eigener Lizenz |
| upstream/arcane | BSD-3-Clause |
| upstream/beszel | MIT |
| upstream/opentofu | MPL-2.0 |
| upstream/forgejo | GPL-3.0 |
| upstream/immich | AGPL-3.0 |
| upstream/languagetool | LGPL-2.1 |
| upstream/vaultwarden | AGPL-3.0 |

Die Submodule sind groß und deshalb in `.gitmodules` als shallow markiert. Sie dienen als Nachschlagewerk für Schnittstellen und Konfiguration.
