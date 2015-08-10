CREATE PROCEDURE dbo.CreaPivoteTablasCC
AS
BEGIN
	--**CERTIF_PMM_PU**--		
	DELETE FROM SENARITD.PagoU.CertificadoPMMPU	
	DELETE FROM SENARITD.dbo.Piv_CERTIF_PMM_PU
	SELECT * INTO SENARITD.dbo.Piv_CERTIF_PMM_PU       
	FROM CC.dbo.CERTIF_PMM_PU
	/*
	SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD EstadoM INT
	*/
		--NUP--CERTIFICADO_PMMPU 
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Persona.Persona p
		ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

		--ID_TRAMITE--CERTIFICADO_PMMPU 
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--CERTIFICADO_PMMPU 
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--CERTIFICADO_PMMPU 
		UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Beneficio.BeneficioAsegurado ba
		ON ba.NUPAsegurado = a.NUP
	
		--ESTADO--CERTIFICADO_PMMPU 
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.Estado = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 106
			
	
	--**DOCUMENTO_COMPARATIVO**--
	DELETE FROM SENARITD.PagoU.DocumentoComparativo
	DELETE FROM SENARITD.dbo.Piv_DOC_COMPARATIVO
	SELECT * INTO SENARITD.dbo.Piv_DOC_COMPARATIVO
	FROM CC.dbo.DOC_COMPARATIVO dc
	/*
	SELECT * FROM SENARITD.dbo.Piv_DOC_COMPARATIVO
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD EstadoM INT
	*/	
		--NUP--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Persona.Persona p
		ON dbo.eliminaLetras(dbo.eliminapuntos(a.CI)) = p.NumeroDocumento

		--ID_TRAMITE--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
		FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN SENARITD.dbo.Piv_DOC_COMPARATIVO a
		ON ba.NUPAsegurado = a.NUP

		--ESTADO--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 106	
		
END 