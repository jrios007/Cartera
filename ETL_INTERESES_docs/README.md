# ETL INTERESES — documentación (NO son archivos .ktr ejecutables)

Esta carpeta contiene la documentación disponible de la segunda rama del job AUTOMATIZACION_CARTERA_MOROSO ("ETL INTERESES": cálculo de intereses moratorios, amnistías y su agregación a cartera), compuesta por 13 transformaciones que NO tienen su archivo .ktr binario/XML disponible en ningún repositorio ni carpeta accesible a esta sesión.

Lo que SÍ se pudo recuperar (extraído de SharePoint, carpeta `Documentación SPOON/ETL INTERESES/` de alexis.martinez@sitti.com.co) es, por cada transformación:
- Capturas de pantalla del canvas de Spoon (.png/.jpg)
- Algunos fragmentos SQL extraídos de pasos individuales (.sql), no siempre completos

Esto NO reemplaza el archivo .ktr real: falta la definición completa del flujo (hops, tipos de paso, parámetros de conexión). Si en algún momento se consigue el .ktr real de estas 13 transformaciones, debe reemplazar esta documentación parcial.

Transformaciones cubiertas: FACT_CARTERA_INTERESES_EXT, FACT_CARTERA_INTERESES_RES_EXT_ITEM_2, FACT_CARTERA_INTERES_RESTA_CARGA_ITEM2, FACT_INTE_GENERADO_PAGADO_MES_ACTUAL, FACT_INTE_GENERADO_PAGADO_MES_ITEM_3, FACT_INTE_GENERADO_PAGADO_MES_ITEM_4, FACT_INTE_GENERADO_PAGADO_MES_ITEM_5, FACT_INTE_PAGADO_X_DECUENTO, FACT_INTE_SALE_X_RECAUDO_MES_ACTUA_ITEM_7, FACT_INTERESE_SALE_X_PRESCRIPCIONES_ITEM_8, Amnistia Morosos, Amnistia AP, FACT_CARTERA_MOROSO_AGREGADO_CARGA_FOTO.

Nota: la captura de FACT_INTERESE_SALE_X_PRESCRIPCIONES_ITEM_8 está guardada en SharePoint con el nombre "Sin FACT_INTERESE_SALE_X_PRESCRIPCIONES_ITEM_8.png"; la transformación sí existe (step "Intereses que salen" → "Fact_Cartera_Intereses_Moroso", marcada como ENTRADA-SALIDA-DESCARTADOS/DUMMY en la nota del propio diagrama), se conserva el nombre original del archivo tal como estaba en SharePoint.

Adicionalmente se encontró y se incluye, aunque no estaba en la lista original de 13, una carpeta hermana `14_FACT_CARTERA_MOROSO_AGREGADO_CARGA` (sin "_FOTO") dentro de la misma rama ETL INTERESES en SharePoint, documentada en `FACT_CARTERA_MOROSO_AGREGADO_CARGA/`.
