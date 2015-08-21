USE [SENARITD]
GO
/****** Object:  StoredProcedure [dbo].[CreaPivoteTablasPAGOS_PU]    Script Date: 13/08/2015 17:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreaPivoteTablasPAGOS_PU]
AS
BEGIN
	--PRE BENEFICIARIOS
	DROP TABLE SENARITD.dbo.Piv_PreBeneficiarios
	SELECT * INTO SENARITD.dbo.Piv_PreBeneficiarios
	FROM PAGOS_P.dbo.Pre_Beneficiarios a
	
	--SELECT * FROM SENARITD.dbo.Piv_PreBeneficiarios
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD Parentesco INT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD Estado INT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD ClaseBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD RedDH INT
	ALTER TABLE SENARITD.dbo.Piv_PreBeneficiarios ADD NUPDH BIGINT
		
		--NUP--PRE BENEFICIARIOS
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Persona.Persona p
		ON a.T_MATRICULA = p.Matricula

		--ID_TRAMITE--PRE BENEFICIARIOS
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--PRE BENEFICIARIOS
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--PARENTESCO--PRE BENEFICIARIOS
		UPDATE a SET Parentesco = CASE WHEN a.PARENTESCO = 'H' THEN 4 ELSE 3 END
		FROM SENARITD.dbo.Piv_PreBeneficiarios a

		--ESTADO--PRE BENEFICIARIOS
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109

		--CALSE BENEFICIO--PRE BENEFICIARIOS
		UPDATE a SET a.ClaseBeneficio = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.CLASE_BENEFICIO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 110

		--RED_DH --PRE BENEFICIARIOS
		UPDATE a SET a.RedDH = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.RED_DH = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 111
		
		--NUPDH
		UPDATE a SET NUPDH = p.NUP
		FROM SENARITD.dbo.Piv_PreBeneficiarios a JOIN SENARITD.Persona.Persona p
		ON a.DH_MATRICULA = p.Matricula		

	--PRE TITULARES 
	DROP TABLE SENARITD.dbo.Piv_PreTitulares
	SELECT * INTO SENARITD.dbo.Piv_PreTitulares
	FROM PAGOS_P.dbo.Pre_Titulares a
	
	--SELECT * FROM SENARITD.dbo.Piv_PreTitulares
	ALTER TABLE SENARITD.dbo.Piv_PreTitulares ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_PreTitulares ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_PreTitulares ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_PreTitulares ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_PreTitulares ADD Estado INT
		
		--NUP--PRE TITULARES 
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.Piv_PreTitulares a JOIN SENARITD.Persona.Persona p
		ON a.MATRICULA = p.Matricula

		--ID_TRAMITE--PRE TITULARES 		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_PreTitulares a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--PRE TITULARES 		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_PreTitulares a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--PRE TITULARES 		
		UPDATE a SET a.IdBeneficio = CASE WHEN a.CLASE_PAGO = '1' THEN 19
										  WHEN a.CLASE_PAGO = '2' THEN 21
										  WHEN a.CLASE_PAGO = '3' THEN 20
										  WHEN a.CLASE_PAGO = '4' THEN 22
									 END 
		FROM  SENARITD.dbo.Piv_PreTitulares a
		
		--ESTADO--PRE TITULARES		
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_PreTitulares a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109	
		
	--TITULAR_PU 
	DROP TABLE SENARITD.dbo.Piv_TitularPU
	SELECT * INTO SENARITD.dbo.Piv_TitularPU
	FROM PAGOS_P.dbo.Titular_PU a
	
	--SELECT * FROM SENARITD.dbo.Piv_TitularPU
	ALTER TABLE SENARITD.dbo.Piv_TitularPU ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_TitularPU ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_TitularPU ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_TitularPU ADD Estado INT
		
		--NUP--TITULAR_PU		
		UPDATE a SET NUP = p.NUP
		FROM SENARITD.dbo.Piv_TitularPU a JOIN SENARITD.Persona.Persona p
		ON a.T_MATRICULA = p.Matricula

		--ID_TRAMITE--TITULAR_PU		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_TitularPU a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--TITULAR_PU		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_TitularPU a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ESTADO--TITULAR_PU		
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_TitularPU a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109	
		
	--CHEQUE_PU
	DROP TABLE SENARITD.dbo.Piv_ChequePU
	SELECT * INTO SENARITD.dbo.Piv_ChequePU
	FROM PAGOS_P.dbo.chePU cp
	
	--SELECT * FROM SENARITD.dbo.Piv_ChequePU
	ALTER TABLE SENARITD.dbo.Piv_ChequePU ADD NUPTitular BIGINT
	ALTER TABLE SENARITD.dbo.Piv_ChequePU ADD NUPDH BIGINT
	ALTER TABLE SENARITD.dbo.Piv_ChequePU ADD EstadoM INT
	ALTER TABLE SENARITD.dbo.Piv_ChequePU ADD IdBanco INT
	ALTER TABLE SENARITD.dbo.Piv_ChequePU ADD Conciliado INT
		
		--NUP TITULAR--CHEQUE_PU		
		UPDATE a SET NUPTitular = p.NUP
		FROM SENARITD.dbo.Piv_ChequePU a JOIN SENARITD.Persona.Persona p 
		ON a.T_MATRICULA = p.Matricula

		--NUP DH--CHEQUE_PU
		UPDATE a SET NUPDH = p.NUP
		FROM SENARITD.dbo.Piv_ChequePU a JOIN SENARITD.Persona.Persona p 
		ON a.DH_MATRICULA = p.Matricula
		
		--ESTADO--CHEQUE_PU				
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_ChequePU a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109 

		--ID_BANCO		
		UPDATE a SET IdBanco = CASE WHEN a.BANCO = 3 THEN 802 
									WHEN a.BANCO = 4 THEN 806  
									WHEN a.BANCO = 5 THEN 811
							   END
		FROM SENARITD.dbo.Piv_ChequePU a
		
		--CONCILIADO--CHEQUE_PU
				
		
END