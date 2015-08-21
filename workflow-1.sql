-- Limpia las tablas del módulo

delete Workflow.ReglaQueryDet
delete Workflow.ReglaQuery
delete Workflow.FlujoNodoPredecesorProcesoPrm
delete Workflow.FlujoNodoPredecesorProceso
delete Workflow.FlujoNodoPredecesorLink
delete Workflow.FlujoNodoPredecesorTDocCond
delete Workflow.FlujoNodoPredecesor
delete Workflow.FlujoNodoTipoDocumento
delete Workflow.FlujoNodoConcepto
delete Workflow.FlujoNodoLink
delete Workflow.FlujoNodo
delete Workflow.Flujo
delete Workflow.TipoTramiteTipoDocumento
delete Workflow.TipoTramiteConcepto
delete Workflow.TipoTramiteRolUsuario
delete Workflow.TipoTramiteRol
delete Workflow.TipoTramite
delete Workflow.GrupoRestriccionDet
delete Workflow.GrupoRestriccion
delete Workflow.InfoEvalTmp
delete Workflow.Restriccion
delete Workflow.Concepto
delete Workflow.TransicionMasivaDet
delete Workflow.TransicionMasiva
delete Workflow.ComprobanteTrasladoDocumentoDetTrg
delete Workflow.ComprobanteTrasladoDocumentoDetTmp
delete Workflow.ComprobanteTrasladoDocumentoDet
delete Workflow.ComprobanteTrasladoDocumento
delete Workflow.SolicitudTramiteConceptoTmp 
delete Workflow.SolicitudTramiteDocumentoTmp
delete Workflow.InstanciaNodoConcepto
delete Workflow.InstanciaNodo 
delete Workflow.Instancia
delete Workflow.SolicitudTramiteConcepto
delete Workflow.SolicitudTramiteDocumento
delete Workflow.SolicitudTramite 
delete Workflow.HisReglaQueryDet
delete Workflow.HisReglaQuery 
delete Workflow.HisFlujoNodoPredecesorProcesoPrm
delete Workflow.HisFlujoNodoPredecesorProceso
delete Workflow.HisFlujoNodoPredecesorLink
delete Workflow.HisFlujoNodoPredecesorTDocCond
delete Workflow.HisFlujoNodoPredecesor
delete Workflow.HisFlujoNodoTipoDocumento
delete Workflow.HisFlujoNodoConcepto
delete Workflow.HisFlujoNodoLinkParametro
delete Workflow.HisFlujoNodoLink
delete Workflow.HisFlujoNodo
delete Workflow.HisFlujo
delete Workflow.HisTipoTramiteTipoDocumento 
delete Workflow.HisTipoTramiteConcepto
delete Workflow.HisTipoTramiteRolUsuarioLog
delete Workflow.HisTipoTramiteRolUsuario
delete Workflow.HisTipoTramiteRol 
delete Workflow.HisTipoTramite
delete Workflow.HisGrupoRestriccionDet
delete Workflow.HisGrupoRestriccion
delete Workflow.HisRestriccion 
delete Workflow.HisConcepto
delete Workflow.HisInstanciaDefinicion
go

-- Crea las definiciones preliminares
exec PR_MigraWF 
go

-- Crea una conexión 
declare @w_iReturn int 
declare @o_iIdConexion bigint
declare @o_sMensajeError varchar(1000)

exec Seguridad.PR_Conexion
@i_cOperacion		= 'I',
@i_iIdUsuario		= 98,						-- Utilizar un usuario válido (preferentemente uno que se encuentre con el rol Administrador del Sistema)
@i_sCuentaUsuario	= 'RMOJICA',				-- CuentaUsuario del tal usuario 
@i_iIdRol			= 1,						-- Identificación del rol
@i_iIdOficina		= 2,						-- Oficina en la que está registrado el usuario
@o_iIdConexion		= @o_iIdConexion output,	
@o_sSSN				= null,
@o_sMensajeError	= @o_sMensajeError output

select Procedimiento = 'Seguridad.PR_Conexion', o_sMensajeError = @o_sMensajeError

-- Crea una instancia para las definiciones

exec Workflow.PR_HisInstanciaDefinicion 
@s_iIdConexion      = @o_iIdConexion,
@s_cOperacion       = 'I',
@s_iSesionTrabajo   = null,
@s_sSSN             = null,
@o_sMensajeError    = @o_sMensajeError output,
@i_iIdHisInstancia  = null,
@i_fFechaRegistro   = null,
@i_sComentarios     = null,
@i_bFlagActivo      = null,
@i_sIdTipoTramite	= 'CC_CADQ'

select Procedimiento = 'Workflow.PR_HisInstanciaDefinicion', @o_sMensajeError
go

exec PR_MigraWF2 
go
