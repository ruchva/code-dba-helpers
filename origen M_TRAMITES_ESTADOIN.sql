USE [SENARITD]
GO
/****** Object:  StoredProcedure [dbo].[MIGRA_WORKFLOWFUNCTRAMITE]    Script Date: 25/08/2015 10:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MIGRA_WORKFLOWFUNCTRAMITE]
AS
BEGIN

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------      1 . PARTE .-  PROCEDIMIENTO PARA SELECCIONAR DE FUNC_TRAMITE ----------------------------*/
/*---------------------------------- A UN CONJUNTO MAS PEQUEÑO DE SOLO TRAMITES CC-------------------------------*/
/*------------------------------------------  TABLA RESULTADO KFUNCTRAMITECC------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------SE OBTIENE UN  SUBCONJUNTO DE TRAMITE QUE SON SOLO DE CC-----------------------*/
/*--------------------------- Cruzando FUNCTRAMITE con TRAMITE cuya ClaseRenta es U  es decir CC ------------------*/
/*----- --------------------------------------------   Tabla Resultado =  KFunTramiteCC    --------------------------------------------*/

--drop table KFunTramiteCC		
select a.* into KFunTramiteCC from CRENTA..FUNC_TRAMITE  a										-- OBTIENE LA TABLA PIVOTE SOLO DE CC
		inner join CRENTA..TRAMITE b on  a.Matricula=b.Matricula and   a.Tramite=b.Tramite 
		where b.ClaseRenta='U' 

	
/*--------------------------------Verifica cantidad de tramites distintos  de la tabla KFunTramiteCC----------------------*/
/*-------------------------------------------- Cantidad de Tramites distintos = 214671  ------------------------------------------*/

PRINT ' EXTRAE DATOS DE FUNC TRAMITE SOLO LOS QUE SON DE CC' 
PRINT '-----------------------------------------------------------------------------------------'
DECLARE   @CAN  INT
SET @CAN= (  select COUNT(Tramite) from SENARITD..KFunTramiteCC ) 
PRINT 'LA CANTIDAD DE REGISTROS DE LA TABLA KFUNTRAMITECC ES :------>' + CAST(@CAN AS CHAR(10))
DECLARE   @CANT  INT
SET @CANT= (  select COUNT (DISTINCT Tramite) from KFunTramiteCC ) 
PRINT 'LA CANTIDAD DE REGISTROS UNICOS DE LA TABLA KFUNTRAMITECC ES :------>' + CAST(@CANT AS CHAR(10)) 

/*---------------
   ---------------
  ---------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------      2. PARTE .-  PROCEDIMIENTO PARA INDENTIFICAR GRUPOS O INCONSISTENCIAS----------------*/
/*------------------------------      - PRIMERO REALIZA UN ANALISIS EN CANTIDADES +----------------------------------------*/
/*------------------------------        DE LOS ESTADOS DE LOS TRAMITES PP PX ETC  --------------------------------------------*/
/*------------------------------      - CREA UNA TRABLA DE PIVOTE PARA LO TRAMITES QUE TERMINARON ------------*/
/*------------------------------      - CREA UNA TRABLA DE PIVOTE PARA LO TRAMITES QUE NO TERMINARON -------*/

/*---------- TODOS LOS TRAMITES QUE  TIENEN ESTADOS EN  Sta='C'  OR StaRec='A'    ------------------------------numero de casos  =  548 regist5ro  ---*/
DECLARE   @CANT3  INT
SET @CANT3= (select  COUNT (Tramite)
from  KFunTramiteCC 
where   Sta='C'  or StaRec='A')
PRINT 'TRAMITES DONDE  LOS ESTADOS   STA = C  Y  STAREC = A..   SON ---->' + CAST(@CANT3 AS CHAR(10))

/*---------- TODOS LOS TRAMITES QUE  TIENEN ESTADOS EN    Sta='P'  and StaRec='N'  -------------------------    numero de casos  =  0 registro  ---*/
DECLARE   @CANT4  INT
SET @CANT4= (select  COUNT (Tramite)
from  KFunTramiteCC 
where   Sta='P'  AND StaRec='N')
PRINT 'TRAMITES DONDE  LOS ESTADOS   STA = P  Y  STAREC = N..   SON ---->' + CAST(@CANT4 AS CHAR(10))

/*-------- TODOS LOS TRAMITES QUE  TIENEN ESTADOS EN Sta='P'  and StaRec='X'  ----------------------    numero de casos  =  1158 regist5ro  pero  1178 tramites----*/
DECLARE   @CANT5  INT
SET @CANT5= (select  COUNT (Tramite)
from  KFunTramiteCC 
where   Sta='P'  AND StaRec='X')
PRINT 'TRAMITES DONDE  LOS ESTADOS   STA = P  Y  STAREC = X..   SON ---->' + CAST(@CANT5 AS CHAR(10))

/*---------TODOS LOS TRAMITES QUE  TIENEN ESTADOS EN Sta='X'  and StaRec='P'  ----------------------- numero de casos  =  85 regist5ro  pero  85 tramites----*/
DECLARE   @CANT6  INT
SET @CANT6= (select  COUNT (Tramite)
from  KFunTramiteCC 
where   Sta='X'  AND StaRec='P')
PRINT 'TRAMITES DONDE  LOS ESTADOS   STA = X  Y  STAREC = P..   SON ---->' + CAST(@CANT6 AS CHAR(10))

/*------------ TODOS LOS TRAMITES QUE  TIENEN ESTADOS EN   Sta='R'  OR StaRec='N'  ----------------------   numero de casos  =  7652 regist5ro  pero  7556 tramites------*/
DECLARE   @CANT7  INT
SET @CANT7= (select  COUNT (Tramite)
from  KFunTramiteCC 
where    Sta='R'  and StaRec='N')

PRINT 'TRAMITES DONDE  LOS ESTADOS   STA =R  Y  STAREC = N..   SON ---->' + CAST(@CANT7 AS CHAR(10))

/* -----------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------- ANALISIS DE TRAMITES POR SUS ESTADOS Y ARMAR LA TABLA PIVOTE----------*/
/*-----------------------------------------------------------------------------------------------------------------------------------*/
 --TRAMITES QUE TUVIERON ALGUN ERROR PERO SIGUE SU CURSO HASTA CONCLUIR CON UN ESTADO P Y P Y FECHA SALIDA NULL
/*copiar en el otro */

Select COUNT(Tramite) , Tramite  from dbo.KFunTramiteCC 
 where FechaSalida is NULL and Sta='P' and StaRec='P'  group by Tramite  order by COUNT(Tramite)  desc
/*
12142
14310
15304
15932
16006
16116
17351
17581
18462
19611
20487
26729
27079
27173
27176
27179
27183
27669
28290
28297
29829
29869
29873
30433
30975
31023
31025
31035
33628
33836

*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------  CREA LA TABLA PIVOTE CON DATOS DE LOS TRAMITES CON DIFERENTES ESTADOS --------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* CREANDO una tabla  pivote */

--DROP TABLE #TramitePPUnicos

IF OBJECT_ID('tempdb..#TramitePPUnicos') IS NULL 
		select Tramite,  MAX(Fecha_Ingreso) fechaIngr into #TramitePPUnicos from  KFunTramiteCC 
		 where FechaSalida is NULL and Sta='P' and StaRec='P' group by Tramite order by  Tramite
		 
--SELECT * FROM #TramitePPUnicos
/* -------------------  CREA TABLA DE INCOSISTENCIAS -----------------------*/
-- DROP TABLE M_TRAMITES_ESTADOIN 
CREATE TABLE  [dbo].M_TRAMITES_ESTADOIN(
	[Tramite] [nvarchar](10) NOT NULL,
	[Matricula] [nvarchar](10) NOT NULL,
	[Sta] [char] (1) NULL,
	[StaRec] [char] (1) NULL,
	[Obs][varchar](10) NULL,
	[Funcionario][nvarchar](20)
	) ON [PRIMARY]
	
	/*-----   LLENA LA TABLA  CON DATOS DE LOS TRAMITES QUE CONCLUYERON  ------------ */
	/*------------------------------------Sta is  P OR StaRec is P   'terminado'------------------------------------*/
	/*------------------------------      212051   --------------------------------------------------------------------------*/
	
INSERT INTO dbo.M_TRAMITES_ESTADOIN
(Tramite,Matricula,Sta,StaRec,Obs,Funcionario)
Select a.Tramite,a.Matricula,a.Sta,a.StaRec,'Terminado', a.Funcionario
 from dbo.KFunTramiteCC a inner join #TramitePPUnicos b on a.Tramite=b.Tramite and a.Fecha_Ingreso=b.fechaIngr
where FechaSalida is NULL and Sta='P' and StaRec='P' order by  ctrlfecha

	/* MODIFICA LA TABLA  -*/
ALTER table		dbo.M_TRAMITES_ESTADOIN 
			add			
							TramiteTramP		int ,
							titular				nvarchar(100),
							TipoTram		nvarchar(20),
							Rol					int,
							Usuario			int,
							fechareg			datetime,
							fechaini			datetime,
							Rolinicio				int,
							Usuarioini		int,
							Est					char(1),
							Nua					varchar(20),
							Identificador	varchar(20),
							flag					int ,
							Oficina			int,
							AutoManual	int
							
--  select * from dbo.M_TRAMITES_ESTADOIN where flag=1
/* select * FROM  dbo.KFunTramiteCC   where Tramite in ('17581','31035','29873','20487','27183','14310','15304','19611','30975','30433','33681','29869','27079','12142','17351','16116','16006','31025','33836',
																								'29829','28297','26729','18462','199791','27176','27179','28290','27669','33628','31023','27173') order by Tramite,  ctrlfecha
 select * FROM  dbo.KFunTramiteCC   where Tramite ='29869'  order by Tramite,  ctrlfecha
 select * FROM  dbo.M_TRAMITES_ESTADOIN   where Tramite ='29869'  order by Tramite,  ctrlfecha 580208ALD
 select * FROM  dbo.KFunTramiteCC   where Tramite ='199791'  order by Tramite,  ctrlfecha
 select * FROM  dbo.M_TRAMITES_ESTADOIN   where Tramite ='199791'  order by Tramite,  ctrlfecha 580208ALD
*/

																								
	/*ACTUALIZA LA TABLA PARA SABER LO REGISTROS QUE TIENEN DOBLE NULL Y ESTADO PP*/
	/*
455825LZL	455825LSL	12142
655225VSM	625225VSM	14310
405322GRN	405322GRF	15304
650426JCM	650426JCH	16006
530512BCJ	531205BCJ	16116
500119CQG	500119COG	17351
491227CCJ	491227CHJ	17581
625820AGB	625820AGC	18462
420830SQL	420830AQL	19611
740929SCM	740922SCM	20487
705929RSD	700929RSD	26729
585215RCF	580215RCF	27079
451002SCA	541002SCA	27173
376109ABA	371109ABA	27176
616221MLK	611221MLK	27179
656010CSR	651010CSR	27183
525728SCO	520728SCO	27669
470207CRR	472007CRR	28290
460421TDH	640421TDH	28297
331023PLG	311023PLG	29829
585208ALD	580208ALD	29869****
565728EPL	560728ELP	29873
571123AYJ		576123AYJ		30433
676209QAL	671209QAL	30975
510612EMA	500612EMA	31023
440927TVG	440927TBG	31025
611222GAI		611222GAL	31035
335821BMS	335829BMS	33628
596221CMB	591221CMB	33681
596221CMB	351015ESE		33681
526224BCG	521224BCG	33836
251001CMJ	251001CMJ	199791
*/	
	/*  SON TRAMITE QUE TIENE UN DOBLE FINAL  TRAMITES QUE TIENE DOBLE MATRICULA CON ERRORES*/
	/* copiar en el otor*/
	
	UPDATE 	dbo.M_TRAMITES_ESTADOIN 
	SET  flag=1
	 FROM dbo.M_TRAMITES_ESTADOIN   
	 where Tramite in ('12142','14310','15304','15932','16006','16116','17351','17581',
		 '18462','19611','20487','26729', '27079','27173','27176','27179',
		 '27183','27669','28290','28297','29829','29869','29873',
		 '30433','30975','31023','31025','31035','33628','33836') 
															
																								
	/*ACTUALIZA LA TABLA PARA SABER LO REGISTROS QUE TIENEN DOBLE NULL Y ESTADO PP*/
	/*  SON TRAMITE QUE TIENE UN DOBLE FINAL  TRAMITES QUE TIENE DOBLE MATRICULA CON ERRORES */
	/* CASO PONERLE UN FLAG 2 QUE INDICARA QUE HAY QUE PONERLE UNA FECHA */
	--UPDATE 	dbo.M_TRAMITES_ESTADOIN 
	--SET  flag=2
	--FROM dbo.M_TRAMITES_ESTADOIN   where Tramite = '199791'			
	/***/
	--update dbo.M_TRAMITES_ESTADOIN
	--SET Matricula='585208ALD'
	-- FROM M_TRAMITES_ESTADOIN   where Tramite = '29869'

	--select 	Tramite, Matricula, flag from	dbo.M_TRAMITES_ESTADOIN  	where Tramite in ('17581','31035','29873','20487','27183','14310','15304','19611','30975','30433','33681','29869','27079','12142','17351','16116','16006','31025','33836',
	--																							'29829','28297','26729','18462','199791','27176','27179','28290','27669','33628','31023','27173') 

	/*-----   LLENA LA TABLA  CON DATOS DE LOS TRAMITES QUE CONCLUYERON  ------------ */
	/*------------------------------------Sta is  NULL OR StaRec is NULL  ----------------------------------------*/
	/*---------------------------------------------	  numero de casos  =  3			------------------------------------*/
	
DECLARE   @CANTI  INT
SET @CANTI= (select  COUNT (Tramite)
from  KFunTramiteCC 
where  Sta is  NULL or StaRec is NULL)

PRINT 'TRAMITES DONDE  LOS ESTADOS   STA =NULL Y  STAREC=NULL..   SON ---->' + CAST(@CANTI AS CHAR(10))

INSERT INTO dbo.M_TRAMITES_ESTADOIN
(Tramite,Matricula,Sta,StaRec,Obs,Funcionario)
select   DISTINCT (A.Tramite),A.Matricula,NULL,NULL,'Nulos',A.Funcionario
from  KFunTramiteCC A 
where  (A.Sta is  NULL or A.StaRec is NULL) and
A.Tramite not in(select Tramite
from  dbo.M_TRAMITES_ESTADOIN )

	/*-----   LLENA LA TABLA  CON DATOS DE LOS TRAMITES QUE----------------------------- */
	/*------------------------------------Sta is  ' '  OR StaRec is ' '    -----------------------------------------*/
	/*------------------------------------	  numero de casos  =  35			------------------------------------*/
	
DECLARE   @CANT2  INT
SET @CANT2= (select  COUNT (Tramite)
from  KFunTramiteCC 
where   Sta=' ' OR StaRec=' ')

PRINT 'TRAMITES DONDE  LOS ESTADOS   STA =VACIO  Y  STAREC =VACIO..   SON ---->' + CAST(@CANT2 AS CHAR(10))

INSERT INTO dbo.M_TRAMITES_ESTADOIN
(Tramite,Matricula,Sta,StaRec,Obs,Funcionario)
select   DISTINCT A.Tramite,A.Matricula,'','','Vacios',10
from  KFunTramiteCC A
where  (A.Sta=' ' or A.StaRec=' ') and
A.Tramite not in(select Tramite
from  dbo.M_TRAMITES_ESTADOIN )


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------  CREA LA TABLA PIVOTE CON DATOS DE LOS TRAMITES CON ESTADOS  P  P                --------------------*/
/*---------------------TRAMITES  que no estan concluidos (P P) ES DECIR TODAVIA ESTAN EN CURSO-------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

--drop table #TramiteCurso

PRINT 'COLOCAR TRAMITES QUE ESTAN EN CURSO' 
PRINT 'TEMPORAL:'
select Tramite, MAX(ctrlfecha)Fecha into #TramiteCurso from KFunTramiteCC 
 where  Tramite not in(select Tramite from dbo.M_TRAMITES_ESTADOIN) group by Tramite

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* DE ACUERDO A CONVERSACION CON EDDY VERA LOS ESTADOS QUE TIENES ESTADO PX O XP ESTARNA COMO PP*/

PRINT 'COLOCAR TRAMITES QUE ESTAN EN ESTADO PX O XP' 

INSERT INTO dbo.M_TRAMITES_ESTADOIN
(Tramite,Matricula,Sta,StaRec, Obs,Funcionario)
select a.Tramite, a.Matricula, a.Sta, a.StaRec,'TerminadoP',Funcionario from KFunTramiteCC a 
inner join #TramiteCurso b on a.Tramite=b.Tramite and a.ctrlfecha=b.Fecha
where (a.Sta='P' and a.StaRec='X') or (a.Sta='X' and a.StaRec='P')

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  */
/* DE ACUERDO A CONVERSACION CON EDDY VERA LOS ESTADOS DIFERENTE A  PX O XP   SON TRAMITES EN CURSO */

PRINT ' INSERTAR TRAMITES QUE ESTAN EN CURSO ' 

INSERT INTO dbo.M_TRAMITES_ESTADOIN
(Tramite,Matricula,Sta,StaRec, Obs,Funcionario)
select a.Tramite, a.Matricula, a.Sta, a.StaRec,'En Curso',Funcionario from KFunTramiteCC a 
inner join #TramiteCurso b on a.Tramite=b.Tramite and a.ctrlfecha=b.Fecha
where (a.Sta!='P' OR a.Sta!='X') AND (a.StaRec!='X' and a.StaRec!='P')

/*---------------
   ---------------
  ---------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------      3. PARTE .-  PROCEDIMIENTO PARA LLENAR LAS DEMAS COLUMNAS CON DATOS------------- --*/
/* -------------------					 PARA CADA  TRAMITE COMPLETAR NUA , IDENTIFICADOR ------------------------------ --*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/ 

/*-----------------     DE TRAMITES QUE ESTAN EN CURSO DE PAGO 'CC_CPAGO' ------------------------------------------*/ 

/*-------- 2 grupo.--	Llenando  TipoTram, Nua e Identificador de  otras tablas   -------------------------------*/
/*									PAGO_CC..TITULAR_CC y  PAGO_CC..TITULAR_CCFA  ---------------------------------*/
/*									CC..CERTIFICADO     Y   CC..CALCULO_CC   ------------------------------------------------*/
/*									CC..MARCA				Y		CC. MEDIOSMAG   ------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------*/
		/* crea una  temporal #TramPago  184560 */
		--	drop table  #TramCCPago
		--	select a.Matricula, a.Tramite, a.tipo_cc,b.no_certif
		--	into #TramCCPago
		--	from CC..CERTIFICADO b inner join CC..CALCULO_CC a
		--	on a.Matricula=b.Matricula and a.Tramite=b.Tramite and a.componente=b.componente 
				    
		--	/*crea temporal con  la tabla con PAGO_CC..TITULAR_CC   dbo.eliminaCerosIzqui*/
		--	drop table #TramCCPago1
		--	select  a.num_ide,a.nua, b.Tramite
		--	into #TramCCPago1
		--	from PAGO_CC..TITULAR_CC a inner join #TramCCPago b
		--	on a.no_certi=b.no_certif  and a.tipo_cc=b.tipo_cc
			
		--	/* inserta lo registros de  PAGO_CC..TITULAR_CC*/
			
		--	insert into #TramCCPago1 
		--	select  a.num_ide,a.nua, b.Tramite
		--	from PAGO_CC..TITULAR_CCFA a inner join #TramCCPago b
		--	on a.no_certi=b.no_certif  and a.tipo_cc=b.tipo_cc
			
		--/* cruzando con MARCA CC y MEDIOS_MAG */
	 --    	DROP table #CRUCE
		--	select a.Matricula, a.Tramite, a.tipo_cc,a.no_certif, c.NUA,CC.dbo.sp_numeral_ci(c.Num_Id) Num_Id into #CRUCE
			
		--	from #TramCCPago a 
		--	inner join CC..MARCA_CC b
		--	on a.Matricula=b.Matricula and a.Tramite=b.Tramite 
		--	inner join CC..MEDIOS_MAG c
		--	on  a.Tramite=c.Tramite 
		--	inner join  #TramCCPago1 d
		--	on a.Tramite=d.Tramite 
	
	/* primero optener vista de un cruce de 		M_TRAMITES_ESTADOIN   y la vista de PAGO_CC.vw_CursoPagoCC*/
	
	--SELECT * FROM M_TRAMITES_ESTADOIN
	--SELECT * FROM PAGO_CC.dbo.vw_CursoPagoCC
			
			--  DROP table #CRUCEPAGO
			
			select a.* into #CRUCEPAGO
			from  M_TRAMITES_ESTADOIN b inner join PAGO_CC.dbo.vw_CursoPagoCC a
			on b.Tramite=a.Tramite and b.Matricula=a.Matricula
			
			--select * from #CRUCEPAGO
			
	/*  actualizando la tabla M_TRAMITES_ESTADOIN  con el cruzado de #TramCCPago1 */
			
				UPDATE  dbo.M_TRAMITES_ESTADOIN												 -- Curso de pago CC_CPAGO
				 SET TipoTram				='CC_CPAGO',
			  			 Nua						= dbo.eliminaCerosIzquiWF(a.NUA),
						 Identificador			= dbo.eliminaCerosIzquiWF(a.Num_Id)
				-- select a.*
				from  M_TRAMITES_ESTADOIN b inner join #CRUCEPAGO a
				on b.Tramite=a.Tramite and b.Matricula=a.Matricula
								
				select distinct b.Tramite
				from  M_TRAMITES_ESTADOIN b inner join #CRUCEPAGO a
				on b.Tramite=a.Tramite and b.Matricula=a.Matricula
				
			
 /*-----------------     DE TRAMITES QUE ESTAN EN CURSO DE ADQUISICION  'CC_CADQ' ---------------------------*/

--select top 1 * from Tramite.TramitePersona
--select top 1 * from PIVOTE..migratitularoficial
--select top 1 * from dbo.M_TRAMITES_ESTADOIN		
--select top 1 * from CRENTA..TRAMITE
--select top 1.* from CRENTA..PERSONA

/* creando una temporal de datos CRUCEADQ  */ --216909

--drop  table #CRUCEADQ

SELECT b.Matricula,b.Tramite,b.Fecha_IngresoT,dbo.eliminaCerosIzquiWF(RTRIM(LTRIM(b.nua)) ) NUA
into  #CRUCEADQ
 FROM dbo.M_TRAMITES_ESTADOIN a INNER JOIN  CRENTA..TRAMITE b
ON a.Tramite=b.Tramite and a.Matricula=b.Matricula 
where a.TipoTram is NULL
--select * from CRENTA..TRAMITE where Tramite='115986'
--select * from #CRUCEADQ where NUA  like '%S%'
	
	/* actualizando CC_ADQ, NUA, FechaIngresoT y una FLag para saber que nua son vacios o ceros o cuales con R en el NUA*/

	 UPDATE  dbo.M_TRAMITES_ESTADOIN											
		  SET TipoTram				='CC_CADQ',
			  	  Nua						= b.NUA,
			  	  fechaini				= b.Fecha_IngresoT,
			  	  flag					= CASE 
																WHEN b.NUA	 =''					THEN 3
																WHEN b.NUA  like '%R%'		THEN 4
												END 
	--		SELECT b.* 
			FROM dbo.M_TRAMITES_ESTADOIN 	a INNER JOIN  #CRUCEADQ b
			ON a.Tramite=b.Tramite and a.Matricula=b.Matricula where a.TipoTram is NULL
	
/* actualizando los CI */

	--print CC.dbo.sp_numeral_ci('1748524 PAND')
	
		  UPDATE  dbo.M_TRAMITES_ESTADOIN											
		  SET Identificador				=CC.dbo.sp_numeral_ci(dbo.eliminaCerosIzquiWF(b.CI))
			--		SELECT b.* 
			FROM dbo.M_TRAMITES_ESTADOIN	 a INNER JOIN  CRENTA..PERSONA b
			ON  a.Matricula=b.Matricula where a.TipoTram ='CC_CADQ'
	
/* caso especial donde hay un CI  con NULL*/
       --select * from dbo.M_TRAMITES_ESTADOIN	 where Identificador is not NULL
       --select * from  KFunTramiteCC where Tramite='103601' --Matricula='401222OMJ' 
       --select * from CRENTA..TRAMITE where Matricula='401222OMJ'
       --select * from CRENTA..PERSONA where Matricula='401222OMJ'
       --select top 1 * From Tramite.TramitePersona  WHERE NumeroTramiteCrenta='103601'
       
         UPDATE  dbo.M_TRAMITES_ESTADOIN							--- tramite que no se migra				
		  SET flag	= 5
			--		SELECT * 
			from dbo.M_TRAMITES_ESTADOIN	 where Identificador is NULL and  TipoTram ='CC_CADQ'

/*-----------------------CANTIDAD DE DATOS LLENADOS --------------------------------*/
DECLARE	 @num			int
			SET	 @num=(SELECT COUNT(Tramite) FROM dbo.M_TRAMITES_ESTADOIN)
		PRINT  'NUMERO DE TRAMITES ---->' + CAST(@num AS CHAR(10))

DECLARE	 @num1			int
			SET	 @num1=(SELECT COUNT(Tramite) FROM dbo.M_TRAMITES_ESTADOIN where Nua  is not NULL)
		PRINT  'NUMERO DE TRAMITES CON NUA---->' + CAST(@num1 AS CHAR(10))
		
DECLARE	 @num2			int
			SET	 @num2=(SELECT COUNT(Tramite) FROM dbo.M_TRAMITES_ESTADOIN where Nua  is  NULL)
		PRINT  'NUMERO DE TRAMITES SIN NUA---->' + CAST(@num2 AS CHAR(10))
	
--- SELECT *  FROM dbo.M_TRAMITES_ESTADOIN			where TipoTram is NULL

/*---------------
   ---------------
  ---------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------      4. PARTE .-  PROCEDIMIENTO PARA LLENAR LAS DEMAS COLUMNAS CON DATOS------------- --*/
/* ----------------------------------					 PARA CADA  TITULAR , FECHAINICIO, ETC -----------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/ 

/*---------------------------------------------------------------------------------------------*/
/*--	LLENANDO LOS TITULARES DE LOS TRAMITES------------------------*/
/*---------------------------------------------------------------------------------------------*/

UPDATE 	dbo.M_TRAMITES_ESTADOIN	
		SET		titular=b.PrimerNombre+' '+ b.SegundoNombre+' '+b.PrimerApellido+' '+b.SegundoApellido
		--select a.*, b.NumeroDocumento,b.CUA, b.PrimerNombre,b.SegundoNombre,b.PrimerApellido,b.SegundoApellido
		FROM dbo.M_TRAMITES_ESTADOIN a inner join Persona.Persona b 
		On dbo.eliminaCerosIzquiWF(RTRIM(LTRIM(a.Identificador)) )=b.NumeroDocumento  and  a.Nua=  convert(varchar(20), b.CUA)


UPDATE 	dbo.M_TRAMITES_ESTADOIN							/*cORREGIR TARDA DEMASIADO  5:28*/
		SET		titular=b.Nombres+' '+ b.[Apellido Paterno]+' '+b.[Apellido Materno]
	--	select a.Tramite, a.Identificador,a.Matricula, b.*
		FROM dbo.M_TRAMITES_ESTADOIN a inner join CRENTA..PERSONA b 
		On  dbo.eliminaCerosIzquiWF(RTRIM(LTRIM(a.Identificador)) )= CC.dbo.sp_numeral_ci(RTRIM(LTRIM(  b.CI  )))
		where 	Len(a.Identificador) >0 and a.Identificador !='0' and a.titular is null
		
--		select * from M_TRAMITES_ESTADOIN  where flag in(3,4)=6  Tramite='115986'
--select * from CRENTA..TRAMITE where Tramite='115986'
--select * from CRENTA..PERSONA where Matricula='370509MQJ'
			

--select * from 	dbo.M_TRAMITES_ESTADOIN where  titular is null order by Identificador
--select top 1* from CRENTA..PERSONA
--select * from 	dbo.M_TRAMITES_ESTADOIN  order by  Identificador
--select * from CRENTA..PERSONA where CI='10788'
--select * from 	dbo.M_TRAMITES_ESTADOIN  where Identificador='10788'
--select top 1 * from  Persona.Persona where NumeroDocumento='10788'

 
/*---------------------------------------------------------------------------------------------*/
/* ---  PARA CADA  TRAMITE COMPLETAR  FECHAS INICIO----------------*/
/*--------------------------------------------------------------------------------------------*/
		/* creando temporales*/
		-- DROP TABLE #FechaReg
		Select  a.Tramite, a.Matricula, b.Fecha_IngresoT FechaReg into #FechaReg  --- actualiza fecha de creacion de tramites
		 from M_TRAMITES_ESTADOIN a inner join  CRENTA..TRAMITE  b
		on a.Tramite=b.Tramite and a.Matricula=b.Matricula

	--	DROP TABLE #fechasminima
		SELECT Tramite,  MIN(Fecha_Ingreso) FechaIngreso  into #fechasminima
		 FROM KFunTramiteCC GROUP BY Tramite   --216909

		-- DROP TABLE #FechaIni
		Select  a.Tramite, a.Matricula, c.FechaIngreso FechaIni   into #FechaIni --- actualiza fecha de inicio de tramites
		 from M_TRAMITES_ESTADOIN a inner join #fechasminima c 
		on a.Tramite=c.Tramite 

/* actualizando la tabla con fechas de Registro*/

		UPDATE  dbo.M_TRAMITES_ESTADOIN												
		  SET fechareg		=		b.FechaReg --,
		--	  	  fechaini		=		c.FechaIni
		  --  select a.Tramite , a.Matricula, b.FechaReg
			FROM  dbo.M_TRAMITES_ESTADOIN  a  inner join #FechaReg b 
			on a.Tramite=b.Tramite  and a.Matricula=b.Matricula 
			
/* actualizando la tabla con fechas de Inicio*/		
		UPDATE  dbo.M_TRAMITES_ESTADOIN												
		  SET	  	  fechaini		=		c.FechaIni
			--Select a.Tramite , a.Matricula,  c.FechaIni
			FROM  dbo.M_TRAMITES_ESTADOIN  a 	inner join #FechaIni c 
			on a.Tramite=c.Tramite and a.Matricula=c.Matricula
			

/*--------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------REALIZANDO LO DEL FUNCIONARIO-----------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
-- drop table #TramiteFechaInicio

--select Tramite,   MIN(ctrlfecha) fechacontrol into #TramiteFechaInicio
--				from  KFunTramiteCC 
--				 group by Tramite , Matricula,Fecha_Ingreso order by Tramite
				 
--select * from KFunTramiteCC where Tramite in ('124457','71705','40433','35932','78334') order by Tramite,Fecha_Ingreso

 -- select distinct(Tramite) from  #TramiteFuncionario
--  select * from  #TramiteFechaInicio

/*----------------------------------------------------------------*/
/*  ACTUALIZANDO LA TABLA FUNCIONARIOS */
/*---------------------------------------------------------------*/
----select a.Tramite,a.Matricula, a.Fecha_Ingreso,a.ctrlfecha, b.Tramite,b.fechacontrol   from KFunTramiteCC  a inner join #TramiteFechaInicio b
----on a.Tramite=b.Tramite and a.ctrlfecha=b.fechacontrol

----select * from KFunTramiteCC where Tramite='214414' order by ctrlfecha
----select * from CRENTA..TRAMITE where Tramite='214414'
----select a.Tramite,a.Matricula,a.fechareg, b.IdUsuarioRegistro,c.IdUsuario,d.IdRol,d.FechaVigencia,d.FechaExpiracion  from M_TRAMITES_ESTADOIN a inner join Tramite.TramitePersona b
----on a.Tramite=b.NumeroTramiteCrenta inner Join Seguridad.Usuario c
----on b.IdUsuarioRegistro=c.IdUsuario inner Join Seguridad.RolUsuario  d
----on c.IdUsuario=d.IdUsuario 
----  where a.Tramite='214414' 
    
----select * from Seguridad.Usuario where IdUsuario in ('9967','10270','10203','10113','10203')
----select * from Seguridad.RolUsuario where IdUsuario in ('9967','10270','10203','10113','10203') order by IdUsuario
----select * from Seguridad.Rol where IdRol in (9,177)

----select * from Clasificador.DetalleClasificador where IdTipoClasificador=74
----select * from Clasificador.DetalleClasificador where IdDetalleClasificador=616
  
/*----------------------------------------------------------------------------------*/
/*Actualizando tramites n migrados en Tramite.Tramite Persona  */
/*----------------------------------------------------------------------------------*/
    
         UPDATE  dbo.M_TRAMITES_ESTADOIN							--- tramite que no se migraron Tramite.TramitePErsona	
		  SET flag	= 6
	--	 select * from  dbo.M_TRAMITES_ESTADOIN	
	       where Tramite not in (	select NumeroTramiteCrenta  from Tramite.TramitePersona ) 
	     --  order by Tramite


----select a.Tramite,a.Matricula,a.fechareg, b.IdUsuarioRegistro
----  from M_TRAMITES_ESTADOIN a inner join Tramite.TramitePersona b
----  on a.Tramite=b.NumeroTramiteCrenta
  

			UPDATE  dbo.M_TRAMITES_ESTADOIN												
			SET Usuario				=		 b.IdUsuarioRegistro,
				  Usuarioini		=		 b.IdUsuarioRegistro
		 			-- select a.Tramite,a.Matricula, b.IdUsuarioRegistro
				  from M_TRAMITES_ESTADOIN a inner join Tramite.TramitePersona b
				  on a.Tramite=b.NumeroTramiteCrenta
				
/*--------------------------------------------------------------------------------------------------------------------------*/
/*											ACTUALIZA ROLES																						*/
/*----------------------------- REALIZANDO La OFICINAS de REGISTRO-----------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------*/
				
UPDATE  dbo.M_TRAMITES_ESTADOIN												
		SET		Rol				=	177,
					Rolinicio		=	177,
					Oficina		=	b.IdOficinaRegistro
		  --		SELECT 177,177,b.IdOficinaRegistro
		  FROM dbo.M_TRAMITES_ESTADOIN a 
						INNER JOIN   Tramite.TramitePersona  b
						ON a.Tramite=NumeroTramiteCrenta
						
						
--SELECT * FROM M_TRAMITES_ESTADOIN WHERE flag =2

--select * from KFunTramiteCC where Tramite='29869'
--select * from M_TRAMITES_ESTADOIN where Tramite='29869'

/****************************/

--Update  dbo.FuncionarioCompl
--	set  
--	IdUsuario=a.IdUsuario 							
--	-- Select b.IdUsuario, a.*
--	 from Seguridad.Usuario a inner join dbo.FuncionarioCompl b
--	on a.Carnet=b.Carnet

/*--------------------------------------------------------------------------------------------------------------------------*/
/*											ACTUALIZA NUMERO																						*/
/*-----------------------------DE Tramites homologado con Tramite Persona-----------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------*/

     UPDATE dbo.M_TRAMITES_ESTADOIN 
		  SET 
		  TramiteTramP	= b.IdTramite
	--	select a.Tramite, b.IdTramite,b.NumeroTramiteCrenta
		from  dbo.M_TRAMITES_ESTADOIN a inner join Tramite.TramitePersona b
		on a.Tramite=b.NumeroTramiteCrenta  

/*--------------------------------------------------------------------------------------------------------------------------*/
/*											ACTUALIZA  SI AUTOMATICO MANUAL			         							*/
/*---------------------------------------------cruzando con Tramite Persona-----------------------------------*/
/*---------------------------------------------356 Manual    357  Automatico -----------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------*/
   UPDATE dbo.M_TRAMITES_ESTADOIN 
		  SET 
		  AutoManual	= b.IdTipoTramite
	--	select a.Tramite, b.IdTramite,b.NumeroTramiteCrenta,b.*
		from  dbo.M_TRAMITES_ESTADOIN a inner join Tramite.TramitePersona b
		on a.Tramite=b.NumeroTramiteCrenta  
		
		--select * from Clasificador.DetalleClasificador where IdTipoClasificador=19
		--select * from Clasificador.DetalleClasificador where IdDetalleClasificador='356'
/*-------------------------------------------------------------------------------------------------*/
/*				Tramites que no se deberian migrar por alguna inconsistencia	 	*/
/*-------------------------------------------------------------------------------------------------*/
-- drop table dbo.M_TRAMITE_INCONSISTENCIASWF
select Tramite,Matricula,flag into dbo.M_TRAMITE_INCONSISTENCIASWF
 from  dbo.M_TRAMITES_ESTADOIN WHERE  flag in(1,2,5,6) order by flag




END

--select * from dbo.M_TRAMITES_ESTADOIN WHERE  flag in(1,2,5,6) order by flag

