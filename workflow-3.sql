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
) 
select 
1409001,					IdActividad,			DescripcionActividad,
null,						0,						0,
1,							IdOficina,				IdArea,
177,						null,					0,
0,							0,						0,
null,						null,					'A'
from dbo.M_ACTIVIDADFLUJO
SELECT * FROM M_ACTIVIDADFLUJO ma -- se llena en MIGRA_WORKFLOWPARAMETROS
SELECT  Departamento, DescripcionD, Prestacion,
  CASE WHEN Departamento IN (29,67,92,117,52,77,2,20,23,40,60,115,132,140,48,31,37,54,78,112,26,62,141
	,8,9,10,12,17,25,30,35,42,45,47,49,50,57,59,64,68,69,70,75,82,83,84,85,86,87,98,99,101,102,114,120,122,123
	,71,104,124,143,72,73,76,96,97,105,108,109,142,89,90,103,107,118,121,134,136,137,91,11,39,41,74,106,111,119
	,21,44,18,51,65,19,66,7,22,36,93,95,138,116,139,33,34,94,100,43,46,133,28,58,144,145)  THEN 2
  END AS Oficina, 
  CASE 
    WHEN Departamento IN (29,67,92,117)  THEN 20100
	WHEN Departamento IN (52,77)  THEN 20200
	WHEN Departamento IN (2,20,23,40,60,115,132,140)  THEN 20300
	WHEN Departamento IN (48)  THEN 20400
	WHEN Departamento IN (31)  THEN 20500
	WHEN Departamento IN (37,54,78)  THEN 20600
	WHEN Departamento IN (112)  THEN 20601
	WHEN Departamento IN (26,62,141)  THEN 20602
	WHEN Departamento IN (8,9,10,12,17,25,30,35,42,45,47,49,50,57,59,64,68,69,70,75,82,83,84,85,86,87,98,99,101,102,114,120,122,123)  THEN 20604
	WHEN Departamento IN (71,104,124,143)  THEN 20700
	WHEN Departamento IN (72,73,76,96,97,105,108,109,142)  THEN 20701
	WHEN Departamento IN (89)  THEN 20702
	WHEN Departamento IN (90,103,107,118,121,134,136,137)  THEN 20704
	WHEN Departamento IN (91)  THEN 20705
	WHEN Departamento IN (11,39,41,74,106,111,119)  THEN 20707
	WHEN Departamento IN (21,44)  THEN 20714
	WHEN Departamento IN (18)  THEN 20801
	WHEN Departamento IN (51,65)  THEN 20900
	WHEN Departamento IN (19,66)  THEN 20901
	WHEN Departamento IN (7,22,36,93,95)  THEN 21100
	WHEN Departamento IN (138)  THEN 21101
	WHEN Departamento IN (116)  THEN 21102
	WHEN Departamento IN (139)  THEN 21103
	WHEN Departamento IN (33,34,94,100)  THEN 21104
	WHEN Departamento IN (43,46,133)  THEN 21200
	WHEN Departamento IN (28,58)  THEN 21201
	WHEN Departamento IN (144,145)  THEN 21202
    END AS Area, 
    0 AS Flujo,
	status   
FROM CRENTA..DEPARTAMENTO  
WHERE Departamento NOT IN (61,63,79,80,81,125,126,127,128,129,130,131,135) /*--- NO SE PUEDIERON CLASIFICAR	--*/
  AND Departamento NOT IN (55,61,83,88,110,113,123,124,126,141)		       /*--- DEPARTAMENTOS  QUE NO SE ENCUENTRA EN FUNC_TRAMITE --*/
ORDER BY Departamento
-----------------------------------------------------------------------

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
-- a continuacion llena la red de todas las combinaciones posibles de actividades
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
-- las 5 actividades son de TipoTramite = 'CC_CADQ' en curso de adquisicion de pago
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'ID_TRAMITE',		1,	1,	0,	1,	0,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'GRUPO_BENEF',		2,	1,	0,	1,	0,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'FLUJO_INI',		3,	1,	0,	1,	1,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'OFICINA_INI',		4,	1,	0,	1,	0,	null, null, null, null, null, null, null
insert into Workflow.TipoTramiteConcepto select 'CC_CADQ',	'ID_TRAMITE_MIG',	5,	1,	0,	1,	0,	null, null, null, null, null, null, null


go
