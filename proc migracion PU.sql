--CERTIFICADO_PMMPU 
DROP TABLE #temp_certif 
SELECT * INTO #temp_certif       
FROM CC.dbo.CERTIF_PMM_PU

	--NUP--CERTIFICADO_PMMPU 
	ALTER TABLE #temp_certif ADD NUP BIGINT	
	UPDATE a SET NUP = p.NUP
	FROM #temp_certif a JOIN SENARITD.Persona.Persona p
	ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

	--ID_TRAMITE--CERTIFICADO_PMMPU 
	ALTER TABLE #temp_certif ADD IdTramite INT
	UPDATE a SET a.IdTramite = tp.IdTramite
	FROM #temp_certif a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID_GRUPO_BENEFICIO--CERTIFICADO_PMMPU 
	ALTER TABLE #temp_certif ADD IdGrupoBeneficio INT
	UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
	FROM #temp_certif a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID BENEFICIO--CERTIFICADO_PMMPU 
	ALTER TABLE #temp_certif ADD IdBeneficio INT
	UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
	FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_certif a
	ON ba.NUPAsegurado = a.NUP
	
	--ESTADO--CERTIFICADO_PMMPU 
	ALTER TABLE #temp_certif ADD EstadoM INT	
	UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
	FROM #temp_certif a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.Estado = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 106
		
/***********************************************************************************************************************/
--CHEQUE_PU 
DROP TABLE #temp_cheque
SELECT * INTO #temp_cheque
FROM PAGOS_P.dbo.chePU

	--NUP TITULAR--CHEQUE_PU
	ALTER TABLE #temp_cheque ADD NUPTitular BIGINT
	UPDATE a SET NUPTitular = p.NUP
	FROM #temp_cheque a JOIN SENARITD.Persona.Persona p 
	ON a.T_MATRICULA = p.Matricula

	--NUP DH--CHEQUE_PU


	--ESTADO--CHEQUE_PU	
	ALTER TABLE #temp_cheque ADD EstadoM INT	
	UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
	FROM #temp_cheque a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.ESTADO = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 109 

	--ID_BANCO
	ALTER TABLE #temp_cheque ADD IdBanco INT
	UPDATE a SET IdBanco = CASE WHEN a.BANCO = 3 THEN 802 
	                            WHEN a.BANCO = 4 THEN 806  
	                            WHEN a.BANCO = 5 THEN 811
	                       END
	FROM #temp_cheque a
		
	--CONCILIADO--CHEQUE_PU
	
	
/***********************************************************************************************************************/
--DOCUMENTO_COMPARATIVO 
DROP TABLE #temp_docom
SELECT * INTO #temp_docom
FROM CC.dbo.DOC_COMPARATIVO dc

	--NUP--DOCUMENTO_COMPARATIVO 
	ALTER TABLE #temp_docom ADD NUP BIGINT
	UPDATE a SET NUP = p.NUP --23192
	FROM #temp_docom a JOIN SENARITD.Persona.Persona p
	ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

	--ID_TRAMITE--DOCUMENTO_COMPARATIVO 
	ALTER TABLE #temp_docom ADD IdTramite INT
	UPDATE a SET a.IdTramite = tp.IdTramite
	FROM #temp_docom a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID_GRUPO_BENEFICIO--DOCUMENTO_COMPARATIVO 
	ALTER TABLE #temp_docom ADD IdGrupoBeneficio INT
	UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
	FROM #temp_docom a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID BENEFICIO--DOCUMENTO_COMPARATIVO 
	ALTER TABLE #temp_docom ADD IdBeneficio INT
	UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
	FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_docom a
	ON ba.NUPAsegurado = a.NUP

	--ESTADO--DOCUMENTO_COMPARATIVO 
	ALTER TABLE #temp_docom ADD EstadoM INT
	UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
	FROM #temp_docom a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.ESTADO = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 106
	
	 
/***********************************************************************************************************************/
--PRE BENEFICIARIOS
DROP TABLE #temp_preben
SELECT * INTO #temp_preben
FROM PAGOS_P.dbo.Pre_Beneficiarios a

	--NUP--PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD NUP BIGINT
	UPDATE a SET NUP = p.NUP
	FROM #temp_preben a JOIN SENARITD.Persona.Persona p
	ON a.T_MATRICULA = p.Matricula

	--ID_TRAMITE--PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD IdTramite INT
	UPDATE a SET a.IdTramite = tp.IdTramite
	FROM #temp_preben a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID_GRUPO_BENEFICIO--PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD IdGrupoBeneficio INT
	UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
	FROM #temp_preben a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--PARENTESCO--PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD Parentesco INT
	UPDATE a SET Parentesco = CASE WHEN a.PARENTESCO = 'H' THEN 4 ELSE 3 END
	FROM #temp_preben a

	--ESTADO--PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD Estado INT
	UPDATE a SET a.Estado = dc.IdDetalleClasificador
	FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.ESTADO = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 109

	--CALSE BENEFICIO--PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD ClaseBeneficio INT
	UPDATE a SET a.ClaseBeneficio = dc.IdDetalleClasificador
	FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.CLASE_BENEFICIO = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 110

	--RED_DH --PRE BENEFICIARIOS
	ALTER TABLE #temp_preben ADD RedDH INT
	UPDATE a SET a.ClaseBeneficio = dc.IdDetalleClasificador
	FROM #temp_preben a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.RED_DH = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 111

/***********************************************************************************************************************/
--PRE TITULARES 
DROP TABLE #temp_pretit
SELECT * INTO #temp_pretit
FROM PAGOS_P.dbo.Pre_Titulares a
	--NUP--PRE TITULARES 
	ALTER TABLE #temp_pretit ADD NUP BIGINT
	UPDATE a SET NUP = p.NUP
	FROM #temp_pretit a JOIN SENARITD.Persona.Persona p
	ON a.MATRICULA = p.Matricula

	--ID_TRAMITE--PRE TITULARES 
	ALTER TABLE #temp_pretit ADD IdTramite INT
	UPDATE a SET a.IdTramite = tp.IdTramite
	FROM #temp_pretit a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID_GRUPO_BENEFICIO--PRE TITULARES 
	ALTER TABLE #temp_pretit ADD IdGrupoBeneficio INT
	UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
	FROM #temp_pretit a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID BENEFICIO--PRE TITULARES 
	ALTER TABLE #temp_pretit ADD IdBeneficio INT
	UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
	FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN #temp_pretit a
	ON ba.NUPAsegurado = a.NUP
		
	--ESTADO--PRE TITULARES
	ALTER TABLE #temp_pretit ADD Estado INT
	UPDATE a SET a.Estado = dc.IdDetalleClasificador
	FROM #temp_pretit a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.ESTADO = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 109

/***********************************************************************************************************************/
--TITULAR_PU 
DROP TABLE #temp_tit
SELECT * INTO #temp_tit
FROM PAGOS_P.dbo.Titular_PU a

	--NUP--TITULAR_PU
	ALTER TABLE #temp_tit ADD NUP BIGINT
	UPDATE a SET NUP = p.NUP
	FROM #temp_tit a JOIN SENARITD.Persona.Persona p
	ON a.T_MATRICULA = p.Matricula

	--ID_TRAMITE--TITULAR_PU
	ALTER TABLE #temp_tit ADD IdTramite INT
	UPDATE a SET a.IdTramite = tp.IdTramite
	FROM #temp_tit a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ID_GRUPO_BENEFICIO--TITULAR_PU
	ALTER TABLE #temp_tit ADD IdGrupoBeneficio INT
	UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
	FROM #temp_tit a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.NUP = tp.NUP	

	--ESTADO--TITULAR_PU
	ALTER TABLE #temp_tit ADD Estado INT
	UPDATE a SET a.Estado = dc.IdDetalleClasificador
	FROM #temp_tit a JOIN SENARITD.Clasificador.DetalleClasificador dc
	ON a.ESTADO = dc.CodigoDetalleClasificador
	WHERE dc.IdTipoClasificador = 109

	