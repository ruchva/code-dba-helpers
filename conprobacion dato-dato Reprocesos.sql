--*****EN ORIGEN Y NO EN DESTINO*****--

SELECT * FROM SENARITD.dbo.Piv_REPROCESO_CC a
WHERE NOT EXISTS (SELECT * FROM SENARITD.Reprocesos.ReprocesoCC rc WHERE rc.NUP = a.NUP)
ORDER BY a.NUP

---------------------------------------
SELECT * FROM Persona.Persona p WHERE p.NUP = 57374
SELECT * FROM SENARITD.Reprocesos.ReprocesoCC rc WHERE rc.NroFormularioRepro = 1200
SELECT * FROM dbo.Piv_REPROCESO_CC_rows prcr WHERE prcr.rownumber = 1200
SELECT * FROM CC.dbo.REPROCESO_CC rc WHERE rc.NRO_FORM = 4005

---------------------------------------

--ORIGEN
SELECT prcr.rownumber AS NroFormularioRepro,CASE WHEN TIPO_REP='O' THEN '31388'
												 WHEN TIPO_REP='C' THEN '31383'
												 WHEN TIPO_REP='E' THEN '31385'
												 WHEN TIPO_REP='X' THEN '31391'
												 WHEN TIPO_REP='D' THEN '31384'
												 WHEN TIPO_REP='L' THEN '31386'
												 WHEN TIPO_REP='U' THEN '31390'
												 WHEN TIPO_REP='M' THEN '31387'
												 WHEN TIPO_REP='Y' THEN '31501'
												 WHEN TIPO_REP='N' THEN '31502'
											 END AS IdTipoReproceso,prcr.IdTipoBeneficio,NUM_RA AS NumeroResolucion,prcr.FECHA_RA AS FechaResolucion,prcr.FECHA AS FechaInicioRepro,
prcr.NUP,prcr.IdTramite,prcr.IdGrupoBeneficio,prcr.NoFormularioCalculo,prcr.IdTipoFormularioCalculo,prcr.FECHA_CALCULO AS FechaCalculo,
prcr.MontoCC,prcr.NO_CERTIF AS NroCertificado,prcr.IdTipoTramite,prcr.FECHA AS FechaCalculoRepro,prcr.FECHA_SOL AS FechaSolicitud,prcr.PAGO_CC AS PagoCC,prcr.SAL_ACT_I AS SalarioActualizadoRefI,
prcr.MONTO_CC_I AS MontoActualizadoCCI,prcr.MONTO_PU_I AS MontoActualizadoPUI, prcr.SAL_ACT_II AS SalarioActualizadoRefII,prcr.MONTO_CC_II AS MontoActualizadoCCII,prcr.MONTO_PU_II AS MontoActualizadoPUII,
1 AS IdEstadoReproceso,1 AS RegistroActivo, (SELECT IdUsuario
											 FROM   Seguridad.Usuario
											 WHERE  CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO))) AS IdUsuario
FROM Piv_REPROCESO_CC_rows prcr WHERE prcr.IdTramite IS NOT NULL AND prcr.IdTipoTramite IS NOT NULL
--DESTINO
SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio,rc.NumeroResolucion,
       rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
       rc.IdGrupoBeneficio, rc.NoFormularioCalculo,rc.IdTipoFormularioCalculo,rc.FechaCalculo, 
       rc.MontoCC,rc.NroCertificado,rc.IdTipoTramite,rc.FechaCalculoRepro,rc.FechaSolicitud, rc.PagoCC,rc.SalarioActualizadoRefI,
       rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, rc.SalarioActualizadoRefII,
       rc.MontoActualizadoCCII, rc.MontoActualizadoPUII, rc.IdEstadoReproceso,
       rc.RegistroActivo, rc.IdUsuario
FROM Reprocesos.ReprocesoCC rc

--EXCEPT AL LA UNION
SELECT 'Pivote' AS Origen,*
FROM (  SELECT prcr.rownumber AS NroFormularioRepro,CASE WHEN TIPO_REP='O' THEN '31388'
														 WHEN TIPO_REP='C' THEN '31383'
														 WHEN TIPO_REP='E' THEN '31385'
														 WHEN TIPO_REP='X' THEN '31391'
														 WHEN TIPO_REP='D' THEN '31384'
														 WHEN TIPO_REP='L' THEN '31386'
														 WHEN TIPO_REP='U' THEN '31390'
														 WHEN TIPO_REP='M' THEN '31387'
														 WHEN TIPO_REP='Y' THEN '31501'
														 WHEN TIPO_REP='N' THEN '31502'
													 END AS IdTipoReproceso,prcr.IdTipoBeneficio,NUM_RA AS NumeroResolucion,prcr.FECHA_RA AS FechaResolucion,prcr.FECHA AS FechaInicioRepro,
		prcr.NUP,prcr.IdTramite,prcr.IdGrupoBeneficio,prcr.NoFormularioCalculo,prcr.IdTipoFormularioCalculo,prcr.FECHA_CALCULO AS FechaCalculo,
		prcr.MontoCC,prcr.NO_CERTIF AS NroCertificado,prcr.IdTipoTramite,prcr.FECHA AS FechaCalculoRepro,prcr.FECHA_SOL AS FechaSolicitud,prcr.PAGO_CC AS PagoCC,prcr.SAL_ACT_I AS SalarioActualizadoRefI,
		prcr.MONTO_CC_I AS MontoActualizadoCCI,prcr.MONTO_PU_I AS MontoActualizadoPUI, prcr.SAL_ACT_II AS SalarioActualizadoRefII,prcr.MONTO_CC_II AS MontoActualizadoCCII,prcr.MONTO_PU_II AS MontoActualizadoPUII,
		1 AS IdEstadoReproceso,1 AS RegistroActivo, (SELECT IdUsuario
													 FROM   Seguridad.Usuario
													 WHERE  CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO))) AS IdUsuario
		FROM Piv_REPROCESO_CC_rows prcr WHERE prcr.IdTramite IS NOT NULL AND prcr.IdTipoTramite IS NOT NULL
		EXCEPT
		SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio,rc.NumeroResolucion,
			   rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
			   rc.IdGrupoBeneficio, rc.NoFormularioCalculo,rc.IdTipoFormularioCalculo,rc.FechaCalculo, 
			   rc.MontoCC,rc.NroCertificado,rc.IdTipoTramite,rc.FechaCalculoRepro,rc.FechaSolicitud, rc.PagoCC,rc.SalarioActualizadoRefI,
			   rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, rc.SalarioActualizadoRefII,
			   rc.MontoActualizadoCCII, rc.MontoActualizadoPUII, rc.IdEstadoReproceso,
			   rc.RegistroActivo, rc.IdUsuario
		FROM Reprocesos.ReprocesoCC rc
	) AS IZQUIERDA
UNION 
SELECT 'Destino' AS Origen,*
FROM (  SELECT rc.NroFormularioRepro, rc.IdTipoReproceso, rc.IdTipoBeneficio,rc.NumeroResolucion,
			   rc.FechaResolucion, rc.FechaInicioRepro, rc.NUP, rc.IdTramite,
			   rc.IdGrupoBeneficio, rc.NoFormularioCalculo,rc.IdTipoFormularioCalculo,rc.FechaCalculo, 
			   rc.MontoCC,rc.NroCertificado,rc.IdTipoTramite,rc.FechaCalculoRepro,rc.FechaSolicitud, rc.PagoCC,rc.SalarioActualizadoRefI,
			   rc.MontoActualizadoCCI, rc.MontoActualizadoPUI, rc.SalarioActualizadoRefII,
			   rc.MontoActualizadoCCII, rc.MontoActualizadoPUII, rc.IdEstadoReproceso,
			   rc.RegistroActivo, rc.IdUsuario
		FROM Reprocesos.ReprocesoCC rc
		EXCEPT
		SELECT prcr.rownumber AS NroFormularioRepro,CASE WHEN TIPO_REP='O' THEN '31388'
														 WHEN TIPO_REP='C' THEN '31383'
														 WHEN TIPO_REP='E' THEN '31385'
														 WHEN TIPO_REP='X' THEN '31391'
														 WHEN TIPO_REP='D' THEN '31384'
														 WHEN TIPO_REP='L' THEN '31386'
														 WHEN TIPO_REP='U' THEN '31390'
														 WHEN TIPO_REP='M' THEN '31387'
														 WHEN TIPO_REP='Y' THEN '31501'
														 WHEN TIPO_REP='N' THEN '31502'
													 END AS IdTipoReproceso,prcr.IdTipoBeneficio,NUM_RA AS NumeroResolucion,prcr.FECHA_RA AS FechaResolucion,prcr.FECHA AS FechaInicioRepro,
		prcr.NUP,prcr.IdTramite,prcr.IdGrupoBeneficio,prcr.NoFormularioCalculo,prcr.IdTipoFormularioCalculo,prcr.FECHA_CALCULO AS FechaCalculo,
		prcr.MontoCC,prcr.NO_CERTIF AS NroCertificado,prcr.IdTipoTramite,prcr.FECHA AS FechaCalculoRepro,prcr.FECHA_SOL AS FechaSolicitud,prcr.PAGO_CC AS PagoCC,prcr.SAL_ACT_I AS SalarioActualizadoRefI,
		prcr.MONTO_CC_I AS MontoActualizadoCCI,prcr.MONTO_PU_I AS MontoActualizadoPUI, prcr.SAL_ACT_II AS SalarioActualizadoRefII,prcr.MONTO_CC_II AS MontoActualizadoCCII,prcr.MONTO_PU_II AS MontoActualizadoPUII,
		1 AS IdEstadoReproceso,1 AS RegistroActivo, (SELECT IdUsuario
													 FROM   Seguridad.Usuario
													 WHERE  CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO))) AS IdUsuario
		FROM Piv_REPROCESO_CC_rows prcr WHERE prcr.IdTramite IS NOT NULL AND prcr.IdTipoTramite IS NOT NULL
	) AS DERECHA







