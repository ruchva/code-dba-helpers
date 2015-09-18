create procedure ComprobacionDD_PreTitulares as
begin

	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT ppt.NUP
	              ,ppt.FORMULARIO'Formulario'
				  ,ppt.IdTramite
				  ,ppt.IdGrupoBeneficio
				  ,ppt.NUM_CERTIF'NumeroCertificado'
				  ,ppt.IdBeneficio
				  ,ppt.ANIOS_INSALUBRES'AniosInsalubres'
				  ,ppt.MONTO_BASE'MontoBase'
				  ,ppt.REINTEGRO_DESDE'ReintegroDesde'
				  ,ppt.REINTEGRO_HASTA'ReintegroHasta'
				  ,ppt.REINTEGRO'Reintegro'
				  ,ppt.AGUINALDO'Aguinaldo'
				  ,ppt.RED_EDAD'RedEdad'
				  ,ppt.MESES_CNS'MesesCNS'
				  ,ppt.Estado
				  ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
				  ,1'RegistroActivo'
				  ,NULL'Resolucion'
				  ,NULL'FechaResolucion'
			FROM Piv_PreTitulares ppt
			WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
			EXCEPT
			SELECT * FROM PagoU.PreTitulares pt
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT * FROM PagoU.PreTitulares pt		
			EXCEPT
			SELECT ppt.NUP
	              ,ppt.FORMULARIO'Formulario'
				  ,ppt.IdTramite
				  ,ppt.IdGrupoBeneficio
				  ,ppt.NUM_CERTIF'NumeroCertificado'
				  ,ppt.IdBeneficio
				  ,ppt.ANIOS_INSALUBRES'AniosInsalubres'
				  ,ppt.MONTO_BASE'MontoBase'
				  ,ppt.REINTEGRO_DESDE'ReintegroDesde'
				  ,ppt.REINTEGRO_HASTA'ReintegroHasta'
				  ,ppt.REINTEGRO'Reintegro'
				  ,ppt.AGUINALDO'Aguinaldo'
				  ,ppt.RED_EDAD'RedEdad'
				  ,ppt.MESES_CNS'MesesCNS'
				  ,ppt.Estado
				  ,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC)'Version'
				  ,1'RegistroActivo'
				  ,NULL'Resolucion'
				  ,NULL'FechaResolucion'
			FROM Piv_PreTitulares ppt
			WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
		) AS DERECHA

end