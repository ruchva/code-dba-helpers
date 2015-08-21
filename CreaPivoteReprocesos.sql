ALTER PROCEDURE dbo.CreaPivoteReprocesos
AS
BEGIN
	DROP TABLE SENARITD.dbo.Piv_REPROCESO_CC
	SELECT * INTO SENARITD.dbo.Piv_REPROCESO_CC
	FROM CC.dbo.REPROCESO_CC rc JOIN CC.dbo.CERTIFICADO c ON rc.MATRICULA = c.Matricula
	WHERE rc.TIPO_REP IN ('C')
	-----------------------------------	
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD NUP INT
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD IdTipoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD IdGrupoBeneficio INT 
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD IdTipoTramite INT 
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD NoFormularioCalculo INT
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD IdTipoFormularioCalculo INT
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD EstadoFormCalcCC INT
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD MontoCC DECIMAL 
	ALTER TABLE SENARITD.dbo.Piv_REPROCESO_CC ADD SIP_impresion INT 
	
	UPDATE a SET NUP = tp.NUP, IdTramite = tp.IdTramite, IdGrupoBeneficio = tp.IdGrupoBeneficio, IdTipoTramite = tp.IdTipoTramite
	FROM SENARITD.dbo.Piv_REPROCESO_CC a JOIN SENARITD.Tramite.TramitePersona tp 
	ON a.TRAMITE = tp.NumeroTramiteCrenta

	UPDATE a SET NoFormularioCalculo = fcc.NoFormularioCalculo, IdTipoFormularioCalculo = fcc.IdTipoFormularioCalculo
	FROM SENARITD.dbo.Piv_REPROCESO_CC a JOIN SENARITD.CertificacionCC.FormularioCalculoCC fcc 
	ON fcc.IdTramite = dbo.eliminaLetras(a.TRAMITE)
	
	--UPDATE EstadoFormCalcCC
	
	UPDATE a SET MontoCC = fcc.MontoCC
	FROM SENARITD.dbo.Piv_REPROCESO_CC a JOIN SENARITD.CertificacionCC.FormularioCalculoCC fcc 
	ON fcc.IdTramite = dbo.eliminaLetras(a.TRAMITE)
	
	--UPDATE SIP_impresion
	
	UPDATE a SET a.IdTipoBeneficio = CASE WHEN a.BENEFICIO = 'PU' THEN 21
										  WHEN a.BENEFICIO = 'PMM' THEN 19
										  WHEN a.BENEFICIO = 'CC' AND a.TIPO_CC = 'M' THEN 16
										  WHEN a.BENEFICIO = 'CC' AND a.TIPO_CC = 'G' THEN 17
									 END
	FROM SENARITD.dbo.Piv_REPROCESO_CC a
			
	DROP TABLE SENARITD.dbo.Piv_REPROCESO_CC_rows
	SELECT (SELECT MAX(NroFormularioRepro) FROM SENARITD.Reprocesos.ReprocesoCC) + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
	INTO SENARITD.dbo.Piv_REPROCESO_CC_rows
	FROM SENARITD.dbo.Piv_REPROCESO_CC
END


