SELECT p.NUP FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(pcpp.CI)))) 
	FROM dbo.Piv_CERTIF_PMM_PU pcpp WHERE pcpp.NUP IS NULL
)

SELECT * FROM dbo.Piv_CERTIF_PMM_PU a
JOIN SENARITD.Persona.Persona p ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE a.NUP IS NULL AND p.NumeroDocumento IN (SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(pcpp.CI)))) 
										      FROM dbo.Piv_CERTIF_PMM_PU pcpp WHERE pcpp.NUP IS NULL)

UPDATE a SET a.NUP = p.NUP
FROM dbo.Piv_CERTIF_PMM_PU a
JOIN SENARITD.Persona.Persona p 
ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
WHERE a.NUP IS NULL

--soluciona 205 casos de los 535 en DocumentoComparativo
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) 
	FROM dbo.Piv_DOC_COMPARATIVO a WHERE a.NUP IS NULL
)
--soluciona 2 casos de los 10 en PreBeneficiarios
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_PreBeneficiarios a WHERE a.NUP IS NULL
)
--soluciona 40 casos de los 42 en PreTitulares
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_PreTitulares a WHERE a.NUP IS NULL
)
--soluciona 44 casos de los 52 en TitularPU
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_TitularPU a WHERE a.NUP IS NULL
)
--soluciona 41 casos de los 49 en ChequePU
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_ChequePU a WHERE a.NUPTitular IS NULL
)