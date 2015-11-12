CREATE PROCEDURE ControlCantidadesPU
AS
BEGIN
	DECLARE @cCertificadoPMMPU INT, @MIG_1 INT, @sin_NUP INT, @sin_IDTramite INT, @sin_Estado INT 
	SELECT @cCertificadoPMMPU = COUNT(*) FROM PagoU.CertificadoPMMPU
	SELECT @MIG_1 = COUNT(*) FROM Piv_CERTIF_PMM_PU a
	SELECT @sin_NUP = COUNT(*) FROM Piv_CERTIF_PMM_PU a WHERE a.NUP IS NULL
	SELECT @sin_IDTramite = COUNT(*) FROM Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL
	SELECT @sin_Estado = COUNT(*) FROM Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NULL	
	PRINT 'CertificadoPMMPU     REGISTROS MIGRADOS:  '+ CAST(@cCertificadoPMMPU AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_1 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_1 - @cCertificadoPMMPU AS CHAR(5)) +
	'| Sin NUP: '+CAST(@sin_NUP AS CHAR(5)) + 'Sin IdTramite: '+CAST(@sin_IDTramite AS CHAR(5)) +'Sin Estado: '+CAST(@sin_Estado AS CHAR(5)) 
	PRINT '------------------------------------------------------------------------------------------------------------------------------------------'
	
	
	DECLARE @cDocumentoComparativo INT, @MIG_2 INT, @sin_NUP2 INT, @sin_IDTramite2 INT, @sin_Estado2 INT
	SELECT @cDocumentoComparativo = COUNT(*) FROM PagoU.DocumentoComparativo
	SELECT @MIG_2 = COUNT(*) FROM Piv_DOC_COMPARATIVO pdc
	SELECT @sin_NUP2 = COUNT(*) FROM Piv_DOC_COMPARATIVO a WHERE a.NUP IS NULL
	SELECT @sin_IDTramite2 = COUNT(*) FROM Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL
	SELECT @sin_Estado2 = COUNT(*) FROM Piv_CERTIF_PMM_PU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.EstadoM IS NULL	
	PRINT 'DocumentoComparativo REGISTROS MIGRADOS:  '+ CAST(@cDocumentoComparativo AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_2 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_2 - @cDocumentoComparativo AS CHAR(5)) 
	+'| Sin NUP: '+CAST(@sin_NUP2 AS CHAR(5)) + 'Sin IdTramite: '+CAST(@sin_IDTramite2 AS CHAR(5)) +'Sin Estado: '+CAST(@sin_Estado2 AS CHAR(5)) 
	PRINT '------------------------------------------------------------------------------------------------------------------------------------------'
	
	
	DECLARE @cPreBeneficiarios INT, @MIG_3 INT, @sin_NUP3 INT, @sin_IDTramite3 INT, @sin_Estado3 INT 
	SELECT @cPreBeneficiarios = COUNT(*) FROM PagoU.PreBeneficiarios
	SELECT @MIG_3 = COUNT(*) FROM Piv_PreBeneficiarios ppb
	SELECT @sin_NUP3 = COUNT(*) FROM Piv_PreBeneficiarios a WHERE a.NUP IS NULL
	SELECT @sin_IDTramite3 = COUNT(*) FROM Piv_PreBeneficiarios a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL
	SELECT @sin_Estado3 = COUNT(*) FROM Piv_PreBeneficiarios a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.Estado IS NULL
	PRINT 'PreBeneficiarios     REGISTROS MIGRADOS:  '+ CAST(@cPreBeneficiarios AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_3 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_3 - @cPreBeneficiarios AS CHAR(5)) 
	+'| Sin NUP: '+CAST(@sin_NUP3 AS CHAR(5)) + 'Sin IdTramite: '+CAST(@sin_IDTramite3 AS CHAR(5)) +'Sin Estado: '+CAST(@sin_Estado3 AS CHAR(5)) 
	PRINT '------------------------------------------------------------------------------------------------------------------------------------------'
	
	
	DECLARE @cPreTitulares INT, @MIG_4 INT, @sin_NUP4 INT, @sin_IDTramite4 INT, @sin_Estado4 INT
	SELECT @cPreTitulares = COUNT(*) FROM PagoU.PreTitulares
	SELECT @MIG_4 = COUNT(*) FROM Piv_PreTitulares ppt
	SELECT @sin_NUP4 = COUNT(*) FROM Piv_PreTitulares a WHERE a.NUP IS NULL
	SELECT @sin_IDTramite4 = COUNT(*) FROM Piv_PreTitulares a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL
	SELECT @sin_Estado4 = COUNT(*) FROM Piv_PreTitulares a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.Estado IS NULL	
	PRINT 'PreTitulares         REGISTROS MIGRADOS:  '+ CAST(@cPreTitulares AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_4 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_4 - @cPreTitulares AS CHAR(5))
	+'| Sin NUP: '+CAST(@sin_NUP4 AS CHAR(5)) + 'Sin IdTramite: '+CAST(@sin_IDTramite4 AS CHAR(5)) +'Sin Estado: '+CAST(@sin_Estado4 AS CHAR(5)) 
	PRINT '------------------------------------------------------------------------------------------------------------------------------------------'
	
	
	DECLARE @cTitularPU INT, @MIG_6 INT, @sin_NUP6 INT, @sin_IDTramite6 INT, @sin_Estado6 INT
	SELECT @cTitularPU = COUNT(*) FROM PagoU.TitularPU
	SELECT @MIG_6 = COUNT(*) FROM Piv_TitularPU ptp
	SELECT @sin_NUP6 = COUNT(*) FROM Piv_TitularPU a WHERE a.NUP IS NULL
	SELECT @sin_IDTramite6 = COUNT(*) FROM Piv_TitularPU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NULL
	SELECT @sin_Estado6 = COUNT(*) FROM Piv_TitularPU a WHERE a.NUP IS NOT NULL AND a.IdTramite IS NOT NULL AND a.Estado IS NULL	
	PRINT 'TitularPU            REGISTROS MIGRADOS:  '+ CAST(@cTitularPU AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_6 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_6 - @cTitularPU AS CHAR(5))
	+'| Sin NUP: '+CAST(@sin_NUP6 AS CHAR(5)) + 'Sin IdTramite: '+CAST(@sin_IDTramite6 AS CHAR(5)) +'Sin Estado: '+CAST(@sin_Estado6 AS CHAR(5)) 
	PRINT '------------------------------------------------------------------------------------------------------------------------------------------'

	
	DECLARE @cChequePU INT, @MIG_5 INT, @sin_NUP5 INT, @sin_Estado5 INT
	SELECT @cChequePU = COUNT(*) FROM PagoU.ChequePU
	SELECT @MIG_5 = COUNT(*) FROM Piv_ChequePU pcp
	SELECT @sin_NUP5 = COUNT(*) FROM Piv_ChequePU a WHERE a.NUPTitular IS NULL
	SELECT @sin_Estado5 = COUNT(*) FROM Piv_ChequePU a WHERE a.NUPTitular IS NOT NULL AND a.EstadoM IS NULL	
	PRINT 'ChequePU             REGISTROS MIGRADOS:  '+ CAST(@cChequePU AS CHAR(5)) +'| ORIGEN:  '+ CAST(@MIG_5 AS CHAR(5))+'| OBSERVADOS:  '+CAST(@MIG_5 - @cChequePU AS CHAR(5))
	+'| Sin NUP: '+CAST(@sin_NUP5 AS CHAR(5)) + 'Sin Estado: '+CAST(@sin_Estado5 AS CHAR(5)) 
	PRINT '------------------------------------------------------------------------------------------------------------------------------------------'


END	

