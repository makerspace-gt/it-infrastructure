# Daten und Aufbewahrung

Diese Übersicht ist die Grundlage für das Verzeichnis von Verarbeitungstätigkeiten und das Löschkonzept. Sie zeigt pro Dienst, welche personenbezogenen Daten anfallen, wo IP-Adressen gespeichert werden und wie lange. Die Standardwerte stammen aus den Quellen unter upstream/, soweit dort angegeben. Was als zu prüfen markiert ist, klären wir in Schritt 1 des jeweiligen Dienstes. Das ist keine Rechtsberatung.

## Grundregeln

| Datenart | Aufbewahrung | Begründung |
|---|---|---|
| Logs mit IP-Adressen, etwa Zugriffe und Anmeldeversuche | 7 Tage | Erkennen und Abwehren von Angriffen, berechtigtes Interesse nach Art. 6 Abs. 1 lit. f DSGVO |
| Prüfprotokolle wie Anmeldungen in authentik oder Änderungen in NetBird | 90 Tage | Nachvollziehen von Sicherheitsvorfällen |
| Tickets des Repair Cafés | 3 Jahre nach Abschluss | Nachfragen zu Reparaturen, Statistik, erneute Termine |
| Anfragen zum Repair Café ohne Termin, zu dem jemand erschienen ist | 3 Monate | Nur für die Terminvergabe nötig |
| Übrige Tickets mit steuerlich relevanten Belegen wie Rechnungen oder Spenden | 10 Jahre nach Abschluss | Steuerliche Aufbewahrungspflicht |
| Übrige Tickets ohne solche Belege | 3 Jahre nach Abschluss | Nachvollziehen von Anfragen und Absprachen |
| Übrige Inhalte wie Dateien oder Beiträge | Nach Löschkonzept des Dienstes | Zweck des jeweiligen Dienstes |
| Backups | Bis zu 6 Monate | Wiederherstellung, gelöschte Daten verschwinden spätestens nach dieser Frist auch aus den Backups |

Wo ein Dienst IP-Adressen nicht braucht, speichern wir sie gar nicht oder nur gekürzt.

## Systemweit

| Bereich | Daten | Standard | Maßnahme |
|---|---|---|---|
| Container-Logs | Alles, was Dienste ausgeben, oft mit IP-Adressen | Docker dreht Logs ohne Einstellung nicht und behält sie unbegrenzt | Basisrolle schreibt Container-Logs ins [Journal](https://docs.docker.com/engine/logging/drivers/journald/), [journald](https://www.freedesktop.org/software/systemd/man/latest/journald.conf.html) löscht nach 7 Tagen |
| Systemlogs | SSH-Anmeldungen mit IP, sudo | Journal mit Größenbegrenzung, ohne Frist | Gleiche Frist von 7 Tagen über journald |
| Traefik | Zugriffe aus dem Internet auf den NetBird-Proxy | Läuft laut [Installationsskript](https://github.com/netbirdio/netbird/blob/main/infrastructure_files/getting-started.sh) als Teil von NetBird auf der Zugangs-VM, Zugriffslog nur, wenn eingeschaltet | Zugriffslog nur über das Journal, also 7 Tage, oder IP-Felder laut [Doku](https://doc.traefik.io/traefik/observability/access-logs/) auf redact setzen |
| CrowdSec | IP-Adressen der Anfragen an den Proxy und der Anmeldeversuche per SSH auf allen VMs, Sperrlisten | Optional in NetBird, laut [Installationsskript](https://github.com/netbirdio/netbird/blob/main/infrastructure_files/getting-started.sh) mit `NETBIRD_ENABLE_CROWDSEC`. Prüft IP-Adressen gegen eine gemeinsame Reputationsdatenbank, die [zentrale API](https://docs.crowdsec.net/docs/central_api/intro) kann dabei auch Meldungen über Angreifer erhalten | Eingeschaltet mit Austausch über die zentrale API. Dabei gehen IP-Adressen von Angreifern an CrowdSec in Frankreich, dafür schließen wir einen AVV ab |
| Backups mit resticker | Kopien aller Daten | Alte Rollen hielten bis zu 12 Monate | Monatliche Snapshots auf 6 begrenzen, damit Löschungen nach spätestens 6 Monaten auch aus den Backups verschwinden |
| Offline-Kopie am Raspberry Pi | Kopien aller Daten | Eigene Regeln | Dieselbe Frist wie auf der Storagebox |

## Pro Dienst

| Dienst | Personenbezogene Daten | IP-Adressen | Standard | Vorschlag |
|---|---|---|---|---|
| authentik | Name, E-Mail, Gruppen, Zwei-Faktor-Geräte | Ereignisse mit IP und Browser | Ereignisse 365 Tage, `event_retention` in den [Systemeinstellungen](https://github.com/goauthentik/authentik/blob/main/authentik/admin/models.py) | Ereignisse 90 Tage |
| NetBird | E-Mail und Name aus authentik, Geräte mit Hostname, Betriebssystem und öffentlicher IP | Peers, Aktivitätslog, Zugriffslog des Proxys | Zu prüfen | Aktivitäten 90 Tage, Zugriffslog des Proxys 7 Tage |
| Vaultwarden | E-Mail, Name, verschlüsselter Tresor, den nur das Mitglied öffnen kann | Ereignisse von Organisationen, Logs | Ereignisse unbegrenzt, solange `EVENTS_DAYS_RETAIN` nicht gesetzt ist | `EVENTS_DAYS_RETAIN=90` |
| Zammad | Gäste mit Name, E-Mail, Telefon, Tickets, Anhänge, Fotos von Geräten | Logs von Rails und nginx, über das Journal 7 Tage | Tickets unbegrenzt | Repair Café 3 Jahre nach Abschluss, Anfragen ohne Erscheinen 3 Monate, übrige Tickets 3 Jahre, mit steuerlich relevanten Belegen 10 Jahre. Tickets mit Belegen bekommen dafür ein Tag oder Feld. Umgesetzt über zeitgesteuerte Aktionen in Zammad mit der Aktion Löschauftrag. Reparaturdaten sind dann bereits anonym als Laufzettel bei reparatur-initiativen.org. Adressen erfassen wir nicht in den Feldern der Kunden. Der Geo Location Service ist trotzdem abgeschaltet, damit auch künftig keine Adressen an OpenStreetMap gehen |
| n8n | Daten der Ausführungen, darin Inhalte aus Tickets | Logs | Ausführungen 14 Tage, `EXECUTIONS_DATA_MAX_AGE=336` in [executions.config.ts](https://github.com/n8n-io/n8n/blob/master/packages/@n8n/config/src/configs/executions.config.ts) | 7 Tage oder nur fehlgeschlagene Ausführungen speichern |
| Ollama | Prompts nur im Arbeitsspeicher | Keine eigenen Logs mit IP | Speichert keine Prompts, solange kein Debug-Log läuft | Kein Debug-Log im Betrieb |
| Open WebUI | Konten, Chatverläufe der Engagierten | Logs | Chats unbegrenzt, zu prüfen | Chats nach 90 Tagen löschen, keine echten Gästedaten in Tests |
| Nextcloud | Konten, Dateien, Kalender, Kontakte | Aktivitäten, nextcloud.log | Zu prüfen | Aktivitäten 90 Tage, Papierkorb und Versionen automatisch |
| Discourse | Konten, Beiträge, Nachrichten | IP bei Registrierung und letzter Anmeldung | E-Mail-Logs 90 Tage, Entwürfe 180 Tage laut [site_settings.yml](https://github.com/discourse/discourse/blob/main/config/site_settings.yml). Teilt anonymisierte Statistiken | Statistiken nicht teilen, Umgang mit gespeicherten IP-Adressen prüfen |
| Immich | Fotos mit EXIF-Daten inklusive Ort, Gesichter | Logs | Erkennung von Gesichtern eingeschaltet | Gesichtserkennung bleibt an, damit wir Fotos Personen zuordnen und sie um ihre Einwilligung zur Veröffentlichung fragen können. Siehe Abschnitt zu Immich |
| Vikunja | Konten, Aufgaben | Logs | Zu prüfen | Erledigte Aufgaben archivieren |
| Forgejo | Konten, E-Mail, Commits mit Namen der Autoren | Logs | Zu prüfen | Commits in öffentlichen Repos sind öffentlich, darauf bei der Registrierung hinweisen |
| Uptime Kuma | Keine, außer Konten der Admins | Keine | Verlauf der Monitore zu prüfen | 90 Tage Verlauf |
| Beszel | Keine, nur Messwerte der Hosts | Keine | Zu prüfen | |
| Arcane | Konten der Admins | Logs | Zu prüfen | |
| signal-cli-rest-api | Telefonnummern, empfangene Nachrichten | Keine | Speichert empfangene Nachrichten lokal, zu prüfen | Nur ausgehende Benachrichtigungen, empfangene Nachrichten nicht aufheben |
| LanguageTool | Geprüfte Texte nur im Arbeitsspeicher | Logs | Zu prüfen | Keine Texte loggen |
| Dependency-Track | Keine, außer Konten | Keine | | |
| reparatur-initiativen.org | Laufzettel ohne personenbezogene Daten | | | Alter und Geschlecht der Gäste nicht übertragen |

## Immich und Gesichtserkennung

Wir nutzen die Gesichtserkennung, um Fotos Personen zuzuordnen und diese gezielt um ihre Einwilligung zur Veröffentlichung zu fragen. Gesichtserkennung verarbeitet biometrische Daten, die nach [Art. 9 DSGVO](https://dsgvo-gesetz.de/art-9-dsgvo/) besonders geschützt sind. Die Erkennung läuft dabei schon, bevor jemand eingewilligt hat. Diesen Widerspruch klären wir mit einer Datenschutzberatung. Bis dahin bleibt die Gesichtserkennung eingeschaltet, und wir halten das Risiko mit diesen Maßnahmen klein:

- Nur ein kleiner Kreis von Engagierten hat Zugriff auf Immich und die erkannten Personen
- Bei Veranstaltungen weisen Aushänge auf Fotos und die Zuordnung hin, wer nicht fotografiert werden will, bekommt ein Erkennungszeichen
- Wer nicht einwilligt, wird samt erkanntem Gesicht gelöscht
- Die Daten für die Gesichtserkennung bleiben lokal, das Machine Learning läuft auf dem Mini-PC oder der Fotos-VM

## Offene Punkte

- Standardwerte mit dem Vermerk zu prüfen in Schritt 1 des jeweiligen Dienstes klären und hier nachtragen
- Gesichtserkennung in Immich mit einer Datenschutzberatung klären
