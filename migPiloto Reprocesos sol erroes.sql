/*--adicionar dos tipos de reprocesos
select * from Clasificador.DetalleClasificador order by IdDetalleClasificador desc
INSERT INTO [Clasificador].[DetalleClasificador] ([IdDetalleClasificador], [IdTipoClasificador], [CodigoDetalleClasificador], [DescripcionDetalleClasificador], [ObservacionClasificador], [IdPadre], [IdEstadoDetalleClasificador], [RegistroActivo]) 
VALUES ('31528', '101', 'Y', 'D.S. 29194', 'NINGUNA', '0', '31', '1');
INSERT INTO [Clasificador].[DetalleClasificador] ([IdDetalleClasificador], [IdTipoClasificador], [CodigoDetalleClasificador], [DescripcionDetalleClasificador], [ObservacionClasificador], [IdPadre], [IdEstadoDetalleClasificador], [RegistroActivo]) 
VALUES ('31529', '101', 'N', 'NULL?', 'NINGUNA', '0', '31', '1');

--si no se migro 266
DROP TABLE SENASIR.dbo.Piv_REPROCESO_CC_rows
SELECT (SELECT MAX(NroFormularioRepro) FROM SENASIR.Reprocesos.ReprocesoCC) + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
SELECT 0 + ROW_NUMBER() OVER (ORDER BY TRAMITE DESC) AS rownumber, *
INTO SENASIR.dbo.Piv_REPROCESO_CC_rows
FROM SENASIR.dbo.Piv_REPROCESO_CC

*/
INSERT INTO Reprocesos.ReprocesoCC
SELECT rownumber--NroFormularioRepro--IDENTITY
		,IdTipoReproceso---IdTipoReproceso
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
		--nuevos campos identificados en la piloto 2
		,MontoCCAceptado --MontoCCAceptado --MontoCC
		,null --MontoCCAceptadoNuevo--MontoCCNuevo 
		,SalarioCotizableActualizadoTotal --SalarioCotizableActualizadoTotal
		,null --SalarioCotizableATotalNuevo
		,DensidadTotal --DensidadTotal
		,null --DensidadTotalNuevo
		--
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
		,IdEstadoReproceso
		,FECHA--FechaCambioEstado
		,1--RegistroActivo
		,(SELECT IdUsuario
		FROM   Seguridad.Usuario
		WHERE  CuentaUsuario = UPPER(dbo.eliminaSENASIR(USUARIO))
		)--IdUsuario 
FROM   dbo.Piv_REPROCESO_CC_rows
WHERE  IdTramite IS NOT NULL 
	AND IdTipoTramite IS NOT NULL
	and IdTipoBeneficio is not null


--SELECT COUNT(*) FROM Piv_REPROCESO_CC_rows prcr
--SELECT COUNT(*) FROM Reprocesos.ReprocesoCC rc





