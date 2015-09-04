--CERTIFICADOPMMPU
--ORIGEN
SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif AS NumeroCertificado,a.doc AS Documento,a.fecha_emi AS FechaEmision,a.monto AS Monto,a.IdBeneficio,a.Tipo_PP AS TipoPP,a.EstadoM AS Estado
	  ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,a.tipo_cambio AS TipoCambio  
FROM Piv_CERTIF_PMM_PU a
WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
ORDER BY a.NUP
--DESTINO
SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.Version,b.TipoCambio
FROM PagoU.CertificadoPMMPU b
ORDER BY b.NUP
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif AS NumeroCertificado,a.doc AS Documento,a.fecha_emi AS FechaEmision,a.monto AS Monto,a.IdBeneficio,a.Tipo_PP AS TipoPP,a.EstadoM AS Estado
	          ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,a.tipo_cambio AS TipoCambio  
		FROM Piv_CERTIF_PMM_PU a
		WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL	AND a.EstadoM IS NOT NULL
		EXCEPT
		SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.Version,b.TipoCambio
		FROM PagoU.CertificadoPMMPU b	
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.Version,b.TipoCambio
		FROM PagoU.CertificadoPMMPU b		
		EXCEPT
		SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif AS NumeroCertificado,a.doc AS Documento,a.fecha_emi AS FechaEmision,a.monto AS Monto,a.IdBeneficio,a.Tipo_PP AS TipoPP,a.EstadoM AS Estado
	          ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,a.tipo_cambio AS TipoCambio  
		FROM Piv_CERTIF_PMM_PU a
		WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
	) AS DERECHA
-------------------------------------------------------------
--DOCUNENTOCOMPARATIVO
--ORIGEN
SELECT pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.COMPONENTE AS Componente, pdc.NUP, pdc.MONTO_CC AS MontoCC,pdc.MONTO_PMM AS MontoPMM,pdc.APORTES_AFP AS AportesAFP,pdc.NRO_DOCUMENTO AS NumeroDocumento,
pdc.IdBeneficio,pdc.FECHA_SELECCION AS FechaSeleccion,pdc.SALUD AS Salud,pdc.NRO_MESES AS NumeroMeses,pdc.INTERIOR_MINA AS InteriorMina,pdc.FECHA_PROCESO AS FechaProcesos,pdc.NRO_MINA AS NumeroMina,
pdc.TRAB_SIM AS TrabajosSimultaneos, NULL AS Descuento8porciento,pdc.ESTADO AS Estado,pdc.MONTO_PU AS MontoPU,pdc.IdSector,pdc.PRIMERA_FEC_AFILIA AS PrimeraFechaAfiliacion,pdc.DENSIDAD AS Densidad,
pdc.SALARIO_COTIZABLE AS SalarioCotizable,pdc.SALARIO_COTIZABLE_ACT AS SalarioCotizableActual,pdc.FECHA_CALCULO AS FechaCalculo,pdc.FECHA_EMISION AS FechaEmision,pdc.TIPO_CAMBIO AS TipoCambio,
ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,pdc.ULTIMA_FEC_AFILIA AS UltimaFechaAfiliacion 
FROM Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.DocumentoComparativo dc
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.COMPONENTE AS Componente, pdc.NUP, pdc.MONTO_CC AS MontoCC,pdc.MONTO_PMM AS MontoPMM,pdc.APORTES_AFP AS AportesAFP,pdc.NRO_DOCUMENTO AS NumeroDocumento,
		pdc.IdBeneficio,pdc.FECHA_SELECCION AS FechaSeleccion,pdc.SALUD AS Salud,pdc.NRO_MESES AS NumeroMeses,pdc.INTERIOR_MINA AS InteriorMina,pdc.FECHA_PROCESO AS FechaProcesos,pdc.NRO_MINA AS NumeroMina,
		pdc.TRAB_SIM AS TrabajosSimultaneos, NULL AS Descuento8porciento,pdc.ESTADO AS Estado,pdc.MONTO_PU AS MontoPU,pdc.IdSector,pdc.PRIMERA_FEC_AFILIA AS PrimeraFechaAfiliacion,pdc.DENSIDAD AS Densidad,
		pdc.SALARIO_COTIZABLE AS SalarioCotizable,pdc.SALARIO_COTIZABLE_ACT AS SalarioCotizableActual,pdc.FECHA_CALCULO AS FechaCalculo,pdc.FECHA_EMISION AS FechaEmision,pdc.TIPO_CAMBIO AS TipoCambio,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,pdc.ULTIMA_FEC_AFILIA AS UltimaFechaAfiliacion 
		FROM Piv_DOC_COMPARATIVO pdc
		WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.DocumentoComparativo dc	
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.DocumentoComparativo dc			
		EXCEPT
		SELECT pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.COMPONENTE AS Componente, pdc.NUP, pdc.MONTO_CC AS MontoCC,pdc.MONTO_PMM AS MontoPMM,pdc.APORTES_AFP AS AportesAFP,pdc.NRO_DOCUMENTO AS NumeroDocumento,
		pdc.IdBeneficio,pdc.FECHA_SELECCION AS FechaSeleccion,pdc.SALUD AS Salud,pdc.NRO_MESES AS NumeroMeses,pdc.INTERIOR_MINA AS InteriorMina,pdc.FECHA_PROCESO AS FechaProcesos,pdc.NRO_MINA AS NumeroMina,
		pdc.TRAB_SIM AS TrabajosSimultaneos, NULL AS Descuento8porciento,pdc.ESTADO AS Estado,pdc.MONTO_PU AS MontoPU,pdc.IdSector,pdc.PRIMERA_FEC_AFILIA AS PrimeraFechaAfiliacion,pdc.DENSIDAD AS Densidad,
		pdc.SALARIO_COTIZABLE AS SalarioCotizable,pdc.SALARIO_COTIZABLE_ACT AS SalarioCotizableActual,pdc.FECHA_CALCULO AS FechaCalculo,pdc.FECHA_EMISION AS FechaEmision,pdc.TIPO_CAMBIO AS TipoCambio,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,pdc.ULTIMA_FEC_AFILIA AS UltimaFechaAfiliacion 
		FROM Piv_DOC_COMPARATIVO pdc
		WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
	) AS DERECHA
-------------------------------------------------------------
--PREBENEFICIARIOS
--ORIGEN
/*SELECT ppb.NUP AS NUPTitular,ppb.NUPDH,ppb.FORMULARIO AS Formulario,ppb.IdTramite,ppb.IdGrupoBeneficio,ppb.CLASE_BENEFICIO AS ClaseBeneficio,ppb.PORCENTAJE AS Porcentaje,ppb.RED_DH AS RedDH,
ppb.PARENTESCO AS Parentesco,ppb.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL AS FechaResolucion
FROM Piv_PreBeneficiarios ppb
WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.PreBeneficiarios pb
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ppb.NUP AS NUPTitular,ppb.NUPDH,ppb.FORMULARIO AS Formulario,ppb.IdTramite,ppb.IdGrupoBeneficio,ppb.CLASE_BENEFICIO AS ClaseBeneficio,ppb.PORCENTAJE AS Porcentaje,ppb.RED_DH AS RedDH,
		ppb.PARENTESCO AS Parentesco,ppb.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL AS FechaResolucion
		FROM Piv_PreBeneficiarios ppb
		WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.PreBeneficiarios pb
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.PreBeneficiarios pb		
		EXCEPT
		SELECT ppb.NUP AS NUPTitular,ppb.NUPDH,ppb.FORMULARIO AS Formulario,ppb.IdTramite,ppb.IdGrupoBeneficio,ppb.CLASE_BENEFICIO AS ClaseBeneficio,ppb.PORCENTAJE AS Porcentaje,ppb.RED_DH AS RedDH,
		ppb.PARENTESCO AS Parentesco,ppb.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL AS FechaResolucion
		FROM Piv_PreBeneficiarios ppb
		WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NOT NULL
	) AS DERECHA*/
-------------------------------------------------------------
--PRETITULARES
--ORIGEN
SELECT ppt.NUP,ppt.FORMULARIO AS Formulario,ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF AS NumeroCertificado,ppt.IdBeneficio,ppt.ANIOS_INSALUBRES AS AniosInsalubres,ppt.MONTO_BASE AS MontoBase,
ppt.REINTEGRO_DESDE AS ReintegroDesde,ppt.REINTEGRO_HASTA AS ReintegroHasta,ppt.REINTEGRO AS Reintegro,ppt.AGUINALDO AS Aguinaldo,ppt.RED_EDAD AS RedEdad,ppt.MESES_CNS AS MesesCNS,ppt.Estado,
ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL FechaResolucion
FROM Piv_PreTitulares ppt
WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.PreTitulares pt
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ppt.NUP,ppt.FORMULARIO AS Formulario,ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF AS NumeroCertificado,ppt.IdBeneficio,ppt.ANIOS_INSALUBRES AS AniosInsalubres,ppt.MONTO_BASE AS MontoBase,
		ppt.REINTEGRO_DESDE AS ReintegroDesde,ppt.REINTEGRO_HASTA AS ReintegroHasta,ppt.REINTEGRO AS Reintegro,ppt.AGUINALDO AS Aguinaldo,ppt.RED_EDAD AS RedEdad,ppt.MESES_CNS AS MesesCNS,ppt.Estado,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL FechaResolucion
		FROM Piv_PreTitulares ppt
		WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.PreTitulares pt
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.PreTitulares pt		
		EXCEPT
		SELECT ppt.NUP,ppt.FORMULARIO AS Formulario,ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF AS NumeroCertificado,ppt.IdBeneficio,ppt.ANIOS_INSALUBRES AS AniosInsalubres,ppt.MONTO_BASE AS MontoBase,
		ppt.REINTEGRO_DESDE AS ReintegroDesde,ppt.REINTEGRO_HASTA AS ReintegroHasta,ppt.REINTEGRO AS Reintegro,ppt.AGUINALDO AS Aguinaldo,ppt.RED_EDAD AS RedEdad,ppt.MESES_CNS AS MesesCNS,ppt.Estado,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL FechaResolucion
		FROM Piv_PreTitulares ppt
		WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
	) AS DERECHA
-------------------------------------------------------------
--CHEQUEPU
--ORIGEN
SELECT pcp.EstadoM,pcp.NUPTitular,pcp.NUPDH,pcp.COD AS Codigo,pcp.ANIO AS Anio,pcp.MES AS Mes,pcp.DEBE AS Debe,pcp.HABER AS Haber,pcp.NRO_CHEQUE AS NumeroCheque,pcp.NRO_BAN AS NumeroBanco,pcp.IdBanco,
pcp.FECHA_EMI AS FechaEmision,pcp.C31,NULL AS Conciliado,ROW_NUMBER() OVER(PARTITION BY NUPTitular ORDER BY T_MATRICULA ASC) AS Version,1 AS RegistroActivo
FROM Piv_ChequePU pcp
WHERE pcp.NUPTitular IS NOT NULL
--DESTINO
SELECT * FROM PagoU.ChequePU cp
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ppt.NUP,ppt.FORMULARIO AS Formulario,ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF AS NumeroCertificado,ppt.IdBeneficio,ppt.ANIOS_INSALUBRES AS AniosInsalubres,ppt.MONTO_BASE AS MontoBase,
		ppt.REINTEGRO_DESDE AS ReintegroDesde,ppt.REINTEGRO_HASTA AS ReintegroHasta,ppt.REINTEGRO AS Reintegro,ppt.AGUINALDO AS Aguinaldo,ppt.RED_EDAD AS RedEdad,ppt.MESES_CNS AS MesesCNS,ppt.Estado,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL FechaResolucion
		FROM Piv_PreTitulares ppt
		WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.PreTitulares pt
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.PreTitulares pt		
		EXCEPT
		SELECT ppt.NUP,ppt.FORMULARIO AS Formulario,ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF AS NumeroCertificado,ppt.IdBeneficio,ppt.ANIOS_INSALUBRES AS AniosInsalubres,ppt.MONTO_BASE AS MontoBase,
		ppt.REINTEGRO_DESDE AS ReintegroDesde,ppt.REINTEGRO_HASTA AS ReintegroHasta,ppt.REINTEGRO AS Reintegro,ppt.AGUINALDO AS Aguinaldo,ppt.RED_EDAD AS RedEdad,ppt.MESES_CNS AS MesesCNS,ppt.Estado,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo,NULL AS Resolucion,NULL FechaResolucion
		FROM Piv_PreTitulares ppt
		WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
	) AS DERECHA
-------------------------------------------------------------
--TITULARPU
--ORIGEN
SELECT ptp.NUP,ptp.IdTramite,ptp.IdGrupoBeneficio,ptp.NUM_CERTIF AS NumeroCertificado,ptp.FORMULARIO AS Formulario,ptp.ANIOS_INSALUBRES AS AniosInsalubres,ptp.FECHA_ALTA AS FechaAlta,ptp.RESOLUCION AS Resolucion,
ptp.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo
FROM Piv_TitularPU ptp
WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.TitularPU tp
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ptp.NUP,ptp.IdTramite,ptp.IdGrupoBeneficio,ptp.NUM_CERTIF AS NumeroCertificado,ptp.FORMULARIO AS Formulario,ptp.ANIOS_INSALUBRES AS AniosInsalubres,ptp.FECHA_ALTA AS FechaAlta,ptp.RESOLUCION AS Resolucion,
		ptp.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo
		FROM Piv_TitularPU ptp
		WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.TitularPU tp
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.TitularPU tp	
		EXCEPT
		SELECT ptp.NUP,ptp.IdTramite,ptp.IdGrupoBeneficio,ptp.NUM_CERTIF AS NumeroCertificado,ptp.FORMULARIO AS Formulario,ptp.ANIOS_INSALUBRES AS AniosInsalubres,ptp.FECHA_ALTA AS FechaAlta,ptp.RESOLUCION AS Resolucion,
		ptp.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,1 AS RegistroActivo
		FROM Piv_TitularPU ptp
		WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
	) AS DERECHA





















