/*--adicionar dos tipos de reprocesos
select * from Clasificador.DetalleClasificador order by IdDetalleClasificador desc
INSERT INTO [Clasificador].[DetalleClasificador] ([IdDetalleClasificador], [IdTipoClasificador], [CodigoDetalleClasificador], [DescripcionDetalleClasificador], [ObservacionClasificador], [IdPadre], [IdEstadoDetalleClasificador], [RegistroActivo]) VALUES ('31528', '101', 'Y', 'D.S. 29194', 'NINGUNA', '0', '31', '1');
INSERT INTO [Clasificador].[DetalleClasificador] ([IdDetalleClasificador], [IdTipoClasificador], [CodigoDetalleClasificador], [DescripcionDetalleClasificador], [ObservacionClasificador], [IdPadre], [IdEstadoDetalleClasificador], [RegistroActivo]) VALUES ('31529', '101', 'N', 'NULL?', 'NINGUNA', '0', '31', '1');

--si no se migro 266
DROP TABLE SENASIR.dbo.Piv_REPROCESO_CC_rows
SELECT (SELECT MAX(NroFormularioRepro) FROM SENASIR.Reprocesos.ReprocesoCC) + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
SELECT 0 + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
INTO SENASIR.dbo.Piv_REPROCESO_CC_rows
FROM SENASIR.dbo.Piv_REPROCESO_CC

corregir antes el FK IdTipoBeneficio que apunta a DetalleClasificador y no existe el ID 16
redireccionar a BeneficioOtorgado

la recomendacion de Victor es:
SELECT * FROM Clasificador.TipoClasificador WHERE IdTipoClasificador=105
SELECT * FROM Clasificador.DetalleClasificador WHERE IdTipoClasificador=105

hay que actualizar los IdTipoBeneficio en el pivote de la siguiente forma
--IdTipoBeneficio --solucion Victor IdDetalleClasificador
	UPDATE a SET a.IdTipoBeneficio = CASE WHEN a.BENEFICIO = 'PU' THEN 31421
										  WHEN a.BENEFICIO = 'PMM' THEN 31423
										  WHEN a.BENEFICIO = 'CC' THEN 31422
									 END
	FROM dbo.Piv_REPROCESO_CC a

select * from Reprocesos.ReprocesoCC
*/
INSERT INTO Reprocesos.ReprocesoCC
SELECT rownumber--NroFormularioRepro--IDENTITY
		,CASE WHEN TIPO_REP = 'O' THEN 31388 
			  WHEN TIPO_REP = 'C' THEN 31383
			  WHEN TIPO_REP = 'E' THEN 31385
			  WHEN TIPO_REP = 'X' THEN 31391
			  WHEN TIPO_REP = 'D' THEN 31384
			  WHEN TIPO_REP = 'L' THEN 31386
			  WHEN TIPO_REP = 'U' THEN 31390
			  WHEN TIPO_REP = 'M' THEN 31387
			  WHEN TIPO_REP = 'Y' THEN 31513
			  WHEN TIPO_REP = 'N' THEN 31514
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
		,NULL--EstadoFormCalcCC ---***COMPLETAR DESPUES DE MIGRAR *CompletaReprocesos
		,NULL--VerSalarioCotizable 
		,FECHA_CALCULO--FechaCalculo 
		,MontoCC --MontoCC
		,NULL--MontoCCNuevo 
		,NULL--SIP_impresion ---***COMPLETAR DESPUES DE MIGRAR *CompletaReprocesos
		,NULL--SIP_impresionNuevo 
		,NO_CERTIF--NroCertificado ---***VERIFICAR CORRESPONDENCIA CON CertificadoCC
		,IdTipoTramite--IdTipoTramite
		,NULL--IdTipoCC
		,NULL--RegistroAPS
		,NULL--CursoPago
		,NULL--CertificadoAnulado
		,NULL--RegistroAPS_Baja
		,NULL--NroCertificadoNuevo
		,NULL--NumeroEnvioCertificadoNuevo
		,NULL--RegistroAPS_Alta
		--,NULL--FechaNAcimiento
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
		,NULL--FechaNAcimiento
		,MONTO_CC_II--MontoActualizadoCCII
		,MONTO_PU_II--MontoActualizadoPUII
		,1--IdEstadoReproceso
		,GETDATE()--FechaCambioEstado ---***CONSULTAR ORIGEN DE ESTE CAMPO
		,1--RegistroActivo
		,(SELECT IdUsuario
		FROM   Seguridad.Usuario
		WHERE  CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO))
		)--IdUsuario 
FROM   dbo.Piv_REPROCESO_CC_rows
WHERE  IdTramite IS NOT NULL 
	AND IdTipoTramite IS NOT NULL
	and IdTipoBeneficio is not null








