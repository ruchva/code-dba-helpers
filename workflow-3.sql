/**************************************************************************
* SISTEMA SENASIR - Workflow.PR_MigraWF
***************************************************************************
* AUTOR:       Ramiro Mojica
* DESCRIPCION: Carga las tablas del módulo con las definiciones iniciales
*			   requeridas para la migración
* FECHA:       09/10/2014
*
***************************************************************************
* HISTORIA DE MODIFICACIONES
***************************************************************************
* AUTOR:
* JUSTIFICACION:
* FECHA:
***************************************************************************/

if exists (select * from dbo.sysobjects 
where id = object_id(N'PR_MigraWF')
and   objectproperty(id, N'IsProcedure') = 1)
	drop procedure PR_MigraWF 
go

create procedure PR_MigraWF as

insert into Workflow.Flujo values ( 1409001, 'Curso de Adq. - Trámite Migrados',				'CC_CADQ', null, 0, 0, null, 0, null, null, null, 5, null, 0 )

insert into Workflow.FlujoNodo ( 
IdFlujo,					IdNodo,					Descripcion,
Comentarios,				DuracionMaxDias,		DuracionMaxHoras,
NivelOficina,				IdOficina,				IdArea,
IdRol,						IdUsuario,				FlagRechazo,
FlagFicticio,				FlagSincronizador,		FlagTerminal,
IdEstadoTramite,			Nemonico,				Estado
) select 
1409001,					IdActividad,			DescripcionActividad,
null,						0,						0,
1,							IdOficina,				IdArea,
177,						null,					0,
0,							0,						0,
null,						null,					'A'
from dbo.M_ACTIVIDADFLUJO

insert into Workflow.FlujoNodo ( 
IdFlujo,				IdNodo,						Descripcion,
Comentarios,			DuracionMaxDias,			DuracionMaxHoras,
NivelOficina,			IdOficina,					IdArea,
IdRol,					IdUsuario,					FlagRechazo,
FlagFicticio,			FlagSincronizador,			FlagTerminal,
IdEstadoTramite,		Nemonico,					Estado
) select 
1409001,				1,							'Actividad Ficticia Auxiliar',
null,					0,							0, 
1,						2,							null, 
5,						null,						0,
1,						0,							0,
null,					null,						'A'

insert into Workflow.FlujoNodoPredecesor (
IdFlujo,				IdNodoPred,					IdNodo,
IdGrupoRestriccion,		FLagGeneraCbteRspldo,		FlagImrimeCbteRspldo,
FlagTransicionMasiva,	NodoParalelo,				ReglaNodoParalelo,
FlagManual,				FlagAlerta,					MensajeAlerta,
FlagAnonimo
) select 
1409001,				1,							2,
null,					0,							0,
0,						null,						null,
1,						0,							null,
0

insert into Workflow.FlujoNodoPredecesor (
IdFlujo,				IdNodoPred,					IdNodo,
IdGrupoRestriccion,		FLagGeneraCbteRspldo,		FlagImrimeCbteRspldo,
FlagTransicionMasiva,	NodoParalelo,				ReglaNodoParalelo,
FlagManual,				FlagAlerta,					MensajeAlerta,
FlagAnonimo
) select 
PRED.IdFlujo,	PRED.IdNodo,				SUCC.IdNodo,
null,					0,							0,
0,						null,						null,
1,						0,							null,
0
from Workflow.FlujoNodo PRED
cross join Workflow.FlujoNodo SUCC 
where PRED.IdFlujo = 1409001
and   PRED.IdNodo  not in (1) 
and   SUCC.IdFlujo = 1409001
and   SUCC.IdNodo  not in (1) 
and   PRED.IdNodo  <> SUCC.IdNodo


-- CONFIGURACION DEL FLUJO HISTORICO

insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'FLUJO_INI',		'Flujo que se pretende iniciar',							null,	'I',	null,	null,	null,	null,  null)
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'GRUPO_BENEF',		'Grupo Beneficio',											null,	'I',	null,	null,	null,	null,  'iIdGrupoBeneficio')
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'ID_TRAMITE',		'Identificador del trámite',								null,	'I',	null,	null,	null,	null,  'iIdTramite')
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'OFICINA_INI',		'Oficina en la que se inicia el trámite',					null,	'I',		null,	  null,			  null,	   null,  null)
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'ID_TRAMITE_MIG',	'Identificador del trámite migrado',						null,	'C',		null,	  null,			  null,	   null,  null)

insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'ID_TRAMITE',		1,		1,		0,		1,		 0,		null,		null,		null,		null,		null,	 null,		null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'GRUPO_BENEF',		2,		1,		0,		1,		 0,		null,		null,		null,		null,		null,	 null,		null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'FLUJO_INI',		3,		1,		0,		1,		 1,		null,		null,		null,		null,		null,	 null,		null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'OFICINA_INI',		4,		1,		0,		1,		 0,		null,		null,		null,		null,		null,	 null,		null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'ID_TRAMITE_MIG',	5,		1,		0,		1,		 0,		null,		null,		null,		null,		null,	 null,		null


go
