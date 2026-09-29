--INTERESES

--#################################################################
-- CALCULOS PARA INTERESES

--#################################################################
-- CALCULOS PARA INTERESES

--Item en blanco de la cartera
--NOVEDADES QUE SUMAN A LA CARTERA DE INTERESES:
--NOVEDADES QUE RESTAN A LA CARTERA DE INTERESES:

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
        FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') AS Id_Mes_Corte,
      null AS  Valor_Multa,
      sk_tipo_Cartera  
FROM dwh_sttm..Dim_Tipo_Cartera CAR
WHERE sk_tipo_Cartera IN (40,41) 


--Items que vienen desde la tabla general de cartera
  --Saldo intereses de comparendos morosos al mes anterior

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') AS Id_Mes_Corte,
         Coalesce(SUM(Valor_Multa),0 ) Valor_Intereses,
         22 AS sk_tipo_Cartera
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
    LEFT JOIN  dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada Fac
      ON Car.sk_tipo_Cartera = Fac.sk_Tipo
      AND Id_Mes_Corte = (SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0 
							THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
							ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1	END AS ID_Mes_Corte
   							FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')       
  WHERE sk_tipo_Cartera IN (36)  
  GROUP BY Id_Mes_Corte, sk_tipo_Cartera

--Saldo intereses integrados en AP de morosos al mes anterior --0.2

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
(Id_Mes_Corte, Valor_Multa, Sk_Tipo) 
SELECT 
 (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') AS Id_Mes_Corte, 
  SUM(Valor_Multa) AS Valor_Multa, 
  23 as Sk_Tipo 
  FROM dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
  WHERE Id_Mes_Corte = (SELECT CASE WHEN (CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),5,2)  AS INTEGER)) -1 = 0 
							THEN CAST( CAST( CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,4)  AS INTEGER) - 1 AS VARCHAR(4)) + '12' AS INTEGER)
							ELSE  CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) -1	END AS ID_Mes_Corte
   							FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
  AND sk_tipo IN (38) 
  GROUP BY Id_Mes_Corte


--Items que vienen desde la tabla general de cartera

--(+) Interes generado de morosos mes actual

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT Coalesce(Id_Mes_Corte,(SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                          FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')) AS Id_Mes_Corte,
         Coalesce(SUM(FAC.Valor_Intereses),0 ) Valor_Intereses,
      sk_tipo_Cartera 
 FROM dwh_sttm..Dim_Tipo_Cartera CAR
    LEFT JOIN  dwh_sttm..fact_cartera_intereses_moroso Fac
    ON Car.sk_tipo_Cartera = Fac.sk_Tipo
    AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                      FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
  WHERE sk_tipo_Cartera IN (25)  AND Valor_Intereses  > 0
  GROUP BY Id_Mes_Corte, sk_tipo_Cartera


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 384900863 
WHERE Id_Mes_Corte= 202411 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 9782312 
WHERE Id_Mes_Corte= 202412 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 14481637 
WHERE Id_Mes_Corte= 202501 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 523552482 
WHERE Id_Mes_Corte= 202506 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 12701972 
WHERE Id_Mes_Corte= 202507 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 8776730790
WHERE Id_Mes_Corte= 202508 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 5919668
WHERE Id_Mes_Corte= 202510 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa +  27120444
WHERE Id_Mes_Corte= 202511 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa +  550752000
WHERE Id_Mes_Corte= 202601 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa +  579527492
WHERE Id_Mes_Corte= 202602 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 776817082
WHERE Id_Mes_Corte= 202603 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 592506778
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')




--(+) Interes generado y pagado en el mes actual de morosos mes actual

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT Coalesce(Id_Mes_Corte,(SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')) AS Id_Mes_Corte,
         Coalesce(SUM(Valor_Intereses),0 ) Valor_Intereses,
         sk_tipo_Cartera 
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
    LEFT JOIN  dwh_sttm..fact_cartera_intereses_moroso Fac
      ON Car.sk_tipo_Cartera = Fac.sk_Tipo
      AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
  WHERE sk_tipo_Cartera IN (26)  AND Valor_Intereses  > 0
  GROUP BY Id_Mes_Corte, sk_tipo_Cartera


--(+) Interes generado y pagado en el mes actual de morosos mes anterior

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT Coalesce(Id_Mes_Corte,(SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')) AS Id_Mes_Corte,
         Coalesce(SUM(Valor_Intereses),0 ) Valor_Intereses,
         sk_tipo_Cartera 
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
    LEFT JOIN  dwh_sttm..fact_cartera_intereses_moroso Fac
      ON Car.sk_tipo_Cartera = Fac.sk_Tipo
      AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
  WHERE sk_tipo_Cartera IN (27) AND Valor_Intereses  > 0
  GROUP BY Id_Mes_Corte, sk_tipo_Cartera

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 4282024 
WHERE Id_Mes_Corte= 202104 and sk_Tipo = 27
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 18817852 
WHERE Id_Mes_Corte= 202508 and sk_Tipo = 27
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 27393706 
WHERE Id_Mes_Corte= 202509 and sk_Tipo = 27
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 





--(+) Inteses generado asociado a mora de acuerdos de pago

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT Coalesce(Id_Mes_Corte,(SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')) AS Id_Mes_Corte,
		 --Coalesce(SUM(Valor_Tarifa),0 ) Valor_Intereses,
         Valor_Intereses,
         sk_tipo_Cartera 
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
    LEFT JOIN  dwh_sttm..fact_cartera_intereses_moroso Fac
      ON Car.sk_tipo_Cartera = Fac.sk_Tipo
      AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
  WHERE sk_tipo_Cartera IN (28) AND Valor_Intereses  > 0
  GROUP BY Id_Mes_Corte, Valor_Intereses,sk_tipo_Cartera


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 173407971 
WHERE Id_Mes_Corte= 202411 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 177208524 
WHERE Id_Mes_Corte= 202412 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 236141252 
WHERE Id_Mes_Corte= 202501 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 222646697
WHERE Id_Mes_Corte= 202502 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 253787510
WHERE Id_Mes_Corte= 202503 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 230264891
WHERE Id_Mes_Corte= 202504 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 361044530
WHERE Id_Mes_Corte= 202504 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 297244908
WHERE Id_Mes_Corte= 202508 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 306943098
WHERE Id_Mes_Corte= 202509 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 297822220
WHERE Id_Mes_Corte= 202510 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 249341213
WHERE Id_Mes_Corte= 202511 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 299448691
WHERE Id_Mes_Corte= 202601 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 248851881
WHERE Id_Mes_Corte= 202602 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 190111457
WHERE Id_Mes_Corte= 202603 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 147252410
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

--Items que vienen desde la tabla general de cartera
  --(-) Interes que sale por recaudo  
  --(-) Interes que sale por prescripciones
  --(-) Interes que sale por celebración acuerdo de pago
  --(-) Interes que sale por exoneraciones varias
  --(-) Interes que sale por devolución moroso
  --Saldo intereses integrados en AP de morosos al mes actual

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT Coalesce(Id_Mes_Corte,(SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')) AS Id_Mes_Corte,
       Coalesce(SUM(valor_intereses),0 ) Valor_Intereses,
       sk_tipo_Cartera
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
      LEFT JOIN  dwh_sttm..fact_cartera_intereses_moroso Fac
        ON Car.sk_tipo_Cartera = Fac.sk_Tipo
        AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
WHERE  sk_tipo_Cartera IN (30,47,31,32,33,34) --68, 70, 51
  GROUP BY Id_Mes_Corte, sk_tipo_Cartera



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 359637421 
WHERE Id_Mes_Corte= 202102 and sk_Tipo = 30
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 1356589
WHERE Id_Mes_Corte= 202108 and sk_Tipo = 30
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 73289
WHERE Id_Mes_Corte= 202101 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 737748
WHERE Id_Mes_Corte= 202110 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 49981
WHERE Id_Mes_Corte= 202111 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 122815
WHERE Id_Mes_Corte= 202201 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 252276
WHERE Id_Mes_Corte= 202202 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 4228224
WHERE Id_Mes_Corte= 202203 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 63307
WHERE Id_Mes_Corte= 202205 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 410
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 283335
WHERE Id_Mes_Corte= 202207 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 1799
WHERE Id_Mes_Corte= 202208 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 223556
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 38
WHERE Id_Mes_Corte= 202210 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 117148
WHERE Id_Mes_Corte= 202211 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 2044
WHERE Id_Mes_Corte= 202302 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  390925402
WHERE Id_Mes_Corte= 202304 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  608660199
WHERE Id_Mes_Corte= 202307 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  604183520
WHERE Id_Mes_Corte= 202308 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  525182393
WHERE Id_Mes_Corte= 202312 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 285504939
WHERE Id_Mes_Corte= 202602 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  580953417
WHERE Id_Mes_Corte= 202401 and sk_Tipo = 3 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  634384959
WHERE Id_Mes_Corte= 202402 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 87271128
WHERE Id_Mes_Corte= 202403 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 115499755
WHERE Id_Mes_Corte= 202404 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 162384396
WHERE Id_Mes_Corte= 202405 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 125462583
WHERE Id_Mes_Corte= 202406 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 131487151
WHERE Id_Mes_Corte= 202407 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 195404150
WHERE Id_Mes_Corte= 202410 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 173118801
WHERE Id_Mes_Corte= 202411 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 265955992
WHERE Id_Mes_Corte= 202512 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 299482802
WHERE Id_Mes_Corte= 202601 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 177208524
WHERE Id_Mes_Corte= 202412 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 232338141
WHERE Id_Mes_Corte= 202501 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 222646697
WHERE Id_Mes_Corte= 202502 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 253787510
WHERE Id_Mes_Corte= 202503 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 230411828
WHERE Id_Mes_Corte= 202504 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 150455470
WHERE Id_Mes_Corte= 202408 
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 170917865
WHERE Id_Mes_Corte= 202409
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 261482090
WHERE Id_Mes_Corte= 202505
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 243625797
WHERE Id_Mes_Corte= 202506
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 360962977
WHERE Id_Mes_Corte= 202507
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  899039238
WHERE Id_Mes_Corte= 202508
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 306229965
WHERE Id_Mes_Corte= 202509
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 298382003
WHERE Id_Mes_Corte= 202510
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa +  270041276
WHERE Id_Mes_Corte= 202511
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 222284132
WHERE Id_Mes_Corte= 202603
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 33370943
WHERE Id_Mes_Corte= 202604
 and sk_Tipo = 30 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 7911363
WHERE Id_Mes_Corte= 202502
 and sk_Tipo = 26 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  1090779
WHERE Id_Mes_Corte= 202508
 and sk_Tipo = 26 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa -458737
WHERE Id_Mes_Corte= 202604
 and sk_Tipo = 26 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 423227553 
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 13402961 
WHERE Id_Mes_Corte= 202302 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 6350768569
WHERE Id_Mes_Corte= 202304 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 6730492962
WHERE Id_Mes_Corte= 202307 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 6750191338
WHERE Id_Mes_Corte= 202308 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 6837768050
WHERE Id_Mes_Corte= 202309 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 5076673880
WHERE Id_Mes_Corte= 202312 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 8502107389
WHERE Id_Mes_Corte= 202401 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 7332129351
WHERE Id_Mes_Corte= 202402 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa -14922671
WHERE Id_Mes_Corte= 202403 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 7802283941
WHERE Id_Mes_Corte= 202404 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 620343080
WHERE Id_Mes_Corte= 202408 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 198263650
WHERE Id_Mes_Corte= 202409 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 8521289986
WHERE Id_Mes_Corte= 202410 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 10847576
WHERE Id_Mes_Corte= 202505 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 932032
WHERE Id_Mes_Corte= 202307 and sk_Tipo = 26
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')




UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 954219 
WHERE Id_Mes_Corte= 202105 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 3979654 
WHERE Id_Mes_Corte= 202108 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 6522386 
WHERE Id_Mes_Corte= 202109 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 8696505 
WHERE Id_Mes_Corte= 202110 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1783168380
WHERE Id_Mes_Corte= 202111 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1919907608
WHERE Id_Mes_Corte= 202112 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1080692513
WHERE Id_Mes_Corte= 202201 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1138800525
WHERE Id_Mes_Corte= 202202 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1348800875
WHERE Id_Mes_Corte= 202203 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1574501505
WHERE Id_Mes_Corte= 202204 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1887902612
WHERE Id_Mes_Corte= 202205 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2095454100
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1129876428
WHERE Id_Mes_Corte= 202207 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 3065055615
WHERE Id_Mes_Corte= 202208 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1311065867
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1201324431
WHERE Id_Mes_Corte= 202210 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 1595866478
WHERE Id_Mes_Corte= 202211 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2328829479
WHERE Id_Mes_Corte= 202212 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2676067150
WHERE Id_Mes_Corte= 202301 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2103998357
WHERE Id_Mes_Corte= 202302 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  1868994212
WHERE Id_Mes_Corte= 202303 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  1497489449
WHERE Id_Mes_Corte= 202304 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  3743795423
WHERE Id_Mes_Corte= 202307 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2278100052
WHERE Id_Mes_Corte= 202308 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 4648459135
WHERE Id_Mes_Corte= 202309 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2721867523
WHERE Id_Mes_Corte= 202310 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 4514544353
WHERE Id_Mes_Corte= 202312 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2190136773
WHERE Id_Mes_Corte= 202401 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 2855169978
WHERE Id_Mes_Corte= 202402 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 12424745
WHERE Id_Mes_Corte= 202403 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 11226441
WHERE Id_Mes_Corte= 202404 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 18050915
WHERE Id_Mes_Corte= 202405 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 16861810
WHERE Id_Mes_Corte= 202406 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 12256120
WHERE Id_Mes_Corte= 202407 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 13362271
WHERE Id_Mes_Corte= 202408 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 27002546 - 9536145
WHERE Id_Mes_Corte= 202410 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 8349818
WHERE Id_Mes_Corte= 202504 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 17188201
WHERE Id_Mes_Corte= 202505 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 17747811
WHERE Id_Mes_Corte= 202506 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 30814554
WHERE Id_Mes_Corte= 202507 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 23967035
WHERE Id_Mes_Corte= 202508 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 20595358
WHERE Id_Mes_Corte= 202509 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 21311230
WHERE Id_Mes_Corte= 202510 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')
UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 28633540
WHERE Id_Mes_Corte= 202511 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 20220864
WHERE Id_Mes_Corte= 202512 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 12610064
WHERE Id_Mes_Corte= 202601 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 15353299
WHERE Id_Mes_Corte= 202602 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 39036167
WHERE Id_Mes_Corte= 202603 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa =  Valor_Multa + 44242220
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 31
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')




UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 34306424
WHERE Id_Mes_Corte= 202111 and sk_Tipo = 32 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 68741802
WHERE Id_Mes_Corte= 202303 and sk_Tipo = 32 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 200701
WHERE Id_Mes_Corte= 202402 and sk_Tipo = 32 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 18434198
WHERE Id_Mes_Corte= 202202 and sk_Tipo = 32 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



/*
INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
       SELECT Id_Mes_Corte,     SUM(VALOR_INTERESES_MOROSOS),    CASE WHEN Sk_Tipo = 5 OR Sk_Tipo = 42 THEN 32
                                                  WHEN Sk_Tipo = 7 THEN 33
                                                  WHEN Sk_Tipo = 8 THEN 31
                                                  WHEN Sk_Tipo = 11 THEN 34 
												  END Sk_Tipo 
    FROM DWH_STTM..Fact_Cartera_Moroso
    WHERE Id_Mes_Corte = (SELECT CAST(CONVERT(VARCHAR(6),fecha_fin,112) AS INT )  
                            FROM DWH_STTM..Dim_Parametros WHERE Id_param = 'Cartera_Contravenciones')
    AND Sk_Tipo IN (5,7,8,11,42)
    GROUP BY Id_Mes_Corte ,CASE WHEN Sk_Tipo = 5 OR Sk_Tipo = 42 THEN 32
                                                  WHEN Sk_Tipo = 7 THEN 33
                                                  WHEN Sk_Tipo = 8 THEN 31
                                                  WHEN Sk_Tipo = 11 THEN 34 
												  END 
*/

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 1029347043 + 73289
WHERE Id_Mes_Corte= 202101 and sk_Tipo = 33 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 4818502
WHERE Id_Mes_Corte= 202112 and sk_Tipo = 33 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 6934331
WHERE Id_Mes_Corte= 202203 and sk_Tipo = 33 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 1138712
WHERE Id_Mes_Corte= 202204 and sk_Tipo = 33 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 1034942
WHERE Id_Mes_Corte= 202304 and sk_Tipo = 33 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  7195812714
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 35 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



--Items de amnistia
INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT Coalesce(Id_Mes_Corte,(SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')) AS Id_Mes_Corte,
       Coalesce(SUM(valor_intereses),0 ) Valor_Intereses,
       sk_tipo_Cartera
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
      LEFT JOIN  dwh_sttm..fact_cartera_intereses_moroso Fac
        ON Car.sk_tipo_Cartera = Fac.sk_Tipo
        AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
WHERE  sk_tipo_Cartera IN (45,46,50,51,52,53, 68, 69, 70)  AND Valor_Intereses  > 0
  GROUP BY Id_Mes_Corte, sk_tipo_Cartera
  
UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 10329418636
WHERE Id_Mes_Corte= 202110 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 6489681216
WHERE Id_Mes_Corte= 202111 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202112 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202201 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202202 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202203 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202204 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202205 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202207 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202208 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 51 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 18110445
WHERE Id_Mes_Corte= 202102 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 42178974
WHERE Id_Mes_Corte= 202103 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 17452480
WHERE Id_Mes_Corte= 202104 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 21789256
WHERE Id_Mes_Corte= 202105 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa +  35445373
WHERE Id_Mes_Corte= 202108 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 154589391
WHERE Id_Mes_Corte= 202109 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 166392730
WHERE Id_Mes_Corte= 202110 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 137931442
WHERE Id_Mes_Corte= 202111 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 85824974
WHERE Id_Mes_Corte= 202112 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202201 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202202 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202203 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202204 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202205 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202207 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202208 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 53 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa = 0
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 45 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 1552087
WHERE Id_Mes_Corte= 202104 and sk_Tipo = 47 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 11087678 + 10000
WHERE Id_Mes_Corte= 202105 and sk_Tipo = 47 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 10568683
WHERE Id_Mes_Corte= 202205 and sk_Tipo = 47 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa +  4351292
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 47 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa +  1604670
WHERE Id_Mes_Corte= 202212 and sk_Tipo = 47 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


 

  
-- Saldo total cartera intereses mes anterior (0.1 + 0.2) -- 1.0
INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
  SELECT Id_Mes_Corte , 
    SUM(Valor_Multa) AS Valor_Multa, 
    24 as Sk_Tipo 
  FROM dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada
  WHERE  sk_tipo IN (22,23)  
	AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 
  GROUP BY Id_Mes_Corte


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  435729192136
WHERE Id_Mes_Corte= 202105 and sk_Tipo = 22 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 4282024
WHERE Id_Mes_Corte= 202105 and sk_Tipo = 24 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 486121933
WHERE Id_Mes_Corte= 202207 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 549888365
WHERE Id_Mes_Corte= 202208 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  5030698516
WHERE Id_Mes_Corte= 202210 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  5469302947
WHERE Id_Mes_Corte= 202211 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 859849752
WHERE Id_Mes_Corte= 202405 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  6189964877
WHERE Id_Mes_Corte= 202301 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  6626797431
WHERE Id_Mes_Corte= 202307 and sk_Tipo = 25 AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                             FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 633384710 
WHERE Id_Mes_Corte= 202406 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 703841677 
WHERE Id_Mes_Corte= 202407 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 24373136 
WHERE Id_Mes_Corte= 202512 and sk_Tipo = 25
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 115499755
WHERE Id_Mes_Corte= 202404 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 116584435
WHERE Id_Mes_Corte= 202405 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 222521753
WHERE Id_Mes_Corte= 202410 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 247586254
WHERE Id_Mes_Corte= 202506 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 240584369
WHERE Id_Mes_Corte= 202512 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')





-- Total novedades que suman (2+3+4+5) -- 6.0
 INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
  SELECT Id_Mes_Corte,
  SUM(Valor_multa) AS Valor_Multa, 
  29 as Sk_Tipo
  FROM dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
  WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')       
  AND sk_tipo IN (25,26,27,28)
  group by Id_Mes_Corte


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa  + 116584435 + 859849752
WHERE Id_Mes_Corte= 202405 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 10730725825
WHERE Id_Mes_Corte= 202507 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 



UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 9093884329
WHERE Id_Mes_Corte= 202508 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 11663792218
WHERE Id_Mes_Corte= 202602 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 13958932567
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa  + 124074115 
WHERE Id_Mes_Corte= 202102 and sk_Tipo = 47
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 21342830
WHERE Id_Mes_Corte= 202304 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 3299
WHERE Id_Mes_Corte= 202307 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 86828507
WHERE Id_Mes_Corte= 202403 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 261482090
WHERE Id_Mes_Corte= 202505 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 361044530
WHERE Id_Mes_Corte= 202507 and sk_Tipo = 28
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 4282024 
WHERE Id_Mes_Corte= 202104 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 486121933 
WHERE Id_Mes_Corte= 202207 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa - 549888365 
WHERE Id_Mes_Corte= 202208 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 5449696886
WHERE Id_Mes_Corte= 202209 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 5106475597
WHERE Id_Mes_Corte= 202210 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 5569465853
WHERE Id_Mes_Corte= 202211 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 6491753808
WHERE Id_Mes_Corte= 202304 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 7038178780
WHERE Id_Mes_Corte= 202309 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 8633677713
WHERE Id_Mes_Corte= 202401 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 7434410579
WHERE Id_Mes_Corte= 202402 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 71905836
WHERE Id_Mes_Corte= 202403 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 115499755 + 10266065
WHERE Id_Mes_Corte= 202404 and sk_Tipo = 29
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa  + 4336974 
WHERE Id_Mes_Corte= 202103 and sk_Tipo = 47
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 30179579
WHERE Id_Mes_Corte= 202110 and sk_Tipo = 47
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 0
WHERE Id_Mes_Corte= 202204 and sk_Tipo = 47
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = 840826
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 47
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



--  Interes que sale por devolución moroso -- 11.0
UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 1956501
WHERE Id_Mes_Corte= 202108 and sk_Tipo = 34
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 142023561
WHERE Id_Mes_Corte= 202109 and sk_Tipo = 34
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa + 150956
WHERE Id_Mes_Corte= 202201 and sk_Tipo = 34
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  0
WHERE Id_Mes_Corte= 202206 and sk_Tipo = 34
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


-- Total novedades que restan (7+8+9+10+11) -- 12.0
INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
  SELECT Id_Mes_Corte , 
  SUM(valor_multa) AS Valor_Multa, 
  35 as Sk_Tipo 
  FROM dwh_sttm..fact_cartera_intereses_moroso_agregada 
  WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')       
  AND sk_tipo IN (30,31,32,33,34,47,45,50,51,68,70)
  GROUP BY Id_Mes_Corte


-- Saldo intereses de comparendos morosos al mes actual (0.1 + 6 - 12) -- 13.0
INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT UNO.id_mes_corte AS Id_Mes_Corte, 
  UNO.Valor_Multa - DOS.Valor_Multa AS Valor_Multa, 
  36 AS Sk_Tipo 
FROM
    (SELECT Id_Mes_Corte , 
        SUM(valor_multa) AS Valor_Multa
    FROM dwh_sttm..fact_cartera_intereses_moroso_agregada 
    WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')        
    AND sk_tipo IN (22,29)
    GROUP By Id_Mes_Corte) UNO
  INNER JOIN
    (SELECT Id_Mes_Corte , 
        SUM(Valor_Multa) AS Valor_Multa
    FROM dwh_sttm..fact_cartera_intereses_moroso_agregada 
    WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')        
    AND sk_tipo IN (35)
    GROUP By Id_Mes_Corte) DOS
    ON UNO.Id_Mes_Corte = DOS.Id_Mes_Corte



--  SALDO INTERESES INTEGRADOS EN AP DE MOROSOS AL MES ACTUAL -- 15.0

INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT 
 (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER)AS ID_Mes_Corte
                              FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') as  Id_Mes_Corte,
  SUM(SALDO_AP_INT)  AS SALDO_AP,
  38 AS Sk_Tipo_Cartera 
  FROM dwh_sttm..Dim_Tipo_Cartera CAR
	LEFT JOIN dwh_sttm..Fact_Cartera_Acuerdos_Generados_Mes_Actual  MA
		ON CAR.Sk_Tipo_Cartera = MA.Sk_tipo
  WHERE Sk_tipo IN (19)
	AND MA.id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')  
  GROUP BY Sk_Tipo_Cartera

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 29206968
WHERE Id_Mes_Corte= 202101 and sk_Tipo = 38
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  Valor_Multa - 20200484
WHERE Id_Mes_Corte= 202301 and sk_Tipo = 38
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada
SET Valor_Multa = Valor_Multa + 11274278 
WHERE Id_Mes_Corte= 202411 and sk_Tipo = 38
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  437159811409
WHERE Id_Mes_Corte= 202301 and sk_Tipo = 39
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa = 480161160232
WHERE Id_Mes_Corte= 202301 and sk_Tipo = 39
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa = 590630208887
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 39
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =   475165634569
WHERE Id_Mes_Corte= 202401 and sk_Tipo = 36
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =   478775505764
WHERE Id_Mes_Corte= 202402 and sk_Tipo = 36
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =   549603648116
WHERE Id_Mes_Corte= 202507 and sk_Tipo = 36
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =   551661974442
WHERE Id_Mes_Corte= 202508 and sk_Tipo = 36
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =   585742753250
WHERE Id_Mes_Corte= 202602 and sk_Tipo = 36
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =   588275038346
WHERE Id_Mes_Corte= 202604 and sk_Tipo = 36
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')


-- (+/-) Variacion saldo intereses registrados en Ap mes Actual -- 14.0
INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
SELECT UNO.id_mes_corte AS Id_Mes_Corte, 
  UNO.Valor_Multa - DOS.Valor_Multa as Valor_Multa, 
  37 AS Sk_Tipo 
FROM 
   ( SELECT Id_Mes_Corte, 
          SUM(Valor_Multa) AS Valor_Multa
    FROM dwh_sttm..fact_cartera_intereses_moroso_agregada 
    WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')         
    AND sk_tipo = 38  
    GROUP BY Id_Mes_Corte) UNO
  LEFT JOIN 
    (SELECT Id_Mes_Corte, 
          SUM(Valor_Multa) AS Valor_Multa
    FROM dwh_sttm..fact_cartera_intereses_moroso_agregada 
    WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')         
    AND sk_tipo = 23
    GROUP BY Id_Mes_Corte) DOS
  ON UNO.id_mes_corte = DOS.id_mes_corte


UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  84243066
WHERE Id_Mes_Corte= 202104 and sk_Tipo = 37
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

--566920465
UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  1149267228 
WHERE Id_Mes_Corte= 202105 and sk_Tipo = 37
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones') 

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  666231659 
WHERE Id_Mes_Corte= 202108 and sk_Tipo = 37
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')

UPDATE DWH_STTM.dbo.Fact_Cartera_Intereses_Moroso_Agregada 
SET Valor_Multa =  73542298
WHERE Id_Mes_Corte= 202301 and sk_Tipo = 37
AND Id_Mes_Corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')



-- SALDO TOTAL CARTERA INTERESES A MULTAS POR CONTRAVENCIONES DEL MES (13+14) -- 16.0
 INSERT INTO dwh_sttm..Fact_Cartera_Intereses_Moroso_Agregada 
	(Id_Mes_Corte, Valor_Multa, Sk_Tipo)
  SELECT Id_Mes_Corte , 
    SUM(valor_multa) AS Valor_Multa, 
    39 as Sk_Tipo 
  FROM dwh_sttm..fact_cartera_intereses_moroso_agregada 
  WHERE id_mes_corte = (SELECT CAST(SUBSTRING(CONVERT(VARCHAR(8),Fecha_Inicio,112),1,6)  AS INTEGER) AS ID_Mes_Corte
                           FROM dwh_sttm..Dim_Parametros WHERE id_Param = 'Cartera_Contravenciones')      
  AND sk_tipo IN (36,38)
  GROUP BY Id_Mes_Corte
