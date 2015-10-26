ALTER PROCEDURE [dbo].[CreaPivoteReprocesos]
AS
BEGIN
	DROP TABLE dbo.Piv_REPROCESO_CC
	SELECT * INTO dbo.Piv_REPROCESO_CC
	FROM CC.dbo.REPROCESO_CC rc JOIN CC.dbo.CERTIFICADO c ON rc.MATRICULA = c.Matricula
	WHERE rc.TIPO_REP IN ('C','O','E','X','D','L','U','M','Y','N')
	-----------------------------------	
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD NUP INT
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdTipoBeneficio INT
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdTramite INT
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdGrupoBeneficio INT 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdTipoTramite INT 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdTipoReproceso INT 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdEstadoReproceso INT 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD NoFormularioCalculo INT
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD IdTipoFormularioCalculo INT
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD EstadoFormCalcCC INT
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD MontoCCAceptado DECIMAL 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD DensidadTotal DECIMAL 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD SalarioCotizableActualizadoTotal DECIMAL 
	ALTER TABLE dbo.Piv_REPROCESO_CC ADD SIP_impresion INT 
	
	--NUP
	UPDATE a SET NUP = tp.NUP, IdTramite = tp.IdTramite, IdGrupoBeneficio = tp.IdGrupoBeneficio, IdTipoTramite = tp.IdTipoTramite
	FROM dbo.Piv_REPROCESO_CC a JOIN Tramite.TramitePersona tp 
	ON a.TRAMITE = tp.NumeroTramiteCrenta

	--NoFormularioCalculo
	UPDATE a SET NoFormularioCalculo = fcc.NoFormularioCalculo, IdTipoFormularioCalculo = fcc.IdTipoFormularioCalculo
	FROM dbo.Piv_REPROCESO_CC a JOIN CertificacionCC.FormularioCalculoCC fcc 
	ON fcc.IdTramite = dbo.eliminaLetras(a.TRAMITE)
	
	--MontoCCAceptado
	UPDATE a SET MontoCCAceptado = fcc.MontoCC
	            ,SalarioCotizableActualizadoTotal = fcc.SalarioCotizableActualizadoTotal
				,DensidadTotal = fcc.DensidadTotal
	FROM dbo.Piv_REPROCESO_CC a JOIN CertificacionCC.FormularioCalculoCC fcc 
	ON fcc.IdTramite = dbo.eliminaLetras(a.TRAMITE)
		
	/*
	--IdTipoBeneficio --apunta a BeneficioOtorgado asi deberia ser
	UPDATE a SET a.IdTipoBeneficio = CASE WHEN a.BENEFICIO = 'PU' THEN 21
										  WHEN a.BENEFICIO = 'PMM' THEN 19
										  WHEN a.BENEFICIO = 'CC' AND a.TIPO_CC = 'M' THEN 16
										  WHEN a.BENEFICIO = 'CC' AND a.TIPO_CC = 'G' THEN 17
									 END
	FROM dbo.Piv_REPROCESO_CC a
	*/
	
	--IdTipoBeneficio --solucion Victor IdDetalleClasificador
	UPDATE a SET a.IdTipoBeneficio = CASE WHEN a.BENEFICIO = 'PU' THEN 31421
										  WHEN a.BENEFICIO = 'CC' THEN 31422
										  WHEN a.BENEFICIO = 'PMM' THEN 31423
									 END
	FROM dbo.Piv_REPROCESO_CC a
	
	--IdTipoReproceso
	UPDATE a SET a.IdTipoReproceso = CASE WHEN TIPO_REP = 'O' THEN 31388 
										  WHEN TIPO_REP = 'C' THEN 31383
										  WHEN TIPO_REP = 'E' THEN 31385
										  WHEN TIPO_REP = 'X' THEN 31391
										  WHEN TIPO_REP = 'D' THEN 31384
										  WHEN TIPO_REP = 'L' THEN 31386
										  WHEN TIPO_REP = 'U' THEN 31390
										  WHEN TIPO_REP = 'M' THEN 31387
										  WHEN TIPO_REP = 'Y' THEN 31513
										  WHEN TIPO_REP = 'N' THEN 31514
									 END
	FROM dbo.Piv_REPROCESO_CC a
	
	--IdEstadoReproceso
	UPDATE a SET a.IdEstadoReproceso = CASE WHEN a.ESTADO = 'K' THEN 50
											WHEN a.ESTADO = 'A' THEN 42
											WHEN a.ESTADO = 'R' THEN 1---*****completar
											WHEN a.ESTADO = 'I' THEN 47
										END
	FROM CC.dbo.REPROCESO_CC a
	
	
	--NroFormularioRepro		
	DROP TABLE dbo.Piv_REPROCESO_CC_rows
	--SELECT (SELECT MAX(NroFormularioRepro) FROM Reprocesos.ReprocesoCC) + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
	--NO se migro 266
	SELECT 0 + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
	INTO dbo.Piv_REPROCESO_CC_rows
	FROM dbo.Piv_REPROCESO_CC

	
END


