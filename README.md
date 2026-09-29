# MC — BIM Mission Control

A **single-file, offline HTML app** that sets up and runs **ISO 19650 BIM projects** end to end: it creates the folder structure, applies a consistent naming convention, and generates every project document from templates — filled with your project data. No server, no install, no build step, no libraries.

---

## What it does

You describe the project once (client, team, disciplines, milestones, contract, BIM scope…), and MC turns that into a **ready-to-work ISO 19650 project on disk**:

- **📁 Folder tree** — builds the ISO 19650 structure (`00_Admin_Contracts`, `01_Incoming`, `02_CDE` → WIP · Shared · Published · Archived, `03_Resources`, `04_Project-Documentation`), driven by the **disciplines you list** — nothing is forced. Discipline-aware: it seeds the right resource sub-folders per software, not per single tool.
- **📄 Document generation** — fills the baseline template library (Agreement, BIM Protocol, EIR, BEP, MIDP/TIDP, Container Register, Meeting Minutes, Meeting-Availability, Process Maps, Exchange-Flow Matrix, IE-Worksheet, User Manual…) with your data, using a **pure-JS OOXML token engine** — `{{TOKEN}}` replacement, repeating rows (one row per team member / discipline / appointment…), a live folder-tree diagram, and Word-comment-safe cloning. No third-party libraries.
- **🔗 Everything stays coordinated (DRY)** — a datum is entered once and reused everywhere: the team feeds the meeting minutes, the appointments, the responsibility matrix; the milestones feed the schedule and the process maps; the client feeds the contract. Read-only mirrors and dropdowns keep tabs in sync instead of duplicating data.

## The workspace (tabs)

| Tab | What you manage |
|---|---|
| **00 Dashboard** | All your projects at a glance. |
| **01 Project** | Identity → client requirements → incoming files → team & disciplines → milestones. |
| **02 Legal** | Confirm legal identity, contract & entities, client legal-document register and office logo. |
| **03 Access** | Connect the optional shared workspace, then manage users and access. |
| **04 BIM Manager** | Five ordered sub-tabs: **Scope & roles** (appointments, uses, responsibilities, risks), **Standards & tools** (coding, software, naming, resources, models, parameters, coordinates), **Information flow** (information manager, CDE, communication, federation), **Quality & exchange**, and **Element types**. |
| **05 Diagrams** | **BIM process maps** (Penn State PxP style): a **Level 1** overview (BIM uses across milestones) and editable **Level 2** detail per process (steps · decisions · exchanges) — auto-seeded from your BIM uses and generated into the Process-Maps document as Mermaid. |
| **06 Schedule** | Per-discipline time weight, comparison columns, and milestone-anchored discipline/process timelines with editable dates. Durations count **working days only**; set the work week and holiday calendar. |
| **07 Generate** | Review core inputs, create the folder structure, and generate project documents. Missing core data triggers a warning; treat incomplete outputs as drafts. Regenerating overwrites same-named files. |
| **08 Change Log** | Append-only record of changes and sign-ins. |

The leading numbers are **app workflow steps**. Where a card feeds the 0004 Information Standard, its smaller `0004 · A.x` badge preserves the document paragraph reference; the two numbering systems have different purposes.

## Naming convention

Every generated file and folder README follows a consistent, ISO 19650-aligned code:

```
{Project}-{Originator}-{Level}-{Type}-{Number}_{Title}
```

e.g. `BK-EC-XX-RP-0012_Minutes-Template.docx`. Discipline-specific **deliverables** (models, drawings, reports) additionally carry their discipline code (STR, STL, HID, MEC…); general/admin documents omit it.

## Use

Open **`MC_PROJETOS.html`** in **Chrome** or **Edge**. It uses the browser's **File System Access API** to read and write folders directly on disk — no installation needed. Point it at your projects folder and let it build the structure and documents. Your project register lives in the browser and can be **saved to / loaded from a JSON file** (share it or move it between machines).

> Chromium-based browsers only (Chrome, Edge) — the File System Access API is required. Light/dark themes follow your system.

**New here?** Follow the step-by-step **[User Guide](GUIDE.md)**.

## Contents

- `MC_PROJETOS.html` — the app (HTML + CSS + vanilla JS, one file).
- `_BASELINE DOCUMENTS/` — the master template library (`.docx` / `.xlsx` / `.md` with `{{TOKEN}}` placeholders and repeating-row templates). Template-only guidance/example text is marked `{{GUIDE}}` — visible in the baseline, removed automatically in generated projects.
- `GUIDE.md` — the user guide.

## Notes

- Runs **entirely in the browser** — no data leaves your machine. Generated documents land in the folders on disk; the register is `localStorage` + an optional JSON file.
- Built around **ISO 19650** (with buildingSMART terminology) and informed by the **Penn State BIM Project Execution Planning** guide for the process maps and BIM uses.
- Designed for compact structural / restaurant projects, but works for any ISO 19650 appointment.

## License

[MIT](LICENSE) — free to use, modify, fork, and distribute. Contributions welcome.
