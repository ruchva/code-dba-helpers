create procedure ComprobacionDD_Reprocesos as
begin
	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT p.rownumber'NroFormularioRepro'
				  ,CASE WHEN TIPO_REP='O' THEN '31388'
						WHEN TIPO_REP='C' THEN '31383'
						WHEN TIPO_REP='E' THEN '31385'
						WHEN TIPO_REP='X' THEN '31391'
						WHEN TIPO_REP='D' THEN '31384'
						WHEN TIPO_REP='L' THEN '31386'
						WHEN TIPO_REP='U' THEN '31390'
						WHEN TIPO_REP='M' THEN '31387'
						WHEN TIPO_REP='Y' THEN '31501'
						WHEN TIPO_REP='N' THEN '31502'
					END'IdTipoReproceso'
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
				   ,p.MontoCC
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
				   ,1'IdEstadoReproceso'
				   ,1'RegistroActivo'
				   ,(SELECT IdUsuario FROM Seguridad.Usuario WHERE CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO)))'IdUsuario'
			FROM Piv_REPROCESO_CC_rows p 
			WHERE p.IdTramite IS NOT NULL AND p.IdTipoTramite IS NOT NULL
			EXCEPT
			SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio, rc.NumeroResolucion, rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
				   rc.IdGrupoBeneficio, rc.NoFormularioCalculo, rc.IdTipoFormularioCalculo, rc.FechaCalculo, rc.MontoCC, rc.NroCertificado, rc.IdTipoTramite, rc.FechaCalculoRepro,
				   rc.FechaSolicitud, rc.PagoCC, rc.SalarioActualizadoRefI, rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, rc.SalarioActualizadoRefII, rc.MontoActualizadoCCII, 
				   rc.MontoActualizadoPUII, rc.IdEstadoReproceso, rc.RegistroActivo, rc.IdUsuario
			FROM Reprocesos.ReprocesoCC rc
			WHERE IdTipoReproceso <> 31389
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio, rc.NumeroResolucion, rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
				   rc.IdGrupoBeneficio, rc.NoFormularioCalculo, rc.IdTipoFormularioCalculo, rc.FechaCalculo, rc.MontoCC, rc.NroCertificado, rc.IdTipoTramite, rc.FechaCalculoRepro,
				   rc.FechaSolicitud, rc.PagoCC, rc.SalarioActualizadoRefI, rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, rc.SalarioActualizadoRefII, rc.MontoActualizadoCCII, 
				   rc.MontoActualizadoPUII, rc.IdEstadoReproceso, rc.RegistroActivo, rc.IdUsuario
			FROM Reprocesos.ReprocesoCC rc
			WHERE IdTipoReproceso <> 31389
			EXCEPT
			SELECT p.rownumber'NroFormularioRepro'
				  ,CASE WHEN TIPO_REP='O' THEN '31388'
						WHEN TIPO_REP='C' THEN '31383'
						WHEN TIPO_REP='E' THEN '31385'
						WHEN TIPO_REP='X' THEN '31391'
						WHEN TIPO_REP='D' THEN '31384'
						WHEN TIPO_REP='L' THEN '31386'
						WHEN TIPO_REP='U' THEN '31390'
						WHEN TIPO_REP='M' THEN '31387'
						WHEN TIPO_REP='Y' THEN '31501'
						WHEN TIPO_REP='N' THEN '31502'
					END'IdTipoReproceso'
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
				   ,p.MontoCC
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
				   ,1'IdEstadoReproceso'
				   ,1'RegistroActivo'
				   ,(SELECT IdUsuario FROM Seguridad.Usuario WHERE CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO)))'IdUsuario'
			FROM Piv_REPROCESO_CC_rows p 
			WHERE p.IdTramite IS NOT NULL AND p.IdTipoTramite IS NOT NULL
		) AS DERECHA

end