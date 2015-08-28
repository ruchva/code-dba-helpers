/*  PR_MIGRAWF2  */
if exists (select * from dbo.sysobjects 
where id = object_id(N'PR_MigraWF2')
and   objectproperty(id, N'IsProcedure') = 1)
	drop procedure PR_MigraWF2 
go

create procedure PR_MigraWF2 as
-- ingresa tramites - cabeceras 
insert into Workflow.SolicitudTramite 
select 
	IdSolicitud       = row_number() over(order by (select 1)),
	CodigoTramite     = convert(varchar(15), row_number() over(order by (select 1))),
	Descripcion       = isnull(MTEI.titular, 'Sin titular'),
	Comentarios       = null,
	IdHisInstancia    = 1 ,			
	IdTipoTramite     = 'CC_CADQ',
	IdRol		      = 177,				
	IdUsuario		  = MTEI.Usuario,
	FechaHoraRegistro = MTEI.fechareg,
	FechaHoraInicio   = MTEI.fechareg,	
	IdRolInicio		  = 177,			
	IdUsuarioInicio   = MTEI.Usuario,
	FechaHoraTermino  = null,	
	Estado			  = 'I'
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP 
SELECT * FROM Workflow.SolicitudTramite st
SELECT * FROM M_TRAMITES_ESTADOIN mte WHERE ISNULL(mte.flag, 0) NOT IN (1, 6, 5) AND TipoTram = 'CC_CADQ'
SELECT a.* FROM   CRENTA..FUNC_TRAMITE a -- OBTIENE LA TABLA PIVOTE SOLO DE CC
JOIN CRENTA..TRAMITE b ON  a.Matricula = b.Matricula AND a.Tramite = b.Tramite
WHERE  b.ClaseRenta = 'U' --KFunTramiteCC 

-- detalle de los tramites 
-- en base a las 5 actividades creadas de TipoTramite = 'CC_CADQ'
insert into Workflow.SolicitudTramiteConcepto (
IdSolicitud,		Secuencia,			IdHisInstancia,
IdTipoTramite,		IdConcepto,			TipoDato,
FlagInicio,			ValorInt,			ValorMoney,
ValorFloat,			ValorChar,			ValorDate,
ValorCatalog,		ValorBoolean
) 
select 
IdSolicitud			= row_number() over(order by (select 1)),
Secuencia			= 1, 
IdHisInstancia		= 1,
IdTipoTramite		= 'CC_CADQ',
IdConcepto			= 'ID_TRAMITE',
TipoDato			= 'I',
FlagInicio			= 1,			
ValorInt			= MTEI.TramiteTramP,
ValorMoney			= null,
ValorFloat			= null,			
ValorChar			= null,			
ValorDate			= null,
ValorCatalog		= null,		
ValorBoolean		= null
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP
SELECT * FROM Workflow.SolicitudTramiteConcepto stc WHERE stc.Secuencia = 1

insert into Workflow.SolicitudTramiteConcepto (
IdSolicitud,		Secuencia,			IdHisInstancia,
IdTipoTramite,		IdConcepto,			TipoDato,
FlagInicio,			ValorInt,			ValorMoney,
ValorFloat,			ValorChar,			ValorDate,
ValorCatalog,		ValorBoolean
) 
select 
IdSolicitud			= row_number() over(order by (select 1)),
Secuencia			= 2, 
IdHisInstancia		= 1,
IdTipoTramite		= 'CC_CADQ',
IdConcepto			= 'GRUPO_BENEF',
TipoDato			= 'I',
FlagInicio			= 1,			
ValorInt			= 3,			
ValorMoney			= null,
ValorFloat			= null,			
ValorChar			= null,			
ValorDate			= null,
ValorCatalog		= null,		
ValorBoolean		= null
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP
SELECT * FROM Workflow.SolicitudTramiteConcepto stc WHERE stc.Secuencia = 2

insert into Workflow.SolicitudTramiteConcepto (
IdSolicitud,		Secuencia,			IdHisInstancia,
IdTipoTramite,		IdConcepto,			TipoDato,
FlagInicio,			ValorInt,			ValorMoney,
ValorFloat,			ValorChar,			ValorDate,
ValorCatalog,		ValorBoolean
) 
select 
IdSolicitud			= row_number() over(order by (select 1)),
Secuencia			= 3,
IdHisInstancia		= 1,
IdTipoTramite		= 'CC_CADQ',
IdConcepto			= 'OFICINA_INI',
TipoDato			= 'I',
FlagInicio			= 1,			
ValorInt			= isnull(MTEI.Oficina, 2), 
ValorMoney			= null,
ValorFloat			= null,			
ValorChar			= null,			
ValorDate			= null,
ValorCatalog		= null,		
ValorBoolean		= null
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP
SELECT * FROM Workflow.SolicitudTramiteConcepto stc WHERE stc.Secuencia = 3

insert into Workflow.SolicitudTramiteConcepto (
IdSolicitud,		Secuencia,			IdHisInstancia,
IdTipoTramite,		IdConcepto,			TipoDato,
 FlagInicio,		ValorInt,			ValorMoney,
ValorFloat,			ValorChar,			ValorDate,
ValorCatalog,		ValorBoolean
) select 
IdSolicitud			= row_number() over(order by (select 1)),
Secuencia			= 4,
IdHisInstancia		= 1,
IdTipoTramite		= 'CC_CADQ',
IdConcepto			= 'FLUJO_INI',
TipoDato			= 'I',
FlagInicio			= 1,			
ValorInt			= case when AutoManual = 356 then 1409001 else 1409002 end,
ValorMoney			= null,
ValorFloat			= null,			
ValorChar			= null,			
ValorDate			= null,
ValorCatalog		= null,		
ValorBoolean		= null
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP
SELECT * FROM Workflow.SolicitudTramiteConcepto stc WHERE stc.Secuencia = 4

insert into Workflow.SolicitudTramiteConcepto (
IdSolicitud,		Secuencia,			IdHisInstancia,
IdTipoTramite,		IdConcepto,			TipoDato,
 FlagInicio,		ValorInt,			ValorMoney,
ValorFloat,			ValorChar,			ValorDate,
ValorCatalog,		ValorBoolean
) select 
IdSolicitud			= row_number() over(order by (select 1)),
Secuencia			= 5,
IdHisInstancia		= 1,
IdTipoTramite		= 'CC_CADQ',
IdConcepto			= 'ID_TRAMITE_MIG',
TipoDato			= 'C',
FlagInicio			= 1,			
ValorInt			= null,
ValorMoney			= null,
ValorFloat			= null,			
ValorChar			= Tramite,			
ValorDate			= null,
ValorCatalog		= null,		
ValorBoolean		= null
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP
SELECT * FROM Workflow.SolicitudTramiteConcepto stc WHERE stc.Secuencia = 5

-- registra la ejecucion del tramite - cabecera de la instancia
insert into Workflow.Instancia (
IdInstancia,			IdHisInstancia,			IdTipoTramite,
IdFlujo,				FechaHrInicio,			FechaHrFin,
IdOficina,				IdArea,					IdRol,
IdUsuario,				IdSolicitud,			Estado,
CambioEstadoFechaHr,	CancelaJustificacion,	CancelaIdOficina,
CancelaIdRol,			CancelaIdUsuario,		IdInstanciaAnterior
) select 
IdInstancia				= row_number() over(order by (select 1)),
IdHisInstancia			= 1,
IdTipoTramite			= 'CC_CADQ',
IdFlujo					= 1409001,
FechaHrInicio			= MTEI.fechareg,
FechaHrFin				= null,
IdOficina				= isnull(MTEI.Oficina, 2),
IdArea					= 20701,
IdRol					= 177,
IdUsuario				= MTEI.Usuario,
IdSolicitud				= row_number() over(order by (select 1)),
Estado					= 'I',
CambioEstadoFechaHr		= null,
CancelaJustificacion	= null,
CancelaIdOficina		= null,
CancelaIdRol			= null,
CancelaIdUsuario		= null,
IdInstanciaAnterior		= null
from dbo.M_TRAMITES_ESTADOIN MTEI
where isnull(MTEI.flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
order by MTEI.TramiteTramP

-- registra los estados o nodos por donde pasa un tramite
-- detalle de la instancia
insert into Workflow.InstanciaNodo ( 
IdInstancia,			Secuencia,					IdHisInstancia,
IdTipoTramite,			IdSolicitud,				IdFlujo,
IdNodo,					Contador,					FechaHrInicio,
FechaHrFin,				NivelOficina,				IdOficina,
IdArea,					IdRol,						IdUsuario,
Comentarios,			SecuenciaPred,				IdNodoPred,
FlagCbteTrasladoDoc,	FlagCbteTrasladoDocOK,		Estado
) select 
IdInstancia		= INSTANCIA.IdInstancia,
Secuencia		= row_number() over(order by (INSTANCIA.IdInstancia)),
IdHisInstancia	= 1, 
IdTipoTramite	= INSTANCIA.IdTipoTramite,
IdSolicitud		= INSTANCIA.IdSolicitud,
IdFlujo			= INSTANCIA.IdFlujo,
IdNodo			= MTF.IdActividad,
Contador		= 0,
FechaHrInicio   = MTF.FechaIngreso,
FechaHrFin		= MTF.FechaSalida,
NivelOficina	= 1,
IdOficina		= 2,
IdArea		    = MTF.IdArea,
IdRol			= 177,
IdUsuario		= MTF.Usuario, 
Comentarios	    = '',
SecuenciaPred   = 1,
IdNodoPred		= 1,
FlagCbteTrasladoDoc = 0,
FlagCbteTrasladoDocOK = 0,
Estado			= 'F'
from M_TRAMITES_ESTADOIN MTEI
inner join M_TRAMITESFLUJO MTF on MTEI.Tramite = MTF.TramiteCrenta
inner join (select IdSolicitud, ValorChar from Workflow.SolicitudTramiteConcepto where IdConcepto = 'ID_TRAMITE_MIG') STCPTO on STCPTO.ValorChar = MTEI.Tramite
inner join Workflow.Instancia INSTANCIA on INSTANCIA.IdSolicitud = STCPTO.IdSolicitud 
where TipoTram = 'CC_CADQ'
order by INSTANCIA.IdInstancia, MTF.FechaIngreso

-- empieza un proceso de correccion
declare 
@w_iIdInstancia		bigint,
@w_iIdInstanciaTmp	bigint,
@w_iSecuencia		int,
@w_iSecuenciaNew	int

declare @w_table_INodo table (
IdInstancia		bigint		not null,
Secuencia		int			not null,
SecuenciaNew	int			not null
)

declare cursor_INodo cursor for select 
IdInstancia, Secuencia
from Workflow.InstanciaNodo 

open cursor_INodo

fetch cursor_INodo into @w_iIdInstancia, @w_iSecuencia 

while @@fetch_status = 0 begin
	select @w_iSecuenciaNew   = 0
	select @w_iIdInstanciaTmp = @w_iIdInstancia

	while @@fetch_status = 0 and @w_iIdInstanciaTmp = @w_iIdInstancia begin 
		select @w_iSecuenciaNew = @w_iSecuenciaNew + 1
		insert into @w_table_INodo values (@w_iIdInstancia, @w_iSecuencia, @w_iSecuenciaNew) 
		fetch cursor_INodo into @w_iIdInstancia, @w_iSecuencia 
	end 
end 

close cursor_INodo
deallocate cursor_INodo

update INODO set INODO.Secuencia = INODOTMP.SecuenciaNew
from Workflow.InstanciaNodo INODO 
inner join @w_table_INodo INODOTMP on INODO.IdInstancia = INODOTMP.IdInstancia and INODO.Secuencia = INODOTMP.Secuencia

update Workflow.InstanciaNodo set SecuenciaPred = null, IdNodoPred = null
where Secuencia = 1 

update Workflow.InstanciaNodo set SecuenciaPred = Secuencia - 1
where Secuencia > 1 

update INODO set INODO.IdNodoPred = (select INODOTMP.IdNodo from Workflow.InstanciaNodo INODOTMP where INODO.IdInstancia = INODOTMP.IdInstancia and INODO.SecuenciaPred = INODOTMP.Secuencia)
from Workflow.InstanciaNodo INODO
where INODO.SecuenciaPred is not null 

go
