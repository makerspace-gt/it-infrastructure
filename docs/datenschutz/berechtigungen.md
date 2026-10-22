# Berechtigungen

Dieses Konzept legt fest, welche Gruppen es gibt, wer in welchem Dienst was sehen und bearbeiten darf, wer andere aufnimmt und wer welche Maschinen nutzen darf. Es setzt die Grundsätze aus [Art. 5 Abs. 1 Buchst. f)](https://dsgvo-gesetz.de/art-5-dsgvo/), [Art. 25 Abs. 2](https://dsgvo-gesetz.de/art-25-dsgvo/) und [Art. 32](https://dsgvo-gesetz.de/art-32-dsgvo/) DSGVO um, jede Person bekommt nur, was sie für ihre Aufgabe braucht. Das ist keine Rechtsberatung.

Stand ist ein Entwurf. Einträge mit dem Vermerk Vorschlag sind noch nicht beschlossen.

## Grundregeln

- **Gruppen in authentik sind die einzige Quelle.** Die Dienste übernehmen die Gruppen per OIDC. Wer in authentik aus einer Gruppe entfernt wird, verliert den Zugriff in allen Diensten.
- **Aufnahme nur durch die zuständige Gruppe.** Wer jemanden in eine Gruppe aufnehmen darf, steht in der Tabelle der Gruppen. Admins setzen Gruppen nur auf Anweisung, nicht auf eigene Entscheidung.
- **Erst Verpflichtung, dann Zugriff.** Wer personenbezogene Daten anderer sieht, unterschreibt vorher die [Verpflichtung auf Vertraulichkeit](vorlagen/verpflichtung-vertraulichkeit.md).
- **Austritt.** Bei Austritt oder Ende der Aufgabe entfernt die aufnehmende Gruppe die Person aus der Gruppe, bei Austritt aus dem Verein sperrt der Vorstand das Konto in authentik. Signal-Gruppen werden dabei von Hand mit bereinigt.
- **Überprüfung.** Der Vorstand prüft die Mitglieder aller Gruppen einmal im Jahr zusammen mit den [TOMs](toms.md).

## Gruppen

| Gruppe | Wer | Aufnahme durch | Ort heute |
|---|---|---|---|
| Vorstand | Gewählter Vorstand | Mitgliederversammlung, eingetragen vom Vorstand | Signal-Gruppe Vorstand |
| Admins | Betreuen Server und Dienste, siehe [admins.yml](../../ansible/group_vars/all/admins.yml) | Vorstand | |
| AG Cyber | Mitglieder, die an der IT des Vereins mitarbeiten | AG Cyber, Vorschlag | Signal-Gruppe AG Cyber |
| Mitglieder | Alle Vereinsmitglieder | Vorstand nach Aufnahme in den Verein | Kategorie Intern in Discourse |
| Repair Café Agents | Engagierte, die Anfragen und Reparaturen in Zammad bearbeiten | Repair Café Agents, Vorschlag | Signal-Gruppe Repair Café Agents |
| Repair Café Empfang | Engagierte am Empfang des Repair Cafés | Repair Café Agents, Vorschlag | Signal-Gruppe Repair Café Empfang |
| Interessierte | Personen mit Konto im Forum, die nicht Mitglied sind | Registrieren sich selbst | Forum |
| Allgemeine Signal-Gruppe | Mitglieder, Engagierte und Interessierte | Alle Teilnehmenden, Vorschlag | Signal |

Ohne Konto und ohne Gruppe sind Gäste des Repair Cafés und Anfragende. Ihre Daten liegen in Zammad, sie selbst haben keinen Zugriff auf die Dienste.

## Dienste

Sehen heißt lesen, Bearbeiten schließt Sehen ein, Verwalten schließt Einstellungen und Rechte anderer ein.

| Dienst | Vorstand | Admins | AG Cyber | Mitglieder | Repair Café Agents | Repair Café Empfang | Interessierte |
|---|---|---|---|---|---|---|---|
| Zammad, Repair Café | Bearbeiten | Verwalten | Nein | Nein | Bearbeiten | Bearbeiten | Nein |
| Zammad, allgemeine Anfragen | Bearbeiten | Verwalten | Nein | Nein | Bearbeiten | Bearbeiten | Nein |
| Zammad, Gruppe Datenschutz | Bearbeiten | Nein | Nein | Nein | Nein | Nein | Nein |
| Discourse, öffentliche Kategorien | Bearbeiten | Verwalten | Bearbeiten | Bearbeiten | Bearbeiten | Bearbeiten | Bearbeiten |
| Discourse, Intern | Bearbeiten | Verwalten | Bearbeiten | Bearbeiten | Nein, außer Mitglied | Nein, außer Mitglied | Nein |
| Nextcloud, Ordner des Vorstands mit Verträgen | Bearbeiten | Nein, Vorschlag | Nein | Nein | Nein | Nein | Nein |
| Nextcloud, Ordner der Mitglieder | Bearbeiten | Verwalten | Bearbeiten | Bearbeiten | Nein, außer Mitglied | Nein, außer Mitglied | Nein |
| Immich | Bearbeiten | Verwalten | Nein | Sehen, Vorschlag | Nein | Nein | Nein |
| Vaultwarden, Sammlungen des Vereins | Je Sammlung | Verwalten | Je Sammlung | Je Sammlung | Je Sammlung | Je Sammlung | Nein |
| Forgejo | Bearbeiten | Verwalten | Bearbeiten | Sehen | Sehen | Nein | Öffentliche Repos sehen |
| Vikunja | Bearbeiten | Verwalten | Bearbeiten | Bearbeiten | Bearbeiten | Nein | Nein |
| Open WebUI mit MANUEL | Nein | Verwalten | Bearbeiten | Nein | Bearbeiten | Nein | Nein |
| Server, OpenTofu, Ansible | Nein | Verwalten | Nein | Nein | Nein | Nein | Nein |
| Mitgliederverwaltung | Kassenwart | Nein | Nein | Nein | Nein | Nein | Nein |

Zu einzelnen Diensten:

- **Zammad.** Zammad kann Kontaktdaten nicht nach Gruppen ausblenden, jedes Konto mit der Rolle Agent sieht alle Kunden, siehe [TOMs](toms.md). Empfang und Agents haben deshalb technisch dieselben Rechte auf die Gästedaten. Die Gruppe Datenschutz ist davon getrennt, weil Gruppen in Zammad zumindest die Tickets trennen.
- **Admins.** Admins können technisch auf alle Daten zugreifen, etwa über Backups oder die Datenbank. Sie tun das nur für Betrieb, Wiederherstellung und auf Anweisung des Vorstands.
- **Vaultwarden.** Passwörter des Vereins liegen in Sammlungen einer Organisation. Wer welche Sammlung sieht, legen Vorstand und Admins pro Sammlung fest. Private Tresore sieht niemand außer den Nutzenden.
- **Signal.** Die Signal-Gruppen sind nicht an authentik angebunden. Admins der jeweiligen Signal-Gruppe pflegen sie von Hand nach der Tabelle der Gruppen.

## Maschinen und Werkzeuge

Bestimmte Maschinen dürfen nur Personen nutzen, die eingewiesen sind. Gründe dafür sind:

- **Gefahr.** Die Maschine kann Menschen verletzen oder einen Brand auslösen
- **Teure Maschine.** Falsche Bedienung kann teure Schäden verursachen
- **Teures Material.** Fehldrucke oder Verschnitt kosten viel
- **Störung anderer.** Lärm, Staub oder Geruch stören andere in der Werkstatt, deshalb gelten feste Regeln für die Nutzung

Für den Datenschutz zählt, dass die Liste der Eingewiesenen personenbezogene Daten enthält.

Die Gründe sind ein Vorschlag:

| Maschine | Gründe | Einweisen dürfen |
|---|---|---|
| CO2-Lasercutter | Gefahr, teure Maschine, Störung anderer | Einweisende Lasercutter |
| Shaper Origin | Gefahr, teure Maschine | Einweisende Shaper Origin |
| Portal-CNC-Fräse | Gefahr, Störung anderer | Einweisende CNC-Fräse |
| Maschinen der Holzwerkstatt | Gefahr, Störung anderer | Einweisende Holzwerkstatt |
| 3D-Drucker Bambu Lab A2L | Teure Maschine | Einweisende 3D-Druck |
| 3D-Drucker von Prusa, FDM | Keine Einweisung nötig | |
| 3D-Drucker von Prusa, Resin SL1S | Gefahr durch Chemikalien, teures Material, Störung anderer | Einweisende 3D-Druck |
| Stickmaschine | Teure Maschine | Einweisende Textilwerkstatt |
| Overlock und Schneideplotter ScanNCut CM900 | Keine Einweisung nötig | |
| Elektronik-Labor | Keine Einweisung nötig | |

Umsetzung, Vorschlag:

- **Einweisung als Gruppe in authentik.** Für jede Maschine gibt es eine Gruppe Einweisung, etwa Einweisung Lasercutter, und eine Gruppe Einweisende. Wer eingewiesen hat, nimmt die Person in die Gruppe auf. So sehen Engagierte in authentik oder im Forum, wer eine Maschine nutzen darf, ohne eine eigene Liste zu führen.
- **Nachweis.** Die unterschriebene Bestätigung der Einweisung liegt zusätzlich im Ordner des Vorstands in Nextcloud, weil sie für Haftung und Versicherung zählt.
- **Löschung.** Die Gruppe endet mit dem Austritt. Den unterschriebenen Nachweis heben wir nach dem Austritt noch 3 Jahre auf, der regelmäßigen Verjährung nach [§ 195 BGB](https://www.gesetze-im-internet.de/bgb/__195.html).

## Offene Punkte

- Einträge mit dem Vermerk Vorschlag im Vorstand beschließen
- Abgleich, wer heute in den Signal-Gruppen und in Discourse Intern ist, mit den künftigen Gruppen
- Liste der Maschinen und Einweisenden vervollständigen
