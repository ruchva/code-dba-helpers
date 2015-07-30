--CERTIFICADO_PMMPU 
DROP TABLE #temp_certif 
SELECT * INTO #temp_certif       
FROM CC.dbo.CERTIF_PMM_PU
SELECT * FROM #temp_certif
SELECT TOP(50)* FROM SENARITD.Persona.Persona p
SELECT TOP(1000)* FROM CRENTA.dbo.PERSONA p

SELECT * FROM #temp_certif a LEFT JOIN CRENTA.dbo.PERSONA p --62 casos
ON a.Matricula = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_certif a LEFT JOIN CRENTA.dbo.TRAMITE t --64 casos
ON a.Matricula = t.Matricula
WHERE t.Matricula IS NULL

--NUP--CERTIFICADO_PMMPU 
ALTER TABLE #temp_certif ADD NUP BIGINT

SELECT * FROM #temp_certif a LEFT JOIN SENARITD.Persona.Persona p --4923 casos
ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento
WHERE p.NumeroDocumento IS NULL

SELECT * FROM #temp_certif a LEFT JOIN SENARITD.Persona.Persona p --4871 casos
ON a.Matricula = p.Matricula
WHERE p.Matricula IS NULL

SELECT *--p.NUP, p.NumeroDocumento, tc.CI 
FROM #temp_certif a JOIN SENARITD.Persona.Persona p
ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

UPDATE a SET NUP = p.NUP
FROM #temp_certif a JOIN SENARITD.Persona.Persona p
ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

--ID_TRAMITE--CERTIFICADO_PMMPU 
ALTER TABLE #temp_certif ADD IdTramite INT
SELECT * FROM #temp_certif
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_certif a LEFT JOIN SENARITD.Tramite.TramitePersona tp
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

UPDATE a SET a.IdTramite = tp.IdTramite
FROM #temp_certif a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--ID_GRUPO_BENEFICIO--CERTIFICADO_PMMPU 
ALTER TABLE #temp_certif ADD IdGrupoBeneficio INT
SELECT * FROM #temp_certif
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_certif a LEFT JOIN SENARITD.Tramite.TramitePersona tp
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
FROM #temp_certif a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--ID BENEFICIO--CERTIFICADO_PMMPU 
ALTER TABLE #temp_certif ADD IdBeneficio INT

SELECT * FROM #temp_certif
SELECT * FROM SENARITD.Clasificador.BeneficioOtorgado bo

--ESTADO--CERTIFICADO_PMMPU 
ALTER TABLE #temp_certif ADD EstadoMig INT
SELECT * FROM #temp_certif
SELECT * FROM SENARITD.Clasificador.DetalleClasificador dc
WHERE dc.IdTipoClasificador = 106
--como se cual tipo le corresponde?

 
/***********************************************************************************************************************/
--CHEQUE_PU 
DROP TABLE #temp_cheque
SELECT * INTO #temp_cheque
FROM PAGOS_P.dbo.chePU
SELECT * FROM #temp_cheque 
SELECT TOP(50)* FROM SENARITD.Persona.Persona p

SELECT * FROM #temp_cheque a LEFT JOIN CRENTA.dbo.PERSONA p --6 casos
ON a.T_MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_cheque a LEFT JOIN CRENTA.dbo.TRAMITE t --6 casos
ON a.T_MATRICULA = t.Matricula
WHERE t.Matricula IS NULL

--NUP TITULAR--CHEQUE_PU
ALTER TABLE #temp_cheque ADD NUPTitular BIGINT

SELECT * 
FROM #temp_cheque a JOIN CRENTA.dbo.PERSONA p 
ON a.T_MATRICULA = p.Matricula

SELECT * 
FROM #temp_cheque a JOIN SENARITD.Persona.Persona p 
ON a.T_MATRICULA = p.Matricula

UPDATE a SET NUPTitular = p.NUP
FROM #temp_cheque a JOIN SENARITD.Persona.Persona p 
ON a.T_MATRICULA = p.Matricula

--probar por ci

/***************************************************/--PROBANDO CON MARCA--CHEQUE_PU
--ALTER TABLE #temp_cheque ADD NUPDH BIGINT
ALTER TABLE #temp_cheque ADD marca SMALLINT
UPDATE tc SET marca = 1--matricula
FROM SENARITD.Persona.Persona p JOIN #temp_cheque tc 
ON p.Matricula = tc.T_MATRICULA

UPDATE tc SET marca = 2--matricula y documento
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
/*******************************************************************/

--NUP DH--CHEQUE_PU


--ESTADO--CHEQUE_PU
--clasificador a ser creado

--ID_BANCO
SELECT * FROM SENARITD.Clasificador.DetalleClasificador WHERE IdTipoClasificador = '93'--ENTIDADES FINANCIERAS
SELECT TOP(100)* FROM SENARITD.Persona.Persona p
SELECT * FROM #temp_cheque

--CONCILIADO--CHEQUE_PU



DROP TABLE #temp_cheque
/***********************************************************************************************************************/
--DOCUMENTO_COMPARATIVO 
DROP TABLE #temp_docom
SELECT * INTO #temp_docom
FROM CC.dbo.DOC_COMPARATIVO dc
SELECT * FROM #temp_docom
SELECT * FROM SENARITD.Persona.Persona p

SELECT * FROM #temp_docom a LEFT JOIN CRENTA.dbo.PERSONA p --1105
ON a.MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_docom a LEFT JOIN CRENTA.dbo.TRAMITE t --1112
ON a.MATRICULA = t.Matricula
WHERE t.Matricula IS NULL

--NUP--DOCUMENTO_COMPARATIVO 
ALTER TABLE #temp_docom ADD NUP BIGINT

SELECT * FROM #temp_docom a LEFT JOIN SENARITD.Persona.Persona p --16551
ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento
WHERE p.NumeroDocumento IS NULL

SELECT * FROM #temp_docom a LEFT JOIN SENARITD.Persona.Persona p --17767
ON a.MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_docom a JOIN SENARITD.Persona.Persona p --23303
ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

UPDATE a SET NUP = p.NUP --23192
FROM #temp_docom a JOIN SENARITD.Persona.Persona p
ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

--ID_TRAMITE--DOCUMENTO_COMPARATIVO 
ALTER TABLE #temp_docom ADD IdTramite INT
SELECT * FROM #temp_docom
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_docom a LEFT JOIN SENARITD.Tramite.TramitePersona tp --86
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

UPDATE a SET a.IdTramite = tp.IdTramite
FROM #temp_docom a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--ID_GRUPO_BENEFICIO--DOCUMENTO_COMPARATIVO 
ALTER TABLE #temp_docom ADD IdGrupoBeneficio INT
SELECT * FROM #temp_docom
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_docom a LEFT JOIN SENARITD.Tramite.TramitePersona tp --86
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
FROM #temp_docom a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

/************************************************/--PROBANDO CON MARCA--DOCUMENTO_COMPARATIVO 
ALTER TABLE #temp_docom ADD marca SMALLINT
UPDATE td SET marca = 1
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA
UPDATE td SET NUP = p.NUP
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA 
UPDATE td SET marca = 2
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(td.CI))
UPDATE td SET NUP = p.NUP
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(td.CI))
UPDATE td SET marca = 3
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(td.CI))
AND p.CUA = td.NUA
UPDATE td SET NUP = p.NUP
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(td.CI))
AND p.CUA = td.NUA
SELECT *
FROM #temp_docom td JOIN SENARITD.Persona.Persona p 
ON p.Matricula = td.MATRICULA 
AND p.NumeroDocumento = dbo.eliminaLetras(dbo.eliminapuntos(td.CI))
AND p.CUA = td.NUA
/************************************************************************/

--ID BENEFICIO--DOCUMENTO_COMPARATIVO 
SELECT * FROM #temp_docom
SELECT * FROM SENARITD.Beneficio.BeneficioAsegurado ba

ALTER TABLE #temp_docom ADD IdBeneficio INT

UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_docom a
ON ba.NUPAsegurado = a.NUP

SELECT *
FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_docom a
ON ba.NUPAsegurado = a.NUP

--ESTADO--DOCUMENTO_COMPARATIVO 
ALTER TABLE #temp_docom ADD EstadoMig INT
SELECT * FROM #temp_docom
SELECT * FROM SENARITD.Clasificador.DetalleClasificador dc
WHERE dc.IdTipoClasificador = 106 --no esta en el serv de migracion

SELECT a.ESTADO,dc.ObservacionClasificador  
FROM #temp_docom a JOIN SENARITD.Clasificador.DetalleClasificador dc
ON a.ESTADO = dc.ObservacionClasificador
WHERE dc.IdTipoClasificador = 106 --no esta en el serv de migracion

DROP TABLE #temp_docom
/***********************************************************************************************************************/

--PRE BENEFICIARIOS
DROP TABLE #temp_preben
SELECT * INTO #temp_preben
FROM PAGOS_P.dbo.Pre_Beneficiarios a
SELECT * FROM #temp_preben
SELECT TOP(1000)* FROM SENARITD.Persona.Persona p

SELECT * FROM #temp_preben a LEFT JOIN CRENTA.dbo.PERSONA p --1
ON a.T_MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_preben a LEFT JOIN CRENTA.dbo.TRAMITE t --1
ON a.T_MATRICULA = t.Matricula
WHERE t.Matricula IS NULL

--NUP--PRE BENEFICIARIOS
ALTER TABLE #temp_preben ADD NUP BIGINT

SELECT * FROM #temp_preben a LEFT JOIN SENARITD.Persona.Persona p --1280
ON dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)) = p.NumeroDocumento
WHERE p.NumeroDocumento IS NULL

SELECT * FROM #temp_preben a LEFT JOIN SENARITD.Persona.Persona p --16
ON a.T_MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_preben a JOIN SENARITD.Persona.Persona p --2234
ON a.T_MATRICULA = p.Matricula

UPDATE a SET NUP = p.NUP
FROM #temp_preben a JOIN SENARITD.Persona.Persona p
ON a.T_MATRICULA = p.Matricula

/************************************************/--PROBANDO CON MARCA--PRE BENEFICIARIOS
ALTER TABLE #temp_preben ADD marca SMALLINT
UPDATE a SET marca = 1
FROM #temp_preben a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.T_MATRICULA
UPDATE a SET marca = 2
FROM #temp_preben a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.T_MATRICULA
AND p.NumeroDocumento = a.NUM_IDENTIF
SELECT * 
FROM #temp_preben a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.T_MATRICULA
AND p.NumeroDocumento = a.NUM_IDENTIF
/************************************************************************/

--ID_TRAMITE--PRE BENEFICIARIOS
ALTER TABLE #temp_preben ADD IdTramite INT
SELECT * FROM #temp_preben
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_preben a LEFT JOIN SENARITD.Tramite.TramitePersona tp --284
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

SELECT * FROM #temp_preben a JOIN SENARITD.Tramite.TramitePersona tp --53
ON a.NUP = tp.NUP

UPDATE a SET a.IdTramite = tp.IdTramite
FROM #temp_preben a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--ID_GRUPO_BENEFICIO--PRE BENEFICIARIOS
ALTER TABLE #temp_preben ADD IdGrupoBeneficio INT
SELECT * FROM #temp_preben
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_preben a LEFT JOIN SENARITD.Tramite.TramitePersona tp --284
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

SELECT * FROM #temp_preben a JOIN SENARITD.Tramite.TramitePersona tp --53
ON a.NUP = tp.NUP

UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
FROM #temp_preben a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--PARENTESCO--PRE BENEFICIARIOS
ALTER TABLE #temp_preben ADD Parentesco INT
SELECT * FROM #temp_preben

SELECT COUNT(*), a.PARENTESCO FROM #temp_preben a
GROUP BY a.PARENTESCO
HAVING COUNT(a.PARENTESCO) > 1 --solo hijo y conyugue

SELECT CASE WHEN a.PARENTESCO = 'H' THEN 4 ELSE 3 END, a.PARENTESCO
FROM #temp_preben a

UPDATE a SET Parentesco = CASE WHEN a.PARENTESCO = 'H' THEN 4 ELSE 3 END
FROM #temp_preben a

--ESTADO--PRE BENEFICIARIOS
ALTER TABLE #temp_preben ADD Estado INT
SELECT * FROM PAGOS_P.dbo.param_estado;

SELECT * FROM SENARITD.Clasificador.DetalleClasificador dc
WHERE dc.IdTipoClasificador = 109

SELECT * FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
ON a.ESTADO = dc.CodigoDetalleClasificador
WHERE dc.IdTipoClasificador = 109

UPDATE a SET a.Estado = dc.IdDetalleClasificador
FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
ON a.ESTADO = dc.CodigoDetalleClasificador
WHERE dc.IdTipoClasificador = 109

--CALSE BENEFICIO--PRE BENEFICIARIOS
SELECT COUNT(*), a.CLASE_BENEFICIO FROM #temp_preben a
GROUP BY a.CLASE_BENEFICIO
HAVING COUNT(*) > 1
SELECT *--'VIUDA: '+CAST(VIUDA AS VARCHAR(10))+' HIJO: '+CAST(HIJO AS VARCHAR(10)) 
FROM PAGOS_P.dbo.param_clase_beneficio ;

SELECT * FROM SENARITD.Clasificador.DetalleClasificador dc
WHERE dc.IdTipoClasificador = 110

SELECT * FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
ON a.ESTADO = dc.CodigoDetalleClasificador
WHERE dc.IdTipoClasificador = 110

UPDATE a SET a.Estado = dc.IdDetalleClasificador
FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
ON a.ESTADO = dc.CodigoDetalleClasificador
WHERE dc.IdTipoClasificador = 110


/***********************************************************************************************************************/
--PRE TITULARES 
DROP TABLE #temp_pretit
SELECT * INTO #temp_pretit
FROM PAGOS_P.dbo.Pre_Titulares a
SELECT * FROM #temp_pretit
SELECT TOP(1000)* FROM SENARITD.Persona.Persona p

SELECT * FROM #temp_pretit a LEFT JOIN CRENTA.dbo.PERSONA p --4
ON a.MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_pretit a LEFT JOIN CRENTA.dbo.TRAMITE t --5
ON a.MATRICULA = t.Matricula
WHERE t.Matricula IS NULL

--NUP--PRE TITULARES 
ALTER TABLE #temp_pretit ADD NUP BIGINT

SELECT * FROM #temp_pretit a LEFT JOIN SENARITD.Persona.Persona p --49
ON dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)) = p.NumeroDocumento
WHERE p.NumeroDocumento IS NULL

SELECT * FROM #temp_pretit a LEFT JOIN SENARITD.Persona.Persona p --42
ON a.MATRICULA = p.Matricula
WHERE p.Matricula IS NULL

SELECT * FROM #temp_pretit a JOIN SENARITD.Persona.Persona p --5040
ON a.MATRICULA = p.Matricula

UPDATE a SET NUP = p.NUP
FROM #temp_pretit a JOIN SENARITD.Persona.Persona p
ON a.MATRICULA = p.Matricula

--ID_TRAMITE--PRE TITULARES 
ALTER TABLE #temp_pretit ADD IdTramite INT
SELECT * FROM #temp_pretit
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_pretit a LEFT JOIN SENARITD.Tramite.TramitePersona tp --128
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

SELECT * FROM #temp_pretit a JOIN SENARITD.Tramite.TramitePersona tp --4476
ON a.NUP = tp.NUP

UPDATE a SET a.IdTramite = tp.IdTramite
FROM #temp_pretit a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--ID_GRUPO_BENEFICIO--PRE TITULARES 
ALTER TABLE #temp_pretit ADD IdGrupoBeneficio INT
SELECT * FROM #temp_pretit
SELECT TOP(100)* FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM #temp_pretit a LEFT JOIN SENARITD.Tramite.TramitePersona tp --128
ON a.NUP = tp.NUP
WHERE tp.NUP IS NULL AND a.NUP IS NOT NULL

SELECT * FROM #temp_pretit a JOIN SENARITD.Tramite.TramitePersona tp --4476
ON a.NUP = tp.NUP

UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
FROM #temp_pretit a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

--ID BENEFICIO--PRE TITULARES 
ALTER TABLE #temp_pretit ADD IdBeneficio INT

SELECT * FROM #temp_pretit
SELECT * FROM SENARITD.Beneficio.BeneficioAsegurado ba

UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_pretit a
ON ba.NUPAsegurado = a.NUP

SELECT *
FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_pretit a
ON ba.NUPAsegurado = a.NUP

/************************************************/--PROBANDO CON MARCA--PRE TITULARES
ALTER TABLE #temp_pretit ADD marca SMALLINT
UPDATE a SET marca = 1
FROM #temp_pretit a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.MATRICULA
UPDATE a SET marca = 2
FROM #temp_pretit a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.MATRICULA
AND p.NumeroDocumento = a.NUM_IDENTIF
/***************************************************************/

SELECT * 
FROM #temp_pretit a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.MATRICULA
AND p.NumeroDocumento = a.NUM_IDENTIF

/***********************************************************************************************************************/
--TITULAR PU CUA, NUP, IdSector
DROP TABLE #temp_tit
SELECT * INTO #temp_tit
FROM PAGOS_P.dbo.Titular_PU a
SELECT * FROM #temp_tit
SELECT TOP(1000)* FROM SENARITD.Persona.Persona p

ALTER TABLE #temp_tit ADD marca SMALLINT
ALTER TABLE #temp_tit ADD NUP BIGINT
ALTER TABLE #temp_tit ADD CUA BIGINT

UPDATE a SET marca = 1
FROM #temp_tit a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.T_MATRICULA

UPDATE a SET marca = 2
FROM #temp_tit a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.T_MATRICULA
AND p.NumeroDocumento = NUM_IDENTIF

SELECT *
FROM #temp_tit a JOIN SENARITD.Persona.Persona p
ON p.Matricula = a.T_MATRICULA
AND p.NumeroDocumento = NUM_IDENTIF
--ON p.CUA = a.NUA















