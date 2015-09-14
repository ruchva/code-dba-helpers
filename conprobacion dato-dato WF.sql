--Flujo solo destino
select * from Workflow.Flujo f where f.IdFlujo = 1409001 
-------------------------------------------------------------------------------------------------
--FlujoNodo
--ORIGEN
select 1409001 as IdFlujo, a.IdActividad as IdNodo,a.DescripcionActividad as Descripcion,a.IdOficina,a.IdArea from M_ACTIVIDADFLUJO a 
select f.IdFlujo,f.IdNodo,f.Descripcion,f.IdOficina,f.IdArea from Workflow.FlujoNodo f where IdArea is not null and IdFlujo = 1409001 
--DESTINO
SELECT fn.Descripcion,fn.IdArea,fn.IdOficina FROM Workflow.FlujoNodo fn

SELECT 'Pivote' AS Origen,*
FROM (  select 1409001 as IdFlujo, a.IdActividad as IdNodo,a.DescripcionActividad as Descripcion,a.IdOficina,a.IdArea from M_ACTIVIDADFLUJO a
		EXCEPT
		select f.IdFlujo,f.IdNodo,f.Descripcion,f.IdOficina,f.IdArea from Workflow.FlujoNodo f where IdArea is not null and IdFlujo = 1409001
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  select f.IdFlujo,f.IdNodo,f.Descripcion,f.IdOficina,f.IdArea from Workflow.FlujoNodo f where IdArea is not null and IdFlujo = 1409001	
		EXCEPT
		select 1409001 as IdFlujo, a.IdActividad as IdNodo,a.DescripcionActividad as Descripcion,a.IdOficina,a.IdArea from M_ACTIVIDADFLUJO a
	) AS DERECHA

--CASO DEL EJEMPLO ANTERIOR
SELECT * FROM M_ACTIVIDADFLUJO ma
WHERE ma.DescripcionActividad = 'PRA' AND ma.IdArea = 21202 AND ma.IdOficina = 2
SELECT * FROM M_ACTIVIDADFLUJO ma
WHERE ma.DescripcionActividad = 'TESORERIA' AND ma.IdArea = 21202 AND ma.IdOficina = 2
SELECT * FROM Workflow.FlujoNodo fn 
WHERE fn.Descripcion = 'PRA' and fn.IdArea = 20604
-------------------------------------------------------------------------------------------------
--FlujoNodoPredecesor
--origen
select IdFlujo,IdNodo from Workflow.FlujoNodo f where IdArea is not null and f.IdFlujo = 1409001
--destino
select IdFlujo,IdNodo from Workflow.FlujoNodoPredecesor f where f.IdFlujo = 1409001
--n*n - n registros

SELECT 'Pivote' AS Origen,*
FROM (  select IdFlujo,IdNodo from Workflow.FlujoNodo f where IdArea is not null and f.IdFlujo = 1409001
		EXCEPT
		select IdFlujo,IdNodo from Workflow.FlujoNodoPredecesor f where f.IdFlujo = 1409001
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  select IdFlujo,IdNodo from Workflow.FlujoNodoPredecesor f where f.IdFlujo = 1409001
		EXCEPT
		select IdFlujo,IdNodo from Workflow.FlujoNodo f where IdArea is not null and f.IdFlujo = 1409001
	) AS DERECHA
-------------------------------------------------------------------------------------------------
--Concepto
select * from Workflow.Concepto c where c.IdConcepto in ('FLUJO_INI', 'GRUPO_BENEF', 'ID_TRAMITE', 'OFICINA_INI', 'ID_TRAMITE_MIG')
-------------------------------------------------------------------------------------------------
--TipoTramiteConcepto
select * from Workflow.TipoTramiteConcepto c where c.IdConcepto in ('FLUJO_INI', 'GRUPO_BENEF', 'ID_TRAMITE', 'OFICINA_INI', 'ID_TRAMITE_MIG')
-------------------------------------------------------------------------------------------------
--SolicitudTramite
--origen
select titular as Descripcion,Usuario as IdUsuario,fechareg as FechaHoraRegistro,fechareg as FechaHoraInicio,Usuario as IdUsuarioInicio 
from M_TRAMITES_ESTADOIN m where m.TipoTram = 'CC_CADQ' and m.flag not in (1,5,6)
--destino
select Descripcion,IdUsuario,FechaHoraRegistro,FechaHoraInicio,IdUsuarioInicio from Workflow.SolicitudTramite

SELECT 'Pivote' AS Origen,*
FROM (  select titular as Descripcion,Usuario as IdUsuario,fechareg as FechaHoraRegistro,fechareg as FechaHoraInicio,Usuario as IdUsuarioInicio 
        from M_TRAMITES_ESTADOIN m where m.TipoTram = 'CC_CADQ' and m.flag not in (1,5,6)
		EXCEPT
		select Descripcion,IdUsuario,FechaHoraRegistro,FechaHoraInicio,IdUsuarioInicio from Workflow.SolicitudTramite
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  select Descripcion,IdUsuario,FechaHoraRegistro,FechaHoraInicio,IdUsuarioInicio from Workflow.SolicitudTramite
		EXCEPT
		select titular as Descripcion,Usuario as IdUsuario,fechareg as FechaHoraRegistro,fechareg as FechaHoraInicio,Usuario as IdUsuarioInicio 
		from M_TRAMITES_ESTADOIN m where m.TipoTram = 'CC_CADQ' and m.flag not in (1,5,6)
	) AS DERECHA
-------------------------------------------------------------------------------------------------
--SolicitudTramiteConcepto
select * from Workflow.SolicitudTramiteConcepto s where s.IdConcepto in ('FLUJO_INI', 'GRUPO_BENEF', 'ID_TRAMITE', 'OFICINA_INI', 'ID_TRAMITE_MIG')
-------------------------------------------------------------------------------------------------
--Instancia
--origen
select fechareg as FechaHrInicio,Oficina as IdOficina,Usuario as IdUsuario from dbo.M_TRAMITES_ESTADOIN a where a.TipoTram = 'CC_CADQ' and a.flag not in (1,5,6)
--destino
select FechaHrInicio,IdOficina,IdUsuario from Workflow.Instancia

SELECT 'Pivote' AS Origen,*
FROM (  select fechareg as FechaHrInicio,Oficina as IdOficina,Usuario as IdUsuario from dbo.M_TRAMITES_ESTADOIN a where a.TipoTram = 'CC_CADQ' and a.flag not in (1,5,6)
		EXCEPT
		select FechaHrInicio,IdOficina,IdUsuario from Workflow.Instancia
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  select FechaHrInicio,IdOficina,IdUsuario from Workflow.Instancia
		EXCEPT
		select fechareg as FechaHrInicio,Oficina as IdOficina,Usuario as IdUsuario from dbo.M_TRAMITES_ESTADOIN a where a.TipoTram = 'CC_CADQ' and a.flag not in (1,5,6)
	) AS DERECHA
-------------------------------------------------------------------------------------------------
--InstanciaNodo
--origen
select INSTANCIA.IdInstancia,INSTANCIA.IdTipoTramite,INSTANCIA.IdSolicitud,INSTANCIA.IdFlujo,MTF.IdActividad as IdNodo,MTF.FechaIngreso as FechaHrInicio,MTF.FechaSalida as FechaHrFin,MTF.IdArea,MTF.Usuario as IdUsuario 
from M_TRAMITES_ESTADOIN MTEI join M_TRAMITESFLUJO MTF on MTEI.Tramite = MTF.TramiteCrenta
							  join (select IdSolicitud, ValorChar from Workflow.SolicitudTramiteConcepto where IdConcepto = 'ID_TRAMITE_MIG') STCPTO on STCPTO.ValorChar = MTEI.Tramite
							  join Workflow.Instancia INSTANCIA on INSTANCIA.IdSolicitud = STCPTO.IdSolicitud 
--destino	
select i.IdInstancia,i.IdTipoTramite,i.IdSolicitud,i.IdFlujo,i.IdNodo,i.FechaHrInicio,i.FechaHrFin,i.IdArea,i.IdUsuario from Workflow.InstanciaNodo i

SELECT 'Pivote' AS Origen,*
FROM (  select INSTANCIA.IdInstancia,INSTANCIA.IdTipoTramite,INSTANCIA.IdSolicitud,INSTANCIA.IdFlujo,MTF.IdActividad as IdNodo,MTF.FechaIngreso as FechaHrInicio,MTF.FechaSalida as FechaHrFin,MTF.IdArea,MTF.Usuario as IdUsuario 
		from M_TRAMITES_ESTADOIN MTEI join M_TRAMITESFLUJO MTF on MTEI.Tramite = MTF.TramiteCrenta
		                              join (select IdSolicitud, ValorChar from Workflow.SolicitudTramiteConcepto where IdConcepto = 'ID_TRAMITE_MIG') STCPTO on STCPTO.ValorChar = MTEI.Tramite
		                              join Workflow.Instancia INSTANCIA on INSTANCIA.IdSolicitud = STCPTO.IdSolicitud 
		EXCEPT
		select i.IdInstancia,i.IdTipoTramite,i.IdSolicitud,i.IdFlujo,i.IdNodo,i.FechaHrInicio,i.FechaHrFin,i.IdArea,i.IdUsuario from Workflow.InstanciaNodo i
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  select i.IdInstancia,i.IdTipoTramite,i.IdSolicitud,i.IdFlujo,i.IdNodo,i.FechaHrInicio,i.FechaHrFin,i.IdArea,i.IdUsuario from Workflow.InstanciaNodo i
		EXCEPT
		select INSTANCIA.IdInstancia,INSTANCIA.IdTipoTramite,INSTANCIA.IdSolicitud,INSTANCIA.IdFlujo,MTF.IdActividad as IdNodo,MTF.FechaIngreso as FechaHrInicio,MTF.FechaSalida as FechaHrFin,MTF.IdArea,MTF.Usuario as IdUsuario 
		from M_TRAMITES_ESTADOIN MTEI join M_TRAMITESFLUJO MTF on MTEI.Tramite = MTF.TramiteCrenta
		                              join (select IdSolicitud, ValorChar from Workflow.SolicitudTramiteConcepto where IdConcepto = 'ID_TRAMITE_MIG') STCPTO on STCPTO.ValorChar = MTEI.Tramite
		                              join Workflow.Instancia INSTANCIA on INSTANCIA.IdSolicitud = STCPTO.IdSolicitud 
	) AS DERECHA
-------------------------------------------------------------------------------------------------
--OficinaArea
select * from Seguridad.OficinaArea

-------------------------------------------------------------------------------------------------
--Rol
select * from Seguridad.Rol r where r.Descripcion like '%Migrador%' 

-------------------------------------------------------------------------------------------------





----------------------------------------------------------------
--SOLILCITUD TRAMITE - TRAMITES
SELECT * FROM Workflow.SolicitudTramite st
SELECT * FROM M_TRAMITES_ESTADOIN mte WHERE mte.TipoTram = 'CC_CADQ' and mte.flag in (1,5,6)
SELECT * FROM Workflow.SolicitudTramiteConcepto stc
----------------------------------------------------------------
--INSTANCIA - TRAMITES
SELECT * FROM Workflow.Instancia i
SELECT * FROM M_TRAMITES_ESTADOIN mte WHERE mte.TipoTram = 'CC_CADQ'
SELECT * FROM Workflow.InstanciaNodo in1
---------------------------------------------------------------







