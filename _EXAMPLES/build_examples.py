"""Build a multi-project MC demo from the Burger King JSON example.

The three additional project names come from folder names on F:. All newly
created scope, dates and process data are illustrative, not real project facts.
"""

import copy
import json
import re
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "BURGER KING" / "MC_data_BK_sample.json"
APP = HERE.parent / "MC_PROJETOS.html"
OUTPUT = HERE / "MC_data_all_04c_process_examples.json"

SPECS = [
    ("assai", "ASSAÍ - FOZ DE IGUAÇU — DEMO", "ASFI", "Assaí", "Foz do Iguaçu",
     ["STR", "FDN", "HID", "MEC"],
     [("Existing conditions modeling", "M1", "Eric Castro"),
      ("Site analysis", "M1", "Camila Rocha"),
      ("Programming", "M1", "Rafael Nunes"),
      ("Design authoring", "M2", "Eric Castro"),
      ("Cost estimation", "M4", "Eric Castro"),
      ("Design review", "M4", "Rafael Nunes")]),
    ("autozone", "AUTOZONE - ARAUCÁRIA — DEMO", "AZAR", "AutoZone", "Araucária",
     ["STR", "STL", "FDN", "HID"],
     [("4D modeling", "M4", "Rafael Nunes"),
      ("Structural analysis", "M3", "Eric Castro"),
      ("Lighting analysis", "M3", "Rafael Nunes"),
      ("Design coordination", "M4", "Rafael Nunes"),
      ("Site utilization planning", "M4", "Rafael Nunes")]),
    ("carrefour", "CPV - CARREFOUR CAMPINAS VALINHOS — DEMO", "CPV", "Carrefour", "Campinas / Valinhos",
     ["STR", "MAS", "FDN", "HID", "MEC"],
     [("Energy analysis", "M3", "Helena Prado"),
      ("3D control and planning", "M4", "Rafael Nunes"),
      ("Record modeling", "M5", "Rafael Nunes"),
      ("Maintenance scheduling", "M5", "Helena Prado"),
      ("Building system analysis", "M5", "Helena Prado")]),
]

def app_templates():
    source = APP.read_text(encoding="utf-8")
    match = re.search(r"const PROCESS_TEMPLATES=(\{[\s\S]*?\});\s*function processStepsFor", source)
    if not match:
        raise ValueError("Process template library not found in MC_PROJETOS.html")
    return json.loads(match.group(1))


def build_project(base, spec, emails, templates):
    key, name, code, client, city, disciplines, uses = spec
    p = copy.deepcopy(base)
    p.update(id=f"demo_{key}", name=name, code=code, client=client, city=city,
             address="", postal="", country="Brasil", status="hold",
             desc="DEMONSTRATION ONLY: scope, dates and workflow are illustrative, not verified project facts.",
             contractNo="", quote="", files=[], schedule={}, externals={"ar_office": "", "ge_office": ""})
    p["clientData"] = {"ap_name": client, "ap_rep": "", "ap_contact": "",
                       "oir": "Example only - confirm the real OIR.",
                       "pir": "Example only - define actual information exchanges by milestone.",
                       "air": "Example only - confirm handover asset data requirements.",
                       "brand": "", "permits": []}
    p["contract"] = {field: "" for field in base["contract"]}
    p["team"] = []
    for item in base["team"]:
        if item["kind"] == "Discipline" and not any(f"({d})" in item["label"] for d in disciplines):
            continue
        row = copy.deepcopy(item)
        row["id"] = f"demo_{key}_team_{len(p['team']) + 1}"
        if row["label"] == "Client representative":
            row["person"] = row["email"] = ""  # do not imply BK's client contact represents another client
        else:
            row["email"] = emails.get(row.get("person", ""), "")
        p["team"].append(row)
    for i, milestone in enumerate(p["milestones"]):
        milestone.update(id=f"demo_{key}_milestone_{i+1}",
                         planned=f"2027-{[2, 4, 6, 8, 10][i]:02d}-15", actual="")
    p["docMeta"] = {"version": "DEMO", "date": "2027-01-15"}
    bim = p["bim"]
    bim.update(software=[], comm={"chat": "", "board": "", "calendar": ""},
               coords={"ns": "", "ew": "", "elev": "", "north": "", "cadastral": ""},
               standard={}, responsibilities=[], risks=[], appointments=[],
               cde={"platform": "", "url": "", "notes": ""}, federation={}, qa=[], formats=[],
               bimUses=[])
    p["processes"] = []
    for i, (use, phase, owner) in enumerate(uses, 1):
        use_id = f"demo_{key}_use_{i}"
        bim["bimUses"].append({"id": use_id, "use": use,
                               "purpose": f"Illustrative {use.lower()} workflow; confirm for this project."})
        if use not in templates:
            raise ValueError(f"Missing app template: {use}")
        steps = [{"id": f"demo_{key}_step_{i}_{j}", "kind": kind, "text": text,
                  "who": owner if kind in ("task", "decision") else ""}
                 for j, (kind, text) in enumerate(templates[use], 1)]
        p["processes"].append({"id": f"demo_{key}_process_{i}", "useId": use_id,
                               "phase": phase, "who": owner, "status": "Draft", "steps": steps})
    return p


def main():
    if OUTPUT.exists():
        raise SystemExit(f"Refusing to overwrite {OUTPUT}")
    source = json.loads(SOURCE.read_text(encoding="utf-8-sig"))
    base = source["projects"][0]
    templates = app_templates()
    emails = {user["name"]: user.get("email", "") for user in source.get("users", [])}
    selected = {use for spec in SPECS for use, _, _ in spec[6]}
    if selected != set(templates):
        raise ValueError(f"04c coverage mismatch: missing {set(templates)-selected}; extra {selected-set(templates)}")
    projects = [base] + [build_project(base, spec, emails, templates) for spec in SPECS]
    now = datetime.now(timezone.utc).isoformat()
    result = {"meta": {"title": "MC multi-project DEMO", "schema": 1, "created": now},
              "rev": 1, "lastSavedBy": "", "lastSavedAt": "", "projects": projects,
              "users": source.get("users", []), "accessLog": [],
              "log": [{"id": f"demo_log_{i}", "ts": now, "editor": "system", "email": "",
                       "project": p["id"], "projName": p["name"],
                       "field": "project included in demo set", "from": "", "to": p["name"]}
                      for i, p in enumerate(projects, 1)]}
    OUTPUT.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Created {OUTPUT} with {len(projects)} projects")


if __name__ == "__main__":
    main()
