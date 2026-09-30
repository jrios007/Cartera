# Correcciones aplicadas (3 de los 30 .ktr de Cartera Capital)

Los otros 27 archivos son idénticos a los de la raíz del repo.

1. FACT_RECAUDO_CARTERA_MOROSA_EXT.ktr: el filtro dinámico de fechas (`?,?`) estaba comentado y reemplazado por un literal fijo de diciembre 2025. Se restauró el filtro dinámico.
2. FACT_PAGOS_SIMIT_EXT.ktr: en el WHERE principal faltaban paréntesis alrededor de los OR de ESTADO_RECIBO; ahora `AND (ESTADO_RECIBO='1' OR ='2' OR ='3')`.
3. FACT_ACUERDOS_GENERADOS_MES_ACTUAL.ktr: las divisiones por TOTAL_AP usan NULLIF(TOTAL_AP,0) para evitar ORA-01476.

Pendiente, no modificado (requiere decisión de negocio): FACT_CARTERA_GENERADA_MES_CARGA.ktr tiene comentado el bloque de carga de ID_CLASE_ORIGEN=3 (Sk_Tipo=58, saneamiento recuperado).

Nota: estos 3 archivos quedaron con saltos de línea LF en vez de CRLF; no afecta al XML.
