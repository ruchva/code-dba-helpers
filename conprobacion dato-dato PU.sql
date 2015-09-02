--*****EN ORIGEN Y NO EN DESTINO*****--

SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a --NO en pivote
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.CertificadoPMMPU cp WHERE cp.NUP = a.NUP)
      AND a.NUP IS NOT NULL
ORDER BY a.NUP

SELECT * FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.DocumentoComparativo dc WHERE dc.NUP = a.NUP)
ORDER BY a.NUP
------------------------------------
SELECT * FROM SENARITD.dbo.Piv_ChequePU a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.ChequePU cp WHERE cp.NUPTitular = a.NUPTitular)
ORDER BY a.NUPTitular

SELECT * FROM SENARITD.dbo.Piv_PreBeneficiarios a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.PreBeneficiarios pb WHERE pb.NUPTitular = a.NUP)
ORDER BY a.NUP

SELECT * FROM SENARITD.dbo.Piv_PreTitulares a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.PreTitulares pt WHERE pt.NUP = a.NUP)
ORDER BY a.NUP

SELECT * FROM SENARITD.dbo.Piv_TitularPU a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.TitularPU tp WHERE tp.NUP = a.NUP)
ORDER BY a.NUP

----------------------------------------------

SELECT * FROM Persona.Persona p WHERE p.NUP = 71322
SELECT * FROM SENARITD.PagoU.CertificadoPMMPU cp WHERE cp.NUP = 71322 AND cp.IdTramite = 151802
SELECT * FROM dbo.Piv_CERTIF_PMM_PU cp WHERE cp.NUP = 71322 AND cp.IdTramite = 151802
SELECT * FROM CC.dbo.CERTIF_PMM_PU cpp WHERE cpp.Matricula = '540801CAM'
--
SELECT * FROM Persona.Persona p WHERE p.NUP = 168795
SELECT * FROM SENARITD.PagoU.DocumentoComparativo dc WHERE dc.NUP = 168795 AND dc.IdTramite = 117563
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc WHERE pdc.NUP = 168795 AND pdc.IdTramite = 117563
SELECT * FROM CC.dbo.DOC_COMPARATIVO dc WHERE dc.MATRICULA = '541108FVV'
--
SELECT * FROM Persona.Persona p WHERE p.NUP = 57807
SELECT * FROM SENARITD.PagoU.PreBeneficiarios pb WHERE pb.NUPTitular = 57807 AND pb.IdTramite = 125377
SELECT * FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.NUP = 57807 AND ppb.IdTramite = 125377
--SELECT * FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.NUPDH IS NOT NULL AND ppb.NUP IS NOT NULL AND ppb.IdTramite IS NOT NULL
SELECT * FROM PAGOS_P.dbo.Pre_Beneficiarios pb WHERE pb.T_MATRICULA = '500906SHE'
--SELECT * FROM CRENTA.dbo.PERSONA p WHERE p.Matricula IN ('605814PAE','900415SPJ','955803SPC','990823SPA')
/*
SELECT * FROM Persona.Persona p WHERE p.NUP = 209152
SELECT * FROM SENARITD.PagoU.PreBeneficiarios pb WHERE pb.NUPTitular = 209152 AND pb.IdTramite = 138768
SELECT * FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.NUP = 209152 AND ppb.IdTramite = 138768
SELECT * FROM PAGOS_P.dbo.Pre_Beneficiarios pb WHERE pb.T_MATRICULA = '320731VRN'
*/
--
SELECT * FROM Persona.Persona p WHERE p.NUP = 86629
SELECT * FROM SENARITD.PagoU.PreTitulares pt WHERE pt.NUP = 86629
SELECT * FROM dbo.Piv_PreTitulares ppt WHERE ppt.NUP = 86629
SELECT * FROM PAGOS_P.dbo.Pre_Titulares pt WHERE pt.MATRICULA = '251226PCJ'
--
SELECT * FROM SENARITD.PagoU.TitularPU tp --12
LEFT JOIN SENARITD.PagoU.ChequePU cp ON tp.NUP = cp.NUPTitular
WHERE cp.NUPTitular IS NULL
SELECT * FROM SENARITD.PagoU.ChequePU cp --55
LEFT JOIN SENARITD.PagoU.TitularPU tp ON tp.NUP = cp.NUPTitular
WHERE tp.NUP IS NULL
SELECT * FROM SENARITD.PagoU.TitularPU tp JOIN SENARITD.PagoU.ChequePU cp ON tp.NUP = cp.NUPTitular
--
SELECT * FROM Persona.Persona p WHERE p.NUP = 169672
SELECT * FROM SENARITD.PagoU.TitularPU tp WHERE tp.NUP = 169672
SELECT * FROM dbo.Piv_TitularPU ptp WHERE ptp.NUP = 169672
SELECT * FROM PAGOS_P.dbo.Titular_PU tp WHERE tp.T_MATRICULA = '591214HTJ'
--
SELECT * FROM Persona.Persona p WHERE p.NUP = 169672
SELECT * FROM SENARITD.PagoU.ChequePU cp WHERE cp.NUPTitular = 169672
SELECT * FROM dbo.Piv_ChequePU pcp WHERE pcp.NUPTitular = 169672
SELECT * FROM PAGOS_P.dbo.chePU cp WHERE cp.T_MATRICULA = '591214HTJ'
<<<<<<< HEAD
SELECT * FROM CRENTA.dbo.PERSONA p WHERE p.Matricula = '591214HTJ'
=======
>>>>>>> 7e22bd85c37a98af879e88a6986b6088691319c9

/*SELECT 'pruebas' AS origen,*
FROM   (   SELECT *
           FROM   pruebas.dbo.Clientes
           EXCEPT
		   SELECT *
		   FROM   produccion.dbo.Clientes
       ) AS IZQUIERDA
UNION
SELECT 'produccion' AS origen,*
FROM   (   SELECT *
           FROM   produccion.dbo.Clientes
           EXCEPT
           SELECT *
           FROM   pruebas.dbo.Clientes
       ) AS DERECHA
       */           
------------------------------------------------------------           
--1 ORIGEN
SELECT a.NUP,a.IdTramite,a.IdGrupoBeneficio,a.no_certif AS NumeroCertificado,a.doc AS Documento,a.fecha_emi AS FechaEmision,a.monto AS Monto,a.IdBeneficio,a.Tipo_PP AS TipoPP,a.EstadoM AS Estado
	  ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS Version,a.tipo_cambio AS TipoCambio  
FROM Piv_CERTIFm_PMM_PU a
WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
ORDER BY a.NUP
--2 DESTINO
SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.Version,b.TipoCambio
FROM PagoU.CertificadoPMMPU b
ORDER BY b.NUP
--APLICANDO EXCEPT AL LA UNION
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









           
           
           
            

















