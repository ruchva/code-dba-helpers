/*  PR_MIGRAWF  */
if exists (select * from dbo.sysobjects 
where id = object_id(N'PR_MigraWF')
and   objectproperty(id, N'IsProcedure') = 1)
	drop procedure PR_MigraWF 
go

create procedure PR_MigraWF as

insert into Workflow.Flujo values ( 1409001, 'Curso de Adq. - Trámite Migrados','CC_CADQ', null, 0, 0, null, 0, null, null, null, 5, null, 0 )
--UN FLUJO ES UN CONJUNTO DE ACTIVIDADES
--FLUJO NODO SON LAS ACTIVIDADES
insert into Workflow.FlujoNodo (-- son las actividades de la actividad creada
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
-- creacion de un nodo inicial, todos los flujos tienen uno
insert into Workflow.FlujoNodo (-- nodo inicial  
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
-- a continuacion llena la red de todas las actividades posibles
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
-- este flujo tiene 5 actividades  
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'FLUJO_INI',		'Flujo que se pretende iniciar',	 null,	'I',	null,	null,	  null,	    null,     null)
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'GRUPO_BENEF',		'Grupo Beneficio',					 null,	'I',	null,	null,	  null,	    null,     'iIdGrupoBeneficio')
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'ID_TRAMITE',		'Identificador del trámite',		 null,	'I',	null,	null,	  null,	    null,     'iIdTramite')
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'OFICINA_INI',		'Oficina en la que se inicia el trámite',	null,	'I',	null,	  null,		null,	  null,  null)
insert into Workflow.Concepto ( IdConcepto, Descripcion, Comentarios, TipoDato, Longitud, FlagMayusculas, Mascara, IdTipoClasificador, Alias) values ( 
'ID_TRAMITE_MIG',	'Identificador del trámite migrado',		null,	'C',	null,	  null,		null,	  null,  null)
-- las 5 actividades son de TipoTramite = 'CC_CADQ'
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'ID_TRAMITE',		1,	1,	0,	1,	0,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'GRUPO_BENEF',		2,	1,	0,	1,	0,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'FLUJO_INI',		3,	1,	0,	1,	1,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'OFICINA_INI',		4,	1,	0,	1,	0,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'ID_TRAMITE_MIG',	5,	1,	0,	1,	0,	null, null, null, null, null, null, null


go
