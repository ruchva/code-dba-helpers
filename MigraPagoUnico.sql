ALTER PROCEDURE [dbo].[MigraPagoUnico]
AS
BEGIN
	PRINT 'MIGRANDO EN TABLA PagoU.CertificadoPMMPU'	
	INSERT INTO PagoU.CertificadoPMMPU
	SELECT 
		 ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version' --Version
		,pcpp.NUP --NUP
		,pcpp.IdTramite --IdTramite
		,pcpp.IdGrupoBeneficio --IdGrupoBeneficio
		,pcpp.no_certif --NumeroCertificado
		,pcpp.doc --Documento
		,pcpp.fecha_emi --FechaEmision
        ,pcpp.tipo_cambio --TipoCambio    
		,pcpp.monto --Monto
		,pcpp.IdBeneficio --IdBeneficio
		,pcpp.Tipo_PP --TipoPP
		,NULL --HojaRuta
		,NULL --FechaHojaRuta
		,NULL --IdUsuarioHojaRuta
		,pcpp.EstadoM --Estado
        ,1 --RegistroActivo    
	FROM dbo.Piv_CERTIF_PMM_PU pcpp
	WHERE pcpp.NUP IS NOT NULL 
	  AND pcpp.IdTramite IS NOT NULL
	  AND pcpp.EstadoM IS NOT NULL
	  AND pcpp.NUP IN (SELECT NUP FROM Persona.Persona)
	  --and pcpp.Clase_Pago in ('PU','PMM')
	
	DECLARE @cCertificadoPMMPU INT 
	SELECT @cCertificadoPMMPU = COUNT(*) FROM PagoU.CertificadoPMMPU
	PRINT 'CANTIDAD DE REGISTROS:  '+ CAST(@cCertificadoPMMPU AS CHAR(5)) 
	PRINT '------------------------------------------------------'
	
	PRINT 'MIGRANDO EN TABLA PagoU.DocumentoComparativo'
	INSERT INTO PagoU.DocumentoComparativo
	SELECT 
		 ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version' --Version
		,pdc.IdTramite --IdTramite
		,pdc.IdGrupoBeneficio --IdGrupoBeneficio
		,pdc.COMPONENTE --Componente
		,pdc.NUP --NUP
		,pdc.IdSector --IdSector
		,pdc.PRIMERA_FEC_AFILIA --PrimeraFechaAfiliacion
        ,pdc.ULTIMA_FEC_AFILIA --UltimaFechaAfiliacion      
		,pdc.DENSIDAD --Densidad		
		,pdc.SALARIO_COTIZABLE --SalarioCotizable
		,pdc.SALARIO_COTIZABLE_ACT --SalarioCotizableActual
		,pdc.FECHA_CALCULO --FechaCalculo
		,pdc.FECHA_EMISION --FechaEmision
		,pdc.TIPO_CAMBIO --TipoCambio
		,pdc.MONTO_CC --MontoCC
		,pdc.MONTO_PMM --MontoPMM
		,pdc.MONTO_PU --MontoPU
		,pdc.APORTES_AFP --AportesAFP
		,pdc.NRO_DOCUMENTO --NumeroDocumento
		,pdc.IdBeneficio --IdBeneficio
		,pdc.FECHA_SELECCION --FechaSeleccion
		,pdc.SALUD --Salud
		,pdc.NRO_MESES --NumeroMeses
		,pdc.INTERIOR_MINA --InteriorMina
		,pdc.FECHA_PROCESO --FechaProceso
		,pdc.NRO_MINA --NumeroMina
		,pdc.TRAB_SIM --TrabajosSimultaneos
		,NULL --Descuento8porciento
		,pdc.EstadoM --Estado
        ,1 --RegistroActivo  
	FROM dbo.Piv_DOC_COMPARATIVO pdc
	WHERE pdc.NUP IS NOT NULL 
	  AND pdc.IdTramite IS NOT NULL
	  AND pdc.IdGrupoBeneficio IS NOT NULL	  
	  AND pdc.EstadoM IS NOT NULL
	  and pdc.NUP IN (SELECT NUP FROM Persona.Persona)	
	  and pdc.IdTramite in (select IdTramite from Tramite.TramitePersona)
	  --and pdc.SELEC in ('PU','PMM')
	
	DECLARE @cDocumentoComparativo INT 
	SELECT @cDocumentoComparativo = COUNT(*) FROM PagoU.DocumentoComparativo
	PRINT 'CANTIDAD DE REGISTROS:  '+ CAST(@cDocumentoComparativo AS CHAR(5)) 
	PRINT '------------------------------------------------------'	
	
	PRINT 'MIGRANDO EN TABLA PagoU.PreBeneficiarios'
	INSERT INTO PagoU.PreBeneficiarios --DELETE FROM PagoU.PreBeneficiarios
	SELECT 
		 ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version' --Version
		,ppb.NUP --NUPTitular
		,ppb.NUPDH --NUPDH ---***faltantes insertar en Persona.Persona
		,ppb.FORMULARIO --Formulario
		,ppb.IdTramite --IdTramite
		,ppb.IdGrupoBeneficio --IdGrupoBeneficio
		,ppb.ClaseBeneficio --ClaseBeneficio
		,ppb.PORCENTAJE --Porcentaje
		,ppb.RED_DH --RedDH
		,ppb.Parentesco --Parentesco
		,ppb.Estado --Estado
        ,NULL --Resolucion
        ,NULL --FechaResolucion
        ,1 --RegistroActivo
	FROM dbo.Piv_PreBeneficiarios ppb
	WHERE ppb.NUP IS NOT NULL 
	  AND ppb.IdTramite IS NOT NULL
	  AND ppb.IdGrupoBeneficio IS NOT NULL
	  and ppb.NUP in (select NUP from Persona.Persona)
	  and ppb.NUPDH in (select NUP from Persona.Persona)
	  and ppb.NUPDH not in (select NUPDH from PagoU.PreBeneficiarios)
	  
	DECLARE @cPreBeneficiarios INT 
	SELECT @cPreBeneficiarios = COUNT(*) FROM PagoU.PreBeneficiarios
	PRINT 'CANTIDAD DE REGISTROS:  '+ CAST(@cPreBeneficiarios AS CHAR(5)) 
	PRINT '------------------------------------------------------'	
	
	PRINT 'MIGRANDO EN TABLA PagoU.PreTitulares'
	INSERT INTO PagoU.PreTitulares
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version' --Version
		,ppt.NUP --NUP
		,ppt.FORMULARIO --Formulario
		,ppt.IdTramite --IdTramite
		,ppt.IdGrupoBeneficio --IdGrupoBeneficio
		,ppt.NUM_CERTIF --NumeroCertificado
		,ppt.IdBeneficio --IdBeneficio
		,ppt.ANIOS_INSALUBRES --AniosInsalubres
		,ppt.MONTO_BASE --MontoBase
		,ppt.REINTEGRO_DESDE --ReintegroDesde
		,ppt.REINTEGRO_HASTA --ReintegroHasta
		,ppt.REINTEGRO --Reintegro
		,ppt.AGUINALDO --Aguinaldo
		,ppt.RED_EDAD --RedEdad
		,ppt.MESES_CNS --MesesCNS
		,ppt.Estado --Estado
        ,NULL --Resolucion
        ,NULL --FechaResolucion
        ,1 --RegistroActivo
	FROM dbo.Piv_PreTitulares ppt
	WHERE ppt.NUP IS NOT NULL 
	  AND ppt.IdTramite IS NOT NULL
	  AND ppt.IdGrupoBeneficio IS NOT NULL
	  AND ppt.IdBeneficio IS NOT NULL
	  and ppt.NUP in (select NUP from Persona.Persona)
	
	DECLARE @cPreTitulares INT 
	SELECT @cPreTitulares = COUNT(*) FROM PagoU.PreTitulares
	PRINT 'CANTIDAD DE REGISTROS:  '+ CAST(@cPreTitulares AS CHAR(5)) 
	PRINT '------------------------------------------------------'
	
	PRINT 'MIGRANDO EN TABLA PagoU.ChequePU'
	INSERT INTO PagoU.ChequePU
	SELECT 
		 ROW_NUMBER() OVER(PARTITION BY NUPTitular ORDER BY T_MATRICULA ASC)'Version'
		,pcp.EstadoM --Estado
		,pcp.NUPTitular --NUPTitular
		,pcp.NUPDH --NUPDH
		,pcp.COD --Codigo
		,pcp.ANIO --Anio
		,pcp.MES --Mes
		,pcp.DEBE --Debe
		,pcp.HABER --Haber
		,pcp.NRO_CHEQUE --NumeroCheque
		,pcp.NRO_BAN --NumeroBanco
		,pcp.IdBanco --IdBanco
		,pcp.FECHA_EMI --FechaEmision
		,pcp.C31 --C31
		,NULL --Conciliado
		,1 --RegistroActivo
	FROM dbo.Piv_ChequePU pcp
	WHERE pcp.NUPTitular IS NOT NULL 
	  AND pcp.EstadoM IS NOT NULL
	  AND pcp.NUPTitular IN (SELECT NUP FROM Persona.Persona)
	
	DECLARE @cChequePU INT 
	SELECT @cChequePU = COUNT(*) FROM PagoU.ChequePU
	PRINT 'CANTIDAD DE REGISTROS:  '+ CAST(@cChequePU AS CHAR(5)) 
	PRINT '------------------------------------------------------'
	
	PRINT 'MIGRANDO EN TABLA PagoU.TitularPU'
	INSERT INTO PagoU.TitularPU
	SELECT 
		 ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
		,ptp.Estado --Estado
		,ptp.NUP --NUP
		,ptp.IdTramite --IdTramite
		,ptp.IdGrupoBeneficio --IdGrupoBeneficio
		,ptp.NUM_CERTIF --NumeroCertificado
		,ptp.FORMULARIO --Formulario
		,ptp.ANIOS_INSALUBRES --AniosInsalubres
		,ptp.FECHA_ALTA --FechaAlta
		,ptp.RESOLUCION --Resolucion
		,1 --RegistroActivo
	FROM dbo.Piv_TitularPU ptp
	WHERE ptp.NUP IS NOT NULL 
	  AND ptp.IdTramite IS NOT NULL
	  and ptp.NUP in (select NUP from Persona.Persona)
	
	DECLARE @cTitularPU INT 
	SELECT @cTitularPU = COUNT(*) FROM PagoU.TitularPU
	PRINT 'CANTIDAD DE REGISTROS:  '+ CAST(@cTitularPU AS CHAR(5)) 
	PRINT '------------------------------------------------------'
END

--select count(*) from PagoU.CertificadoPMMPU cp
--select count(*) from dbo.Piv_CERTIF_PMM_PU
--select count(*) from PagoU.DocumentoComparativo dc
--select count(*) from dbo.Piv_DOC_COMPARATIVO
--select count(*) from PagoU.PreBeneficiarios pb
--select count(*) from dbo.Piv_PreBeneficiarios
--select count(*) from PagoU.PreTitulares pt
--select count(*) from dbo.Piv_PreTitulares
--select count(*) from PagoU.TitularPU tp
--select count(*) from dbo.Piv_TitularPU
--select count(*) from PagoU.ChequePU cp
--select count(*) from dbo.Piv_ChequePU


