SELECT DISTINCT
		   AUX1.Consecutivo_Moroso
		,  AUX1.PROCESAR_INTERES
		,  MAX(AUX1.Fecha_Comparendo) AS Fecha_Comparendo
	FROM
	(SELECT
		SCM.Consecutivo_Moroso
		,'INTERES' AS PROCESAR_INTERES
		,SCM.Fecha_Comparendo

	FROM STA_STTM.dbo.STA_FACT_INTERESES_CARTERA_MOROSOS CM
	  RIGHT JOIN DWH_STTM.[dbo].[Fact_Cartera_Intereses_Moroso] SCM ON SCM.Consecutivo_Moroso = CM.Consecutivo_Moroso
	  AND SCM.Id_Mes_Corte =(SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0
									THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
									ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1	END AS ID_Mes_Corte
									FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
	  WHERE  CM.[CONSECUTIVO_MOROSO] IS NULL
	) AUX1
	INNER JOIN
	(
		SELECT Consecutivo_Moroso
		FROM DWH_STTM..Fact_Cartera_Moroso
		WHERE Id_Mes_Corte = (SELECT CAST(CONVERT(VARCHAR(6),fecha_fin,112) AS INT )
								FROM DWH_STTM..Dim_Parametros WHERE Id_param = 'Cartera_Contravenciones')
		AND Sk_Tipo IN (4,6)
	) AUX2
		ON AUX1.Consecutivo_Moroso = AUX2.Consecutivo_Moroso
	GROUP BY AUX1.Consecutivo_Moroso
		   ,  AUX1.PROCESAR_INTERES
	ORDER BY 1
