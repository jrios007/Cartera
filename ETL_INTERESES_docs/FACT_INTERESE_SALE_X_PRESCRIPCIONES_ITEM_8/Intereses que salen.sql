SELECT AUX2.Id_Mes_Corte,
	   AUX2.Consecutivo_Moroso,
	   MAX(AUX1.ID_Usuario_moroso) AS ID_Usuario_moroso,
	   MAX(AUX1.Nro_Comparendo_Moroso) AS Nro_Comparendo_Moroso,
	   MAX(AUX1.sk_Tipo_Comparendo) AS sk_Tipo_Comparendo,
	   MAX(AUX1.sk_Estado_Comparendo) AS sk_Estado_Comparendo,
       MAX(COALESCE(AUX1.Fecha_Comparendo,'1900-01-01')) AS Fecha_Comparendo,
       MAX(AUX1.sk_Fecha) AS sk_Fecha,
       MAX(AUX1.Fecha_Calculo_Interes) AS Fecha_Calculo_Interes,
       MAX(AUX1.Numero_Placa) AS Numero_Placa,
       MAX(AUX1.sk_Persona) AS sk_Persona,
       MAX(COALESCE(AUX1.sk_Vehiculo,-1)) AS sk_Vehiculo,
       AUX2.SK_TIPO,
       SUM(AUX1.Valor_Interes_Actual) AS Valor_Intereses
FROM
(
    SELECT SCM.Consecutivo_Moroso, SCM.Valor_Interes_Actual, SCM.ID_Usuario_moroso, SCM.Nro_Comparendo_Moroso, SCM.sk_Tipo_Comparendo, SCM.sk_Estado_Comparendo, SCM.Fecha_Comparendo
          , SCM.sk_Fecha, SCM.Fecha_Calculo_Interes, SCM.Numero_Placa, SCM.sk_Persona, SCM.sk_Vehiculo
    FROM STA_STTM.dbo.STA_FACT_INTERESES_CARTERA_MOROSOS CM
      RIGHT JOIN [DWH_STTM].[dbo].[Fact_Cartera_Intereses_Moroso] SCM
      ON SCM.Consecutivo_Moroso = CM.Consecutivo_Moroso
      --AND SCM.Id_Mes_Corte = (SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0
      --                          THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
      --                          ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1    END AS ID_Mes_Corte
      --                          FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
    WHERE CM.CONSECUTIVO_MOROSO IS NULL AND SCM.SK_TIPO <> 22
    AND SCM.Id_Mes_Corte = (SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0
                                THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
                                ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1    END AS ID_Mes_Corte
                                FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
) AUX1 INNER JOIN
(
    SELECT Id_Mes_Corte, Consecutivo_Moroso, CASE WHEN Sk_Tipo = 5 OR Sk_Tipo = 42 THEN 32
                                                  WHEN Sk_Tipo = 7 THEN 33
                                                  WHEN Sk_Tipo = 8 THEN 31
                                                  WHEN Sk_Tipo = 11 THEN 34
												  END Sk_Tipo
    FROM DWH_STTM..Fact_Cartera_Moroso
    WHERE Id_Mes_Corte = (SELECT CAST(CONVERT(VARCHAR(6),fecha_fin,112) AS INT )
                            FROM DWH_STTM..Dim_Parametros WHERE Id_param = 'Cartera_Contravenciones')
    AND Sk_Tipo IN (5,7,8,11,42)
) AUX2 ON AUX1.Consecutivo_Moroso = AUX2.Consecutivo_Moroso
GROUP BY
AUX2.Id_Mes_Corte, AUX2.Consecutivo_Moroso, AUX2.SK_TIPO
