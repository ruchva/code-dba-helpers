create procedure ComprobacionDD_Reprocesos as
begin
	
	SELECT 'Pivote' AS Origen,*
	INTO #temp_reprocesos_QC
	FROM (  SELECT p.rownumber'NroFormularioRepro'
				   ,p.IdTipoReproceso
				   ,p.IdTipoBeneficio
				   ,p.NUM_RA'NumeroResolucion'
				   ,p.FECHA_RA'FechaResolucion'
				   ,p.FECHA'FechaInicioRepro'
				   ,p.NUP
				   ,p.IdTramite
				   ,p.IdGrupoBeneficio
				   ,p.NoFormularioCalculo
				   ,p.IdTipoFormularioCalculo
				   ,p.FECHA_CALCULO'FechaCalculo'				   
				   ,p.MontoCCAceptado
				   ,p.SalarioCotizableActualizadoTotal
				   ,p.DensidadTotal				   
				   ,p.NO_CERTIF'NroCertificado'
				   ,p.IdTipoTramite
				   ,p.FECHA'FechaCalculoRepro'
				   ,p.FECHA_SOL'FechaSolicitud'
				   ,p.PAGO_CC'PagoCC'
				   ,p.SAL_ACT_I'SalarioActualizadoRefI'
				   ,p.MONTO_CC_I'MontoActualizadoCCI'
				   ,p.MONTO_PU_I'MontoActualizadoPUI'
				   ,p.SAL_ACT_II'SalarioActualizadoRefII'
				   ,p.MONTO_CC_II'MontoActualizadoCCII'
				   ,p.MONTO_PU_II'MontoActualizadoPUII'
				   ,p.FECHA'FechaCambioEstado'
				   ,(SELECT IdUsuario FROM Seguridad.Usuario WHERE CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO)))'IdUsuario'
			FROM Piv_REPROCESO_CC_rows p 
			WHERE p.IdTramite IS NOT NULL AND p.IdTipoTramite IS NOT NULL
			EXCEPT
			SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio, rc.NumeroResolucion, rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
				   rc.IdGrupoBeneficio, rc.NoFormularioCalculo, rc.IdTipoFormularioCalculo, rc.FechaCalculo, rc.MontoCCAceptado, rc.SalarioCotizableActualizadoTotal, rc.DensidadTotal,
				   rc.NroCertificado, rc.IdTipoTramite, rc.FechaCalculoRepro, rc.FechaSolicitud, rc.PagoCC, rc.SalarioActualizadoRefI, rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, 
				   rc.SalarioActualizadoRefII, rc.MontoActualizadoCCII, rc.MontoActualizadoPUII, rc.FechaCambioEstado, rc.IdUsuario
			FROM Reprocesos.ReprocesoCC rc
			WHERE IdTipoReproceso <> 31389
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio, rc.NumeroResolucion, rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
				   rc.IdGrupoBeneficio, rc.NoFormularioCalculo, rc.IdTipoFormularioCalculo, rc.FechaCalculo, rc.MontoCCAceptado, rc.SalarioCotizableActualizadoTotal, rc.DensidadTotal,
				   rc.NroCertificado, rc.IdTipoTramite, rc.FechaCalculoRepro, rc.FechaSolicitud, rc.PagoCC, rc.SalarioActualizadoRefI, rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, 
				   rc.SalarioActualizadoRefII, rc.MontoActualizadoCCII, rc.MontoActualizadoPUII, rc.FechaCambioEstado, rc.IdUsuario
			FROM Reprocesos.ReprocesoCC rc
			WHERE IdTipoReproceso <> 31389
			EXCEPT
			SELECT p.rownumber'NroFormularioRepro'
				   ,p.IdTipoReproceso
				   ,p.IdTipoBeneficio
				   ,p.NUM_RA'NumeroResolucion'
				   ,p.FECHA_RA'FechaResolucion'
				   ,p.FECHA'FechaInicioRepro'
				   ,p.NUP
				   ,p.IdTramite
				   ,p.IdGrupoBeneficio
				   ,p.NoFormularioCalculo
				   ,p.IdTipoFormularioCalculo
				   ,p.FECHA_CALCULO'FechaCalculo'				   
				   ,p.MontoCCAceptado
				   ,p.SalarioCotizableActualizadoTotal
				   ,p.DensidadTotal				   
				   ,p.NO_CERTIF'NroCertificado'
				   ,p.IdTipoTramite
				   ,p.FECHA'FechaCalculoRepro'
				   ,p.FECHA_SOL'FechaSolicitud'
				   ,p.PAGO_CC'PagoCC'
				   ,p.SAL_ACT_I'SalarioActualizadoRefI'
				   ,p.MONTO_CC_I'MontoActualizadoCCI'
				   ,p.MONTO_PU_I'MontoActualizadoPUI'
				   ,p.SAL_ACT_II'SalarioActualizadoRefII'
				   ,p.MONTO_CC_II'MontoActualizadoCCII'
				   ,p.MONTO_PU_II'MontoActualizadoPUII'
				   ,p.FECHA'FechaCambioEstado'
				   ,(SELECT IdUsuario FROM Seguridad.Usuario WHERE CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO)))'IdUsuario'
			FROM Piv_REPROCESO_CC_rows p 
			WHERE p.IdTramite IS NOT NULL AND p.IdTipoTramite IS NOT NULL
		) AS DERECHA

	
	IF (SELECT COUNT(*) FROM #temp_reprocesos_QC) = 0
	BEGIN
		PRINT 'TABLAS: ReprocesoCC - REPROCESO_CC'
		PRINT 'NO EXISTEN INCONSISTENCIAS EN LOS DATOS ORIGEN Y DESTINO' 
		PRINT '--------------------------------------------------------'
		DROP TABLE #temp_reprocesos_QC
	END			
	ELSE
	BEGIN
	    SELECT * FROM #temp_reprocesos_QC
	END 
	
	
	
	
end