create procedure ComprobacionDD_DocumentoComparativo as
begin

	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT pdc.IdTramite
	              ,pdc.IdGrupoBeneficio
				  ,pdc.COMPONENTE'Componente'
				  ,pdc.NUP
				  ,pdc.MONTO_CC'MontoCC'
				  ,pdc.MONTO_PMM'MontoPMM'
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
				  ,pdc.ESTADO'Estado'
				  ,pdc.MONTO_PU'MontoPU'
				  ,pdc.IdSector
				  ,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion'
				  ,pdc.DENSIDAD'Densidad'
				  ,pdc.SALARIO_COTIZABLE'SalarioCotizable'
				  ,pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual'
				  ,pdc.FECHA_CALCULO'FechaCalculo'
				  ,pdc.FECHA_EMISION'FechaEmision'
				  ,pdc.TIPO_CAMBIO'TipoCambio'
				  --,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
				  ,1'RegistroActivo'
				  ,pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion' 
			FROM Piv_DOC_COMPARATIVO pdc
			WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL and pdc.EstadoM is not null
			EXCEPT
			SELECT d.IdTramite,d.IdGrupoBeneficio,d.Componente,d.NUP,d.MontoCC,d.MontoPMM,d.AportesAFP,d.NumeroDocumento,d.IdBeneficio,d.FechaSeleccion,d.Salud,d.NumeroMeses,d.InteriorMina,
				   d.FechaProceso,d.NumeroMina,d.TrabajosSimultaneos,d.Descuento8porciento,d.Estado,d.MontoPU,d.IdSector,d.PrimeraFechaAfiliacion,d.Densidad,d.SalarioCotizable,d.SalarioCotizableActual,
				   d.FechaCalculo,d.FechaEmision,d.TipoCambio,d.RegistroActivo,d.UltimaFechaAfiliacion 
			FROM PagoU.DocumentoComparativo dc	
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT d.IdTramite,d.IdGrupoBeneficio,d.Componente,d.NUP,d.MontoCC,d.MontoPMM,d.AportesAFP,d.NumeroDocumento,d.IdBeneficio,d.FechaSeleccion,d.Salud,d.NumeroMeses,d.InteriorMina,
				   d.FechaProceso,d.NumeroMina,d.TrabajosSimultaneos,d.Descuento8porciento,d.Estado,d.MontoPU,d.IdSector,d.PrimeraFechaAfiliacion,d.Densidad,d.SalarioCotizable,d.SalarioCotizableActual,
				   d.FechaCalculo,d.FechaEmision,d.TipoCambio,d.RegistroActivo,d.UltimaFechaAfiliacion 
			FROM PagoU.DocumentoComparativo dc	
			EXCEPT
			SELECT pdc.IdTramite
	              ,pdc.IdGrupoBeneficio
				  ,pdc.COMPONENTE'Componente'
				  ,pdc.NUP
				  ,pdc.MONTO_CC'MontoCC'
				  ,pdc.MONTO_PMM'MontoPMM'
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
				  ,pdc.ESTADO'Estado'
				  ,pdc.MONTO_PU'MontoPU'
				  ,pdc.IdSector
				  ,pdc.PRIMERA_FEC_AFILIA'PrimeraFechaAfiliacion'
				  ,pdc.DENSIDAD'Densidad'
				  ,pdc.SALARIO_COTIZABLE'SalarioCotizable'
				  ,pdc.SALARIO_COTIZABLE_ACT'SalarioCotizableActual'
				  ,pdc.FECHA_CALCULO'FechaCalculo'
				  ,pdc.FECHA_EMISION'FechaEmision'
				  ,pdc.TIPO_CAMBIO'TipoCambio'
				  --,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
				  ,1'RegistroActivo'
				  ,pdc.ULTIMA_FEC_AFILIA'UltimaFechaAfiliacion' 
			FROM Piv_DOC_COMPARATIVO pdc
			WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL and pdc.EstadoM is not null
		) AS DERECHA

end