create procedure ComprobacionDD_TitularPU as
begin

	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT ptp.NUP,ptp.IdTramite
	              ,ptp.IdGrupoBeneficio
				  ,ptp.NUM_CERTIF'NumeroCertificado'
				  ,ptp.FORMULARIO'Formulario'
				  ,ptp.ANIOS_INSALUBRES'AniosInsalubres'
				  ,ptp.FECHA_ALTA'FechaAlta'
				  ,ptp.RESOLUCION'Resolucion'
				  ,ptp.Estado
				  ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
				  ,1'RegistroActivo'
			FROM Piv_TitularPU ptp
			WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
			EXCEPT
			SELECT * FROM PagoU.TitularPU tp
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT * FROM PagoU.TitularPU tp	
			EXCEPT
			SELECT ptp.NUP,ptp.IdTramite
	              ,ptp.IdGrupoBeneficio
				  ,ptp.NUM_CERTIF'NumeroCertificado'
				  ,ptp.FORMULARIO'Formulario'
				  ,ptp.ANIOS_INSALUBRES'AniosInsalubres'
				  ,ptp.FECHA_ALTA'FechaAlta'
				  ,ptp.RESOLUCION'Resolucion'
				  ,ptp.Estado
				  ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
				  ,1'RegistroActivo'
			FROM Piv_TitularPU ptp
			WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
		) AS DERECHA

end