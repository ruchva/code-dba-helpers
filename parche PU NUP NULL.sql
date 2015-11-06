--**CertificacionPMMPU**
--ci, matricula y nombre  
SELECT p.NUP,p.CUA,p.Matricula,a.Matricula,p.NumeroDocumento,a.CI,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.Paterno,a.Materno,a.Nombres
FROM Persona.Persona p 
JOIN dbo.Piv_CERTIF_PMM_PU a ON a.Matricula = p.Matricula 
	AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento  
WHERE dbo.eliminaespacios(p.PrimerApellido) = dbo.eliminaespacios(a.Paterno) 
	AND dbo.eliminaespacios(p.SegundoApellido) = dbo.eliminaespacios(a.Materno) 

--ci, nombre comprobados
SELECT p.NUP,p.CUA,p.Matricula,a.Matricula,p.NumeroDocumento,a.CI,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.Paterno,a.Materno,a.Nombres
FROM Persona.Persona p 
JOIN dbo.Piv_CERTIF_PMM_PU a 
ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE a.NUP IS NULL
  --AND p.NUP NOT IN ('28929','30732','46272','83403','85457','100505','206533')--no son las mismas personas
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
FROM Persona.Persona p 
JOIN dbo.Piv_CERTIF_PMM_PU a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE a.NUP IS NULL  
--/****/

--matricula, nombre comprobados
SELECT p.NUP,p.CUA,p.Matricula,a.Matricula,p.NumeroDocumento,a.CI,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.Paterno,a.Materno,a.Nombres
FROM Persona.Persona p 
JOIN dbo.Piv_CERTIF_PMM_PU a ON a.Matricula = p.Matricula  
WHERE a.NUP IS NULL 
	--AND p.NUP NOT IN ('88878','88945','89124','90281','90817','93848','95306','140508','140510','140512','140513','140514','140515','140516')
--/****/	
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
FROM   Persona.Persona p
       JOIN dbo.Piv_CERTIF_PMM_PU a ON  a.Matricula = p.Matricula
WHERE  a.NUP IS NULL	
--/****/	

--verificamos
SELECT * FROM dbo.Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL
SELECT COUNT(*) FROM SENARITD.PagoU.CertificadoPMMPU cp
SELECT COUNT(*) FROM dbo.Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL

-----------------VERSION
SELECT COUNT(*)'REP', pcpp.NUP FROM dbo.Piv_CERTIF_PMM_PU pcpp 
WHERE pcpp.NUP IS NOT NULL AND pcpp.IdTramite IS NOT NULL
GROUP BY pcpp.NUP HAVING COUNT(*) > 1

SELECT *,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'VERSION'
FROM (SELECT * FROM Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL) p
/******************************************************************************/
--ci, matricula y nombre  
SELECT p.NUP,p.Matricula,a.MATRICULA,p.NumeroDocumento,a.CI,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.PATERNO,a.MATERNO,a.NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_DOC_COMPARATIVO a ON p.Matricula = a.MATRICULA
 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE p.PrimerApellido = a.PATERNO 
  AND p.SegundoApellido = a.MATERNO

--ci y nombres
SELECT p.NUP,p.Matricula,a.MATRICULA,p.NumeroDocumento,a.CI,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.PATERNO,a.MATERNO,a.NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_DOC_COMPARATIVO a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE a.NUP IS NULL
  --AND p.NUP NOT IN ('85457','100505','85457','100505','85457','100505','48573','82473','49674','83403','13513','73301','86071','46272','28929','206533','117439','91006','24346','115779','158430','131984','89593','194959')
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_DOC_COMPARATIVO a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE a.NUP IS NULL  
--/****/

--matricula y nombres
SELECT p.NUP,p.Matricula,a.MATRICULA,p.NumeroDocumento,a.CI,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.PATERNO,a.MATERNO,a.NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_DOC_COMPARATIVO a ON p.Matricula = a.MATRICULA
WHERE a.NUP IS NULL
  --AND p.NUP NOT IN ('16162','88803','88945','89124','89593','89702','90057','90281','90686','90702','90751','90797','90817','91518','91545','91567','91900','92875','93370','93698','93848','94947','95306','95957','96193','96526','96599','96687','97272','97396','140508','140510','140512','140513','140514','140515','140516')
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_DOC_COMPARATIVO a ON p.Matricula = a.MATRICULA
WHERE a.NUP IS NULL
--/****/

--verificacmos
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NULL
SELECT COUNT(*) FROM Piv_DOC_COMPARATIVO pdc WHERE pdc.NUP IS NOT NULL

-----------------VERSION
SELECT COUNT(*)'REP', a.NUP FROM Piv_DOC_COMPARATIVO a
WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL
GROUP BY a.NUP HAVING COUNT(*) > 1

SELECT *,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'VERSION'
FROM (SELECT * FROM Piv_DOC_COMPARATIVO a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL) p
/******************************************************************************/
SELECT p2.NUP,p2.Matricula,a.T_MATRICULA,p2.NumeroDocumento,p.CI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,p.[Apellido Paterno],p.[Apellido Materno],p.Nombres
FROM dbo.Piv_PreBeneficiarios a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
 
SELECT p2.NUP,p2.Matricula,a.T_MATRICULA,p2.NumeroDocumento,p.CI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,p.[Apellido Paterno],p.[Apellido Materno],p.Nombres
FROM dbo.Piv_PreBeneficiarios a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
WHERE a.NUP IS NULL
--/****/
SELECT p2.NUP
      ,ltrim(rtrim(p2.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
FROM dbo.Piv_PreBeneficiarios a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
WHERE a.NUP IS NULL
--/****/

SELECT p2.NUP,p2.Matricula,a.T_MATRICULA,p2.NumeroDocumento,p.CI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,p.[Apellido Paterno],p.[Apellido Materno],p.Nombres
FROM dbo.Piv_PreBeneficiarios a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
WHERE a.NUP IS NULL AND p2.NumeroDocumento <> ''
--/****/
SELECT p2.NUP
      ,ltrim(rtrim(p2.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
FROM dbo.Piv_PreBeneficiarios a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
WHERE a.NUP IS NULL AND p2.NumeroDocumento <> ''
--/****/

--probale para los dh solo 324 de 1627
SELECT p2.NUP,p.DH_MATRICULA,p2.Matricula,p2.NumeroDocumento,d.BCI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,d.BPATERNO,d.BMATERNO,d.BNOMBRES
FROM CC.dbo.DOC_COMP_DH d 
JOIN dbo.Piv_PreBeneficiarios p ON p.DH_MATRICULA = d.BMATRICULA
JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(d.BCI)))) = p2.NumeroDocumento

SELECT * FROM dbo.Piv_PreBeneficiarios a
LEFT JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
WHERE p.Matricula IS NULL --'250429LAR' --unico caso que no figura

SELECT * FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NULL
SELECT * FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.DH_MATRICULA IS NOT NULL
SELECT COUNT(*) FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.NUP IS NOT NULL

-----------------VERSION
SELECT COUNT(*)'REP', a.NUP FROM Piv_PreBeneficiarios a
WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL
GROUP BY a.NUP HAVING COUNT(*) > 1

SELECT *,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'VERSION'
FROM (SELECT * FROM Piv_PreBeneficiarios a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL) p
/******************************************************************************/
SELECT p.NUP,p.Matricula,a.MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_PreTitulares a ON p.Matricula = a.MATRICULA
 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
WHERE p.PrimerApellido = a.T_PATERNO 
  AND p.SegundoApellido = a.T_MATERNO

SELECT p.NUP,p.Matricula,a.MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_PreTitulares a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
WHERE a.NUP IS NULL 
  --AND p.NUP NOT IN ('85457','100505')
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_PreTitulares a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
WHERE a.NUP IS NULL 
--/****/  

SELECT p.NUP,p.Matricula,a.MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_PreTitulares a ON p.Matricula = a.MATRICULA
WHERE a.NUP IS NULL 
  --AND p.NUP NOT IN ('88945','93848','140515','140516')
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_PreTitulares a ON p.Matricula = a.MATRICULA
WHERE a.NUP IS NULL 
--/****/  

SELECT * FROM Piv_PreTitulares ppt WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NULL
SELECT COUNT(*) FROM Piv_PreTitulares ppt WHERE ppt.NUP IS NOT NULL

-----------------VERSION
SELECT COUNT(*)'REP', a.NUP FROM Piv_PreTitulares a
WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL
GROUP BY a.NUP HAVING COUNT(*) > 1

SELECT *,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'VERSION'
FROM (SELECT * FROM Piv_PreTitulares a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL) p
/******************************************************************************/
SELECT p.NUP,p.Matricula,a.T_MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA
 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
WHERE p.PrimerApellido = a.T_PATERNO 
  AND p.SegundoApellido = a.T_MATERNO

SELECT p.NUP,p.Matricula,a.T_MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
WHERE a.NUP IS NULL AND p.NumeroDocumento <> '' 
  --AND p.NUP NOT IN (68170,6786,354,90524,90533,163693,90817,86259,63580,15748,50359,208281,67544,92063,53002,138734,51387,97904,78401,92241,21513,88535,88535,92364,207764,25626,199002,92454,1614750,81236,6165672878
  --,107253,115396,125645,150436,204121,93017,24816,77668,210348,93273,156653,56708,93699,194342,186485,88839,58377,88885,69002,69002,88971,88971,88984,59072,10005,17840,94715,89232,89232,9110,79919,210365,210554
  --,208439,89363,81933,20269,95306,89517,95623,151308,83423,209116,89824,89831,89938,90056,48843)
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
WHERE a.NUP IS NULL AND p.NumeroDocumento <> '' 
--/****/

SELECT p.NUP,p.Matricula,a.T_MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA 
WHERE a.NUP IS NULL
  AND p.PrimerApellido = a.T_PATERNO 
  AND p.SegundoApellido = a.T_MATERNO
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA 
WHERE a.NUP IS NULL
  AND p.PrimerApellido = a.T_PATERNO 
  AND p.SegundoApellido = a.T_MATERNO
--/****/  

SELECT p.NUP,p.Matricula,a.T_MATRICULA,p.NumeroDocumento,a.NUM_IDENTIF,p.PrimerApellido,p.SegundoApellido,p.PrimerNombre,a.T_PATERNO,a.T_MATERNO,a.T_NOMBRES 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA 
WHERE a.NUP IS NULL 
  --AND p.NUP NOT IN (90524,140508,140510,140512,140513,140514,140515,140516)
--/****/
SELECT p.NUP
      ,ltrim(rtrim(p.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(a.T_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end 
FROM Persona.Persona p 
JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA 
WHERE a.NUP IS NULL 
--/****/
  
SELECT * FROM Piv_TitularPU ptp WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NULL  
SELECT COUNT(*) FROM Piv_TitularPU ptp WHERE ptp.NUP IS NOT NULL

-----------------VERSION
SELECT COUNT(*)'REP', a.NUP FROM Piv_TitularPU a
WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL
GROUP BY a.NUP HAVING COUNT(*) > 1

SELECT *,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'VERSION'
FROM (SELECT * FROM Piv_TitularPU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL) p
/******************************************************************************/
SELECT p2.NUP,p2.Matricula,a.T_MATRICULA,p2.NumeroDocumento,p.CI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,p.[Apellido Paterno],p.[Apellido Materno],p.Nombres
FROM dbo.Piv_ChequePU a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento

SELECT p2.NUP,p2.Matricula,a.T_MATRICULA,p2.NumeroDocumento,p.CI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,p.[Apellido Paterno],p.[Apellido Materno],p.Nombres
FROM dbo.Piv_ChequePU a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
WHERE a.NUPTitular IS NULL
--/****/
SELECT p2.NUP
      ,ltrim(rtrim(p2.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
FROM dbo.Piv_ChequePU a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
WHERE a.NUPTitular IS NULL
--/****/

SELECT p2.NUP,p2.Matricula,a.T_MATRICULA,p2.NumeroDocumento,p.CI,p2.PrimerApellido,p2.SegundoApellido,p2.PrimerNombre,p.[Apellido Paterno],p.[Apellido Materno],p.Nombres
FROM dbo.Piv_ChequePU a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
WHERE a.NUPTitular IS NULL AND p2.NumeroDocumento <> '' 
  --AND p2.NUP NOT IN (140508,140510,140512,140513,140514,140515,140516)
--/****/
SELECT p2.NUP
      ,ltrim(rtrim(p2.PrimerNombre))
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(p.Nombres)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
FROM dbo.Piv_ChequePU a
JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
WHERE a.NUPTitular IS NULL AND p2.NumeroDocumento <> ''
--/****/

SELECT * FROM Piv_ChequePU pcp WHERE pcp.NUPTitular IS NULL 
SELECT COUNT(*) FROM Piv_ChequePU pcp WHERE pcp.NUPTitular IS NOT NULL

-----------------VERSION
SELECT COUNT(*)'REP', a.NUPTitular FROM Piv_ChequePU a
WHERE a.NUPTitular IS NOT NULL 
GROUP BY a.NUPTitular HAVING COUNT(*) > 1

SELECT *,ROW_NUMBER() OVER(PARTITION BY p.NUPTitular ORDER BY p.T_MATRICULA ASC)'VERSION'
FROM (SELECT * FROM Piv_ChequePU a WHERE a.NUPTitular IS NOT NULL) p
/******************************************************************************/