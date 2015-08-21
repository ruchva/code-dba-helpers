ALTER PROCEDURE dbo.MigraPagoUnico
AS
BEGIN
	INSERT INTO PagoU.CertificadoPMMPU
	SELECT 
		 pcpp.NUP --NUP
		,pcpp.IdTramite --IdTramite
		,pcpp.IdGrupoBeneficio --IdGrupoBeneficio
		,pcpp.no_certif --NumeroCertificado
		,pcpp.doc --Documento
		,pcpp.fecha_emi --FechaEmision
		,pcpp.monto --Monto
		,pcpp.IdBeneficio --IdBeneficio
		,pcpp.Tipo_PP --TipoPP
		,pcpp.EstadoM --Estado
		,NULL --HojaRuta
		,NULL --FechaHojaRuta
		,NULL --IdUsuarioHojaRuta
		,1 --Version
        ,1 --RegistroActivo    
        ,pcpp.tipo_cambio --TipoCambio    
	FROM dbo.Piv_CERTIF_PMM_PU pcpp
	WHERE pcpp.NUP IS NOT NULL 
	  AND pcpp.IdTramite IS NOT NULL
	  AND pcpp.EstadoM IS NOT NULL
	  AND pcpp.NUP NOT IN (SELECT cp.NUP FROM PagoU.CertificadoPMMPU cp)
	
	INSERT INTO PagoU.DocumentoComparativo
	SELECT 
		 pdc.IdTramite --IdTramite
		,pdc.IdGrupoBeneficio --IdGrupoBeneficio
		,pdc.COMPONENTE --Componente
		,pdc.NUP --NUP
		,pdc.MONTO_CC --MontoCC
		,pdc.MONTO_PMM --MontoPMM
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
		,pdc.MONTO_PU --MontoPU
		,pdc.SECTOR --IdSector***
		,pdc.PRIMERA_FEC_AFILIA --PrimeraFechaAfiliacion
		,pdc.ULTIMA_FEC_AFILIA --UultimaFechaAfiliacion
		,pdc.DENSIDAD --Densidad
		,pdc.SALARIO_COTIZABLE --SalarioCotizable
		,pdc.SALARIO_COTIZABLE_ACT --SalarioCotizableActual
		,pdc.FECHA_CALCULO --FechaCalculo
		,pdc.FECHA_EMISION --FechaEmision
		,pdc.TIPO_CAMBIO --TipoCambio
		,1 --Version
        ,1 --RegistroActivo     
	FROM dbo.Piv_DOC_COMPARATIVO pdc
	WHERE pdc.NUP IS NOT NULL 
	  AND pdc.IdTramite IS NOT NULL
	  AND pdc.IdGrupoBeneficio IS NOT NULL	  
	  AND pdc.EstadoM IS NOT NULL
	  AND pdc.NUP NOT IN (SELECT dc.NUP FROM PagoU.DocumentoComparativo dc)
	
	INSERT INTO PagoU.PreBeneficiarios --DELETE FROM PagoU.PreBeneficiarios
	SELECT 
		 ppb.NUP --NUPTitular
		,ppb.NUPDH --NUPDH
		,ppb.FORMULARIO --Formulario
		,ppb.IdTramite --IdTramite
		,ppb.IdGrupoBeneficio --IdGrupoBeneficio
		,ppb.ClaseBeneficio --ClaseBeneficio
		,ppb.PORCENTAJE --Porcentaje
		,ppb.RED_DH --RedDH
		,ppb.Parentesco --Parentesco
		,ppb.Estado --Estado
		,1 --Version
        ,1 --RegistroActivo
	FROM dbo.Piv_PreBeneficiarios ppb
	WHERE ppb.NUP IS NOT NULL 
	  AND ppb.IdTramite IS NOT NULL
	  AND ppb.IdGrupoBeneficio IS NOT NULL
	  AND ppb.NUP NOT IN (SELECT pb.NUPTitular FROM PagoU.PreBeneficiarios pb)
	
	INSERT INTO PagoU.PreTitulares
	SELECT 
		 ppt.NUP --NUP
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
		,1 --Version
        ,1 --RegistroActivo
	FROM dbo.Piv_PreTitulares ppt
	WHERE ppt.NUP IS NOT NULL 
	  AND ppt.IdTramite IS NOT NULL
	  AND ppt.IdGrupoBeneficio IS NOT NULL
	  AND ppt.IdBeneficio IS NOT NULL
	  AND ppt.NUP NOT IN (SELECT pt.NUP	FROM PagoU.PreTitulares pt)
	
	INSERT INTO PagoU.ChequePU
	SELECT 
		 pcp.EstadoM --Estado
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
	FROM dbo.Piv_ChequePU pcp
	WHERE pcp.NUPTitular IS NOT NULL 
	  AND pcp.EstadoM IS NOT NULL
	  AND pcp.NUPTitular NOT IN (SELECT cp.NUPTitular FROM PagoU.ChequePU cp)
	
	INSERT INTO PagoU.TitularPU
	SELECT 
		 ptp.NUP --NUP
		,ptp.IdTramite --IdTramite
		,ptp.IdGrupoBeneficio --IdGrupoBeneficio
		,ptp.NUM_CERTIF --NumeroCertificado
		,ptp.FORMULARIO --Formulario
		,ptp.ANIOS_INSALUBRES --AniosInsalubres
		,ptp.FECHA_ALTA --FechaAlta
		,ptp.RESOLUCION --Resolucion
		,ptp.Estado --Estado
	FROM dbo.Piv_TitularPU ptp
	WHERE ptp.NUP IS NOT NULL 
	  AND ptp.IdTramite IS NOT NULL
	  AND ptp.NUP NOT IN (SELECT tp.NUP FROM PagoU.TitularPU tp)
	
END