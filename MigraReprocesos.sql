ALTER PROCEDURE [dbo].[MigraReprocesos]
AS
BEGIN
	INSERT INTO Reprocesos.ReprocesoCC
	SELECT rownumber--NroFormularioRepro--IDENTITY
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
		   END	--IdTipoReproceso
		  ,IdTipoBeneficio---IdTipoBeneficio
		  ,NULL	---NFormTipoRepro
		  ,NUM_RA---NumeroResolucion
		  ,FECHA_RA---FechaResolucion
		  ,FECHA--FechaInicioRepro
		  ,NUP--NUP
		  ,IdTramite--IdTramite
		  ,IdGrupoBeneficio--IdGrupoBeneficio
		  ,NoFormularioCalculo--NoFormularioCalculo
		  ,IdTipoFormularioCalculo--IdTipoFormularioCalculoId
		  ,NULL--EstadoFormCalcCC---****
		  ,NULL--VerSalarioCotizable --ULTIM. VERSION SE SALARIO COTIZABLE
		  ,FECHA_CALCULO--FechaCalculo --FORM. FECHA CALCULO
		  ,MontoCC --MontoCC--
		  ,NULL--MontoCCNuevo--*
		  ,NULL--SIP_impresion--****
		  ,NULL--SIP_impresionNuevo--*
		  ,NO_CERTIF--NroCertificado
		  ,IdTipoTramite--IdTipoTramite
		  ,NULL--IdTipoCC
		  ,NULL--RegistroAPS
		  ,NULL--CursoPago
		  ,NULL--CertificadoAnulado
		  ,NULL--RegistroAPS_Baja
		  ,NULL--NroCertificadoNuevo
		  ,NULL--NumeroEnvioCertificadoNuevo
		  ,NULL--RegistroAPS_Alta
		  ,NULL--FechaNAcimiento
		  ,NULL--FechaNAcimientoNueva
		  ,NULL--Matricula
		  ,NULL--MatriculaNueva
		  ,NULL--TipoDocumento
		  ,NULL--NumeroDocumento
		  ,FECHA--FechaCalculoRepro
		  ,FECHA_SOL--FechaSolicitud
		  ,PAGO_CC--PagoCC
		  ,SAL_ACT_I--SalarioActualizadoRefI
		  ,MONTO_CC_I--MontoActualizadoCCI
		  ,MONTO_PU_I--MontoActualizadoPUI
		  ,SAL_ACT_II--SalarioActualizadoRefII
		  ,MONTO_CC_II--MontoActualizadoCCII
		  ,MONTO_PU_II--MontoActualizadoPUII
		  ,1--IdEstadoReproceso
		  ,GETDATE()--FechaCambioEstado--*CONSULTAR ORIGEN*
		  ,1--RegistroActivo
		  ,(SELECT IdUsuario
			FROM   Seguridad.Usuario
			WHERE  CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO))
		   )--IdUsuario 
	FROM   SENARITD.dbo.Piv_REPROCESO_CC_rows
	WHERE  IdTramite IS NOT NULL 
	   AND IdTipoTramite IS NOT NULL
	       
		
END