# User Guide — MC (BIM Mission Control)

A step-by-step guide to generating and managing an ISO 19650 project with MC.

---

## 1. Requirements

- A **Chromium-based browser**: Google Chrome or Microsoft Edge. MC uses the browser's **File System Access API** to create and write folders on your disk — Firefox and Safari do not support it.
- Local use needs no account or internet after you have the files. The optional Supabase shared workspace does require individual accounts and internet access.

## 2. Get the files

Download or clone this repository, keeping the two items **side by side in the same folder**:

```
your-projects-folder/
├── MC_PROJETOS.html          ← the app
└── _BASELINE DOCUMENTS/      ← the template library
```

> Keep `_BASELINE DOCUMENTS` next to `MC_PROJETOS.html`. MC copies its templates into every project you generate.

## 3. Open the app

Double-click **`MC_PROJETOS.html`** (or drag it into Chrome/Edge). It opens as a normal web page — everything runs locally in the browser.

## 4. Sign in (once per browser)

Top right, enter your **name and email**. These are stored only in your browser and are stamped on every change you make (a change log / audit trail). No data leaves your computer.

## 5. Link the template library

Click **"Link _BASELINE DOCUMENTS"** and point it at the `_BASELINE DOCUMENTS` folder. The browser will ask permission to read that folder — allow it. MC needs this to copy templates when it generates a project.

## 6. Create a project

Click **New project**, give it a name, a short **project code** (e.g. `BK`), and the client. Work through the editable tabs from **00 Dashboard** to **07 Generate**; **08 Change Log** keeps the audit history. Within **01 Project**, fill these sections in order:

| Section | What to enter |
|---|---|
| **01.1 · Project identity** | Name, address, client and project code. |
| **01.2 · Client / Appointing Party** | OIR / PIR / AIR and brand standards (feeds the EIR). |
| **01.3 · Client file register** | What the client must deliver (existing projects, surveys, reports) — each maps to an inbox folder in `01_Incoming`. |
| **01.4 · Team & disciplines** | Roles (Information Manager, BIM Manager…) and the **disciplines** actually contracted (Structural Concrete, Hydraulic, Electrical…). Pick from the dropdown — each carries its 3-letter code. |
| **01.5 · Milestones & delivery dates** | Data drops M1–M5. **Planned** = the target deadline (in order, M1 earliest → M5 latest). **Actual** = when it was really delivered. Specify the information need for each drop; the separate legacy LOD field is not an ISO 7817-1 information-need specification. |

Only the disciplines you list are created — nothing is forced.

## 7. Generate folders + documents

After reviewing **01 Project → 02 Legal → 03 Access (if using a shared workspace) → 04 BIM Manager → 05 Diagrams → 06 Schedule**, open **07 Generate**. Its **07.1** checklist highlights missing core data; it is not an ISO 19650 approval or quality certification. Then use **07.2 · Generate ISO 19650 folders & documents** (`0004 · A.6`):

1. Create the **ISO 19650 folder tree** — `00_Admin_Contracts`, `01_Incoming`, `02_CDE` (WIP → Shared → Published → Archived, one sub-folder per discipline), `03_Resources`, `04_Project-Documentation`.
2. **Copy and fill the linked baseline documents** with your project data. Tokens like `{{CODE}}` are replaced, and discipline/role tables expand to one row per real discipline or team member. The template library includes a draft-based information-management transition register that records the working terminology and process checkpoints.

You may create the folder structure early. If core information is still missing when you generate documents, MC asks whether to proceed; **you must treat those outputs as drafts** because the app does not mark or approve them automatically. Before replacing same-named documents, MC previews the collisions, backs up originals under `_MC_Backups` in the project root, and asks for confirmation. Keep formally issued revisions in the controlled CDE as well.

### Draft-based working protocol and published references

MC follows the publicly verifiable direction of ISO/DIS 19650-1 and -2 (2026 drafts) as its internal working protocol. The published references are ISO 19650-1:2018 and ISO 19650-2:2018, subject to the appointment and local adoption. In **04 BIM Manager → Standards & tools**, record the project review status. The generated `ISO-DIS-19650-1-2026_Transition-Register.md` sets out the working terminology, activity sequence and records to review. File identifiers such as 0001 EIR, 0010 MIDP/TIDP and 0004 Information Standard remain stable for traceability; use information production requirements, information production schedule and information production standard in the working instructions. Neither the app nor a draft changes the contract or establishes compliance. Approve project changes through the controlled revision process before formal issue.

Every file is renamed to the naming convention and dropped in its correct folder. Each folder also gets an auto-generated `_README.md` explaining its purpose.

### 7.1 Document order in a real project

The number is a stable library identifier, not a revision. Edit only the documents that apply to the contracted scope, preserve the number, and issue a new revision/status when their content changes. The recommended preparation and acceptance sequence is:

| ID | Document | Prepared / edited by | Review and approval point |
|---:|---|---|---|
| 0001 | Exchange Information Requirements (EIR) | Appointing party | Client approves before selecting/appointing the delivery team. |
| 0002 | Agreement / appointment | Client and commercial lead | Legal and commercial approval after the requirements are defined. |
| 0003 | BIM Protocol | Client / legal lead with BIM lead | Issued as an appointment annex; accepted with the agreement. |
| 0004 | Information Standard | BIM / Information Manager | Technical review with task-team leads before authoring starts. |
| 0005 | BIM Execution Plan (BEP) | Lead appointed party / BIM Manager | Team review; appointing party accepts the pre-appointment BEP. |
| 0006 | Kick-off Meeting record | BIM Manager | Record attendance, open actions and explicit permission to start production. |
| 0007 | Process Maps | BIM Manager and process owners | Validate each process against the approved BEP; re-review when a process changes. |
| 0008 | Exchange Flow Matrix | Information Manager | Confirm sender, receiver, format, purpose and acceptance route for every exchange. |
| 0009 | Information-Exchange Worksheet | Task-team leads | Check required geometry, attributes, classification and LOIN per milestone. |
| 0010 | MIDP / TIDP | Lead appointed party; task teams supply TIDPs | Agree dates, responsibility and delivery containers; update at every planning cycle. |
| 0011 | Container Register | Information Manager | Create before the first shared issue; maintain and audit at every CDE state change. |
| 0012 | Meeting Minutes | Meeting chair / BIM Manager | Issue promptly after each meeting; owners confirm actions and close-out evidence. |
| 0013 | Meeting Availability | BIM Manager / project coordinator | Maintain while coordination meetings are active. |
| 0014 | User Manual | BIM Manager | Issue for onboarding after the standards and workflow are accepted; revise when they change. |

For each review, work from the current **WIP** revision, log comments and actions, resolve them with the named owner, then share the proposed revision through the CDE. The appointed reviewer either accepts it, rejects it with comments, or requests changes. Publish only the accepted version; retain the superseded one in **Archived**. The Kick-off record is the practical gate: no modelling or formal sharing begins until blockers in documents 0001–0005 are closed or explicitly accepted.

### 7.2 Optional shared workspace (real time)

MC can remain a local file while its live project data is shared through Supabase. The shared database does **not** replace the CDE: models, documents and generated folders remain in the project drive; it only synchronizes the information entered in MC.

1. Create a Supabase project and open its **SQL Editor**.
2. Run [SUPABASE_SETUP.sql](SUPABASE_SETUP.sql) once. It creates the tables, row-level security, revision control and real-time publication.
3. In MC, open **03 Access → 03.1 Shared workspace** and enter the project's Supabase URL and its **publishable / anon key**. Never enter a `service_role` key in MC.
4. Create an account or sign in, then create a shared workspace with a private access code of at least eight characters.
5. Each participant connects to the same Supabase project, signs in with their own account and uses the access code to join.

Editors can update the workspace at the same time. MC receives updates in real time and uses a revision check before writing; if two people save incompatible versions, it shows a reload/force-save choice instead of silently discarding the other person's work. The workspace creator is an `admin`; participants joining with the code start as `editor`. Change a user to `viewer` in Supabase when they only need to read.

## 8. The naming convention

```
{Project}-{Originator}-{Level}-{Type}-{Discipline}-{Number}_{Status}_{Revision}
```

Example: `BK-EC-ZZ-M3-STR-0001_S0_P01`

| Field | Meaning |
|---|---|
| Project | Project code (e.g. `BK`) |
| Originator | Who authored it — `EC` = you, `AR` = architect, `GE` = geotechnical office |
| Level | `ZZ` several levels · `XX` no level (reports) · `00`, `01`… building levels |
| Type | `M3` 3D model · `RP` report · `DR` drawing · `SP` schedule/spec |
| Discipline | 3-letter code (see below) |
| Number | Sequential within that combination |
| Status | `S0` WIP · `S1–S4` shared · `A` published |
| Revision | `P01…` preliminary · `C01…` contractual |

### Discipline codes

`ARC` architecture · `STR` structural concrete · `STL` steel · `MAS` masonry · `FDN` foundations · `GEO` geotechnical · `HID` hydraulic/sanitary · `DRA` storm drainage · `FIR` fire-fighting · `MEC` HVAC/mechanical · `ELE` electrical · `ELV` telecom/data · `GAS` gas · `CIV` civil/earthworks · `ROA` roads/pavement · `ACO` acoustics · `SUS` sustainability/environmental · `TOP` topography/survey · `CRD` coordination (federated model + clash) · `ZZZ` multi-discipline / general (contracts, protocols).

## 9. Schedule tab

The **Schedule** tab visualises, per project, how much time each discipline needs:

The first number on a tab or card is its **app workflow step**. A smaller `0004 · A.x` badge identifies the matching paragraph of the Information Standard where applicable. These are deliberately separate: **01.5** holds milestone dates (`0004 · A.1.6`), **04.2.4** holds approved support resources (`0004 · A.5`), and **07.2** generates project folders (`0004 · A.6`).

- **Pie** — time weight by discipline. **Columns** — days compared (drag a column's top handle to change its days). Edit the numbers directly in the legend.
- **Gantt** — the timeline starts at the **Document date**; each discipline bar runs to its milestone. Drag a bar to move it, drag the left/right edge to set the **start / estimated delivery** (before or after its milestone). The delivery date is **green** if it lands within the last milestone, **red** if it overruns. Years are shaded and labelled.
- **Schedule · BIM process timeline** — this process timeline is calculated from the document date, milestones and each process phase. Drag the bar to move the process or its left/right edge to set manual start/end dates. The override is reflected in the Level 2 process fields and in the generated 0007 map; it never moves the global milestones.
- **Work calendar** — above the charts. All durations count **working days only**:
  - **Work week** — Mon–Fri by default; click a day to add/remove it (e.g. enable Saturdays for a project that works them).
  - **Holidays** — pick a **national preset** (Brasil, Perú, Chile, Argentina — movable feasts like Good Friday/Carnaval are computed per year) and/or **+ Add** individual dates. Weekends and holidays are shaded grey in the Gantt and skipped in every day count. Presets are a starting point; add project-specific dates manually.
- **↻ Reset to milestones** re-seeds every discipline from the current milestone dates.

## 10. Element standard

In **04 BIM Manager → 04.5 Element types**, maintain the controlled catalogue of model type names for the disciplines contracted in **01.4 Team**. Only enabled disciplines appear. The app proposes common categories (architecture, structure, MEP and others); you can add, edit or remove rows for the real project scope.

Each type code is generated as:

```
Discipline-Category-Function-System-Variant-Dimension
```

For example, `ARC-WAL-EXT-ME01-FFX-250` identifies an architectural exterior wall. Keep the readable name, classification and notes in their own fields. Do not place storey, room or individual-instance information in the type code; those belong to instance parameters. The catalogue is copied into document 0004 when project documents are generated.

## 11. Where your data lives

- Your **project register** (identities, teams, milestones, schedule) lives in the browser's `localStorage`, and can be exported/imported as a JSON file (Save / Load).
- **Generated documents and folders** live on disk, wherever you built them.
- Nothing is uploaded anywhere.

Back up by keeping the exported JSON and your generated folders.

## 12. Customising the templates

The 14 files in `_BASELINE DOCUMENTS` are ordinary `.docx` / `.xlsx` / `.md` files with `{{TOKEN}}` placeholders. You can edit them by hand (wording, tables, styles) — just keep the tokens intact. A single template row containing `{{ROW_…}}` or `{{DEL_…}}` is cloned once per team member / discipline / deliverable at generation time.

## 13. Troubleshooting

- **"Link _BASELINE DOCUMENTS" does nothing** — you must allow the folder-permission prompt; some browsers block a second folder picker in one click, so link the library first, then create folders.
- **Schedule tab shows a warning** — it needs at least two milestones with **different** planned dates; fill them in Project · A.1.6.
- **A discipline appears as `ZZZ`** — its team label has no recognised code; pick the discipline from the dropdown so it carries its 3-letter code.
- **Nothing generates** — make sure `_BASELINE DOCUMENTS` is linked and you are using Chrome or Edge.

---

*MC is offered as-is under the [MIT License](LICENSE). Contributions and forks are welcome.*
