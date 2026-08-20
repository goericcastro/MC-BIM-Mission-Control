# User Guide — MC (BIM Mission Control)

A step-by-step guide to generating and managing an ISO 19650 project with MC.

---

## 1. Requirements

- A **Chromium-based browser**: Google Chrome or Microsoft Edge. MC uses the browser's **File System Access API** to create and write folders on your disk — Firefox and Safari do not support it.
- No installation, no account, no internet needed after you have the files.

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

Click **New project**, give it a name, a short **project code** (e.g. `BK`), and the client. Then fill the numbered sections in the **Project** tab:

| Section | What to enter |
|---|---|
| **01 · Project identity** | Name, address, client. |
| **02 · Team & disciplines** | Roles (Information Manager, BIM Manager…) and the **disciplines** actually contracted (Structural Concrete, Hydraulic, Electrical…). Pick from the dropdown — each carries its 3-letter code. |
| **03 · Client file register** | What the client must deliver (existing projects, surveys, reports) — each maps to an inbox folder in `01_Incoming`. |
| **04 · Client / Appointing Party** | OIR / PIR / AIR and brand standards (feeds the EIR). |
| **05 · Milestones & delivery dates** | Data drops M1–M5. **Planned** = the target deadline (in order, M1 earliest → M5 latest). **Actual** = when it was really delivered (leave empty until it happens). |

Only the disciplines you list are created — nothing is forced.

## 7. Generate folders + documents

In **06 · Create ISO 19650 folders & documents**, pick where to build the project, then let MC:

1. Create the **ISO 19650 folder tree** — `00_Admin_Contracts`, `01_Incoming`, `02_CDE` (WIP → Shared → Published → Archived, one sub-folder per discipline), `03_Resources`, `04_Project-Documentation`.
2. **Copy and fill the 12 baseline documents** with your project data (Agreement, BIM Protocol, EIR, BEP, MIDP/TIDP, Container Register, Exchange Flow Matrix, IE-Worksheet, LDE, Meeting Minutes, User Manual, Process Maps). Tokens like `{{CODE}}` are replaced, and discipline/role tables expand to one row per real discipline or team member.

Every file is renamed to the naming convention and dropped in its correct folder. Each folder also gets an auto-generated `_README.md` explaining its purpose.

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

- **Pie** — time weight by discipline. **Columns** — days compared. Edit the numbers directly in the legend.
- **Gantt** — the timeline starts at the **Document date**; each discipline bar runs to its milestone. Drag a bar to move it, drag the right edge to set the **estimated delivery** (before or after its milestone). When a milestone has an **Actual** date, the bar shows the variance: **red** = delivered late, **green** = delivered early. Years are shaded and labelled.
- **↻ Reset to milestones** re-seeds every discipline from the current milestone dates.

## 10. Where your data lives

- Your **project register** (identities, teams, milestones, schedule) lives in the browser's `localStorage`, and can be exported/imported as a JSON file (Save / Load).
- **Generated documents and folders** live on disk, wherever you built them.
- Nothing is uploaded anywhere.

Back up by keeping the exported JSON and your generated folders.

## 11. Customising the templates

The 12 files in `_BASELINE DOCUMENTS` are ordinary `.docx` / `.xlsx` / `.md` files with `{{TOKEN}}` placeholders. You can edit them by hand (wording, tables, styles) — just keep the tokens intact. A single template row containing `{{ROW_…}}` or `{{DEL_…}}` is cloned once per team member / discipline / deliverable at generation time.

## 12. Troubleshooting

- **"Link _BASELINE DOCUMENTS" does nothing** — you must allow the folder-permission prompt; some browsers block a second folder picker in one click, so link the library first, then create folders.
- **Schedule tab shows a warning** — it needs at least two milestones with **different** planned dates; fill them in section 05.
- **A discipline appears as `ZZZ`** — its team label has no recognised code; pick the discipline from the dropdown so it carries its 3-letter code.
- **Nothing generates** — make sure `_BASELINE DOCUMENTS` is linked and you are using Chrome or Edge.

---

*MC is offered as-is under the [MIT License](LICENSE). Contributions and forks are welcome.*
