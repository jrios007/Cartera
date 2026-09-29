SELECT
CONVERT(nvarchar(8),fecha_inicio,112) + ' ' + '00:00:00' fecha_inicio,
CONVERT(nvarchar(8),fecha_fin,112) + ' ' + '23:59:59' fecha_fin
FROM DIM_PARAMETROS
WHERE ID_PARAM='Cartera_Contravenciones'
