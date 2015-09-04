--FLUJO - ACTIVIDADFLUJO
SELECT * FROM Workflow.Flujo f
--ORIGEN
SELECT ma.DescripcionActividad AS Descripcion,ma.IdArea,ma.IdOficina FROM M_ACTIVIDADFLUJO ma
--DESTINO
SELECT fn.Descripcion,fn.IdArea,fn.IdOficina FROM Workflow.FlujoNodo fn

--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ma.DescripcionActividad AS Descripcion,ma.IdArea,ma.IdOficina,ma.IdActividad FROM M_ACTIVIDADFLUJO ma
		EXCEPT
		SELECT fn.Descripcion,fn.IdArea,fn.IdOficina,fn.IdNodo FROM Workflow.FlujoNodo fn
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT fn.Descripcion,fn.IdArea,fn.IdOficina FROM Workflow.FlujoNodo fn	
		EXCEPT
		SELECT ma.DescripcionActividad AS Descripcion,ma.IdArea,ma.IdOficina FROM M_ACTIVIDADFLUJO ma
	) AS DERECHA

--CASO DEL EJEMPLO ANTERIOR
SELECT * FROM M_ACTIVIDADFLUJO ma
WHERE ma.DescripcionActividad = 'PRA' AND ma.IdArea = 21202 AND ma.IdOficina = 2
SELECT * FROM M_ACTIVIDADFLUJO ma
WHERE ma.DescripcionActividad = 'TESORERIA' AND ma.IdArea = 21202 AND ma.IdOficina = 2
SELECT * FROM Workflow.FlujoNodo fn 
WHERE fn.Descripcion = 'PRA' and fn.IdArea = 20604

select * from Workflow.FlujoNodo 
SELECT * FROM Workflow.FlujoNodoPredecesor fnp
--n*n - n registros


----------------------------------------------------------------
--SOLILCITUD TRAMITE - TRAMITES
SELECT * FROM Workflow.SolicitudTramite st
SELECT * FROM M_TRAMITES_ESTADOIN mte WHERE mte.TipoTram = 'CC_CADQ'

SELECT * FROM Workflow.SolicitudTramiteConcepto stc


----------------------------------------------------------------
--INSTANCIA - TRAMITES
SELECT * FROM Workflow.Instancia i
SELECT * FROM M_TRAMITES_ESTADOIN mte WHERE mte.TipoTram = 'CC_CADQ'

SELECT * FROM Workflow.InstanciaNodo in1


