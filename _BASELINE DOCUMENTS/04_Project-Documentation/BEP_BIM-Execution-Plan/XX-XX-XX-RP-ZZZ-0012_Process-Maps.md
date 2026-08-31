# BEP ANNEXES 1–2 — PROCESS MAPS (N1 / N2)
**Project:** Sample Project (XX)
**Author:** {{AUTHOR}} · **Version:** {{DOC_VERSION}} · **Date:** {{DOC_DATE}}
**Standard:** ISO 19650-2 · Companion to the BEP (`{{CODE}}-{{OR}}-XX-RP-ZZZ-0004_BEP_v1.0.docx`)

> Annex 1 = N1 general map (BIM uses + information exchanges across phases mapped to milestones M1–M5).
> Annex 2 = N2 detailed maps, one per BIM use in scope.
> These Mermaid diagrams are the working reference until redrawn in Bizagi/BPMN; keep any PDF exports alongside this file.
> Milestone dates are [M1–M5 — TO BE DEFINED] in the MIDP/BEP — never invented here.

---

## ANNEX 1 — N1 GENERAL MAP (swim lanes: BIM uses / Information exchanges)

```mermaid
flowchart LR
  subgraph M1["M1 — Concept / Estudio Previo"]
    U1["BIM use: Existing conditions & site model ({{OR}})"]
  end
  subgraph M2["M2 — Preliminary design"]
    U2["BIM use: Structural analysis - concept ({{OR}})"]
    U3["BIM use: 3D coordination - first federation ({{OR}})"]
  end
  subgraph M3["M3 — Developed design"]
    U4["BIM use: Structural + foundation verification ({{OR}})"]
    U5["BIM use: Hydraulic modelling ({{OR}})"]
    U6["BIM use: 3D coordination + clash ({{OR}})"]
  end
  subgraph M4["M4 — Coordinated / for construction docs"]
    U7["BIM use: Quantities take-off ({{OR}})"]
    U8["BIM use: Zero unresolved clashes ({{OR}})"]
  end
  subgraph M5["M5 — Handover / as-designed"]
    U9["BIM use: Construction documentation issue ({{OR}})"]
  end

  M1 --> M2 --> M3 --> M4 --> M5

  subgraph EX["Information exchanges (data drops through CDE)"]
    E1["Data drop @M1: site/reference"]
    E2["Data drop @M2: S concept + federation"]
    E3["Data drop @M3: S+H coordinated models"]
    E4["Data drop @M4: clash-free coordinated set"]
    E5["Data drop @M5: construction docs + as-designed"]
  end

  M1 -.-> E1
  M2 -.-> E2
  M3 -.-> E3
  M4 -.-> E4
  M5 -.-> E5
```

**Incoming (external) into the flow:** Architecture (AR) and Geotechnical/borehole (GE) deliveries enter via `01_Incoming`, are verified (≤5 working days) and registered into `02_Shared/00_Architecture` as reference before each data drop.

---

## ANNEX 2 — N2 DETAILED MAPS (per BIM use)

### N2.1 — Structural analysis (Revit ↔ Robot ↔ Midas GTS NX)

```mermaid
flowchart TD
  A["Reference: architecture model (AR, verified) + geotech report (GE, verified)"] --> B["Build analytical model in Revit 2026 ({{OR}})"]
  B --> C["Bidirectional link to Robot 2026 - run structural analysis ({{OR}})"]
  C --> D{"Analysis valid? (convergence, code checks)"}
  D -- No --> B
  D -- Yes --> E["Extract foundation loads"]
  E --> F["Foundation / soil-structure verification in Midas GTS NX ({{OR}})"]
  F --> G{"Foundations verified?"}
  G -- No --> B
  G -- Yes --> H["Consolidate results - Calculation-Reports"]
  H --> I["Share container S (S2/S3) into 02_Shared - Container Register row"]
```

### N2.2 — 3D coordination (federation + clash, Revit Interference Check)

```mermaid
flowchart TD
  A["Collect latest Shared containers: Architecture (ref), Structural, Hydraulic"] --> B["Create federated model - link in Revit ({{OR}})"]
  B --> C["Run pairwise clash checks: ARQ-EST, ARQ-HID, EST-HID (Revit Interference Check)"]
  C --> D{"Clashes within tolerance?"}
  D -- No --> E["Assign issues to discipline modeller - resolve in WIP"]
  E --> B
  D -- Yes --> F["Issue favourable coordination report"]
  F --> G["Coordination data drop (status per milestone) - Container Register row"]
```

### N2.3 — Hydraulic modelling & integration

```mermaid
flowchart TD
  A["Reference: coordinated structural model + architecture (verified)"] --> B["Model hydraulic/sanitary network in Revit 2026 ({{OR}})"]
  B --> C{"Routing clash-free vs structure?"}
  C -- No --> B
  C -- Yes --> D["Pre-share checklist (LDE / BEP Section J, size <=300 MB)"]
  D --> E["Share container H (S2) into 02_Shared - Container Register row"]
```

> Note: Fire-Fighting (FIR), Electrical (ELE) and Geotech/Earthworks (GEO) authoring are OUT OF EC SCOPE for this project. If added later, extend Annex 2 with the corresponding N2 map and update the clash matrix (BEP §5.2b).
