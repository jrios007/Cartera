SELECT
CONVERT(nvarchar(8),fecha_inicio,112) + ' ' + '00:00:00' fecha_inicio1,
CONVERT(nvarchar(8),fecha_fin,112) + ' ' + '23:59:59' fecha_fin1,
CONVERT(nvarchar(8),fecha_inicio,112) + ' ' + '00:00:00' fecha_inicio2,
CONVERT(nvarchar(8),fecha_fin,112) + ' ' + '23:59:59' fecha_fin2
FROM DIM_PARAMETROS
WHERE ID_PARAM='Cartera_Contravenciones'
