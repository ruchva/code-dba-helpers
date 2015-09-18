------CC
SELECT COUNT(*) FROM CRENTA.dbo.TRAMITE t WHERE t.ClaseRenta = 'U' --todos de tipo CC
SELECT * FROM CRENTA.dbo.CLASEDERENTA c WHERE c.ClaseRenta = 'U' --todos de tipo CC

SELECT COUNT(*), cpp.Estado FROM CC.dbo.CERTIF_PMM_PU cpp 
GROUP BY cpp.Estado
HAVING COUNT(*) > 1 --clasificador

SELECT * FROM CC.dbo.ESTADO_DOC ed
SELECT COUNT(*), cpp.ESTADO FROM CC.dbo.DOC_COMPARATIVO cpp
GROUP BY cpp.ESTADO
HAVING COUNT(*) > 1 --clasificador

SELECT * FROM PAGOS_P.dbo.param_estado pe
SELECT COUNT(*), cp.ESTADO FROM PAGOS_P.dbo.chePU cp
GROUP BY cp.ESTADO
HAVING COUNT(*) >1 --clasificador

SELECT COUNT(*), cp.BANCO FROM PAGOS_P.dbo.chePU cp
GROUP BY cp.BANCO
HAVING COUNT(*) >1 --clasificador

--verificacion pre_beneficiarios -- DOC_COMP_DH
SELECT * FROM CC.dbo.DOC_COMP_DH dcd 
LEFT JOIN CRENTA.dbo.TRAMITE t ON dcd.TRAMITE = t.Tramite
LEFT JOIN CRENTA.dbo.PERSONA p ON dcd.MATRICULA = p.Matricula
WHERE t.Tramite IS NULL AND p.Matricula IS NULL AND t.ClaseRenta = 'U'

SELECT * FROM CC.dbo.DOC_COMP_DH dcd 
JOIN CRENTA.dbo.TRAMITE t ON dcd.TRAMITE = t.Tramite
JOIN CRENTA.dbo.PERSONA p ON dcd.MATRICULA = p.Matricula
WHERE t.ClaseRenta = 'U'
----
SELECT * FROM CRENTA.dbo.PERSONA p
SELECT * FROM CC.dbo.DOC_COMP_DH dcd LEFT JOIN CRENTA.dbo.PERSONA p
ON dcd.MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM CC.dbo.DOC_COMPARATIVO dc
JOIN CRENTA.dbo.TRAMITE t ON t.Matricula = dc.MATRICULA AND t.Tramite = dc.TRAMITE
WHERE t.ClaseRenta = 'U'

----CertificacionPMMPU --origen CRENTA-CERTIF_PMM_PU
SELECT * FROM CC.dbo.CERTIF_PMM_PU cpp
JOIN CRENTA.dbo.TRAMITE t ON cpp.Matricula = t.Matricula AND cpp.Tramite = t.Tramite
JOIN CRENTA.dbo.PERSONA p ON cpp.Matricula = p.Matricula 
WHERE t.ClaseRenta = 'U'

SELECT COUNT(*),dc.COMPONENTE FROM CC.dbo.DOC_COMPARATIVO dc
GROUP BY dc.COMPONENTE  
HAVING COUNT(*) > 1

SELECT COUNT(*),cpp.Matricula FROM CC.dbo.CERTIF_PMM_PU cpp
GROUP BY cpp.Matricula
HAVING COUNT(*) > 1

--ENTRE pre_beneficiarios y documento_comparativo_dh
SELECT pb.DH_PATERNO,pb.DH_MATERNO,pb.DH_NOMBRES,dcd.BPATERNO,dcd.BMATERNO,dcd.BNOMBRES,pb.DH_MATRICULA,dcd.BMATRICULA
FROM PAGOS_P.dbo.Pre_Beneficiarios pb 
JOIN CC.dbo.DOC_COMP_DH dcd ON dcd.MATRICULA = pb.T_MATRICULA 

--ENTRE pre_titulares y documento_comparativo_dh
SELECT pt.T_PATERNO,pt.T_MATERNO,pt.T_NOMBRES,pt.TRAMITE,dcd.TRAMITE,dcd.BPATERNO,dcd.BMATERNO,dcd.BNOMBRES 
FROM PAGOS_P.dbo.Pre_Titulares pt
JOIN CC.dbo.DOC_COMP_DH dcd ON pt.MATRICULA = dcd.BMATRICULA

SELECT * FROM PAGOS_P.dbo.Pre_Beneficiarios pb
LEFT JOIN CRENTA.dbo.TRAMITE t ON pb.T_MATRICULA = t.Matricula
WHERE t.Matricula IS NULL

SELECT * FROM PAGOS_P.dbo.Pre_Titulares pt
LEFT JOIN CRENTA.dbo.TRAMITE t ON pt.MATRICULA = t.Matricula
WHERE t.Matricula IS NULL

SELECT COUNT(*),pt.MATRICULA FROM PAGOS_P.dbo.Pre_Titulares pt
GROUP BY pt.MATRICULA
HAVING COUNT(*)>1

SELECT COUNT(*),pb.T_MATRICULA FROM PAGOS_P.dbo.Pre_Beneficiarios pb
GROUP BY pb.T_MATRICULA
HAVING COUNT(*)>1

SELECT * FROM CC.dbo.DOC_COMPARATIVO dc
WHERE dc.SELEC = 'PU'
SELECT * FROM CC.dbo.DOC_COMP_DH dcd
--SELECT * FROM PAGOS_P.dbo.Pre_Beneficiarios pb
SELECT * FROM PAGOS_P.dbo.Pre_Beneficiarios pb
JOIN CC.dbo.DOC_COMP_DH dcd ON pb.T_MATRICULA = dcd.MATRICULA

------
SELECT * FROM PAGOS_P.dbo.chePU a 
JOIN SENARITD.Persona.Persona p ON a.DH_MATRICULA = p.Matricula

SELECT * FROM PAGOS_P.dbo.chePU a
WHERE a.DH_MATRICULA IS NOT NULL		

SELECT * FROM PAGOS_P.dbo.chePU a 
JOIN CRENTA.dbo.PERSONA p ON a.DH_MATRICULA = p.Matricula







