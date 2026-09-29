# MC - Revit Element Standard CSV Interface

This document defines the CSV export produced by a Revit plugin and imported into MC's **Element standard** catalogue.

## Purpose

Use one CSV row for each Revit **type**, not each placed instance. The same interface supports client, office, project and consultant templates (`.rvt` or `.rte`).

The CSV is an exchange file. It does not replace the source Revit template, the model, or the ISO 19650 CDE.

## File rules

- Extension: `.csv`
- Encoding: UTF-8 (BOM permitted)
- Separator: comma `,`
- First row: header row, exactly as shown below
- Text with commas, quotes or line breaks: enclose in double quotes; write embedded quotes as `""`
- One row: one Revit family type or system-family type
- Empty optional fields: leave blank; do not write `N/A`, `null` or `-`

## Header

```csv
schema_version,template_owner,template_role,source_file,discipline,category,function,system,variant,dimension,name,classification,notes,revit_category,family_name,type_name,type_id,unique_id,ifc_entity,ifc_predefined_type
```

## Required columns

| Column | Rule | Example |
|---|---|---|
| `schema_version` | Interface version. | `1.0` |
| `template_owner` | Controlled source owner. | `CLIENT` |
| `template_role` | Human-readable source role. | `Client standard` |
| `source_file` | Source `.rvt` or `.rte` filename. | `Client_Template.rte` |
| `discipline` | MC discipline code. | `ARC`, `STR`, `HID`, `MEC`, `ELE` |
| `category` | Controlled element category code. | `WAL`, `DOR`, `WIN`, `COL`, `PIP` |
| `name` | Readable type name. Accents and spaces are allowed. | `Muro exterior ladrillo visto 250 mm` |
| `revit_category` | Revit built-in category name / id. | `OST_Walls` |
| `family_name` | Revit family name; use `System Family` when applicable. | `Basic Wall` |
| `type_name` | Revit type name. | `ARC_WAL_EXT_ME01_FFX_250` |
| `type_id` | Revit `ElementId` of the type. | `458721` |
| `unique_id` | Revit `UniqueId` of the type. | `a1b2c3d4-...` |

## Optional classification columns

| Column | Purpose | Example |
|---|---|---|
| `function` | Intended use / function. | `EXT`, `INT`, `SAN`, `VERT` |
| `system` | Construction or services system. | `ME01`, `CON01`, `PVC01` |
| `variant` | Variant or construction solution. | `FFX`, `ABAT`, `REC`, `PN10` |
| `dimension` | Normalised primary size. | `250`, `0900X2100`, `DN50` |
| `classification` | Classification system and code. | `Uniclass: Pr_20_31` |
| `notes` | Requirement, mapping or technical note. | `Approved project adaptation` |
| `ifc_entity` | Intended IFC entity. | `IfcWall`, `IfcDoor` |
| `ifc_predefined_type` | Intended IFC predefined type. | `STANDARD`, `DOOR` |

## Source priority

| `template_owner` | Use | Priority |
|---|---|---:|
| `CLIENT` | Contractual client template / standard | 1 |
| `PROJECT` | Approved project-specific adaptation | 2 |
| `OFFICE` | Internal office template / library | 3 |
| `CONSULTANT` | Specialist or consultant reference | 4 |

When two rows resolve to the same MC type code, MC must show the conflict for review. It must not silently overwrite a higher-priority source.

## Type-code rule

MC generates the type code. The Revit plugin should export the source data, not treat the code as an editable field.

```text
DISCIPLINE-CATEGORY-FUNCTION-SYSTEM-VARIANT-DIMENSION
```

Example:

```text
ARC-WAL-EXT-ME01-FFX-250
```

The code uses uppercase ASCII letters, numbers and hyphens only. The readable `name` is independent and may use normal Spanish or Portuguese text.

## Revit extraction order

The plugin should resolve controlled fields in this order:

1. Project/client shared parameters: `MC_Function`, `MC_System`, `MC_Variant`, `MC_Classification`.
2. Existing type parameters: `Type Mark`, assembly/classification code, OmniClass and description.
3. A documented plugin mapping by Revit category and family.
4. Blank value for BIM Manager review in MC.

Do not invent a classification, function or material system from the family name alone.

## Example

```csv
schema_version,template_owner,template_role,source_file,discipline,category,function,system,variant,dimension,name,classification,notes,revit_category,family_name,type_name,type_id,unique_id,ifc_entity,ifc_predefined_type
1.0,CLIENT,Client standard,Client_Template.rte,ARC,WAL,EXT,ME01,FFX,250,"Muro exterior ladrillo visto 250 mm",Uniclass: EF_25_10,Contractual requirement,OST_Walls,Basic Wall,ARC_WAL_EXT_ME01_FFX_250,458721,a1b2c3d4-...,IfcWall,STANDARD
1.0,OFFICE,Office standard,MC_Architecture_Template.rte,ARC,DOR,INT,DR01,ABAT,0900X2100,"Puerta interior abatible 900 x 2100 mm",Uniclass: Pr_30_59,Office standard,OST_Doors,Puerta madera,DOR_INT_DR01_ABAT_0900X2100,458890,e5f6g7h8-...,IfcDoor,DOOR
1.0,PROJECT,Project adaptation,Tower_A.rvt,STR,COL,VERT,CON01,REC,300X600,"Columna de concreto 300 x 600 mm",Uniclass: Pr_20_31,Approved project adaptation,OST_StructuralColumns,Concrete-Rectangular-Column,STR_COL_CON01_REC_300X600,459101,i9j0k1l2-...,IfcColumn,COLUMN
```

## Import behaviour required in MC

The importer must present a review screen before committing data:

- New type
- Existing type with matching data
- Modified type
- Conflict with a higher-priority source
- Incomplete row requiring BIM Manager completion

Importing must never delete existing catalogue rows or silently overwrite a `CLIENT` or `PROJECT` source.
