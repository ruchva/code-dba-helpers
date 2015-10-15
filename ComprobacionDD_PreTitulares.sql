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
				  ,NULL'Resolucion'
				  ,NULL'FechaResolucion'
				  ,1'RegistroActivo'
			FROM Piv_PreTitulares ppt
			WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
			EXCEPT
			SELECT pt.NUP, pt.Formulario, pt.IdTramite, pt.IdGrupoBeneficio,
			       pt.NumeroCertificado, pt.IdBeneficio, pt.AniosInsalubres,
			       pt.MontoBase, pt.ReintegroDesde, pt.ReintegroHasta,
			       pt.Reintegro, pt.Aguinaldo, pt.RedEdad, pt.MesesCNS, pt.Estado,
			       pt.Resolucion, pt.FechaResolucion, pt.RegistroActivo
			  FROM PagoU.PreTitulares pt
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT pt.NUP, pt.Formulario, pt.IdTramite, pt.IdGrupoBeneficio,
			       pt.NumeroCertificado, pt.IdBeneficio, pt.AniosInsalubres,
			       pt.MontoBase, pt.ReintegroDesde, pt.ReintegroHasta,
			       pt.Reintegro, pt.Aguinaldo, pt.RedEdad, pt.MesesCNS, pt.Estado,
			       pt.Resolucion, pt.FechaResolucion, pt.RegistroActivo
			  FROM PagoU.PreTitulares pt
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
				  ,NULL'Resolucion'
				  ,NULL'FechaResolucion'
				  ,1'RegistroActivo'
			FROM Piv_PreTitulares ppt
			WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NOT NULL
		) AS DERECHA

end