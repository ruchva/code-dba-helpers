CREATE PROCEDURE ControlCantidadesPU
AS
BEGIN
	DECLARE @cCertificadoPMMPU INT, @MIG_1 INT
	SELECT @cCertificadoPMMPU = COUNT(*) FROM PagoU.CertificadoPMMPU
	SELECT @MIG_1 = COUNT(*) FROM Piv_CERTIF_PMM_PU pcpp	
	PRINT 'CertificadoPMMPU     REGISTROS MIGRADOS:  '+ CAST(@cCertificadoPMMPU AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_1 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_1 - @cCertificadoPMMPU AS CHAR(5)) 
	PRINT '---------------------------------------------------------------------------------'
	
	DECLARE @cDocumentoComparativo INT, @MIG_2 INT
	SELECT @cDocumentoComparativo = COUNT(*) FROM PagoU.DocumentoComparativo
	SELECT @MIG_2 = COUNT(*) FROM Piv_DOC_COMPARATIVO pdc
	PRINT 'DocumentoComparativo REGISTROS MIGRADOS:  '+ CAST(@cDocumentoComparativo AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_2 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_2 - @cDocumentoComparativo AS CHAR(5))
	PRINT '---------------------------------------------------------------------------------'
	/*
	DECLARE @cPreBeneficiarios INT, @MIG_3 INT 
	SELECT @cPreBeneficiarios = COUNT(*) FROM PagoU.PreBeneficiarios
	SELECT @MIG_3 = COUNT(*) FROM Piv_PreBeneficiarios ppb
	PRINT 'PreBeneficiarios     REGISTROS MIGRADOS:  '+ CAST(@cPreBeneficiarios AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_3 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_3 - @cPreBeneficiarios AS CHAR(5)) 
	PRINT '---------------------------------------------------------------------------------'
	*/
	DECLARE @cPreTitulares INT, @MIG_4 INT
	SELECT @cPreTitulares = COUNT(*) FROM PagoU.PreTitulares
	SELECT @MIG_4 = COUNT(*) FROM Piv_PreTitulares ppt
	PRINT 'PreTitulares         REGISTROS MIGRADOS:  '+ CAST(@cPreTitulares AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_4 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_4 - @cPreTitulares AS CHAR(5))
	PRINT '---------------------------------------------------------------------------------'

	DECLARE @cChequePU INT, @MIG_5 INT
	SELECT @cChequePU = COUNT(*) FROM PagoU.ChequePU
	SELECT @MIG_5 = COUNT(*) FROM Piv_ChequePU pcp
	PRINT 'ChequePU             REGISTROS MIGRADOS:  '+ CAST(@cChequePU AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_5 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_5 - @cChequePU AS CHAR(5))
	PRINT '---------------------------------------------------------------------------------'

	DECLARE @cTitularPU INT, @MIG_6 INT 
	SELECT @cTitularPU = COUNT(*) FROM PagoU.TitularPU
	SELECT @MIG_6 = COUNT(*) FROM Piv_TitularPU ptp
	PRINT 'TitularPU            REGISTROS MIGRADOS:  '+ CAST(@cTitularPU AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_6 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_6 - @cTitularPU AS CHAR(5))
	PRINT '---------------------------------------------------------------------------------'


END	

