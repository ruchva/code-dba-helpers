SELECT COUNT(*) FROM PagoU.CertificadoPMMPU      SELECT COUNT(*) FROM dbo.Piv_CERTIF_PMM_PU pcpp
SELECT COUNT(*) FROM PagoU.ChequePU				 SELECT COUNT(*) FROM dbo.Piv_ChequePU pcp
SELECT COUNT(*) FROM PagoU.DocumentoComparativo	 SELECT COUNT(*) FROM dbo.Piv_DOC_COMPARATIVO pdc
SELECT COUNT(*) FROM PagoU.PreBeneficiarios		 SELECT COUNT(*) FROM dbo.Piv_PreBeneficiarios ppb
SELECT COUNT(*) FROM PagoU.PreTitulares			 SELECT COUNT(*) FROM dbo.Piv_PreTitulares ppt
SELECT COUNT(*) FROM PagoU.TitularPU			 SELECT COUNT(*) FROM dbo.Piv_TitularPU ptp

--certificacion pmm pu
SELECT COUNT(*), pcpp.NUP FROM dbo.Piv_CERTIF_PMM_PU pcpp
GROUP BY pcpp.NUP HAVING COUNT(*) > 1

/*
* cantidad de NUP que se repiten
* */
-----------------------------------------------
SELECT ppt.NUP,pdc.NUP,ppt.IdBeneficio,pdc.IdBeneficio,ppt.NUM_IDENTIF,pdc.CI  
FROM dbo.Piv_PreTitulares ppt JOIN dbo.Piv_DOC_COMPARATIVO pdc ON ppt.NUP = pdc.NUP
WHERE ppt.NUP IS NOT NULL
  AND pdc.NUP IS NOT NULL 
  AND pdc.IdBeneficio IS NOT NULL 
  AND ppt.IdBeneficio IS NOT NULL
   
SELECT * FROM dbo.Piv_PreTitulares ppt
WHERE ppt.NUP IS NOT NULL AND ppt.IdBeneficio IS NULL

-----------------------------------------------
SELECT COUNT(*),ba.IdBeneficioOtorgado FROM Beneficio.BeneficioAsegurado ba
GROUP BY ba.IdBeneficioOtorgado HAVING COUNT(*) > 1
/*
* en Beneficio.BeneficioAsegurado tenemos beneficio otorgado 16(cc mensual) y 17(cc global)
* falta los beneficios otrogados de 21(PU) y 19(PMM)
* */
SELECT a.NUP,ba.NUPAsegurado,ba.IdGrupoBeneficio, ba.IdBeneficioOtorgado
FROM SENARITD.dbo.Piv_PreTitulares a  
JOIN SENARITD.Beneficio.BeneficioAsegurado ba ON a.NUP = ba.NUPAsegurado

SELECT a.NUP FROM SENARITD.dbo.Piv_PreTitulares a  
LEFT JOIN SENARITD.Beneficio.BeneficioAsegurado ba ON a.NUP = ba.NUPAsegurado
WHERE ba.NUPAsegurado IS NULL AND a.NUP IS NOT NULL

SELECT CASE WHEN pcpp.Clase_Pago = 'PU' THEN 21
			WHEN pcpp.Clase_Pago = 'PMM' THEN 19
END ,ppt.CLASE_PAGO,pcpp.Clase_Pago,ppt.NUP,pcpp.NUP
FROM dbo.Piv_PreTitulares ppt JOIN dbo.Piv_CERTIF_PMM_PU pcpp ON ppt.NUP = pcpp.NUP

SELECT * FROM PAGOS_P.dbo.param_clase_pago pcp 
SELECT CASE WHEN ppt.CLASE_PAGO = '1' THEN 19
            WHEN ppt.CLASE_PAGO = '2' THEN 21
            WHEN ppt.CLASE_PAGO = '3' THEN 20
            WHEN ppt.CLASE_PAGO = '4' THEN 22
       END,ppt.CLASE_PAGO    
FROM dbo.Piv_PreTitulares ppt
WHERE ppt.NUP IS NOT NULL
SELECT * FROM PagoU.PreTitulares pt
/*
* sacamos los registros que tienen
* */
----------------------------------------------
--cheque pu
SELECT * FROM dbo.Piv_ChequePU pcp 
WHERE pcp.NUPTitular IS NOT NULL

----------------------------------------------
--titulares pu
SELECT * FROM dbo.Piv_TitularPU ptp
WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL

SELECT * FROM dbo.Piv_CERTIF_PMM_PU pcpp
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc 
SELECT * FROM dbo.Piv_PreBeneficiarios ppb
SELECT * FROM dbo.Piv_PreTitulares ppt
SELECT * FROM dbo.Piv_ChequePU pcp
SELECT * FROM dbo.Piv_TitularPU ptp
-----------------------------------------------
--faltantes con IdTramite NULL
SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a --NO en pivote
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.CertificadoPMMPU cp WHERE cp.NUP = a.NUP)
      AND a.NUP IS NOT NULL
ORDER BY a.NUP

SELECT * FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.DocumentoComparativo dc WHERE dc.NUP = a.NUP)
      AND a.NUP IS NOT NULL      
ORDER BY a.NUP

-----------------------------------------------
--ID_TRAMITE--CERTIFICADO_PMMPU 
UPDATE a SET a.IdTramite = tp.IdTramite
FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a WHERE a.NUP = '88261'
SELECT * FROM Persona.Persona p WHERE p.NUP LIKE '88261'
SELECT * FROM Tramite.TramitePersona tp WHERE tp.NUP LIKE '88261'
--SELECT * FROM Persona.Persona p WHERE p.NUP LIKE '8826'
SELECT * FROM CC.dbo.CERTIF_PMM_PU cpp

-----------------------------------------------
--caso constraint PK violada
select * from SENARITD.PagoU.CertificadoPMMPU cp where cp.NUP = 13865
select * from dbo.Piv_CERTIF_PMM_PU where NUP = 13865
select * from CC.dbo.CERTIF_PMM_PU where Matricula = '420128CLJ'

--caso con certificado, dato historico 
SELECT * FROM PAGOS_P.dbo.Titular_PU
SELECT * FROM PAGOS_P.dbo.Titular_PMM tp WHERE tp.T_MATRICULA = '420128CLJ'
SELECT * FROM PAGOS_P.dbo.Titular_PU tp WHERE tp.T_MATRICULA = '420128CLJ'

SELECT * FROM CC.dbo.DOC_COMPARATIVO dc WHERE dc.MATRICULA = '420128CLJ'
SELECT * FROM CC.dbo.CERTIFICADO c WHERE c.Matricula = '420128CLJ'
SELECT * FROM CC.dbo.DOC_COMPARATIVO dc WHERE dc.MATRICULA = '581210PPC'
SELECT * FROM CC.dbo.CERTIFICADO c WHERE c.Matricula = '581210PPC'

------------------------------------------/********/
--problema clave primaria
SELECT COUNT(*) AS cont,pdc.MATRICULA --INTO #temp_nupdup 
FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
GROUP BY pdc.MATRICULA HAVING COUNT(*) > 1
SELECT COUNT(*) AS cont,pdc.NUP INTO #temp_nupdup --drop table #temp_nupdup
FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
GROUP BY pdc.NUP HAVING COUNT(*) > 1

SELECT COUNT(*), pcpp.NUP FROM dbo.Piv_CERTIF_PMM_PU pcpp 
WHERE pcpp.NUP IS NOT NULL AND pcpp.IdTramite IS NOT NULL
GROUP BY pcpp.NUP HAVING COUNT(*) > 1

SELECT * FROM #temp_nupdup

--parche para el campo version
SELECT dc.NUP,IdTramite,dc.Version
FROM PagoU.DocumentoComparativo dc 
WHERE dc.NUP IN (SELECT NUP FROM #temp_nupdup)
ORDER BY dc.IdTramite

SELECT p.NUP,p.IdTramite,p.Version,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS [VERSION]
FROM (SELECT dc.NUP,dc.Version,dc.IdTramite 
      FROM PagoU.DocumentoComparativo dc 
      WHERE dc.NUP IN (SELECT NUP FROM #temp_nupdup)      
     )p

SELECT pcpp.MATRICULA,pcpp.NUP,pcpp.TRAMITE
FROM dbo.Piv_DOC_COMPARATIVO pcpp JOIN #temp_nupdup a ON pcpp.NUP = a.NUP
ORDER BY pcpp.MATRICULA
-------------------------------------------/********/

--verificacion de cantidades
SELECT COUNT(*) FROM PagoU.CertificadoPMMPU cp
SELECT COUNT(*) FROM dbo.Piv_CERTIF_PMM_PU pcpp
WHERE pcpp.NUP IS NULL AND pcpp.IdTramite IS NOT NULL
SELECT * FROM dbo.Piv_CERTIF_PMM_PU pcpp WHERE pcpp.Estado = 'U'--no en clasificador

SELECT COUNT(*) FROM PagoU.DocumentoComparativo dc 
SELECT COUNT(*) FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NULL
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc WHERE pdc.ESTADO = 'U'

SELECT COUNT(*) FROM PagoU.PreBeneficiarios dc 
SELECT COUNT(*) FROM dbo.Piv_PreBeneficiarios ppb
WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NULL

SELECT COUNT(*) FROM PagoU.PreTitulares dc 
SELECT COUNT(*) FROM dbo.Piv_PreTitulares ppt 
WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NULL

SELECT COUNT(*) FROM PagoU.TitularPU dc 
SELECT COUNT(*) FROM dbo.Piv_TitularPU ptp 
WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NULL

SELECT COUNT(*) FROM PagoU.ChequePU dc 
SELECT COUNT(*) FROM dbo.Piv_ChequePU pcp 
WHERE pcp.NUPTitular IS NULL

---------------------------------------------------




