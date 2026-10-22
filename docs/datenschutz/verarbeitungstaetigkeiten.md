# Verarbeitungstätigkeiten

Diese Übersicht enthält die Angaben des Verzeichnisses von Verarbeitungstätigkeiten nach [Art. 30 DSGVO](https://dsgvo-gesetz.de/art-30-dsgvo/), soweit sie öffentlich sein können. Namen und Kontaktdaten der verantwortlichen Personen pflegen wir privat. Speicherfristen und Logs stehen in [Daten und Aufbewahrung](verarbeitungen.md), die eingesetzten Auftragsverarbeiter in [Auftragsverarbeitung](auftragsverarbeitung.md). Das ist keine Rechtsberatung.

## Verantwortlicher

Makerspace Gütersloh e.V., c/o WEBEREI, Bogenstraße 1-8, 33330 Gütersloh, vertreten durch den Vorstand. Ansprechpartner für den Datenschutz ist der Vorstand, erreichbar unter datenschutz@makerspace-gt.de.

## Übersicht

| Nr. | Verarbeitung | Dienste |
|---|---|---|
| 1 | Repair Café, Terminvergabe und Reparaturen | Zammad, MANUEL mit Ollama, n8n |
| 2 | Allgemeine Anfragen an den Verein | Zammad |
| 3 | Konten und Zugänge der Mitglieder und Engagierten | authentik, NetBird |
| 4 | Passwortverwaltung | Vaultwarden |
| 5 | Dateiablage, Kalender und Kontakte | Nextcloud |
| 6 | Forum | Discourse |
| 7 | Fotos von Veranstaltungen | Immich |
| 8 | Aufgaben und Projekte | Vikunja |
| 9 | Code und Dokumentation | Forgejo, GitHub |
| 10 | Newsletter des Repair Cafés | reparatur-initiativen.org |
| 11 | Statistik zu Reparaturen | n8n, reparatur-initiativen.org, Open Repair Alliance |
| 12 | Terminabfragen unter Engagierten | Nuudel |
| 13 | Kommunikation und Benachrichtigungen | Signal, signal-cli-rest-api, WhatsApp-Gruppen |
| 14 | Betrieb und Sicherheit der IT | Logs, CrowdSec, Backups, Uptime Kuma, Beszel |
| 15 | Mitgliederverwaltung | Software auf dem Rechner des Kassenwarts, Online-Banking |
| 16 | Webseite | WordPress bei lima-city |
| 17 | Telefonie | sipgate |
| 18 | Öffentlichkeitsarbeit in sozialen Medien | Instagram, Mastodon, YouTube, Unternehmensprofil bei Google Maps |
| 19 | Einweisungen an Maschinen | authentik, Nextcloud |

## Einzelheiten

### 1 Repair Café, Terminvergabe und Reparaturen

- **Zweck:** Termine für Reparaturen vergeben, Reparaturen dokumentieren, Gäste bei Rückfragen erreichen, Engagierte mit Vorschlägen von MANUEL unterstützen
- **Betroffene:** Gäste des Repair Cafés
- **Daten:** Name, E-Mail, Telefon, Angaben zum Gerät und Defekt, Fotos von Geräten und Typenschildern, Ergebnis der Reparatur, Einwilligung in den Newsletter
- **Rechtsgrundlage:** [Art. 6 Abs. 1 lit. b DSGVO](https://dsgvo-gesetz.de/art-6-dsgvo/) für Terminvergabe und Reparatur, lit. a für den Newsletter
- **Empfänger:** Alle Engagierten mit Konto in Zammad, die Kontaktdaten lassen sich dort nicht auf einzelne Gruppen beschränken. MANUEL verarbeitet die Daten lokal auf dem Mini-PC des Vereins, es gehen keine Daten an externe KI-Anbieter
- **Drittland:** Nein
- **Löschung:** 3 Jahre nach Abschluss, Anfragen ohne Erscheinen nach 3 Monaten

### 2 Allgemeine Anfragen an den Verein

- **Zweck:** Anfragen beantworten und nachvollziehen
- **Betroffene:** Anfragende, Mitglieder, Partner
- **Daten:** Name, Kontaktdaten, Inhalt der Anfrage und Antworten
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b oder f DSGVO
- **Empfänger:** Zuständige Engagierte und Vorstand
- **Drittland:** Nein
- **Löschung:** 3 Jahre nach Abschluss, Tickets mit steuerlich relevanten Belegen 10 Jahre

### 3 Konten und Zugänge

- **Zweck:** Anmeldung an allen Diensten mit einem Konto, Zugriff nach Gruppen, Zugang per VPN
- **Betroffene:** Mitglieder und Engagierte
- **Daten:** Name, E-Mail, Gruppen, Zwei-Faktor-Geräte, Anmeldungen mit IP-Adresse, Geräte im VPN mit Hostname und Betriebssystem
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO, Mitgliedschaft und Engagement, für Protokolle lit. f
- **Empfänger:** Admins
- **Drittland:** Nein
- **Löschung:** Konten nach Austritt, Protokolle nach 90 Tagen

### 4 Passwortverwaltung

- **Zweck:** Gemeinsame und persönliche Zugangsdaten sicher verwalten
- **Betroffene:** Mitglieder und Engagierte
- **Daten:** E-Mail, Name, verschlüsselte Tresore, die nur die Nutzenden öffnen können
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO
- **Empfänger:** Niemand, die Tresore sind für Admins nicht lesbar
- **Drittland:** Nein
- **Löschung:** Nach Austritt, Ereignisse nach 90 Tagen

### 5 Dateiablage, Kalender und Kontakte

- **Zweck:** Zusammenarbeit im Verein, Termine auf der Webseite
- **Betroffene:** Mitglieder, Engagierte, Personen in geteilten Dateien
- **Daten:** Konten, Dateien, Kalender, Kontakte, Aktivitäten
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b und f DSGVO
- **Empfänger:** Mitglieder nach Freigabe, öffentliche Termine auf der Webseite
- **Drittland:** Nein
- **Löschung:** Nach Austritt, Aktivitäten nach 90 Tagen

### 6 Forum

- **Zweck:** Austausch und Wissen der Mitglieder und Interessierten
- **Betroffene:** Registrierte Nutzende
- **Daten:** Konto, Beiträge, Nachrichten, IP-Adressen bei Registrierung und Anmeldung
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO
- **Empfänger:** Öffentlich lesbare Beiträge, Moderation
- **Drittland:** Nein
- **Löschung:** Auf Wunsch der Nutzenden, E-Mail-Logs nach 90 Tagen

### 7 Fotos von Veranstaltungen

- **Zweck:** Dokumentation und Öffentlichkeitsarbeit, Zuordnung von Fotos zu Personen, um sie um ihre Einwilligung zu fragen
- **Betroffene:** Teilnehmende von Veranstaltungen
- **Daten:** Fotos mit EXIF-Daten, durch Gesichtserkennung gebildete biometrische Daten
- **Rechtsgrundlage:** Für Veröffentlichung Art. 6 Abs. 1 lit. a DSGVO. Für die Gesichtserkennung nach Art. 9 DSGVO noch mit einer Datenschutzberatung zu klären, siehe [Daten und Aufbewahrung](verarbeitungen.md)
- **Empfänger:** Kleiner Kreis von Engagierten, veröffentlichte Fotos öffentlich
- **Drittland:** Nein
- **Löschung:** Ohne Einwilligung samt erkanntem Gesicht löschen

### 8 Aufgaben und Projekte

- **Zweck:** Organisation von Aufgaben im Verein
- **Betroffene:** Mitglieder und Engagierte
- **Daten:** Konto, Aufgaben, Zuständigkeiten
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO
- **Empfänger:** Mitglieder nach Freigabe
- **Drittland:** Nein
- **Löschung:** Nach Austritt

### 9 Code und Dokumentation

- **Zweck:** Infrastruktur und Projekte als Code pflegen und teilen
- **Betroffene:** Mitwirkende
- **Daten:** Konto, Name und E-Mail in Commits
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. a und b DSGVO, Hinweis bei der Registrierung, dass Commits in öffentlichen Repos öffentlich sind
- **Empfänger:** Öffentlich bei öffentlichen Repos
- **Drittland:** Spiegelung nach GitHub in den USA, siehe [Auftragsverarbeitung](auftragsverarbeitung.md)
- **Löschung:** Konten nach Austritt, Commits bleiben Teil der Historie

### 10 Newsletter des Repair Cafés

- **Zweck:** Gäste über Termine des Repair Cafés informieren, der Versand läuft über reparatur-initiativen.org
- **Ablauf:** Engagierte fragen Gäste, ob sie den Newsletter möchten. Nur auf Wunsch tragen wir die E-Mail-Adresse auf reparatur-initiativen.org ein und vermerken den Wunsch mit Datum im Ticket. Die Plattform schickt eine Bestätigungsmail, erst damit ist die Anmeldung abgeschlossen. Später übernimmt n8n die Übermittlung per API, sobald Engagierte den Wunsch im Ticket vermerkt haben. Übermittelt wird nur die E-Mail-Adresse, einmalig und mit interner Notiz im Ticket. Die KI-Agenten von MANUEL dürfen das Feld zur Einwilligung nie setzen
- **Betroffene:** Gäste mit Einwilligung
- **Daten:** E-Mail
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. a DSGVO für die Übermittlung an die anstiftung auf Wunsch der Gäste, die Einwilligung in den Newsletter bestätigen die Gäste per Double-Opt-in bei der Plattform. Bei der Nachfrage nennen wir die anstiftung als Empfängerin der E-Mail-Adresse
- **Empfänger:** Plattform reparatur-initiativen.org der anstiftung als voraussichtlich eigener Verantwortlicher, siehe [Auftragsverarbeitung](auftragsverarbeitung.md)
- **Drittland:** Nein
- **Löschung:** Bei Abmeldung

### 11 Statistik zu Reparaturen

- **Zweck:** Auswertung des Repair Cafés, Beitrag zur Open Repair Alliance
- **Betroffene:** Keine, die Daten sind anonym
- **Daten:** Gerät, Kategorie, Marke, Alter, Fehler, Ergebnis, ohne Angaben zur Person
- **Rechtsgrundlage:** Keine personenbezogenen Daten
- **Empfänger:** reparatur-initiativen.org, über die anstiftung die Open Repair Alliance
- **Drittland:** Veröffentlichung als offene Daten
- **Löschung:** Keine

### 12 Terminabfragen unter Engagierten

- **Zweck:** Planen, wer beim Repair Café hilft
- **Betroffene:** Engagierte
- **Daten:** Name oder Kürzel, Verfügbarkeit
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO
- **Empfänger:** Teilnehmende der Abfrage, Nuudel von Digitalcourage
- **Drittland:** Nein
- **Löschung:** Abfrage nach dem Termin löschen

### 13 Kommunikation und Benachrichtigungen

- **Zweck:** Abstimmung im Verein, Benachrichtigungen der Admins und Engagierten
- **Betroffene:** Mitglieder und Engagierte in den Gruppen
- **Daten:** Telefonnummer, Name im Profil, Nachrichten. In Gruppen sehen alle Teilnehmenden die Telefonnummern der anderen
- **Hinweis:** Die Teilnahme an Gruppen in Signal und WhatsApp ist freiwillig. Wichtige Informationen gibt es auch per E-Mail oder im Forum. Neue Gruppen legen wir bevorzugt in Signal an
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. a und b DSGVO
- **Empfänger:** Mitglieder der jeweiligen Gruppe
- **Drittland:** Signal und WhatsApp werden aus den USA betrieben, die Inhalte sind Ende-zu-Ende verschlüsselt. Einordnung siehe [Auftragsverarbeitung](auftragsverarbeitung.md#messenger)
- **Löschung:** Nach Austritt aus der Gruppe

### 14 Betrieb und Sicherheit der IT

- **Zweck:** Betrieb, Abwehr von Angriffen, Wiederherstellung nach Ausfällen
- **Betroffene:** Alle Nutzenden der Dienste
- **Daten:** IP-Adressen und Zugriffe in Logs, Sperrlisten, Kopien aller Daten in Backups
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. f DSGVO
- **Empfänger:** Admins, Anbieter der VMs und der Storagebox, CrowdSec für Reputationsdaten, siehe [Auftragsverarbeitung](auftragsverarbeitung.md)
- **Drittland:** Nein
- **Löschung:** Logs nach 7 Tagen, Backups nach höchstens 6 Monaten

### 15 Mitgliederverwaltung

- **Zweck:** Verwaltung der Mitgliedschaft, Einzug der Beiträge per SEPA-Lastschrift
- **Betroffene:** Mitglieder
- **Daten:** Name, Anschrift, Kontaktdaten, Beginn und Ende der Mitgliedschaft, Beitrag, Kontoinhaber, IBAN, Mandatsreferenz und Datum des SEPA-Mandats
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO für die Mitgliedschaft nach Satzung, lit. c für steuerliche Aufbewahrungspflichten
- **Empfänger:** Vorstand und Kassenwart, die Hausbank des Vereins für den Einzug der Lastschriften als eigener Verantwortlicher
- **Drittland:** Nein
- **Löschung:** Stammdaten nach Ende der Mitgliedschaft, soweit keine Aufbewahrungspflicht besteht. Buchungsbelege 10 Jahre. SEPA-Mandate mindestens 14 Monate nach dem letzten Einzug, wegen möglicher Rückforderungen
- **Werkzeug:** Software lokal auf dem Rechner des Kassenwarts, kein Auftragsverarbeiter. Der Rechner ist verschlüsselt, mit Passwort gesperrt und wird gesichert, siehe technische und organisatorische Maßnahmen

### 16 Webseite

Die Angaben stehen in der Datenschutzerklärung der Webseite.

### 17 Telefonie

- **Zweck:** Erreichbarkeit des Vereins und des Repair Cafés per Telefon
- **Betroffene:** Anrufende, Mitglieder und Engagierte
- **Daten:** Rufnummern, Verbindungsdaten, Nachrichten auf dem Anrufbeantworter, gegebenenfalls SMS
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b und f DSGVO
- **Empfänger:** Zuständige Engagierte, sipgate als Auftragsverarbeiter
- **Drittland:** Nein
- **Löschung:** Verbindungsdaten nach den Einstellungen bei sipgate, Nachrichten nach Übernahme ins Ticket

### 18 Öffentlichkeitsarbeit in sozialen Medien

- **Zweck:** Über den Verein, das Repair Café und Veranstaltungen informieren
- **Betroffene:** Besucher der Profile und des Kanals, abgebildete Personen, Bewertende bei Google Maps
- **Daten:** Veröffentlichte Beiträge, Fotos und Videos, Statistiken über Besucher, Nachrichten an den Verein, Bewertungen
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. f DSGVO für den Auftritt, lit. a für Fotos von Personen
- **Empfänger:** Öffentlich, Meta und Google als gemeinsam Verantwortliche für die Statistiken bei Instagram und YouTube, Google für Google Maps, der Betreiber von social.tchncs.de und per Föderation andere Mastodon-Instanzen, siehe [Auftragsverarbeitung](auftragsverarbeitung.md#soziale-medien-und-google)
- **Drittland:** USA
- **Löschung:** Beiträge auf Wunsch abgebildeter Personen, Nachrichten nach Übernahme ins Ticket

### 19 Einweisungen an Maschinen

- **Zweck:** Sicherstellen, dass nur eingewiesene Personen Maschinen nutzen, die gefährlich oder teuer sind, teures Material verbrauchen oder andere stören, Nachweis für Haftung und Versicherung
- **Betroffene:** Mitglieder und Engagierte
- **Daten:** Name, Maschine, Datum der Einweisung, einweisende Person, unterschriebene Bestätigung
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO aus der Mitgliedschaft, lit. f für den Nachweis
- **Empfänger:** Einweisende und Vorstand, Mitglieder sehen die Gruppen der Einweisungen, siehe [Berechtigungen](berechtigungen.md#maschinen-und-werkzeuge)
- **Drittland:** Nein
- **Löschung:** Gruppe mit dem Austritt, unterschriebene Bestätigung 3 Jahre nach dem Austritt
