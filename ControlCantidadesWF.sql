CREATE PROCEDURE ControlCantidadesWF
AS
BEGIN	
	declare @cFlujo int
	select @cFlujo = count(*) from Workflow.Flujo f where f.IdFlujo = 1409001 
	print '    Workflow.Flujo REGISTROS CREADOS:  '+ CAST(@cFlujo AS CHAR(5)) 
	print '------------------------------------------------------------------------------------------'
	
	declare @cFlujoNodo int, @mig_1 int
	select @cFlujoNodo = count(*) from Workflow.FlujoNodo
	select @mig_1 = count(*) from dbo.M_ACTIVIDADFLUJO_C --***M_ACTIVIDADFLUJO
	print '    Workflow.FlujoNodo REGISTROS MIGRADOS:  '+ CAST(@cFlujoNodo AS CHAR(5)) +'| ORIGEN:  '+ CAST(@mig_1 AS CHAR(5))
	print '------------------------------------------------------------------------------------------'

	declare @cFlujoNodoPredecesor int
	select @cFlujoNodoPredecesor = count(*) from Workflow.FlujoNodoPredecesor a where a.IdFlujo = 1409001
	print '    Workflow.FlujoNodoPredecesor REGISTROS MIGRADOS:  '+ CAST(@cFlujoNodoPredecesor AS CHAR(5)) +'| ORIGEN:  '+ CAST(@cFlujoNodo AS CHAR(5))+'| CALCULADO:  '+CAST((@cFlujoNodo*@cFlujoNodo) - @cFlujoNodo AS CHAR(5))
	print '------------------------------------------------------------------------------------------'

	declare @cConcepto int
	select @cConcepto = count(*) from Workflow.Concepto c where c.IdConcepto in ('FLUJO_INI', 'GRUPO_BENEF', 'ID_TRAMITE', 'OFICINA_INI', 'ID_TRAMITE_MIG')
	print '    Workflow.Concepto REGISTROS CREADOS:  '+ CAST(@cConcepto AS CHAR(5)) 
	print '------------------------------------------------------------------------------------------'

	declare @cTipoTramiteConcepto int
	select @cTipoTramiteConcepto = count(*) from Workflow.TipoTramiteConcepto c where c.IdConcepto in ('FLUJO_INI', 'GRUPO_BENEF', 'ID_TRAMITE', 'OFICINA_INI', 'ID_TRAMITE_MIG')
	print '    Workflow.TipoTramiteConcepto REGISTROS CREADOS:  '+ CAST(@cTipoTramiteConcepto AS CHAR(5)) 
	print '------------------------------------------------------------------------------------------'

	declare @cSolicitudTramite int, @mig_2 int 
	select @cSolicitudTramite = count(*) from Workflow.SolicitudTramite 
	select @mig_2 = count(*) from dbo.M_TRAMITES_ESTADOIN a where a.TipoTram = 'CC_CADQ' and a.flag not in (1,5,6)
	print '    Workflow.SolicitudTramite REGISTROS MIGRADOS:  '+ CAST(@cSolicitudTramite AS CHAR(5)) +'| ORIGEN:  '+ CAST(@mig_2 AS CHAR(5))
	print '------------------------------------------------------------------------------------------'

	declare @cSolicitudTramiteConcepto int
	select @cSolicitudTramiteConcepto = count(*) from Workflow.SolicitudTramiteConcepto s where s.IdConcepto in ('FLUJO_INI', 'GRUPO_BENEF', 'ID_TRAMITE', 'OFICINA_INI', 'ID_TRAMITE_MIG')
	print '    Workflow.SolicitudTramiteConcepto REGISTROS CREADOS:  '+ CAST(@cSolicitudTramiteConcepto AS CHAR(5)) 
	print '------------------------------------------------------------------------------------------'
	
	declare @cInstancia int 
	select @cInstancia = count(*) from Workflow.Instancia
	print '    Workflow.Instancia REGISTROS MIGRADOS:  '+ CAST(@cInstancia AS CHAR(5)) +'| ORIGEN:  '+ CAST(@mig_2 AS CHAR(5))
	print '------------------------------------------------------------------------------------------'

	declare @aInstanciaNodo int, @mig_3 int
	select @aInstanciaNodo = count(*) from Workflow.InstanciaNodo
	select @mig_3 = count(*) 
	from M_TRAMITES_ESTADOIN MTEI
		join M_TRAMITESFLUJO MTF on MTEI.Tramite = MTF.TramiteCrenta
		join (select IdSolicitud, ValorChar from Workflow.SolicitudTramiteConcepto where IdConcepto = 'ID_TRAMITE_MIG') STCPTO on STCPTO.ValorChar = MTEI.Tramite
		join Workflow.Instancia INSTANCIA on INSTANCIA.IdSolicitud = STCPTO.IdSolicitud 
	where TipoTram = 'CC_CADQ'
	print '    Workflow.InstanciaNodo REGISTROS MIGRADOS:  '+ CAST(@aInstanciaNodo AS CHAR(5)) +'| ORIGEN:  '+ CAST(@mig_3 AS CHAR(5))
	print '------------------------------------------------------------------------------------------'

	declare @cOficinaArea int 
	select @cOficinaArea = count(*) from Seguridad.OficinaArea a 
	print '    Seguridad.OficinaArea REGISTROS CREADOS:  '+ CAST(@cOficinaArea AS CHAR(5)) 
	print '------------------------------------------------------------------------------------------'

	declare @cRol int
	select @cRol = count(*) from Seguridad.Rol r where r.Descripcion = 'Migrador Workflow'
	print '    Seguridad.Rol REGISTROS CREADOS:  '+ CAST(@cRol AS CHAR(5)) 
	print '------------------------------------------------------------------------------------------'
END	






