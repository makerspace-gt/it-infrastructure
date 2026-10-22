# Auftragsverarbeitung

Diese Übersicht zeigt, welche Dienstleister in unserem Auftrag personenbezogene Daten verarbeiten und ob ein Vertrag zur Auftragsverarbeitung nach [Art. 28 DSGVO](https://dsgvo-gesetz.de/art-28-dsgvo/) besteht. Die unterschriebenen Verträge liegen privat im Gruppenordner des Vorstands in Nextcloud. Das ist keine Rechtsberatung.

| Anbieter | Leistung | Daten | Ort | AVV | Stand |
|---|---|---|---|---|---|
| Betreiber von OpenNebula unter 4830.org | VMs für alle Dienste | Alle Daten der Dienste | Deutschland, zu prüfen | Offen | |
| Hetzner | Storagebox für Backups und Dateien von Nextcloud | Verschlüsselte Backups, Dateien von Nextcloud | Deutschland oder Finnland, je nach gewähltem Standort der Storagebox, siehe [Datenschutz-FAQ](https://docs.hetzner.com/de/general/general-terms-and-conditions/data-privacy-faq/) | Offen, Hetzner bietet den AVV in der Verwaltungsoberfläche an | |
| lima-city | Domain, DNS, Webseite, E-Mail | Inhalte der Webseite, E-Mails | Deutschland | Offen | |
| GitHub | Spiegel öffentlicher Repos, Container-Images | Namen und E-Mail in Commits | USA, nach [Art. 44 DSGVO](https://dsgvo-gesetz.de/art-44-dsgvo/) zu bewerten | Offen | |
| CrowdSec | Reputation von IP-Adressen | IP-Adressen auffälliger Anfragen | Frankreich | Offen | |
| Digitalcourage mit Nuudel | Terminabfragen | Namen und Verfügbarkeit | Deutschland | Zu prüfen, ob ein AVV angeboten wird | |
| sipgate | Telefonie | Rufnummern, Verbindungsdaten, Anrufbeantworter, gegebenenfalls SMS | Deutschland, siehe [Datenschutz](https://www.sipgate.de/datenschutz) | Offen | |

Keine Auftragsverarbeitung, weil wir dort keine personenbezogenen Daten in unserem Auftrag verarbeiten lassen oder die Anbieter in eigener Verantwortung handeln:

| Anbieter | Begründung |
|---|---|
| anstiftung mit reparatur-initiativen.org | Laufzettel sind anonym. Für die Neuigkeiten des Repair Cafés melden sich Gäste selbst an, die Plattform ist dafür eigenverantwortlich |
| Open Repair Alliance | Erhält nur anonyme Daten über die anstiftung |
| Let's Encrypt | Stellt Zertifikate für Domains aus, keine personenbezogenen Daten |

## Messenger

Signal und WhatsApp sind keine Auftragsverarbeiter in unserem Auftrag. Beide bieten Privatpersonen und Vereinen keinen AVV an, und sie verarbeiten Daten in eigener Verantwortung. Nutzen wir sie als Verein, sind wir trotzdem für unsere Gruppen und Konten verantwortlich.

| | Signal | WhatsApp |
|---|---|---|
| Betreiber | Signal Messenger LLC, USA, siehe [Rechtliches](https://signal.org/legal/) | Meta, USA |
| Inhalte | Ende-zu-Ende verschlüsselt | Ende-zu-Ende verschlüsselt |
| Metadaten | Sehr wenige, nach eigenen Angaben nur Telefonnummer, Zeitpunkt der Registrierung und der letzten Verbindung | Umfangreich, etwa wer mit wem wann kommuniziert |
| Adressbuch | Abgleich ohne Weitergabe der Kontakte im Klartext | Lädt die Telefonnummern aller Kontakte hoch, auch von Personen, die nicht eingewilligt haben |
| Drittland | USA | USA, Meta ist nach dem [Data Privacy Framework](https://www.dataprivacyframework.gov/list) zertifiziert |
| Für Unternehmen | Kein Angebot | WhatsApp Business mit eigenen [Bedingungen zur Datenverarbeitung](https://www.whatsapp.com/legal/business-data-processing-terms) |

Daraus folgt für uns:

- **Signal ist der Messenger des Vereins.** Gruppen und Benachrichtigungen über signal-cli-rest-api laufen über Signal.
- **Teilnahme ist freiwillig.** Niemand muss einen Messenger nutzen, wichtige Informationen gibt es auch per E-Mail oder im Forum.
- **WhatsApp nur, wo es nicht anders geht.** Falls Gäste den Verein über WhatsApp erreichen, dann über ein eigenes Gerät oder Konto des Vereins ohne Adressbuch, mit Hinweis in der Datenschutzerklärung. Daten aus solchen Chats kommen ins Ticket und werden im Messenger gelöscht.

## Soziale Medien und Google

| Dienst | Nutzung | Einordnung |
|---|---|---|
| Instagram | Auftritt des Vereins | Für die Statistiken über Besucher des Profils sind wir mit Meta gemeinsam verantwortlich nach [Art. 26 DSGVO](https://dsgvo-gesetz.de/art-26-dsgvo/), so hat der EuGH für Fanpages entschieden ([C-210/16](https://curia.europa.eu/juris/liste.jsf?num=C-210/16)). Meta regelt das in einer [Vereinbarung für Seiten-Insights](https://www.facebook.com/legal/terms/page_controller_addendum). In der Datenschutzerklärung nennen wir den Auftritt, Meta als gemeinsam Verantwortlichen und das Wesentliche der Vereinbarung. Fotos von Personen veröffentlichen wir nur mit Einwilligung |
| Google | Zu klären, welche Dienste wir nutzen | Ein Eintrag bei Google Maps über das [Unternehmensprofil](https://support.google.com/business/answer/3038177) verarbeitet Bewertungen in Verantwortung von Google, ein AVV ist nicht nötig. Für Dienste wie Google Workspace, Kalender oder Formulare mit personenbezogenen Daten gelten die [Bedingungen zur Auftragsverarbeitung](https://business.safety.google/processorterms/) von Google, dann gehört Google in die Tabelle oben. Google Analytics auf der Webseite bräuchte eine Einwilligung |

Spalte Stand bekommt das Datum des Vertrags. Ändert sich ein Anbieter, wird diese Datei im selben Commit angepasst.
