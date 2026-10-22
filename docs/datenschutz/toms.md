# Technische und organisatorische Maßnahmen

Diese Übersicht beschreibt die Maßnahmen nach [Art. 32 DSGVO](https://dsgvo-gesetz.de/art-32-dsgvo/), mit denen wir personenbezogene Daten schützen. Sie nennt bewusst keine Einzelheiten, die Angreifern helfen würden. Die technische Umsetzung steht im [Plan](../../PLAN.md) und in den Rollen dieses Repos. Das ist keine Rechtsberatung.

## Vertraulichkeit

- **Zugang zu den Servern.** Die VMs laufen bei 4830.org e.V. in Rechenzentren. Aus dem Internet ist auf ihnen nur SSH erreichbar, und das nur mit Schlüssel. Root-Anmeldung ist abgeschaltet, Admins melden sich mit eigenem Konto an.
- **Zugang zu den Diensten.** Öffentliche Dienste sind nur über den Reverse Proxy von NetBird erreichbar, bei Bedarf mit vorgeschalteter Anmeldung. Kritische Dienste sind nur per VPN erreichbar.
- **Anmeldung.** Ein zentrales Konto in authentik für alle Dienste. Zwei-Faktor-Anmeldung ist möglich, für Engagierte aber keine Pflicht. Konten werden bei Austritt gesperrt.
- **Rechte.** Zugriff nach Gruppen, jede Person bekommt nur, was sie für ihre Aufgabe braucht. Gästedaten im Repair Café sehen alle Engagierten mit Konto in Zammad. Zammad kann Kontaktdaten nicht nach Gruppen ausblenden, jedes Konto mit der Rolle Agent sieht alle Kunden, siehe [user_policy.rb](https://github.com/zammad/zammad/blob/develop/app/policies/user_policy.rb). Wir nehmen das in Kauf, weil Engagierte Gäste für Rückfragen zur Reparatur erreichen müssen. Ein Konto gibt es erst nach der Verpflichtung auf Vertraulichkeit, bei Austritt wird es gesperrt.
- **Passwörter.** In Vaultwarden, verschlüsselt mit einem Master-Passwort, das nur die Nutzenden kennen.
- **Geheimnisse der Infrastruktur.** Verschlüsselt im Ansible Vault und im verschlüsselten State von OpenTofu, nie im Klartext im Repo.
- **Trennung.** Dienste laufen in getrennten Containern auf VMs nach Aufgabe. Zugänge und Passwörter liegen auf einer anderen VM als Dienste, die Daten von außen verarbeiten.
- **Lokale Verarbeitung durch KI.** MANUEL verarbeitet Daten auf einem eigenen Rechner des Vereins, es gehen keine Daten an externe KI-Anbieter.
- **Geräte.** Der Mini-PC in der Werkstatt und der Rechner für die Mitgliederverwaltung sind verschlüsselt.
- **Verpflichtung.** Alle Engagierten mit Zugriff auf personenbezogene Daten sind auf Vertraulichkeit verpflichtet, siehe [Vorlage](vorlagen/verpflichtung-vertraulichkeit.md).

## Integrität

- **Verschlüsselte Übertragung.** Alle Weboberflächen nur über HTTPS, Verbindungen zwischen den Servern durch den verschlüsselten Tunnel von NetBird.
- **Nachvollziehbarkeit.** Änderungen an der Infrastruktur nur über Git mit Historie. Anmeldungen und Änderungen protokollieren die Dienste, Protokolle bleiben 90 Tage.
- **Ein Mensch entscheidet.** Vorschläge der KI landen als Notiz oder vorbefülltes Feld und werden von Engagierten geprüft. Einwilligungen setzen nur Menschen.

## Verfügbarkeit und Belastbarkeit

- **Backups.** Täglich verschlüsselt auf eine Storagebox bei Hetzner in Deutschland und zusätzlich offline auf eine Festplatte, die die Daten selbst abholt.
- **Wiederherstellung.** Jeder Dienst geht erst in Betrieb, nachdem die Wiederherstellung aus dem Backup erprobt ist. Einmal im Jahr prüfen wir die Wiederherstellung von der Festplatte.
- **Updates.** Sicherheitsupdates des Betriebssystems automatisch, Container nach festen Regeln.
- **Überwachung.** Erreichbarkeit, Ressourcen und erfolgreiche Backups werden überwacht, Admins werden bei Problemen benachrichtigt.
- **Abwehr.** Härtung aller Server nach einer gemeinsamen Vorlage, Sperren auffälliger IP-Adressen mit CrowdSec.

## Löschung

- Fristen und Umsetzung stehen in [Daten und Aufbewahrung](verarbeitungen.md). Logs mit IP-Adressen werden nach 7 Tagen gelöscht, Backups halten Daten höchstens 6 Monate.

## Überprüfung

- Regelmäßige Prüfung der Server mit Lynis.
- Diese Übersicht und das Verzeichnis der Verarbeitungstätigkeiten prüfen wir einmal im Jahr und bei jeder größeren Änderung.

## Ausblick

Diese Maßnahmen sind vorerst nicht umgesetzt. Wir prüfen sie bei der jährlichen Überprüfung erneut:

- **Zwei-Faktor-Pflicht für Admins und Vorstand.** Über eine Richtlinie für deren Gruppen in authentik, siehe [Authenticator Validation Stage](https://docs.goauthentik.io/add-secure-apps/flows-stages/stages/authenticator_validate/). Engagierte bleiben davon unberührt.
- **Passwortrichtlinie in authentik.** Mindestlänge und Abgleich mit bekannten geleakten Passwörtern über die [Password Policy](https://docs.goauthentik.io/customize/policies/types/password/). Ohne Zwei-Faktor-Anmeldung ist das Passwort der einzige Schutz der Gästedaten in Zammad.
