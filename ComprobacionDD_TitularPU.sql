create procedure ComprobacionDD_TitularPU as
begin

	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT ptp.Estado
	              ,ptp.NUP
	              ,ptp.IdTramite
	              ,ptp.IdGrupoBeneficio
				  ,ptp.NUM_CERTIF'NumeroCertificado'
				  ,ptp.FORMULARIO'Formulario'
				  ,ptp.ANIOS_INSALUBRES'AniosInsalubres'
				  ,ptp.FECHA_ALTA'FechaAlta'
				  ,ptp.RESOLUCION'Resolucion'				  
				  ,1'RegistroActivo'
			FROM Piv_TitularPU ptp
			WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
			EXCEPT
			SELECT tp.Estado, tp.NUP, tp.IdTramite, tp.IdGrupoBeneficio,
			       tp.NumeroCertificado, tp.Formulario, tp.AniosInsalubres,
			       tp.FechaAlta, tp.Resolucion, tp.RegistroActivo
			  FROM PagoU.TitularPU tp
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT tp.Estado, tp.NUP, tp.IdTramite, tp.IdGrupoBeneficio,
			       tp.NumeroCertificado, tp.Formulario, tp.AniosInsalubres,
			       tp.FechaAlta, tp.Resolucion, tp.RegistroActivo
			  FROM PagoU.TitularPU tp
			EXCEPT
			SELECT ptp.Estado
	              ,ptp.NUP
	              ,ptp.IdTramite
	              ,ptp.IdGrupoBeneficio
				  ,ptp.NUM_CERTIF'NumeroCertificado'
				  ,ptp.FORMULARIO'Formulario'
				  ,ptp.ANIOS_INSALUBRES'AniosInsalubres'
				  ,ptp.FECHA_ALTA'FechaAlta'
				  ,ptp.RESOLUCION'Resolucion'				  
				  ,1'RegistroActivo'
			FROM Piv_TitularPU ptp
			WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
		) AS DERECHA

end