USE [SENARITD]
GO
/****** Object:  StoredProcedure [dbo].[CreaPivoteTablasCC]    Script Date: 13/08/2015 11:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreaPivoteTablasCC]
AS
BEGIN
	--**CERTIF_PMM_PU**--			
	DROP TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU
	SELECT * INTO SENARITD.dbo.Piv_CERTIF_PMM_PU       
	FROM CC.dbo.CERTIF_PMM_PU
	
	--SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD EstadoM INT
	
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
		UPDATE a SET a.IdBeneficio = CASE WHEN a.Clase_Pago = 'PU'  THEN 21
										  WHEN a.Clase_Pago = 'PMM' THEN 19
									 END
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a
	
		--ESTADO--CERTIFICADO_PMMPU 
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.Estado = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 106
			
	
	--**DOCUMENTO_COMPARATIVO**--
	DROP TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO
	SELECT * INTO SENARITD.dbo.Piv_DOC_COMPARATIVO
	FROM CC.dbo.DOC_COMPARATIVO dc
	
	--SELECT * FROM SENARITD.dbo.Piv_DOC_COMPARATIVO
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD EstadoM INT
		
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
		UPDATE a SET a.IdBeneficio = CASE WHEN a.SELEC = 'PU'  THEN 21
										  WHEN a.SELEC = 'PMM' THEN 19
										  WHEN a.SELEC = 'CC' AND a.TIPO_CC = 'M' THEN 16
										  WHEN a.SELEC = 'CC' AND a.TIPO_CC = 'G' THEN 17
									 END
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a		
		
		--ESTADO--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 106	
		
END 