# BIM PROJECT — USER MANUAL (ISO 19650)
**Standard:** {{AUTHOR}} · **Version:** {{DOC_VERSION}} · **Date:** {{DOC_DATE}}
**Companion to:** `BIM-PROJECT-KICKOFF_ISO19650_STANDARD.md` (the "Kickoff Standard")
**Project:** Sample Project (XX)
**Changelog v1.1:** added RACI note (§1), "working day" definition (§3.4), code-tables note + Level of Information Need quick reference (§4/§4b), security baseline (§7), audit-mode note (§9).

**Purpose:** this manual tells every team member — internal or external — how to use the project folders and the 13 standard documents day to day. Read Sections 2–4 before touching any file.

---

## 1. Who does what (process owners)

| Role | Owner | Responsibility in this manual |
|---|---|---|
| {{ROW_ROLE}} | {{ROW_PERSON}} | {{ROW_AUTHORITY}} |
| External architecture office (AR): {{AR_OFFICE}} | [EXTERNAL ARCHITECTURE OFFICE — TO BE DEFINED] | Delivers ONLY into `01_Incoming/Architecture`, never into the CDE directly |
| External geotechnical office (GE): {{GE_OFFICE}} | [EXTERNAL GEOTECHNICAL OFFICE — TO BE DEFINED] | Delivers ONLY into `01_Incoming/Geotechnical-Borehole-Data`, never into the CDE directly |

Fixed-default responsibilities (no name asked): **WIP→Shared approval** = BIM Manager (modeller self-check via pre-share checklist is NOT approval — never self-approved); **Drawings-Deliverables** = discipline modeller produces, Information Manager registers numbering/revisions.

One person may hold several roles — in this small project the author ({{AUTHOR}}) holds all internal technical roles. Keep in sync when an owner changes: project Instructions + BEP roles table (Kickoff §5.2c) + this table + ClickUp assignees.

**Authority (RACI).** Who is *Accountable* vs *Responsible* for each activity is defined in the RACI matrix in the BEP (Kickoff §5.2c). Quick read: modeller = R for authoring & self-check; **BIM Manager = A for WIP→Shared approval, BEP changes and LOIN compliance**; **Information Manager = A for the Container Register, incoming verification and security classification**; BIM Coordinator = A for federation & clash; **Client representative = A for Shared→Published authorisation**. Exactly one Accountable per activity — when EC holds several roles, EC still wears the correct "hat" per activity; if in doubt, check the BEP RACI.

---

## 2. Folder guide — where things go

```
{{PROJECT_NAME}}  (Cowork project folder = PROJECT ROOT)
├── 00_Admin_Contracts/            → signed agreement, BIM Protocol, fees. Admin only.
├── 01_Incoming/                   → EXTERNALS DELIVER HERE. Quarantine, nothing is used from here.
├── 02_CDE/
│   ├── 01_WIP/                    → your live native files (.rvt, Robot, Midas, Civil 3D). Private per team.
│   ├── 02_Shared/                 → checked containers for coordination. Read-only for other teams.
│   ├── 03_Published/              → client-authorised deliverables. Read-only for everyone.
│   └── 04_Archived/               → superseded revisions. NEVER modify or delete.
└── 04_Project-Documentation/      → EIR, BEP + annexes, MIDP/TIDP, Container Register,
                                     standards (LDE, this manual), reports, drawings, minutes.
```

Golden rules:

- Work ONLY in your discipline's `01_WIP` subfolder. Never edit anything in Shared, Published or Archived.
- Never email a model. All exchanges go through the CDE; emails reference container IDs only.
- Externals: drop your delivery in your `01_Incoming` subfolder and notify the Information Manager. It becomes usable only after verification (≤5 working days) and registration into `02_Shared`.

---

## 3. CDE workflow — step by step

### 3.1 Sharing your work (WIP → Shared)
1. Finish the model/document in `01_WIP`.
2. Run the pre-share checklist (BEP Section J / LDE): visual check, standards/LDE compliance, correct coordinates (shared origin), model integrity (audit, no warnings above threshold), analytical consistency, **file size ≤ 300 MB** (Section 5 below).
3. Export the exchange container (IFC + PDF, or frozen native copy per BEP).
4. Name it per Section 4, with status `S1–S4` and next revision `Pnn`.
5. Place it in `02_Shared/<discipline>/` and add a row in the Container Register.
6. Notify the team referencing the container ID.

### 3.2 Publishing (Shared → Published)
1. Client reviews the container at the milestone (status S3/S4).
2. On written authorisation, the Information Manager copies it to `03_Published` renamed with status `A` and revision `C01` (then C02…), registers the transition.

### 3.3 Superseding (→ Archived)
When a new revision enters Shared or Published, the Information Manager moves the previous one to `04_Archived`. Archived files are immutable — the audit trail.

### 3.4 Receiving external information (Incoming → Shared)
1. External party uploads to `01_Incoming/<their folder>/`.
2. Information Manager verifies within 5 working days: completeness, coordinates, format, naming.
3. PASS → registered copy goes to `02_Shared/00_Architecture` (or the relevant discipline) as reference; original stays untouched in Incoming.
4. FAIL → returned with a verification report; not usable until re-delivered.

**"Working day" = ** Monday–Friday in timezone **America/Sao_Paulo (BRT)**, excluding Brazilian national and Sample Project local holidays. The count starts the working day *after* the file lands in Incoming (a Friday-evening upload → day 1 is Monday). Same definition for any "≤N working days" rule in the BEP.

---

## 4. Naming and revisions — quick reference

**Format:** `MC-Originator-Level-Type-Discipline-Number_Status_Revision`
**Example:** `{{CODE}}-{{OR}}-00-M3-STR-0001_S2_P01`

| You are… | Then… |
|---|---|
| Saving daily work in WIP | Keep the stable container name, status `S0`. Don't bump revisions daily. |
| Sharing for coordination | Status `S1`, revision `P01` (next share of same container → `P02`…) |
| Sharing for information / review / approval | Status `S2` / `S3` / `S4`, same `Pnn` sequence |
| Client authorises | Status `A`, revision restarts as `C01`, file goes to Published |
| Correcting a published container | New `C02` in Published; `C01` moves to Archived |

Never two active revisions of the same container in Shared/Published. Every transition = one row in the Container Register.

Model splits (rare, only if a container exceeds the size rule): keep the same Level and Discipline and distinguish the parts with consecutive Numbers `0001`, `0002`… (Section 5). There is no Volume field.

Field values must come from the **authoritative code tables** (Kickoff §4.1). Never invent a Type or Discipline code — if a new one is needed, register it via a BEP revision first.

---

## 4b. Level of Information Need (LOIN) — how detailed your model must be

We do **not** use "LOD 200/300/350". ISO 19650 uses **Level of Information Need** (EN 17412-1): deliver the *minimum* information needed for the purpose at that milestone — no more, no less. Three parts: **geometry** (only the 3D detail the purpose needs), **information** (the required properties/attributes — material, fire rating, loads…), and **documentation** (attached calc reports, certificates, datasheets). Your per-milestone requirement is in the **LOIN matrix** (IE Worksheet, sheet `LOIN`, owned by the BIM Manager). Check your discipline's row before a data drop. Over-modelling is a non-conformance just like under-modelling. `[LOIN — EC PROPOSED, CONFIRM WITH CLIENT]` means provisional until the Client confirms.

---

## 5. The 300 MB rule (model size)

No `.rvt` may exceed **300 MB** (Kickoff Standard rule 5.2d, written into the BEP).

**Check it:** before every share (checklist item), monthly in WIP, and at every milestone.

**If you exceed it:**
1. First audit & purge: Audit + Purge Unused ×2, remove unused CAD links/imports, delete orphaned views, compact, review heavy families (>5 MB).
2. Still over → ask the BIM Manager to approve a **model split** (BEP change):
   - Split the model functionally (e.g. frame vs. walls, or by wing) → keep the same Level and Discipline, distinguish the parts with consecutive numbers `0001` / `0002`, titles registered.
3. Split models link each other (Revit Link + Copy/Monitor of levels/grids, same shared origin). Each partition gets its own revisions, Container Register rows and TIDP lines, and the pair enters the clash matrix.

---

## 6. The 13 project documents — what each is for

| # | Document | Use it when… | Maintained by |
|---|---|---|---|
| 1 | Services Agreement | Contract scope/fee questions | Author (legal review before signing) |
| 2 | Annex A — BIM Protocol | Contractual BIM obligations, naming disputes | BIM Manager |
| 3 | EIR | Checking what the Client requires per milestone | Author on behalf of Client (Client must adopt) |
| 4 | BEP | ANY doubt about process, roles, software, uses, checks | BIM Manager (change-managed revisions) |
| 5 | Annex 3–4 Exchange Flow Matrix | Who sends what to whom, in what format | BIM Manager |
| 6 | Annex 5–6 IE Worksheet | Level of information need per exchange | BIM Manager |
| 7 | Annex 1–2 Process Maps | Visual guide of each BIM-use workflow | BIM Coordinator |
| 8 | MIDP + TIDP | Delivery dates, who delivers what, per milestone | Information Manager |
| 9 | Container Register | Trace any file: every state transition lives here | Information Manager |
| 10 | LDE Style Manual | Modelling rules: units, origin, views, families, exports | BIM Manager |
| 11 | Minutes template | Every meeting — actions table is mandatory | Meeting chair |
| 12 | README | New team member orientation, folder map | Information Manager |
| 13 | This User Manual | Daily operation of folders and documents | BIM Manager |

---

## 7. Sharing & permissions matrix (folder-based CDE — Google Drive)

| Agent | Can upload to | Can view | No access |
|---|---|---|---|
| Architecture (AR) | `01_Incoming/Architecture` | `02_Shared` (relevant parts) | `01_WIP`, `00_Admin` |
| Geotechnical (GE) | `01_Incoming/Geotechnical…` | `02_Shared` (relevant parts) | `01_WIP`, `00_Admin` |
| Client | — | `03_Published` (+ `02_Shared` at S3/S4 review) | `01_WIP`, `01_Incoming` |
| Internal modellers | own `01_WIP` discipline folder | all `02_Shared` | `00_Admin` |
| Information Manager | everywhere | everywhere | — |

Share subfolders to specific emails only — never the project root, never "anyone with the link".

**Security (ISO 19650-5) — baseline.** This is a low-sensitivity commercial project, so a proportionate regime applies: share only to named individuals; externals see only their `01_Incoming` folder and relevant `02_Shared` parts; client data never leaves the CDE by email. If the project is later flagged sensitive (BEP Section P), each container also carries a classification (Public / Internal / Confidential) in the Container Register and access tightens to need-to-know. The Information Manager owns classification.

---

## 8. Common mistakes — don't

- Working on a model taken from `02_Shared` (always link, never detach-and-edit someone else's container).
- Renaming files manually outside the convention, or reusing a revision code.
- Deleting anything in `04_Archived` or overwriting a shared container "to fix it quickly".
- Emailing models or accepting external files that skipped `01_Incoming` verification.
- Letting a model grow past 300 MB "until the next milestone".

Questions → Information Manager: eric.castro.ingenieria@gmail.com

---

## 9. Compliance audit

At any time (and at every milestone) the project can be checked against the standard — ask the assistant *"Corre una auditoría ISO 19650"*. It runs a read-only health check (naming/code compliance, CDE state integrity, Container Register coverage, incoming SLA, model size, LOIN, clashes, requirements chain, security, roles) and returns a scored non-conformance report (Kickoff §8). It reports only — nothing is changed until you approve the fixes.
