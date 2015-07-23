SELECT '' AS NUP
      ,Tramite
      ,no_certif
      ,'' AS Documento
      ,fecha_emi
      ,monto
      ,literal_monto
      ,'' AS IdBeneficio
      ,Tipo_PP
      ,Estado
      ,tipo_cambio	 
FROM CC.dbo.CERTIF_PMM_PU
;
SELECT cp.COD
      ,cp.ANIO
      ,cp.MES
      ,'' AS NUPTitular
      ,cp.ESTADO
      ,'' AS IdSector
      ,'' AS NUPDH	
      ,cp.DEBE
      ,cp.HABER	
      ,cp.NRO_CHEQUE
      ,cp.NRO_BAN
      ,'' AS IdBanco
      ,cp.FECHA_EMI
      ,cp.C31
      ,'' AS Conciliado
FROM PAGOS_P.dbo.chePU cp
;
SELECT dc.TRAMITE
      ,dc.COMPONENTE
      ,'' AS NUP
      ,'' AS IdSector
      ,dc.PRIMERA_FEC_AFILIA
      ,dc.ULTIMA_FEC_AFILIA
      ,dc.DENSIDAD
      ,dc.SALARIO_COTIZABLE
      ,dc.SALARIO_COTIZABLE_ACT
      ,dc.TIPO_CC
      ,dc.FECHA_CALCULO
      ,dc.FECHA_EMISION
      ,dc.TIPO_CAMBIO
      ,dc.MONTO_CC
      ,dc.MONTO_PMM
      ,dc.MONTO_PU
      ,dc.APORTES_AFP
      ,dc.NRO_DOCUMENTO
      ,dc.ESTADO
      ,'' AS IdBeneficio	
      ,dc.FECHA_SELECCION
      ,dc.SALUD
      ,dc.NRO_MESES
      ,dc.INTERIOR_MINA
      ,dc.FECHA_PROCESO
      ,dc.NRO_MINA
      ,dc.TRAB_SIM
FROM CC.dbo.DOC_COMPARATIVO dc
;
SELECT pb.FORMULARIO
      ,'' AS NUPTitular
      ,'' AS NUPDH
      ,pb.TRAMITE
      ,pb.CLASE_BENEFICIO
      ,pb.PORCENTAJE
      ,pb.RED_DH
      ,pb.ESTADO
      ,pb.PARENTESCO
FROM PAGOS_P.dbo.Pre_Beneficiarios pb
;
SELECT '' AS CUA
      ,pt.FORMULARIO
      ,pt.TRAMITE
      ,pt.NUM_CERTIF
      ,'' AS NUP
      ,pt.DOC_COMPARATIVO
      ,'' AS IdSector
      ,pt.CLASE_PAGO
      ,pt.ANIOS_INSALUBRES
      ,pt.MONTO_BASE
      ,pt.TIPO_CAMBIO
      ,pt.REINTEGRO_DESDE
      ,pt.REINTEGRO_HASTA
      ,pt.REINTEGRO
      ,pt.AGUINALDO
      ,pt.RED_EDAD
      ,pt.MESES_CNS
      ,pt.ESTADO	
FROM PAGOS_P.dbo.Pre_Titulares pt
;
SELECT '' AS CUA
      ,tp.FORMULARIO
      ,'' AS NUP
      ,tp.ESTADO
      ,tp.TRAMITE
      ,tp.NUM_CERTIF
      ,tp.DOC_COMPARATIVO
      ,'' AS IdSector
      ,tp.ANIOS_INSALUBRES
      ,tp.FECHA_ALTA
      ,tp.RESOLUCION	
FROM PAGOS_P.dbo.Titular_PU tp
;
--sp_columns CertificadoPMMPU;--
--sp_columns ChequePU;--
--sp_columns DocomentoComparativo;--
--sp_columns PreBeneficiarios;--
--sp_columns PreTitulares;--
--sp_columns RTitularDH;
--sp_columns SolicitanteDocumentos;
--sp_columns TitularPU;--
--sp_columns Titular_PU;














