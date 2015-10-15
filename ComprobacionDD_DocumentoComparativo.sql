create procedure ComprobacionDD_DocumentoComparativo as
begin

		SELECT 'Pivote' AS Origen,*
		FROM (  SELECT pdc.IdTramite
					  ,pdc.IdGrupoBeneficio
					  ,pdc.COMPONENTE'Componente'
					  ,pdc.NUP
					  ,pdc.IdSector
					  ,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion'
					  ,pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion'
					  ,pdc.DENSIDAD'Densidad'
					  ,pdc.SALARIO_COTIZABLE'SalarioCotizable'
					  ,pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual'
					  ,pdc.FECHA_CALCULO'FechaCalculo'
					  ,pdc.FECHA_EMISION'FechaEmision'
					  ,pdc.TIPO_CAMBIO'TipoCambio'				  
					  ,pdc.MONTO_CC'MontoCC'
					  ,pdc.MONTO_PMM'MontoPMM'
					  ,pdc.MONTO_PU'MontoPU'				  
					  ,pdc.APORTES_AFP'AportesAFP'
					  ,pdc.NRO_DOCUMENTO'NumeroDocumento'
					  ,pdc.IdBeneficio
					  ,pdc.FECHA_SELECCION'FechaSeleccion'
					  ,pdc.SALUD'Salud'
					  ,pdc.NRO_MESES'NumeroMeses'
					  ,pdc.INTERIOR_MINA'InteriorMina'
					  ,pdc.FECHA_PROCESO'FechaProcesos'
					  ,pdc.NRO_MINA'NumeroMina'
					  ,pdc.TRAB_SIM'TrabajosSimultaneos'
					  ,NULL'Descuento8porciento'
					  ,pdc.EstadoM'Estado'
					  ,1'RegistroActivo'				   
				FROM Piv_DOC_COMPARATIVO pdc
				WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL and pdc.EstadoM is not null
				EXCEPT
				SELECT dc.IdTramite, dc.IdGrupoBeneficio, dc.Componente, dc.NUP,
					   dc.IdSector, dc.PrimeraFechaAfiliacion,
					   dc.UltimaFechaAfiliacion, dc.Densidad, dc.SalarioCotizable,
					   dc.SalarioCotizableActual, dc.FechaCalculo, dc.FechaEmision,
					   dc.TipoCambio, dc.MontoCC, dc.MontoPMM, dc.MontoPU,
					   dc.AportesAFP, dc.NumeroDocumento, dc.IdBeneficio,
					   dc.FechaSeleccion, dc.Salud, dc.NumeroMeses, dc.InteriorMina,
					   dc.FechaProceso, dc.NumeroMina, dc.TrabajosSimultaneos,
					   dc.Descuento8porciento, dc.Estado, dc.RegistroActivo
				FROM PagoU.DocumentoComparativo dc	
			) AS IZQUIERDA
		UNION 
		SELECT 'Destino' AS Origen,*
		FROM (  SELECT dc.IdTramite, dc.IdGrupoBeneficio, dc.Componente, dc.NUP,
					   dc.IdSector, dc.PrimeraFechaAfiliacion,
					   dc.UltimaFechaAfiliacion, dc.Densidad, dc.SalarioCotizable,
					   dc.SalarioCotizableActual, dc.FechaCalculo, dc.FechaEmision,
					   dc.TipoCambio, dc.MontoCC, dc.MontoPMM, dc.MontoPU,
					   dc.AportesAFP, dc.NumeroDocumento, dc.IdBeneficio,
					   dc.FechaSeleccion, dc.Salud, dc.NumeroMeses, dc.InteriorMina,
					   dc.FechaProceso, dc.NumeroMina, dc.TrabajosSimultaneos,
					   dc.Descuento8porciento, dc.Estado, dc.RegistroActivo
				FROM PagoU.DocumentoComparativo dc		
				EXCEPT
				SELECT pdc.IdTramite
					  ,pdc.IdGrupoBeneficio
					  ,pdc.COMPONENTE'Componente'
					  ,pdc.NUP
					  ,pdc.IdSector
					  ,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion'
					  ,pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion'
					  ,pdc.DENSIDAD'Densidad'
					  ,pdc.SALARIO_COTIZABLE'SalarioCotizable'
					  ,pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual'
					  ,pdc.FECHA_CALCULO'FechaCalculo'
					  ,pdc.FECHA_EMISION'FechaEmision'
					  ,pdc.TIPO_CAMBIO'TipoCambio'				  
					  ,pdc.MONTO_CC'MontoCC'
					  ,pdc.MONTO_PMM'MontoPMM'
					  ,pdc.MONTO_PU'MontoPU'				  
					  ,pdc.APORTES_AFP'AportesAFP'
					  ,pdc.NRO_DOCUMENTO'NumeroDocumento'
					  ,pdc.IdBeneficio
					  ,pdc.FECHA_SELECCION'FechaSeleccion'
					  ,pdc.SALUD'Salud'
					  ,pdc.NRO_MESES'NumeroMeses'
					  ,pdc.INTERIOR_MINA'InteriorMina'
					  ,pdc.FECHA_PROCESO'FechaProcesos'
					  ,pdc.NRO_MINA'NumeroMina'
					  ,pdc.TRAB_SIM'TrabajosSimultaneos'
					  ,NULL'Descuento8porciento'
					  ,pdc.EstadoM'Estado'
					  ,1'RegistroActivo'				   
				FROM Piv_DOC_COMPARATIVO pdc
				WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL and pdc.EstadoM is not null
			) AS DERECHA

end