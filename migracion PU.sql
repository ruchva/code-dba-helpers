SELECT * FROM #temp_certif
SELECT TOP(50)* FROM SENARITD.Persona.Persona p

SELECT p.NUP, p.NumeroDocumento, tc.CI 
FROM SENARITD.Persona.Persona p JOIN #temp_certif tc 
ON p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(tc.CI))

ALTER TABLE #temp_certif ADD NUP BIGINT
--sp_columns CertificadoPMMPU;
--DROP TABLE #temp_certif

DROP TABLE #temp_certif 
SELECT * INTO #temp_certif       
FROM CC.dbo.CERTIF_PMM_PU

--ALTER TABLE #temp_certif ADD marca BIT
ALTER TABLE #temp_certif ADD NUP BIGINT
SELECT * FROM #temp_certif
--------------------------**********************-------------
--update a set marca=1
--from #temp_certif a inner join SENARITD.Persona.Persona b on dbo.eliminaLetras(dbo.eliminapuntos(a.CI))=b.NumeroDocumento

UPDATE a SET NUP = b.NUP
FROM #temp_certif a JOIN SENARITD.Persona.Persona b on dbo.eliminaLetras(dbo.eliminapuntos(a.CI))=b.NumeroDocumento

SELECT p.NUP, p.NumeroDocumento, tc.CI, tc.NUP 
FROM SENARITD.Persona.Persona p JOIN #temp_certif tc 
ON p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(tc.CI))

ALTER TABLE #temp_certif ADD Documento NVARCHAR
ALTER TABLE #temp_certif ADD IdBeneficio INT
/***********************************************************************************************************************/
--NUPTitular --NUPDH
DROP TABLE #temp_cheque
SELECT * 
INTO #temp_cheque
FROM PAGOS_P.dbo.chePU
SELECT * FROM #temp_cheque WHERE marca IS NULL
SELECT TOP(50)* FROM SENARITD.Persona.Persona p
ALTER TABLE #temp_cheque ADD NUPTitular BIGINT
--ALTER TABLE #temp_cheque ADD NUPDH BIGINT
ALTER TABLE #temp_cheque ADD marca SMALLINT

UPDATE tc SET marca = 1--iguala matricula
FROM SENARITD.Persona.Persona p JOIN #temp_cheque tc 
ON p.Matricula = tc.T_MATRICULA

UPDATE tc SET marca = 2--iguala matricula y documento
FROM SENARITD.Persona.Persona p JOIN #temp_cheque tc 
ON p.Matricula = tc.T_MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(tc.NUM_IDENTIF))

UPDATE tc SET NUPTitular = p.NUP
FROM #temp_cheque tc JOIN SENARITD.Persona.Persona p 
ON p.Matricula = tc.T_MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(tc.NUM_IDENTIF))

SELECT COUNT(NUPTitular), NUPTitular FROM #temp_cheque
GROUP BY NUPTitular
HAVING COUNT(NUPTitular) > 1

SELECT * FROM #temp_cheque 
WHERE NUPTitular IN ('3345476','3348254','3349166','3352574','3352929','3357241','3357744','3359617','3364467','3365590','3365849','3366068','3366285'
,'3366450','3366538','3367099','3368020','3370892','3371502','3374603','3375081','3427931','3436327','3436791','3436856','3436860','3436932','3436950'
,'3436969','3437018','3437147','3437224','3437233','3437234','3437235','3437236','3437434','3437499','3437521','3437693','3437863','3437919','3437920'
,'3437947','3437985','3438132','3438199','3438200','3439023','3440985','3440986','3444090','3448313','3448442','3448679','3449483','3449616','3449678'
,'3449701','3449743','3449876','3450113','3450471','3450910','3450923','3450997','3451109','3451118','3451277','3451934','3451990','3452174','3456937'
,'3458277','3458866','3485017','3485564','3486585','3495211','3495255','3495376','3495553','3495584','3495610','3495889','3496015','3496028','3496106'
,'3496183','3496335','3497111','3497913','3497914','3497918','3497941','3497953','3497965','3497967','3497972','3497976','3497999','3498002','3498005'
,'3498008','3498019','3498022','3498023','3498028','3498030','3498065','3498067','3498075','3498076','3498077','3498095','3498108','3498110','3498113'
,'3498119','3498121','3498126','3498131','3498135','3498140','3498145','3498172','3498194','3498197','3498200','3498204','3498219','3498251','3498256'
,'3498304','3498325')

SELECT p.NUP
      ,p.NumeroDocumento
      ,p.Matricula
      ,tc.NUM_IDENTIF
      ,tc.T_MATRICULA
      ,tc.DH_MATRICULA
      ,tc.marca
FROM SENARITD.Persona.Persona p 
JOIN #temp_cheque tc
ON p.Matricula = tc.T_MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(tc.NUM_IDENTIF))
ORDER BY p.Matricula
SELECT COUNT(*) FROM #temp_cheque 










