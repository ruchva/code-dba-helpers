CREATE PROCEDURE dbo.CreaPivoteTablasPAGOS_PU
AS
BEGIN
	--PRE BENEFICIARIOS
	DELETE FROM SENARITD.PagoU.PreBeneficiarios
	DELETE FROM SENARITD.dbo.PreBeneficiariosPiv
	SELECT * INTO SENARITD.dbo.PreBeneficiariosPiv
	FROM PAGOS_P.dbo.Pre_Beneficiarios a
	/*
	SELECT * FROM SENARITD.dbo.PreBeneficiariosPiv
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD Parentesco INT
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD Estado INT
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD ClaseBeneficio INT
	ALTER TABLE SENARITD.dbo.PreBeneficiariosPiv ADD RedDH INT
	*/	
		--NUP--PRE BENEFICIARIOS
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.PreBeneficiariosPiv a JOIN SENARITD.Persona.Persona p
		ON a.T_MATRICULA = p.Matricula

		--ID_TRAMITE--PRE BENEFICIARIOS
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.PreBeneficiariosPiv a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--PRE BENEFICIARIOS
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.PreBeneficiariosPiv a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--PARENTESCO--PRE BENEFICIARIOS
		UPDATE a SET Parentesco = CASE WHEN a.PARENTESCO = 'H' THEN 4 ELSE 3 END
		FROM SENARITD.dbo.PreBeneficiariosPiv a

		--ESTADO--PRE BENEFICIARIOS
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM SENARITD.dbo.PreBeneficiariosPiv a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109

		--CALSE BENEFICIO--PRE BENEFICIARIOS
		UPDATE a SET a.ClaseBeneficio = dc.IdDetalleClasificador
		FROM SENARITD.dbo.PreBeneficiariosPiv a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.CLASE_BENEFICIO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 110

		--RED_DH --PRE BENEFICIARIOS
		UPDATE a SET a.RedDH = dc.IdDetalleClasificador
		FROM SENARITD.dbo.PreBeneficiariosPiv a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.RED_DH = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 111

	--PRE TITULARES 
	DELETE FROM SENARITD.PagoU.PreTitulares
	DELETE FROM SENARITD.dbo.PreTitularesPiv
	SELECT * INTO SENARITD.dbo.PreTitularesPiv
	FROM PAGOS_P.dbo.Pre_Titulares a
	/*
	SELECT * FROM SENARITD.dbo.PreTitularesPiv
	ALTER TABLE SENARITD.dbo.PreTitularesPiv ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.PreTitularesPiv ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.PreTitularesPiv ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.PreTitularesPiv ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.PreTitularesPiv ADD Estado INT
	*/	
		--NUP--PRE TITULARES 
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.PreTitularesPiv a JOIN SENARITD.Persona.Persona p
		ON a.MATRICULA = p.Matricula

		--ID_TRAMITE--PRE TITULARES 		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.PreTitularesPiv a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--PRE TITULARES 		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.PreTitularesPiv a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--PRE TITULARES 		
		UPDATE a SET a.IdBeneficio = ba.IdBeneficioOtorgado
		FROM SENARITD.Beneficio.BeneficioAsegurado ba JOIN SENARITD.dbo.PreTitularesPiv a
		ON ba.NUPAsegurado = a.NUP
		
		--ESTADO--PRE TITULARES		
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM SENARITD.dbo.PreTitularesPiv a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109	
		
	--TITULAR_PU 
	DELETE FROM SENARITD.PagoU.TitularPU
	DELETE FROM SENARITD.dbo.TitularPUPiv
	SELECT * INTO SENARITD.dbo.TitularPUPiv
	FROM PAGOS_P.dbo.Titular_PU a
	/*
	SELECT * FROM SENARITD.dbo.TitularPUPiv
	ALTER TABLE SENARITD.dbo.TitularPUPiv ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.TitularPUPiv ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.TitularPUPiv ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.TitularPUPiv ADD Estado INT
	*/	
		--NUP--TITULAR_PU		
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.TitularPUPiv a JOIN SENARITD.Persona.Persona p
		ON a.T_MATRICULA = p.Matricula

		--ID_TRAMITE--TITULAR_PU		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.TitularPUPiv a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--TITULAR_PU		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.TitularPUPiv a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ESTADO--TITULAR_PU		
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM SENARITD.dbo.TitularPUPiv a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109	
		
	--CHEQUE_PU
	DELETE FROM SENARITD.PagoU.ChequePU
	DELETE FROM SENARITD.dbo.ChequePUPv
	SELECT * INTO SENARITD.dbo.ChequePUPv
	FROM PAGOS_P.dbo.chePU cp
	/*
	SELECT * FROM SENARITD.dbo.ChequePUPv
	ALTER TABLE SENARITD.dbo.ChequePUPv ADD NUPTitular BIGINT
	ALTER TABLE SENARITD.dbo.ChequePUPv ADD NUPDH BIGINT
	ALTER TABLE SENARITD.dbo.ChequePUPv ADD EstadoM INT
	ALTER TABLE SENARITD.dbo.ChequePUPv ADD IdBanco INT
	ALTER TABLE SENARITD.dbo.ChequePUPv ADD Conciliado INT
	*/	
		--NUP TITULAR--CHEQUE_PU		
		UPDATE a SET NUPTitular = p.NUP
		FROM SENARITD.dbo.ChequePUPv a JOIN SENARITD.Persona.Persona p 
		ON a.T_MATRICULA = p.Matricula

		--NUP DH--CHEQUE_PU
		UPDATE a SET NUPDH = p.NUP
		FROM SENARITD.dbo.ChequePUPv a JOIN SENARITD.Persona.Persona p 
		ON a.DH_MATRICULA = p.Matricula
		
		--ESTADO--CHEQUE_PU				
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.ChequePUPv a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109 

		--ID_BANCO		
		UPDATE a SET IdBanco = CASE WHEN a.BANCO = 3 THEN 802 
									WHEN a.BANCO = 4 THEN 806  
									WHEN a.BANCO = 5 THEN 811
							   END
		FROM SENARITD.dbo.ChequePUPv a
		
		--CONCILIADO--CHEQUE_PU
				
		
END