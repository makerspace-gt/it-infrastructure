# it-infrastructure

Die IT-Infrastruktur des Makerspace Gütersloh als Code. VMs mit OpenTofu in OpenNebula, Dienste mit Ansible und Docker Compose, Zugang über NetBird und authentik.

Den Stand des Neuaufbaus beschreibt der [Plan](PLAN.md). Wie man mit OpenTofu und Ansible startet, steht in der [Einrichtung](docs/einrichtung.md). Die Quellen der eingesetzten Dienste liegen als Submodule unter `upstream/`. Das bisherige Repo [docker-compose-server](https://github.com/makerspace-gt/docker-compose-server) dient bis zum Abschluss des Umzugs als Nachschlagewerk.

## Lizenz

Neue Inhalte stehen unter der [MIT-Lizenz](LICENSE). Rollen und Dateien, die aus docker-compose-server übernommen werden, behalten dessen Lizenz CC BY 4.0, solange nicht alle Beteiligten einer Änderung zugestimmt haben. Die Kennzeichnung erfolgt pro Datei nach [REUSE](https://reuse.software/). Die Submodule unter `upstream/` behalten ihre eigenen Lizenzen.
