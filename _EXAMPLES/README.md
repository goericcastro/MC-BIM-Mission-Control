# MC multi-project examples

`MC_data_all_04c_process_examples.json` is the current importable demonstration register for MC. It contains the existing Burger King sample plus three additional examples named after folders in `F:\OneDrive - PAG ENGENHARIA E CONSULTORIA LTDA\PROJETOS`:

- ASSAÍ - FOZ DE IGUAÇU
- AUTOZONE - ARAUCÁRIA
- CPV - CARREFOUR CAMPINAS VALINHOS

The three new projects are marked `DEMO` and `hold`. Their scope, milestones and workflows are **illustrative**, not extracted from or verified against the real projects. The team members are reused from `BURGER KING/MC_data_BK_sample.json`; the Burger King client representative is deliberately not assigned to other clients.

Together, the three new projects cover **all 16 Level 2 processes** in Penn State's `04c_Process_Map_Templates-V2.0_(pdf).pdf`, once each. The app also offers all 16 as reusable BIM-use suggestions and process-step templates. Its detail editor represents inputs, tasks, decisions and exchanges in a linear sequence; it does **not** reproduce every branch or loop of the PDF diagrams. Review and adapt the pattern for each real project.

To view them, first use **Save** in MC to back up your current register. Then use **Load** and select `MC_data_all_04c_process_examples.json`. Loading a JSON register replaces the currently open register; do not load this demo into a live shared workspace. Review and replace every demo value before generating documents for a real project. The older `MC_data_multi_project_examples.json` remains available as the earlier, smaller example set.

`build_examples.py` recreates the JSON from the Burger King sample only when the output file does not already exist. It never reads or writes any project files on `F:`.
