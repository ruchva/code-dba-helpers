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
SELECT * FROM CRENTA.dbo.PERSONA p WHERE p.Matricula = '591214HTJ'



















