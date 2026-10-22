# Auftragsverarbeitung

Diese Übersicht zeigt, welche Dienstleister in unserem Auftrag personenbezogene Daten verarbeiten und ob ein Vertrag zur Auftragsverarbeitung nach [Art. 28 DSGVO](https://dsgvo-gesetz.de/art-28-dsgvo/) besteht. Die unterschriebenen Verträge liegen privat im Gruppenordner des Vorstands in Nextcloud. Das ist keine Rechtsberatung.

| Anbieter | Leistung | Daten | Ort | AVV | Stand |
|---|---|---|---|---|---|
| 4830.org e.V., Verein hinter der Freifunk-Community Kreis Gütersloh | VMs in OpenNebula für alle Dienste | Alle Daten der Dienste | Deutschland, zu prüfen | Offen | |
| Hetzner | Storagebox für Backups und Dateien von Nextcloud | Verschlüsselte Backups, Dateien von Nextcloud | Deutschland, siehe [Datenschutz-FAQ](https://docs.hetzner.com/de/general/general-terms-and-conditions/data-privacy-faq/) | Offen, Hetzner bietet den AVV in der Verwaltungsoberfläche an | |
| lima-city | Domain, DNS, Webseite, E-Mail | Inhalte der Webseite, E-Mails | Deutschland | Abgeschlossen | Datum nachtragen |
| GitHub | Bisher Hauptort für Code, Container-Images, später eventuell nur Spiegel | Namen und E-Mail in Commits, Konten der Mitwirkenden | USA, nach [Art. 44 DSGVO](https://dsgvo-gesetz.de/art-44-dsgvo/) zu bewerten, GitHub ist über Microsoft nach dem [Data Privacy Framework](https://www.dataprivacyframework.gov/list) zertifiziert, zu prüfen | Offen, zu prüfen, ob GitHub für unsere Organisation einen AVV anbietet | |
| CrowdSec | Reputation von IP-Adressen | IP-Adressen auffälliger Anfragen | Frankreich | Offen | |
| Digitalcourage mit Nuudel | Terminabfragen | Namen und Verfügbarkeit | Deutschland | Zu prüfen, ob ein AVV angeboten wird | |
| sipgate | Telefonie | Rufnummern, Verbindungsdaten, Anrufbeantworter, gegebenenfalls SMS | Deutschland, siehe [Datenschutz](https://www.sipgate.de/datenschutz) | Offen | |

Keine Auftragsverarbeitung, weil wir dort keine personenbezogenen Daten in unserem Auftrag verarbeiten lassen oder die Anbieter in eigener Verantwortung handeln:

| Anbieter | Begründung |
|---|---|
| anstiftung mit reparatur-initiativen.org für Laufzettel | Laufzettel sind anonym |
| anstiftung mit reparatur-initiativen.org für den Newsletter | Wir tragen E-Mail-Adressen nur auf Wunsch der Gäste ein, die Anmeldung schließen die Gäste selbst per Bestätigungsmail ab. Die anstiftung ist für den Versand damit voraussichtlich eigener Verantwortlicher. Das lassen wir uns von der anstiftung bestätigen |
| Open Repair Alliance | Erhält nur anonyme Daten über die anstiftung |
| Hausbank des Vereins | Führt die Lastschriften für die Beiträge in eigener Verantwortung aus, nach eigenen gesetzlichen Pflichten. Sie ist Empfängerin, kein Auftragsverarbeiter |
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

- **Signal ist der bevorzugte Messenger des Vereins.** Benachrichtigungen über signal-cli-rest-api und neue Gruppen laufen über Signal. Bestehende Gruppen in WhatsApp bleiben, wir weisen aber auf die Weitergabe der Kontakte an Meta hin.
- **Teilnahme ist freiwillig.** Niemand muss einen Messenger nutzen, wichtige Informationen gibt es auch per E-Mail oder im Forum.
- **Gruppen in WhatsApp.** Für die Gruppen des Vereins sind wir verantwortlich. In der Beschreibung jeder Gruppe steht ein kurzer Hinweis auf den Datenschutz und die Alternative per E-Mail oder Forum. Wer eine Gruppe verwaltet, nimmt nur Mitglieder auf, die beitreten wollen.

## Soziale Medien und Google

| Dienst | Nutzung | Einordnung |
|---|---|---|
| Instagram | Auftritt des Vereins | Für die Statistiken über Besucher des Profils sind wir mit Meta gemeinsam verantwortlich nach [Art. 26 DSGVO](https://dsgvo-gesetz.de/art-26-dsgvo/), so hat der EuGH für Fanpages entschieden ([C-210/16](https://curia.europa.eu/juris/liste.jsf?num=C-210/16)). Meta regelt das in einer [Vereinbarung für Seiten-Insights](https://www.facebook.com/legal/terms/page_controller_addendum). In der Datenschutzerklärung nennen wir den Auftritt, Meta als gemeinsam Verantwortlichen und das Wesentliche der Vereinbarung. Fotos von Personen veröffentlichen wir nur mit Einwilligung |
| Google Maps | Unternehmensprofil des Vereins | Google verarbeitet Bewertungen und Besucherdaten in eigener Verantwortung, ein AVV ist nicht nötig. In der Datenschutzerklärung erwähnen wir das Profil |
| YouTube | Kanal des Vereins | Google ist für YouTube selbst verantwortlich. Für die Statistiken über Zuschauer des Kanals ist eine gemeinsame Verantwortung wie bei Instagram denkbar, das klären wir bei der Datenschutzerklärung. Videos mit Personen veröffentlichen wir nur mit Einwilligung. Werden Videos auf der Webseite eingebettet, laden sie erst nach Klick |
| Mastodon | Profil des Vereins auf [social.tchncs.de](https://social.tchncs.de/about), betrieben von Milan Ihl in Deutschland | Der Betreiber verarbeitet die Daten für seinen eigenen Dienst und ist dafür selbst verantwortlich, ein AVV ist nicht nötig. Eine gemeinsame Verantwortung wie bei Instagram liegt nicht vor, weil Mastodon uns keine Statistiken über Besucher liefert. Beiträge gehen per Föderation an andere Instanzen, die sie in eigener Verantwortung speichern. In der Datenschutzerklärung nennen wir das Profil, den Betreiber und die Föderation |

Spalte Stand bekommt das Datum des Vertrags. Ändert sich ein Anbieter, wird diese Datei im selben Commit angepasst.
