create procedure ComprobacionDD_PreBeneficiarios as
BEGIN
	
	SELECT 'Pivote' AS Origen,*
	INTO #temp_pre_beneficiarios_QC
	FROM (  SELECT 
	               ptp.NUP'NUPTitular'
	              ,ptp.NUPDH
	              ,ptp.FORMULARIO'Formulario'
	              ,ptp.IdTramite
	              ,ptp.IdGrupoBeneficio
	              ,ptp.ClaseBeneficio
	              ,ptp.PORCENTAJE'Porcentaje'
	              ,ptp.RED_DH'RedDH'
	              ,ptp.Parentesco
	              ,ptp.Estado
	              ,1'RegistroActivo'
			FROM Piv_PreBeneficiarios ptp
			WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
			EXCEPT
			SELECT pb.NUPTitular, pb.NUPDH, pb.Formulario, pb.IdTramite,
			       pb.IdGrupoBeneficio, pb.ClaseBeneficio, pb.Porcentaje, pb.RedDH,
			       pb.Parentesco, pb.Estado, pb.RegistroActivo
			  FROM PagoU.PreBeneficiarios pb
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT pb.NUPTitular, pb.NUPDH, pb.Formulario, pb.IdTramite,
			       pb.IdGrupoBeneficio, pb.ClaseBeneficio, pb.Porcentaje, pb.RedDH,
			       pb.Parentesco, pb.Estado, pb.RegistroActivo
			  FROM PagoU.PreBeneficiarios pb
			EXCEPT
			SELECT 
	               ptp.NUP'NUPTitular'
	              ,ptp.NUPDH
	              ,ptp.FORMULARIO'Formulario'
	              ,ptp.IdTramite
	              ,ptp.IdGrupoBeneficio
	              ,ptp.ClaseBeneficio
	              ,ptp.PORCENTAJE'Porcentaje'
	              ,ptp.RED_DH'RedDH'
	              ,ptp.Parentesco
	              ,ptp.Estado
	              ,1'RegistroActivo'
			FROM Piv_PreBeneficiarios ptp
			WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL
		) AS DERECHA
	
	IF (SELECT COUNT(*) FROM #temp_pre_beneficiarios_QC) = 0
	BEGIN
		PRINT 'TABLAS: PreBeneficiarios - Pre_Beneficiarios'
		PRINT 'NO EXISTEN INCONSISTENCIAS EN LOS DATOS ORIGEN Y DESTINO' 
		PRINT '--------------------------------------------------------'
		DROP TABLE #temp_pre_beneficiarios_QC
	END			
	ELSE
	BEGIN
	    SELECT * FROM #temp_pre_beneficiarios_QC
	END 
	
	
end