ALTER PROCEDURE [dbo].[CreaPivoteReprocesos]
AS
BEGIN
	DROP TABLE SENASIR.dbo.Piv_REPROCESO_CC
	SELECT * INTO SENASIR.dbo.Piv_REPROCESO_CC
	FROM CC.dbo.REPROCESO_CC rc JOIN CC.dbo.CERTIFICADO c ON rc.MATRICULA = c.Matricula
	WHERE rc.TIPO_REP IN ('C','O','E','X','D','L','U','M','Y','N')
	-----------------------------------	
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD NUP INT
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD IdTipoBeneficio INT
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD IdTramite INT
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD IdGrupoBeneficio INT 
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD IdTipoTramite INT 
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD NoFormularioCalculo INT
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD IdTipoFormularioCalculo INT
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD EstadoFormCalcCC INT
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD MontoCC DECIMAL 
	ALTER TABLE SENASIR.dbo.Piv_REPROCESO_CC ADD SIP_impresion INT 
	
	--NUP
	UPDATE a SET NUP = tp.NUP, IdTramite = tp.IdTramite, IdGrupoBeneficio = tp.IdGrupoBeneficio, IdTipoTramite = tp.IdTipoTramite
	FROM SENASIR.dbo.Piv_REPROCESO_CC a JOIN SENASIR.Tramite.TramitePersona tp 
	ON a.TRAMITE = tp.NumeroTramiteCrenta

	--NoFormularioCalculo
	UPDATE a SET NoFormularioCalculo = fcc.NoFormularioCalculo, IdTipoFormularioCalculo = fcc.IdTipoFormularioCalculo
	FROM SENASIR.dbo.Piv_REPROCESO_CC a JOIN SENASIR.CertificacionCC.FormularioCalculoCC fcc 
	ON fcc.IdTramite = dbo.eliminaLetras(a.TRAMITE)
	
	--UPDATE EstadoFormCalcCC
	
	--MontoCC
	UPDATE a SET MontoCC = fcc.MontoCC
	FROM SENASIR.dbo.Piv_REPROCESO_CC a JOIN SENASIR.CertificacionCC.FormularioCalculoCC fcc 
	ON fcc.IdTramite = dbo.eliminaLetras(a.TRAMITE)
	
	--UPDATE SIP_impresion
	
	--IdTipoBeneficio
	UPDATE a SET a.IdTipoBeneficio = CASE WHEN a.BENEFICIO = 'PU' THEN 21
										  WHEN a.BENEFICIO = 'PMM' THEN 19
										  WHEN a.BENEFICIO = 'CC' AND a.TIPO_CC = 'M' THEN 16
										  WHEN a.BENEFICIO = 'CC' AND a.TIPO_CC = 'G' THEN 17
									 END
	FROM SENASIR.dbo.Piv_REPROCESO_CC a
	
	--NroFormularioRepro		
	DROP TABLE SENASIR.dbo.Piv_REPROCESO_CC_rows
	SELECT (SELECT MAX(NroFormularioRepro) FROM SENASIR.Reprocesos.ReprocesoCC) + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
	INTO SENASIR.dbo.Piv_REPROCESO_CC_rows
	FROM SENASIR.dbo.Piv_REPROCESO_CC
END


