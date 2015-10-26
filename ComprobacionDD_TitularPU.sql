create procedure ComprobacionDD_TitularPU as
begin

	SELECT 'Pivote' AS Origen,*
	INTO #temp_titular_pu_QC
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
	
	IF (SELECT COUNT(*) FROM #temp_titular_pu_QC) = 0
	BEGIN
		PRINT 'TABLAS: TitularPU - Titular_PU'
		PRINT 'NO EXISTEN INCONSISTENCIAS EN LOS DATOS ORIGEN Y DESTINO' 
		PRINT '--------------------------------------------------------'
		DROP TABLE #temp_titular_pu_QC
	END			
	ELSE
	BEGIN
	    SELECT * FROM #temp_titular_pu_QC
	END 
	
	
end