BEGIN TRANSACTION
DELETE from DWH_STTM..Fact_Cartera_Intereses_Moroso
WHERE Id_Mes_Corte = ( SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                       FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
COMMIT
