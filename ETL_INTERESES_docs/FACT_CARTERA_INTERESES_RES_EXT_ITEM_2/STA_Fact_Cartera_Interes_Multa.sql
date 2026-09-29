-- Archivo SQL generado automáticamente
-- 01_intereses_Nuevos_Morosos
SELECT
   STA.Consecutivo_Moroso
,  STA.Valor_Intereses_Morosos AS Valor_Intereses_Actual
,  fact.Valor_Intereses_Morosos AS Valor_Intereses_Anterior
,  (ISNULL(STA.Valor_Intereses_Morosos, 0) - ISNULL(fact.Valor_Intereses_Morosos,0)) AS DIFERENCIA
,  STA.Procesar_Interes
, 'N' AS MARCA
FROM STA_STTM.dbo.STA_FACT_INTERESES_CARTERA_MOROSOS STA
	LEFT JOIN dwh_sttm..Fact_Cartera_Moroso fact
		ON fact.Consecutivo_Moroso = sta.Consecutivo_Moroso
		AND Sk_Tipo IN (1,12)
		AND fact.Id_Mes_Corte = (SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0
					  THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
					  ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1	END AS ID_Mes_Corte
					  FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
  WHERE  fact.CONSECUTIVO_MOROSO IS NULL
	AND STA.Procesar_Interes = 'MULTA'

UNION ALL

SELECT
   STA.Consecutivo_Moroso
,  STA.Valor_Intereses_Morosos AS Valor_Intereses_Actual
,  fact.Valor_Intereses_Morosos AS Valor_Intereses_Anterior
,  (ISNULL(STA.Valor_Intereses_Morosos, 0) - ISNULL(fact.Valor_Intereses_Morosos,0)) AS DIFERENCIA
,  STA.Procesar_Interes
, 'I' AS MARCA
FROM STA_STTM.dbo.STA_FACT_INTERESES_CARTERA_MOROSOS STA

	INNER JOIN dwh_sttm..Fact_Cartera_Moroso fact
		ON fact.Consecutivo_Moroso = sta.Consecutivo_Moroso
		WHERE  STA.Procesar_Interes = 'MULTA N'
		AND Sk_Tipo IN (58,59,60)

UNION ALL

--02_intereses_permanecen_morosos
SELECT
   STA.Consecutivo_Moroso
,  STA.Valor_Intereses_Morosos AS Valor_Intereses_Actual
,  fact.Valor_Intereses_Morosos AS Valor_Intereses_Anterior
,  (ISNULL(STA.Valor_Intereses_Morosos, 0) - ISNULL(fact.Valor_Intereses_Morosos,0)) AS DIFERENCIA
,  STA.Procesar_Interes
, 'P' AS MARCA
FROM STA_STTM.dbo.STA_FACT_INTERESES_CARTERA_MOROSOS STA
	INNER JOIN dwh_sttm..Fact_Cartera_Moroso fact
	  ON fact.Consecutivo_Moroso = sta.Consecutivo_Moroso
	  AND Sk_Tipo IN (1,12)
	  AND fact.Id_Mes_Corte = (SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0
					  THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
					  ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1	END AS ID_Mes_Corte
					  FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
  WHERE STA.Procesar_Interes = 'MULTA'
