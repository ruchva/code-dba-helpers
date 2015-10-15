create procedure ComprobacionDD_ChequePU as
begin

	SELECT 'Pivote' AS Origen,*
	FROM (  SELECT pcp.EstadoM
	              ,pcp.NUPTitular
				  ,pcp.NUPDH
				  ,pcp.COD'Codigo'
				  ,pcp.ANIO'Anio'
				  ,pcp.MES'Mes'
				  ,pcp.DEBE'Debe'
				  ,pcp.HABER'Haber'
				  ,pcp.NRO_CHEQUE'NumeroCheque'
				  ,pcp.NRO_BAN'NumeroBanco'
				  ,pcp.IdBanco
				  ,pcp.FECHA_EMI'FechaEmision'
				  ,pcp.C31
				  ,NULL'Conciliado'
				  ,1'RegistroActivo'
			FROM Piv_ChequePU pcp
			WHERE pcp.NUPTitular IS NOT NULL
			EXCEPT
			SELECT cp.Estado, cp.NUPTitular, cp.NUPDH, cp.Codigo, cp.Anio, cp.Mes,
	               cp.Debe, cp.Haber, cp.NumeroCheque, cp.NumeroBanco, cp.IdBanco,
	               cp.FechaEmision, cp.C31, cp.Conciliado, cp.RegistroActivo
	          FROM PagoU.ChequePU cp
		) AS IZQUIERDA
	UNION 
	SELECT 'Destino' AS Origen,*
	FROM (  SELECT cp.Estado, cp.NUPTitular, cp.NUPDH, cp.Codigo, cp.Anio, cp.Mes,
	               cp.Debe, cp.Haber, cp.NumeroCheque, cp.NumeroBanco, cp.IdBanco,
	               cp.FechaEmision, cp.C31, cp.Conciliado, cp.RegistroActivo
	          FROM PagoU.ChequePU cp
			EXCEPT
			SELECT pcp.EstadoM
	              ,pcp.NUPTitular
				  ,pcp.NUPDH
				  ,pcp.COD'Codigo'
				  ,pcp.ANIO'Anio'
				  ,pcp.MES'Mes'
				  ,pcp.DEBE'Debe'
				  ,pcp.HABER'Haber'
				  ,pcp.NRO_CHEQUE'NumeroCheque'
				  ,pcp.NRO_BAN'NumeroBanco'
				  ,pcp.IdBanco
				  ,pcp.FECHA_EMI'FechaEmision'
				  ,pcp.C31
				  ,NULL'Conciliado'
				  ,1'RegistroActivo'
			FROM Piv_ChequePU pcp
			WHERE pcp.NUPTitular IS NOT NULL
		) AS DERECHA

end