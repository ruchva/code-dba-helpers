/** WORKFLOW **/
SELECT ft.* FROM CRENTA.dbo.FUNC_TRAMITE ft 
JOIN CRENTA.dbo.TRAMITE t ON ft.Matricula = t.Matricula AND ft.Tramite = t.Tramite
WHERE t.ClaseRenta = 'U'

SELECT TOP 1000 * FROM CRENTA.dbo.FUNC_TRAMITE ft --expediente esta en Departamento
WHERE ft.Sta = 'P' AND ft.StaRec = 'P' AND ft.FechaSalida IS NULL

SELECT TOP 1000 * FROM CRENTA.dbo.FUNC_TRAMITE ft --ya salieron del departamento
WHERE ft.Sta = 'R' AND ft.StaRec = 'R' AND ft.FechaSalida IS NOT NULL

SELECT TOP 1000 * FROM CRENTA.dbo.FUNC_TRAMITE ft --asignada a otra area sin confirmar
WHERE ft.Sta = 'C' AND ft.StaRec = 'A' 
--SELECT * FROM CRENTA.dbo.FUNC_TRAMITE_ASG fta
--WHERE fta.Matricula = '030222OLE' AND fta.Tramite = '423/24' AND fta.Funcionario = 1945

--dbo.M_TRAMITES_ESTADOIN--217319
SELECT COUNT(*) FROM CRENTA.dbo.FUNCIONARIO f
SELECT COUNT(*) FROM CRENTA.dbo.DEPARTAMENTO d
SELECT COUNT(*) FROM SENARITD.Tramite.TramitePersona tp

-------------------------------------------------
/*ORIGEN
*   FROM Seguridad.Usuario b 
*   JOIN [ADMINSYS].[dbo].[ADM_USUARIO] a ON a.CARNET = b.Carnet 
*   JOIN FuncionarioCompl c ON a.LOGIN = c.login 
*   AND RTRIM(LTRIM(a.PATERNO))=RTRIM(LTRIM(c.[Apellido Paterno]))
*	AND RTRIM(LTRIM(a.MATERNO))=RTRIM(LTRIM(c.[Apellido Materno]))
*	WHERE c.IdUsuario IS NULL
* */
SELECT COUNT(*) FROM SENARITD.Seguridad.Usuario u
-------------------------------------------------
/* ORIGEN
* #TempFuncionario --> FROM SENARITD.dbo.KFunTramiteCC A
* FROM CRENTA..FUNCIONARIO a JION #TempFuncionario b
* ON a.Funcionario=b.Funcionario		
* */
SELECT COUNT(*)'FuncionarioCompl' FROM dbo.FuncionarioCompl
SELECT COUNT(*)'KFunTramiteCC' FROM dbo.KFunTramiteCC--
SELECT COUNT(*)'KTramiteF' FROM dbo.KTramiteF--0
-------------------------------------------------
/*ORIGEN
* Departamento, DescripcionD, Prestacion
* FROM CRENTA..DEPARTAMENTO
* todo segun validacion de pertenencia a un tipo
* */
SELECT COUNT(*)'M_ACTIVIDADFLUJO' FROM M_ACTIVIDADFLUJO ma
/*SON LAS AREAS QUE PROVIENEN DE CRENTA..DEPARTEMENTO
* CREA EL FLUJO PARA EL MODELO ACTUAL
* */
DECLARE @AUX3 INT
SELECT  @AUX3=count (*)   from M_ACTIVIDADFLUJO
PRINT 'CANTIDAD DE ACTIVIDADES DE LA TABLA DE LA TABLA M_ACTIVIDADFLUJO --->'+ CAST(@AUX3 AS CHAR(5))
DECLARE @AUX4 INT
SELECT  @AUX4=count (distinct Departamento )  from  SENARITD.dbo.KFunTramiteCC 
PRINT 'CANTIDAD DE ACTIVIDADES QUE ESTAN INVOLUCRADAS EN TRAMITES DE CC --->'+ CAST(@AUX4 AS CHAR(5))
/*DESTINO
* Workflow.Flujo --> 
* Workflow.FlujoNodo --> 
* Workflow.FlujoNodoPredecesor --> FlujoNodo 
* */
-------------------------------------------------
SELECT COUNT(*)'M_ACTIVIDADFLUJO_C' FROM M_ACTIVIDADFLUJO_C mac
-------------------------------------------------
/*ORIGEN
* FROM SENARITD.dbo.KFunTramiteCC a JOIN dbo.FuncionarioCompl b
  ON a.Funcionario=b.Funcionario JOIN  dbo.M_ACTIVIDADFLUJO c
  ON a.Departamento=c.IdActividad
  WHERE Tramite NOT IN (SELECT Tramite FROM M_TRAMITE_INCONSISTENCIASWF)
* */
SELECT COUNT(*)'M_TRAMITESFLUJO' FROM M_TRAMITESFLUJO mt
-------------------------------------------------
SELECT COUNT(*)'M_TRAMITE_INCONSISTENCIASWF' FROM M_TRAMITE_INCONSISTENCIASWF mti--CON INCONSISTENCIA
-------------------------------------------------
/*ORIGEN 
  select a.* from CRENTA..FUNC_TRAMITE a
  join CRENTA..TRAMITE b on  a.Matricula=b.Matricula and a.Tramite=b.Tramite 
  where b.ClaseRenta='U' 
* VACIADO EN KFunTramiteCC -- OBTIENE SOLO DE TIPO CC 
* */
SELECT COUNT(*)'M_TRAMITES_ESTADOIN' FROM M_TRAMITES_ESTADOIN mte--
/*DATOS DE LOS TRAMITES QUE CONCLUYERON 
* Sta is  P OR StaRec is P   'terminado' 212051 casos 
* Sta is  NULL OR StaRec is NULL
* Sta is  ' '  OR StaRec is ' '
* Estados PX y XP equivalen a PP
* Estados diferentes a PX, XP, PP son tramites en curso
* En curso de pago TipoTram = 'CC_CPAGO'
* En curso de adquisicion TipoTram = 'CC_CADQ'
* Titular del tramite titular = 'nombre concatenado'
* Fecha inicio tramite fechaini
* Fecha registro tramite fechareg
* Usuario inicio y usuario registro Usuarioini y Usuario
* Rol, rol inicio, oficina registro Rol, Rolinicio, Oficina
* TramiteTramP --> IdTramite de Tramite.TramitePersona
* AutoManual --> IdTipoTramite de Tramite.TramitePersona
* flag in(1,2,5,6) debe entrar a M_TRAMITE_INCONSISTENCIASWF
*----------------CANTIDAD DE DATOS LLENADOS ----------------------*/
DECLARE	@num int SET @num=(SELECT COUNT(Tramite) FROM dbo.M_TRAMITES_ESTADOIN)
		PRINT 'NUMERO DE TRAMITES ---->' + CAST(@num AS CHAR(10))
DECLARE @num1 int SET @num1=(SELECT COUNT(Tramite) FROM dbo.M_TRAMITES_ESTADOIN where Nua  is not NULL)
		PRINT 'NUMERO DE TRAMITES CON NUA---->' + CAST(@num1 AS CHAR(10))		
DECLARE	@num2 int SET @num2=(SELECT COUNT(Tramite) FROM dbo.M_TRAMITES_ESTADOIN where Nua  is  NULL)
		PRINT 'NUMERO DE TRAMITES SIN NUA---->' + CAST(@num2 AS CHAR(10))
/*DESTINO
* Workflow.SolicitudTramite --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ' 
* Workflow.SolicitudTramiteConcepto --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ', Secuencia = 1, Concepto = 'ID_TRAMITE'	, ValorInt = TramiteTramP
* Workflow.SolicitudTramiteConcepto --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ', Secuencia = 2, Concepto = 'GRUPO_BENEF', ValorInt = 3
* Workflow.SolicitudTramiteConcepto --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ', Secuencia = 3, Concepto = 'OFICINA_INI', ValorInt = isnull(Oficina, 2),
* Workflow.SolicitudTramiteConcepto --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ', Secuencia = 4, Concepto = 'FLUJO_INI'	, ValorInt = case when AutoManual = 356 then 1409001 else 1409002 end
* Workflow.SolicitudTramiteConcepto --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ', Secuencia = 5, Concepto = 'ID_TRAMITE_MIG', ValorInt = null
* Workflow.Instancia --> where isnull(flag, 0) not in (1, 6, 5) and TipoTram = 'CC_CADQ'
* Workflow.InstanciaNodo -->from M_TRAMITES_ESTADOIN MTEI
							inner join M_TRAMITESFLUJO MTF on MTEI.Tramite = MTF.TramiteCrenta
							inner join (select IdSolicitud, ValorChar from Workflow.SolicitudTramiteConcepto where IdConcepto = 'ID_TRAMITE_MIG') STCPTO on STCPTO.ValorChar = MTEI.Tramite
							inner join Workflow.Instancia INSTANCIA on INSTANCIA.IdSolicitud = STCPTO.IdSolicitud 
							where TipoTram = 'CC_CADQ'
* Workflow.InstanciaNodo --> actualiza la secuencia
* */
-------------------------------------------------
/*ORIGEN
* datos parametricos de MIGRA_WORKFLOWPARAMETROS
* */
SELECT COUNT(*) FROM Seguridad.OficinaArea

DECLARE @AUX  INT
SELECT  @AUX=count ( distinct (Departamento) )   from CRENTA..FUNC_TRAMITE
PRINT 'CANTIDAD DE DEPARTAMENTOS DE LA TABLA FUN TRAMITE --->'+ CAST(@AUX AS CHAR(5))
DECLARE @AUX2 INT
SELECT  @AUX2=count (* )   from CRENTA..DEPARTAMENTO
PRINT 'CANTIDAD DE DEPARTAMENTOS DE LA TABLA DEPARTAMENTO --->'+ CAST(@AUX2 AS CHAR(5))
-------------------------------------------------


SELECT a.* FROM CRENTA..FUNC_TRAMITE a
JOIN CRENTA..TRAMITE b ON a.Matricula=b.Matricula AND a.Tramite=b.Tramite 
WHERE b.ClaseRenta='U' AND a.Matricula = '460119VAF' 

SELECT * FROM M_TRAMITES_ESTADOIN a WHERE a.Matricula = '460119VAF'

SELECT TOP 1 * FROM Workflow.SolicitudTramite
SELECT TOP 1 * FROM Workflow.SolicitudTramiteConcepto
SELECT TOP 1 * FROM Workflow.Flujo f
SELECT TOP 1 * FROM Workflow.FlujoNodo fn
SELECT TOP 1 * FROM Workflow.Instancia i
SELECT TOP 1 * FROM Workflow.InstanciaNodo in1
SELECT TOP 1 * FROM Workflow.Concepto c

--usuarios








