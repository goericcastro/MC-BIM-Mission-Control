# MC — BIM Mission Control

A single-file, offline HTML app to **generate and manage ISO 19650 BIM projects** — folder tree, naming convention, and document templates — with no server and no build step.

## What it does

- **ISO 19650 folder tree** — creates `00_Admin_Contracts`, `01_Incoming`, `02_CDE` (WIP / Shared / Published / Archived), `03_Resources`, `04_Project-Documentation`, driven by the disciplines you list (nothing is forced).
- **Document generation** — fills 12 baseline templates (Agreement, BIM Protocol, EIR, BEP, MIDP/TIDP, Container Register, LDE, Meeting Minutes, User Manual, Process Maps, Exchange Flow Matrix, IE-Worksheet) with your project data via a pure-JS OOXML token engine — no libraries.
- **Naming convention** — `{Project}-{Originator}-{Level}-{Type}-{Discipline}-{Number}_{Status}_{Revision}`, applied consistently across every generated file and folder README.
- **Schedule tab** — per-discipline time weight (pie), comparison (columns), and a milestone-anchored **Gantt** with editable start/duration/delivery, planned-vs-actual variance (late = red, early = green), and per-year shading. Durations count **working days only** — set the work week per project (Mon–Fri by default, add Saturdays/Sundays) and a **national holiday** preset (Brasil, Perú, Chile, Argentina) plus manual dates; weekends and holidays are shaded and skipped everywhere.

## Use

Open **`MC_PROJETOS.html`** in **Chrome** or **Edge**. It uses the browser's File System Access API to read and write folders directly on disk, so no installation is needed. Point it at your projects folder and let it build the structure.

> Chromium-based browsers only (Chrome, Edge) — the File System Access API is required.

**New here?** Follow the step-by-step **[User Guide](GUIDE.md)**.

## Contents

- `MC_PROJETOS.html` — the app (HTML + CSS + vanilla JS, one file).
- `_BASELINE DOCUMENTS/` — the master template library (`.docx` / `.xlsx` / `.md` with `{{TOKEN}}` placeholders and repeating-row templates).

## Notes

- Runs entirely in the browser. Your project register lives in the browser's `localStorage` (and can be saved to a JSON file); generated documents land in the folders on disk.
- Light and dark themes follow your system.
- Built for compact structural / restaurant projects but works for any ISO 19650 appointment.

## License

[MIT](LICENSE) — free to use, modify, fork, and distribute. Contributions welcome.
