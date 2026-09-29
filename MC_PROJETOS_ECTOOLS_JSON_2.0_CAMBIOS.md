# Orden de actualizacion — MC_PROJETOS ↔ ECTools/Revit

## Objetivo

Actualizar `MC_PROJETOS.html` para completar la compatibilidad con el contrato JSON 2.0 de ECTools y garantizar un intercambio bidireccional trazable, sin buscar tipos por nombre, sin duplicaciones accidentales y sin eliminaciones.

El flujo esperado es:

```text
Revit / ECTools
    → exporta REVIT_TO_MC
MC_PROJETOS
    → importa, revisa y aprueba registros
    → genera MC_TO_REVIT
Revit / ECTools
    → valida, previsualiza y aplica
    → genera MC_Revit_Result_*.json
MC_PROJETOS
    → importa el resultado y actualiza la identidad del registro
```

## 1. Unificar el identificador del lote

Agregar `batch_id` a `MC_Apply_Manifest.json` y utilizarlo como identificador oficial del paquete `MC_TO_REVIT`.

Puede conservarse temporalmente `export_id` por compatibilidad, pero ambos campos deben tener el mismo valor.

```json
{
  "schema_version": "2.0",
  "direction": "MC_TO_REVIT",
  "batch_id": "APPLY-20260925-001",
  "export_id": "APPLY-20260925-001"
}
```

El mismo `batch_id` debe aparecer posteriormente en `MC_Revit_Result_*.json`.

## 2. Separar las direcciones del intercambio

Usar una carpeta de intercambio con la siguiente estructura:

```text
MC_Revit_Exchange/
├── REVIT_TO_MC/
├── MC_TO_REVIT/
├── RESULTS/
└── ARCHIVE/
```

- `REVIT_TO_MC`: paquetes exportados por ECTools.
- `MC_TO_REVIT`: paquetes aprobados generados por MC_PROJETOS.
- `RESULTS`: resultados devueltos por ECTools.
- `ARCHIVE`: copias de paquetes anteriores.

Dejar de utilizar `MC_Revit_CSV` como nombre predeterminado, porque el contrato vigente es JSON 2.0.

## 3. Archivos obligatorios del paquete de aplicacion

MC_PROJETOS debe generar juntos:

```text
MC_Apply_Manifest.json
MC_Element_Types.json
MC_Property_Requirements.json
MC_Coordination_Rules.json
```

Aunque los contratos de propiedades o coordinación no tengan registros, deben existir como sobres JSON válidos con `records: []`.

## 4. Calculo de `contract_sha256`

El hash debe calcularse sobre los bytes UTF-8 exactos del archivo final `MC_Element_Types.json`.

Orden obligatorio:

1. Construir el objeto definitivo.
2. Serializarlo una sola vez.
3. Convertir la serialización a UTF-8 sin BOM.
4. Calcular SHA-256.
5. Guardar exactamente los mismos bytes utilizados para calcularlo.
6. Colocar el hash en `MC_Apply_Manifest.json`.

No volver a serializar ni modificar `MC_Element_Types.json` después de calcular el hash.

## 5. Identidad estable de los registros

No buscar ni relacionar tipos mediante `type_name`. La identidad estable es:

```text
source_document_guid + record_id
```

Además:

- Conservar siempre `revit_unique_id` para tipos existentes.
- No regenerar `record_id` durante un cambio de nombre.
- Un cambio de `type_name` no crea un registro nuevo.
- Validar que no existan claves estables duplicadas en un mismo paquete.

## 6. Operaciones permitidas

La aplicación debe soportar:

- `VALIDATE`: comparar sin modificar Revit.
- `RENAME`: modificar únicamente el nombre del tipo.
- `UPDATE`: actualizar nombre, clasificación o parámetros permitidos.
- `CREATE`: duplicar un tipo base explícitamente identificado.

La acción almacenada en el registro no debe ser ignorada. Debe existir una selección explícita o una deducción controlada:

```text
Sin tipo de origen y con base válida       → CREATE
Nombre diferente                           → RENAME
Metadatos o parámetros diferentes          → UPDATE
Sin diferencias                            → VALIDATE
```

Si cambian simultáneamente el nombre y los parámetros, utilizar `UPDATE`.

No admitir `DELETE`.

## 7. Validaciones para `CREATE`

Un registro `CREATE` debe contener como mínimo:

```json
{
  "record_id": "MC-...",
  "source_document_guid": "...",
  "action": "CREATE",
  "status": "APPROVED",
  "family_name": "...",
  "type_name": "Nombre nuevo",
  "base_family": "Familia existente",
  "base_type": "Tipo base existente",
  "revit_unique_id": ""
}
```

Si faltan `base_family` o `base_type`, el registro debe quedar como `PENDING` y no debe exportarse como aplicable.

## 8. Contrato de resultados

MC_PROJETOS debe aceptar los siguientes campos en `MC_Revit_Result_*.json`:

```json
[
  "timestamp",
  "batch_id",
  "source_document_guid",
  "contract_sha256",
  "request_record_id",
  "result_record_id",
  "type_code",
  "action",
  "result",
  "details",
  "result_type_name",
  "result_revit_element_id",
  "result_revit_unique_id"
]
```

Por compatibilidad, si no existe `request_record_id`, se debe usar `record_id`.

La relación del resultado con el catálogo se realizará mediante:

```text
source_document_guid + request_record_id
```

## 9. Actualizacion del catalogo despues del resultado

Cuando `result = APPLIED`, actualizar el registro original de MC_PROJETOS:

```text
recordId          ← result_record_id, si está presente
revitTypeName     ← result_type_name
revitElementId    ← result_revit_element_id
revitUniqueId     ← result_revit_unique_id
lastRevitResult   ← APPLIED
lastRevitDetails  ← details
lastRevitAt       ← timestamp
```

Esto es obligatorio para `CREATE`. Después de recibir un resultado exitoso, el registro no debe volver a exportarse como `CREATE`.

## 10. Estados y aprobacion

Solamente se enviarán a Revit registros con:

```json
"status": "APPROVED"
```

MC_PROJETOS debe conservar y mostrar los resultados:

- `APPLIED`
- `SKIPPED`
- `FAILED`
- `PENDING`

Los registros `FAILED` o `PENDING` deben mostrar el detalle y permitir su corrección antes de generar otro lote.

## 11. Prohibicion de eliminacion

Generar siempre:

```json
"omission_means_delete": false
```

No implementar:

- Acción `DELETE`.
- Eliminación por ausencia en el paquete.
- Sustitución destructiva.
- Borrado automático de tipos no incluidos.

## 12. Validaciones del manifiesto

Antes de exportar el paquete `MC_TO_REVIT`, MC_PROJETOS debe comprobar:

- `schema_version = 2.0`.
- `direction = MC_TO_REVIT`.
- `source_document_guid` no vacío y común a todos los registros.
- `record_count` igual a `records.length`.
- `contract_sha256` válido.
- `omission_means_delete = false`.
- Disciplinas incluidas declaradas en `included_discipline_codes`.
- Solo registros `APPROVED`.
- Ausencia de claves estables duplicadas.
- `CREATE` con una base válida.

## 13. Informacion visible en la interfaz

Mostrar en la pantalla de intercambio:

- `batch_id`.
- `source_document_guid`.
- Archivo Revit de origen.
- Versión de Revit.
- Disciplinas incluidas.
- Cantidad total de registros.
- Aprobados.
- Pendientes.
- Inválidos.
- Fecha de creación.
- Último resultado importado.

## 14. Criterio de aceptacion

La integración se considerará correcta cuando se complete esta secuencia sin perder la identidad ni duplicar tipos:

```text
ECTools exporta un tipo de Revit
→ MC_PROJETOS importa el registro
→ MC_PROJETOS modifica el nombre o propiedades autorizadas
→ MC_PROJETOS genera un paquete MC_TO_REVIT
→ ECTools valida y aplica el cambio
→ ECTools devuelve el resultado y la identidad resultante
→ MC_PROJETOS actualiza el mismo registro
→ el siguiente intercambio reconoce el tipo existente
```

## Ajuste complementario requerido en ECTools

ECTools debe devolver después de aplicar, especialmente para `CREATE`:

- `request_record_id`.
- `result_record_id`.
- `result_type_name`.
- `result_revit_element_id`.
- `result_revit_unique_id`.

Estos campos permiten que MC_PROJETOS cierre la trazabilidad y no vuelva a interpretar como nuevo un tipo que ya fue creado en Revit.

## 15. Intercambio parcial por categorías

MC_PROJETOS y ECTools pueden importar y exportar únicamente las categorías elegidas por el usuario, sin cambiar los nombres ni los encabezados de los contratos JSON.

El manifiesto debe declarar el alcance real del lote mediante:

```json
{
  "export_kind": "PARTIAL",
  "selected_groups": ["Architecture"],
  "included_discipline_codes": ["ARC"],
  "selected_categories": ["WAL", "DOR", "WIN"],
  "record_count": 125,
  "omission_means_delete": false
}
```

Reglas obligatorias:

- `selected_categories` contiene códigos de categoría normalizados, sin valores vacíos ni duplicados.
- Cada registro del lote debe pertenecer a una categoría declarada. Se usa `category_code` y, como respaldo, `revit_category`.
- MC_PROJETOS importa mediante `upsert` usando `(source_document_guid, record_id)`; nunca sustituye el catálogo completo.
- La ausencia de una categoría o registro en un lote parcial no permite eliminarlo, archivarlo ni marcarlo obsoleto.
- `omission_means_delete` permanece siempre en `false`.
- Los paquetes enviados a Revit contienen exclusivamente registros `APPROVED` y válidos.
- ECTools debe validar `selected_categories` antes de mostrar el Preview y aplicar solamente los registros presentes y aprobados.
- La acción `DELETE` continúa prohibida.

Compatibilidad:

- MC_PROJETOS acepta manifiestos históricos de esquema `2.0` que no incluyan `selected_categories`.
- Todos los nuevos paquetes generados por MC_PROJETOS incluyen `selected_categories`.
- ECTools puede ignorar el campo únicamente para lectura retrocompatible; para nuevos lotes debe validarlo y conservarlo en el resultado o registro de auditoría.

Secuencia recomendada:

```text
Seleccionar modelo Revit y grupo
→ seleccionar una o varias categorías
→ exportar únicamente registros APPROVED
→ ECTools valida manifiesto, hash e identidades
→ Preview
→ Apply sin borrar registros omitidos
→ devolver MC_Revit_Result.json
```

## 16. Registro de categorías por disciplina

La lista de MC_PROJETOS es una ayuda de clasificación y no una lista restrictiva. Incluye categorías físicas/modelables para:

- `Architecture`: muros —incluidos los sistemas de curtain wall—, pisos, cubiertas, cielos, puertas, ventanas, paneles y montantes de curtain wall, escaleras, rampas, barandas, mobiliario, equipamiento, paisajismo y otras categorías arquitectónicas.
- `Structural / Steel`: columnas, framing, cimentaciones, conexiones, stiffeners, armaduras, refuerzo de área y trayectoria, beam systems, tendones, trusses, infraestructura y estructuras temporales.
- `Precast`: muros, losas, columnas, framing, cimentaciones, conexiones, escaleras, paneles, piezas, assemblies y refuerzo prefabricado.
- `Systems`: HVAC, ductos, tuberías, plumbing, fire protection, sprinklers, equipos y dispositivos eléctricos, iluminación, comunicaciones, seguridad, cable trays, conduits y elementos de fabricación MEP.

ECTools debe obtener la categoría real del elemento desde Revit y enviar siempre:

- `category_code`: código estable acordado para MC_PROJETOS.
- `revit_category`: nombre visible de la categoría en Revit.
- `revit_category_id`: identificador estable de Revit, preferentemente el `BuiltInCategory`/`ForgeTypeId` y no el nombre localizado.

Si Revit devuelve una categoría modelable que todavía no existe en el registro de referencia, MC_PROJETOS debe aceptarla, mostrarla y conservarla. No se deben exportar categorías de vistas, anotaciones, tags o elementos internos que no representen tipos físicos coordinables.
