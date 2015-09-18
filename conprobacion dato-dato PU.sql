--CERTIFICADOPMMPU
--ORIGEN
SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif'NumeroCertificado',a.doc'Documento',a.fecha_emi'FechaEmision',a.monto'Monto',a.IdBeneficio,a.Tipo_PP'TipoPP',a.EstadoM'Estado'
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
FROM (  SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif'NumeroCertificado',a.doc'Documento',a.fecha_emi'FechaEmision',a.monto'Monto',a.IdBeneficio,a.Tipo_PP'TipoPP',a.EstadoM'Estado'
				,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,a.tipo_cambio AS TipoCambio  
		FROM Piv_CERTIF_PMM_PU a
		WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
		EXCEPT
		SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.Version,b.TipoCambio
		FROM PagoU.CertificadoPMMPU b	
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.Version,b.TipoCambio
		FROM PagoU.CertificadoPMMPU b		
		EXCEPT
		SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif'NumeroCertificado',a.doc'Documento',a.fecha_emi'FechaEmision',a.monto'Monto',a.IdBeneficio,a.Tipo_PP'TipoPP',a.EstadoM'Estado'
				,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,a.tipo_cambio AS TipoCambio  
		FROM Piv_CERTIF_PMM_PU a
		WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
	) AS DERECHA

-----------------------------------------------------------------------------------------------------------------------------------------------


--DOCUNENTOCOMPARATIVO
--ORIGEN
SELECT pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.COMPONENTE'Componente', pdc.NUP, pdc.MONTO_CC'MontoCC',pdc.MONTO_PMM'MontoPMM',pdc.APORTES_AFP'AportesAFP',pdc.NRO_DOCUMENTO'NumeroDocumento',
pdc.IdBeneficio,pdc.FECHA_SELECCION'FechaSeleccion',pdc.SALUD'Salud',pdc.NRO_MESES'NumeroMeses',pdc.INTERIOR_MINA'InteriorMina',pdc.FECHA_PROCESO'FechaProcesos',pdc.NRO_MINA'NumeroMina',
pdc.TRAB_SIM'TrabajosSimultaneos', NULL'Descuento8porciento',pdc.EstadoM'Estado',pdc.MONTO_PU'MontoPU',pdc.IdSector,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion',pdc.DENSIDAD'Densidad',
pdc.SALARIO_COTIZABLE'SalarioCotizable',pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual',pdc.FECHA_CALCULO'FechaCalculo',pdc.FECHA_EMISION'FechaEmision',pdc.TIPO_CAMBIO'TipoCambio',
ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo',pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion' 
FROM Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.DocumentoComparativo dc
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.COMPONENTE'Componente', pdc.NUP, pdc.MONTO_CC'MontoCC',pdc.MONTO_PMM'MontoPMM',pdc.APORTES_AFP'AportesAFP',pdc.NRO_DOCUMENTO'NumeroDocumento',
		pdc.IdBeneficio,pdc.FECHA_SELECCION'FechaSeleccion',pdc.SALUD'Salud',pdc.NRO_MESES'NumeroMeses',pdc.INTERIOR_MINA'InteriorMina',pdc.FECHA_PROCESO'FechaProcesos',pdc.NRO_MINA'NumeroMina',
		pdc.TRAB_SIM'TrabajosSimultaneos', NULL'Descuento8porciento',pdc.EstadoM'Estado',pdc.MONTO_PU'MontoPU',pdc.IdSector,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion',pdc.DENSIDAD'Densidad',
		pdc.SALARIO_COTIZABLE'SalarioCotizable',pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual',pdc.FECHA_CALCULO'FechaCalculo',pdc.FECHA_EMISION'FechaEmision',pdc.TIPO_CAMBIO'TipoCambio',
		--ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',
		1'RegistroActivo',pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion' 
		FROM Piv_DOC_COMPARATIVO pdc
		WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL and pdc.EstadoM is not null--and NUP = 74546
		EXCEPT
		SELECT d.IdTramite,d.IdGrupoBeneficio,d.Componente,d.NUP,d.MontoCC,d.MontoPMM,d.AportesAFP,d.NumeroDocumento,d.IdBeneficio,d.FechaSeleccion,d.Salud,d.NumeroMeses,d.InteriorMina,
		d.FechaProceso,d.NumeroMina,d.TrabajosSimultaneos,d.Descuento8porciento,d.Estado,d.MontoPU,d.IdSector,d.PrimeraFechaAfiliacion,d.Densidad,d.SalarioCotizable,d.SalarioCotizableActual,
		d.FechaCalculo,d.FechaEmision,d.TipoCambio,d.RegistroActivo,d.UltimaFechaAfiliacion 
        FROM PagoU.DocumentoComparativo d	--where NUP = 74546
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT d.IdTramite,d.IdGrupoBeneficio,d.Componente,d.NUP,d.MontoCC,d.MontoPMM,d.AportesAFP,d.NumeroDocumento,d.IdBeneficio,d.FechaSeleccion,d.Salud,d.NumeroMeses,d.InteriorMina,
		d.FechaProceso,d.NumeroMina,d.TrabajosSimultaneos,d.Descuento8porciento,d.Estado,d.MontoPU,d.IdSector,d.PrimeraFechaAfiliacion,d.Densidad,d.SalarioCotizable,d.SalarioCotizableActual,
		d.FechaCalculo,d.FechaEmision,d.TipoCambio,d.RegistroActivo,d.UltimaFechaAfiliacion 
        FROM PagoU.DocumentoComparativo d	--where NUP = 74546
		EXCEPT
		SELECT pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.COMPONENTE'Componente', pdc.NUP, pdc.MONTO_CC'MontoCC',pdc.MONTO_PMM'MontoPMM',pdc.APORTES_AFP'AportesAFP',pdc.NRO_DOCUMENTO'NumeroDocumento',
		pdc.IdBeneficio,pdc.FECHA_SELECCION'FechaSeleccion',pdc.SALUD'Salud',pdc.NRO_MESES'NumeroMeses',pdc.INTERIOR_MINA'InteriorMina',pdc.FECHA_PROCESO'FechaProceso',pdc.NRO_MINA'NumeroMina',
		pdc.TRAB_SIM'TrabajosSimultaneos', NULL'Descuento8porciento',pdc.EstadoM'Estado',pdc.MONTO_PU'MontoPU',pdc.IdSector,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion',pdc.DENSIDAD'Densidad',
		pdc.SALARIO_COTIZABLE'SalarioCotizable',pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual',pdc.FECHA_CALCULO'FechaCalculo',pdc.FECHA_EMISION'FechaEmision',pdc.TIPO_CAMBIO'TipoCambio',
		--ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',
		1'RegistroActivo',pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion' 
		FROM Piv_DOC_COMPARATIVO pdc
		WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL and pdc.EstadoM is not null--and NUP = 74546
	) AS DERECHA


-----------------------------------------------------------------------------------------------------------------------------------------------
--PREBENEFICIARIOS ---***SE REALIZARA CUANDO SE TENGA NUPDH COMPLETO Y CORREGIDO
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
-----------------------------------------------------------------------------------------------------------------------------------------------


--PRETITULARES
--ORIGEN
SELECT ppt.NUP,ppt.FORMULARIO'Formulario',ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF'NumeroCertificado',ppt.IdBeneficio,ppt.ANIOS_INSALUBRES'AniosInsalubres',ppt.MONTO_BASE'MontoBase',
ppt.REINTEGRO_DESDE'ReintegroDesde',ppt.REINTEGRO_HASTA'ReintegroHasta',ppt.REINTEGRO'Reintegro',ppt.AGUINALDO'Aguinaldo',ppt.RED_EDAD'RedEdad',ppt.MESES_CNS'MesesCNS',ppt.Estado,
ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo',NULL'Resolucion',NULL'FechaResolucion'
FROM Piv_PreTitulares ppt
WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.PreTitulares pt
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ppt.NUP,ppt.FORMULARIO'Formulario',ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF'NumeroCertificado',ppt.IdBeneficio,ppt.ANIOS_INSALUBRES'AniosInsalubres',ppt.MONTO_BASE'MontoBase',
		ppt.REINTEGRO_DESDE'ReintegroDesde',ppt.REINTEGRO_HASTA'ReintegroHasta',ppt.REINTEGRO'Reintegro',ppt.AGUINALDO'Aguinaldo',ppt.RED_EDAD'RedEdad',ppt.MESES_CNS'MesesCNS',ppt.Estado,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo',NULL'Resolucion',NULL'FechaResolucion'
		FROM Piv_PreTitulares ppt
		WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.PreTitulares pt
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.PreTitulares pt		
		EXCEPT
		SELECT ppt.NUP,ppt.FORMULARIO'Formulario',ppt.IdTramite,ppt.IdGrupoBeneficio,ppt.NUM_CERTIF'NumeroCertificado',ppt.IdBeneficio,ppt.ANIOS_INSALUBRES'AniosInsalubres',ppt.MONTO_BASE'MontoBase',
		ppt.REINTEGRO_DESDE'ReintegroDesde',ppt.REINTEGRO_HASTA'ReintegroHasta',ppt.REINTEGRO'Reintegro',ppt.AGUINALDO'Aguinaldo',ppt.RED_EDAD'RedEdad',ppt.MESES_CNS'MesesCNS',ppt.Estado,
		ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo',NULL'Resolucion',NULL'FechaResolucion'
		FROM Piv_PreTitulares ppt
		WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
	) AS DERECHA
-----------------------------------------------------------------------------------------------------------------------------------------------


--CHEQUEPU
--ORIGEN
SELECT pcp.EstadoM,pcp.NUPTitular,pcp.NUPDH,pcp.COD'Codigo',pcp.ANIO'Anio',pcp.MES'Mes',pcp.DEBE'Debe',pcp.HABER'Haber',pcp.NRO_CHEQUE'NumeroCheque',pcp.NRO_BAN'NumeroBanco',pcp.IdBanco,
pcp.FECHA_EMI'FechaEmision',pcp.C31,NULL'Conciliado',ROW_NUMBER() OVER(PARTITION BY NUPTitular ORDER BY T_MATRICULA ASC)'Version',1'RegistroActivo'
FROM Piv_ChequePU pcp
WHERE pcp.NUPTitular IS NOT NULL
--DESTINO
SELECT * FROM PagoU.ChequePU cp
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT pcp.EstadoM,pcp.NUPTitular,pcp.NUPDH,pcp.COD'Codigo',pcp.ANIO'Anio',pcp.MES'Mes',pcp.DEBE'Debe',pcp.HABER'Haber',pcp.NRO_CHEQUE'NumeroCheque',pcp.NRO_BAN'NumeroBanco',pcp.IdBanco,
		pcp.FECHA_EMI'FechaEmision',pcp.C31,NULL'Conciliado',ROW_NUMBER() OVER(PARTITION BY NUPTitular ORDER BY T_MATRICULA ASC)'Version',1'RegistroActivo'
		FROM Piv_ChequePU pcp
		WHERE pcp.NUPTitular IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.ChequePU cp
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.ChequePU cp
		EXCEPT
		SELECT pcp.EstadoM,pcp.NUPTitular,pcp.NUPDH,pcp.COD'Codigo',pcp.ANIO'Anio',pcp.MES'Mes',pcp.DEBE'Debe',pcp.HABER'Haber',pcp.NRO_CHEQUE'NumeroCheque',pcp.NRO_BAN'NumeroBanco',pcp.IdBanco,
		pcp.FECHA_EMI'FechaEmision',pcp.C31,NULL'Conciliado',ROW_NUMBER() OVER(PARTITION BY NUPTitular ORDER BY T_MATRICULA ASC)'Version',1'RegistroActivo'
		FROM Piv_ChequePU pcp
		WHERE pcp.NUPTitular IS NOT NULL
	) AS DERECHA
-----------------------------------------------------------------------------------------------------------------------------------------------


--TITULARPU
--ORIGEN
SELECT ptp.NUP,ptp.IdTramite,ptp.IdGrupoBeneficio,ptp.NUM_CERTIF'NumeroCertificado',ptp.FORMULARIO'Formulario',ptp.ANIOS_INSALUBRES'AniosInsalubres',ptp.FECHA_ALTA'FechaAlta',ptp.RESOLUCION'Resolucion',
ptp.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo'
FROM Piv_TitularPU ptp
WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
--DESTINO
SELECT * FROM PagoU.TitularPU tp
--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT ptp.NUP,ptp.IdTramite,ptp.IdGrupoBeneficio,ptp.NUM_CERTIF'NumeroCertificado',ptp.FORMULARIO'Formulario',ptp.ANIOS_INSALUBRES'AniosInsalubres',ptp.FECHA_ALTA'FechaAlta',ptp.RESOLUCION'Resolucion',
		ptp.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo'
		FROM Piv_TitularPU ptp
		WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
		EXCEPT
		SELECT * FROM PagoU.TitularPU tp
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT * FROM PagoU.TitularPU tp	
		EXCEPT
		SELECT ptp.NUP,ptp.IdTramite,ptp.IdGrupoBeneficio,ptp.NUM_CERTIF'NumeroCertificado',ptp.FORMULARIO'Formulario',ptp.ANIOS_INSALUBRES'AniosInsalubres',ptp.FECHA_ALTA'FechaAlta',ptp.RESOLUCION'Resolucion',
		ptp.Estado,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version',1'RegistroActivo'
		FROM Piv_TitularPU ptp
		WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
	) AS DERECHA
-----------------------------------------------------------------------------------------------------------------------------------------------