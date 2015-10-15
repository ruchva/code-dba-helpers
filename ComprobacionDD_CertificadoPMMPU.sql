create procedure ComprobacionDD_CertificadoPMMPU as
begin

	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT a.NUP
	              ,a.IdTramite
				  ,a.IdGrupoBeneficio
				  ,a.no_certif'NumeroCertificado'
				  ,a.doc'Documento'
				  ,a.fecha_emi'FechaEmision'
				  ,a.tipo_cambio'TipoCambio'
				  ,a.monto'Monto'
				  ,a.IdBeneficio
				  ,a.Tipo_PP'TipoPP'
				  ,a.EstadoM'Estado'
				  ,1'RegistroActivo'
			FROM Piv_CERTIF_PMM_PU a
			WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
			EXCEPT
			SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.TipoCambio,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.RegistroActivo
			FROM PagoU.CertificadoPMMPU b	
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT b.NUP,b.IdTramite,b.IdGrupoBeneficio,b.NumeroCertificado,b.Documento,b.FechaEmision,b.TipoCambio,b.Monto,b.IdBeneficio,b.TipoPP,b.Estado,b.RegistroActivo
			FROM PagoU.CertificadoPMMPU b
			EXCEPT
			SELECT a.NUP
	              ,a.IdTramite
				  ,a.IdGrupoBeneficio
				  ,a.no_certif'NumeroCertificado'
				  ,a.doc'Documento'
				  ,a.fecha_emi'FechaEmision'
				  ,a.tipo_cambio'TipoCambio'
				  ,a.monto'Monto'
				  ,a.IdBeneficio
				  ,a.Tipo_PP'TipoPP'
				  ,a.EstadoM'Estado'
				  ,1'RegistroActivo'
			FROM Piv_CERTIF_PMM_PU a
			WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NOT NULL
		) AS DERECHA


end