#!/usr/bin/env python3
"""Show clusters, hosts, networks, datastores, templates and VMs in OpenNebula.

Uses the XML-RPC API with the credentials from tofu/.env or the environment:
OPENNEBULA_ENDPOINT, OPENNEBULA_USERNAME, OPENNEBULA_PASSWORD (password or login token)
and optionally OPENNEBULA_INSECURE=true to skip TLS verification.
API reference: https://docs.opennebula.io/7.4/product/integration_references/system_interfaces/api/
"""

import argparse
import os
import ssl
import sys
import xml.etree.ElementTree as ET
import xmlrpc.client
from pathlib import Path

ENV_FILE = Path(__file__).resolve().parent.parent / "tofu" / ".env"

# Filter flag -2: all resources the user may use, including those shared via ACLs
FILTER_ALL = -2
# VM state -1: any state except DONE
VM_STATE_NOT_DONE = -1

HOST_STATES = {
    "0": "INIT", "1": "MONITORING_MONITORED", "2": "MONITORED", "3": "ERROR",
    "4": "DISABLED", "5": "MONITORING_ERROR", "6": "MONITORING_INIT",
    "7": "MONITORING_DISABLED", "8": "OFFLINE",
}
VM_STATES = {
    "0": "INIT", "1": "PENDING", "2": "HOLD", "3": "ACTIVE", "4": "STOPPED",
    "5": "SUSPENDED", "6": "DONE", "7": "FAILED", "8": "POWEROFF",
    "9": "UNDEPLOYED", "10": "CLONING", "11": "CLONING_FAILURE",
}


def load_env():
    """Read KEY=VALUE lines from tofu/.env without overriding the environment."""
    if not ENV_FILE.exists():
        return
    for line in ENV_FILE.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def connect():
    load_env()
    try:
        endpoint = os.environ["OPENNEBULA_ENDPOINT"]
        session = f'{os.environ["OPENNEBULA_USERNAME"]}:{os.environ["OPENNEBULA_PASSWORD"]}'
    except KeyError as missing:
        sys.exit(f"Missing {missing} in tofu/.env or the environment")
    context = ssl.create_default_context()
    if os.environ.get("OPENNEBULA_INSECURE", "").lower() == "true":
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
    return xmlrpc.client.ServerProxy(endpoint, context=context), session


def call(proxy, method, *args):
    try:
        result = getattr(proxy, method)(*args)
    except xmlrpc.client.ProtocolError as error:
        sys.exit(
            f"HTTP {error.errcode} {error.errmsg} from {os.environ['OPENNEBULA_ENDPOINT']}\n"
            "Check OPENNEBULA_ENDPOINT, usually http(s)://<host>:2633/RPC2 without a slash before the port"
        )
    except OSError as error:
        sys.exit(f"Cannot reach {os.environ['OPENNEBULA_ENDPOINT']}: {error}")
    if not result[0]:
        sys.exit(f"{method} failed: {result[1]}")
    return ET.fromstring(result[1])


def text(element, path, default=""):
    found = element.find(path)
    return found.text if found is not None and found.text is not None else default


def ids(element, path):
    return ",".join(e.text for e in element.findall(path) if e.text) or "-"


def table(title, headers, rows):
    print(f"\n{title}")
    if not rows:
        print("  (keine)")
        return
    widths = [max(len(str(v)) for v in column) for column in zip(headers, *rows)]
    for row in [headers, ["-" * w for w in widths], *rows]:
        print("  " + "  ".join(str(v).ljust(w) for v, w in zip(row, widths)))


def clusters(proxy, session):
    pool = call(proxy, "one.clusterpool.info", session)
    rows = [[text(c, "ID"), text(c, "NAME"), ids(c, "HOSTS/ID"), ids(c, "VNETS/ID"), ids(c, "DATASTORES/ID")]
            for c in pool.findall("CLUSTER")]
    if not rows:
        # Without permission on the cluster pool, derive the clusters from the hosts
        hosts = call(proxy, "one.hostpool.info", session).findall("HOST")
        found = {}
        for h in hosts:
            found.setdefault((text(h, "CLUSTER_ID"), text(h, "CLUSTER")), []).append(text(h, "NAME"))
        rows = [[cid, name, ", ".join(names), "-", "-"] for (cid, name), names in sorted(found.items())]
    table("Cluster", ["ID", "NAME", "HOSTS", "NETZE", "DATASTORES"], rows)


def hosts(proxy, session):
    pool = call(proxy, "one.hostpool.info", session)
    rows = [[text(h, "ID"), text(h, "NAME"), HOST_STATES.get(text(h, "STATE"), text(h, "STATE")),
             text(h, "CLUSTER"), text(h, "CLUSTER_ID")]
            for h in pool.findall("HOST")]
    table("Hosts", ["ID", "NAME", "STATUS", "CLUSTER", "CLUSTER_ID"], rows)


def networks(proxy, session):
    pool = call(proxy, "one.vnpool.info", session, FILTER_ALL, -1, -1)
    rows = []
    for n in pool.findall("VNET"):
        ranges = "; ".join(f'{text(ar, "IP", text(ar, "MAC"))} +{text(ar, "SIZE")}' for ar in n.findall("AR_POOL/AR")) or "-"
        rows.append([text(n, "ID"), text(n, "NAME"), ids(n, "CLUSTERS/ID"), text(n, "BRIDGE"), ranges])
    table("Netze", ["ID", "NAME", "CLUSTER_IDS", "BRIDGE", "ADRESSBEREICHE"], rows)


def datastores(proxy, session):
    pool = call(proxy, "one.datastorepool.info", session)
    rows = [[text(d, "ID"), text(d, "NAME"), ids(d, "CLUSTERS/ID"), text(d, "FREE_MB"), text(d, "TOTAL_MB")]
            for d in pool.findall("DATASTORE")]
    table("Datastores", ["ID", "NAME", "CLUSTER_IDS", "FREI_MB", "GESAMT_MB"], rows)


IMAGE_STATES = {
    "0": "INIT", "1": "READY", "2": "USED", "3": "DISABLED", "4": "LOCKED", "5": "ERROR",
    "6": "CLONE", "7": "DELETE", "8": "USED_PERS", "9": "LOCKED_USED", "10": "LOCKED_USED_PERS",
}


def images(proxy, session):
    pool = call(proxy, "one.imagepool.info", session, FILTER_ALL, -1, -1)
    rows = [[text(i, "ID"), text(i, "NAME"), IMAGE_STATES.get(text(i, "STATE"), text(i, "STATE")),
             text(i, "DATASTORE"), text(i, "SIZE"), text(i, "FORMAT") or text(i, "TEMPLATE/FORMAT") or text(i, "TEMPLATE/DRIVER") or "-", text(i, "UNAME")]
            for i in pool.findall("IMAGE")]
    table("Images", ["ID", "NAME", "STATUS", "DATASTORE", "GROESSE_MB", "FORMAT", "BESITZER"], rows)


def templates(proxy, session):
    pool = call(proxy, "one.templatepool.info", session, FILTER_ALL, -1, -1)
    rows = [[text(t, "ID"), text(t, "NAME"), text(t, "UNAME"), text(t, "GNAME")] for t in pool.findall("VMTEMPLATE")]
    table("Vorlagen", ["ID", "NAME", "BESITZER", "GRUPPE"], rows)


def vms(proxy, session):
    try:
        pool = call(proxy, "one.vmpool.info", session, FILTER_ALL, -1, -1, VM_STATE_NOT_DONE, "")
    except xmlrpc.client.Fault:
        # Older OpenNebula versions take no filter string
        pool = call(proxy, "one.vmpool.info", session, FILTER_ALL, -1, -1, VM_STATE_NOT_DONE)
    rows = []
    for v in pool.findall("VM"):
        history = v.findall("HISTORY_RECORDS/HISTORY")
        host = text(history[-1], "HOSTNAME") if history else "-"
        ips = ",".join(e.text for e in v.findall("TEMPLATE/NIC/IP") if e.text) or "-"
        rows.append([text(v, "ID"), text(v, "NAME"), VM_STATES.get(text(v, "STATE"), text(v, "STATE")), host, ips])
    table("VMs", ["ID", "NAME", "STATUS", "HOST", "IP"], rows)


SECTIONS = {
    "cluster": clusters, "hosts": hosts, "netze": networks,
    "datastores": datastores, "images": images, "vorlagen": templates, "vms": vms,
}


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("sections", nargs="*", choices=[[], *SECTIONS], metavar="BEREICH",
                        help=f"einer oder mehrere von {', '.join(SECTIONS)}, ohne Angabe alle")
    args = parser.parse_args()
    proxy, session = connect()
    for name in args.sections or SECTIONS:
        SECTIONS[name](proxy, session)


if __name__ == "__main__":
    main()
