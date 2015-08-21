SELECT r.IdTipoBeneficio, r.NoFormularioCalculo, r.EstadoFormCalcCC, r.MontoCC, r.SIP_impresion, r.NroCertificado, r.IdUsuario 
FROM Reprocesos.ReprocesoCC r
INNER JOIN CertificacionCC.FormularioCalculoCC fc ON r.IdTramite=fc.IdTramite AND r.IdGrupoBeneficio=fc.IdGrupoBeneficio 
--REPROCESOS
AND r.IdTipoFormularioCalculo=fc.IdTipoFormularioCalculo
WHERE r.IdTipoReproceso=31383
/*OBS
* IdTipoBeneficio no puede ser null y tiene que estar de acuerdo al clasificador 
* NoFormularioCalculo no puede ser NULL y siempre tiene que apuntar al FormularioCalculoCC que da origen al CertificadoCC
* NFormTipoRepro no existe en Reprocesos.ReprocesoCC (actualizar la estructura)
* EstadoFormCalcCC no puede ser NULL
* MontoCC,SIP_impresion no pueden ser NULL
* Verificar la correspondencia de NroCertificado con CertificadosCC
* IdUsuario??
*/
--------------------------------------------
SELECT * FROM CC.dbo.REPROCESO_CC rc WHERE rc.TIPO_REP NOT IN ('R','X')
SELECT COUNT(*),rc.IdTipoReproceso FROM SENARITD.Reprocesos.ReprocesoCC rc
GROUP BY rc.IdTipoReproceso HAVING COUNT(*) > 1
/*
* identificando casos que podrian no tener conflicto con la clave primaria
* contabilizando datos migrados segun tipo de reproceso
* */
--DELETE FROM SENARITD.Reprocesos.ReprocesoCC WHERE IdTipoReproceso = 31383

SELECT prc.USUARIO, (SELECT IdUsuario FROM Seguridad.Usuario WHERE CuentaUsuario = UPPER(dbo.eliminaSENASIR(prc.USUARIO))) 
FROM dbo.Piv_REPROCESO_CC prc
/*
* obtencion de los ids de los usuarios 
* */
---------------------------------------------
--PAGO UNICO
SELECT COUNT(*) FROM PagoU.CertificadoPMMPU      SELECT COUNT(*) FROM dbo.Piv_CERTIF_PMM_PU pcpp
SELECT COUNT(*) FROM PagoU.ChequePU				 SELECT COUNT(*) FROM dbo.Piv_ChequePU pcp
SELECT COUNT(*) FROM PagoU.DocumentoComparativo	 SELECT COUNT(*) FROM dbo.Piv_DOC_COMPARATIVO pdc
SELECT COUNT(*) FROM PagoU.PreBeneficiarios		 SELECT COUNT(*) FROM dbo.Piv_PreBeneficiarios ppb
SELECT COUNT(*) FROM PagoU.PreTitulares			 SELECT COUNT(*) FROM dbo.Piv_PreTitulares ppt
SELECT COUNT(*) FROM PagoU.TitularPU			 SELECT COUNT(*) FROM dbo.Piv_TitularPU ptp

--certificacion pmm pu
SELECT COUNT(*), pcpp.NUP FROM dbo.Piv_CERTIF_PMM_PU pcpp
GROUP BY pcpp.NUP HAVING COUNT(*) > 1

SELECT COUNT(*) AS repeticiones, pcpp.no_certif 
INTO #temp_no_cert_repetidos
FROM dbo.Piv_CERTIF_PMM_PU pcpp
GROUP BY pcpp.no_certif HAVING COUNT(*) > 1

SELECT pcpp.NUP,pcpp.no_certif  FROM dbo.Piv_CERTIF_PMM_PU pcpp WHERE pcpp.NUP IN 
('162181','208919','161597','210502','208879','161514','83329','170588','153691','207654','84712','85748','210431','85940','148164','208012','163309','138114','163415'
,'149037','208725','85419','210488','66727','210377','197427','161944','85362','210537','86009','136832','149318','210417','208705','56500','148631','210520','148167'
,'148920','199382','209295','85457','208714','208511','161495','210260','163181','138103','87077','209630','17245','19326','208680','87166','209745','208036','161404'
,'70601','208637','209948','12705','85941','86036','148088','87699','162117','162071','71406','163345','209024','18396','19438','13865','210352','80809','78433','196140'
,'85687','160523','210301','207908','210610','137738','210579','138199','93370','163715','210347','170313') 
ORDER BY pcpp.NUP
SELECT * FROM #temp_no_cert_repetidos

SELECT pcpp.NUP,pcpp.IdTramite,pcpp.Estado
FROM dbo.Piv_CERTIF_PMM_PU pcpp
JOIN #temp_no_cert_repetidos a ON a.no_certif = pcpp.no_certif
WHERE pcpp.NUP IS NOT NULL 
  AND pcpp.IdTramite IS NOT NULL
  --AND pcpp.EstadoM IS NULL
ORDER BY pcpp.NUP
/*
* cantidad de NUP que se repiten
* creacion de una temporal con los NUP repetidos
* cruce con la temporal de NUP repetidos para verificar otras llaves candidatas
* conbiancion posible clave candidata  
* */

SELECT pcpp.NUP --NUP
	  ,pcpp.IdTramite --IdTramite
	  ,pcpp.IdGrupoBeneficio --IdGrupoBeneficio
	  ,pcpp.no_certif --NumeroCertificado
	  ,pcpp.doc --Documento
	  ,pcpp.fecha_emi --FechaEmision
	  ,pcpp.monto --Monto
	  ,pcpp.IdBeneficio --IdBeneficio
	  ,pcpp.Tipo_PP --TipoPP
	  ,pcpp.EstadoM --Estado
	  ,NULL AS HojaRuta 
	  ,NULL AS FechaHojaRuta
	  ,NULL AS IdUsuarioHojaRuta
	  ,1 AS Version
      ,1 AS RegistroActivo        
FROM dbo.Piv_CERTIF_PMM_PU pcpp
WHERE pcpp.NUP IS NOT NULL 
  AND pcpp.IdTramite IS NOT NULL
  AND pcpp.EstadoM IS NOT NULL
  AND pcpp.NUP NOT IN (SELECT cp.NUP FROM PagoU.CertificadoPMMPU cp)
SELECT * FROM PagoU.CertificadoPMMPU cp
/*
* verificacion de origrn y destino registro a registro
* */
---------------------------------
--documento comparativo
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc 
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL AND pdc.IdGrupoBeneficio IS NULL

SELECT COUNT(*),pdc.IdTramite FROM dbo.Piv_DOC_COMPARATIVO pdc
GROUP BY pdc.IdTramite HAVING COUNT(*) > 1
SELECT COUNT(*),pdc.IdGrupoBeneficio FROM dbo.Piv_DOC_COMPARATIVO pdc
GROUP BY pdc.IdGrupoBeneficio HAVING COUNT(*) > 1
SELECT COUNT(*),pdc.COMPONENTE FROM dbo.Piv_DOC_COMPARATIVO pdc
GROUP BY pdc.COMPONENTE HAVING COUNT(*) > 1	
/*
* cantidad de datos clave repetidos
* 
* */
SELECT *--pdc.NUP,pdc.IdTramite,pdc.IdGrupoBeneficio,pdc.TRAMITE
FROM dbo.Piv_DOC_COMPARATIVO pdc --WHERE pdc.EstadoM IS NULL
WHERE pdc.IdTramite IN ('96568','111982','123558','136024','126429','130359','112964','2210','111490','127826')
---------------------------------------------
--pre beneficiarios
  SELECT ppb.NUP --NUPTitular
		,NULL --NUPDH
		,ppb.FORMULARIO --Formulario
		,ppb.IdTramite --IdTramite
		,ppb.IdGrupoBeneficio --IdGrupoBeneficio
		,ppb.ClaseBeneficio --ClaseBeneficio
		,ppb.PORCENTAJE --Porcentaje
		,ppb.RED_DH --RedDH
		,ppb.Parentesco --Parentesco
		,ppb.Estado --Estado
		,1 --Version
        ,1 --RegistroActivo
	FROM dbo.Piv_PreBeneficiarios ppb
	WHERE ppb.NUP IS NOT NULL 
	  AND ppb.IdTramite IS NOT NULL
	  AND ppb.IdGrupoBeneficio IS NOT NULL
	  AND ppb.NUP NOT IN (SELECT pb.NUPTitular FROM PagoU.PreBeneficiarios pb)
	  
SELECT * FROM PagoU.PreBeneficiarios pb	  
SELECT * FROM dbo.Piv_PreBeneficiarios ppb WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NOT NULL
/*
* 
*  
* */

SELECT COUNT(*),ppb.NUP FROM dbo.Piv_PreBeneficiarios ppb
GROUP BY ppb.NUP HAVING COUNT(*) > 1

SELECT * FROM dbo.Piv_PreBeneficiarios ppb
WHERE ppb.NUP IN ('10463','17606','57807','66730','70489','73506','85467','85507','85523','85558')
-----------------------------------------------
--pre titulares
SELECT COUNT(*), ppt.NUP FROM dbo.Piv_PreTitulares ppt
GROUP BY ppt.NUP HAVING COUNT(*) > 1

SELECT * FROM dbo.Piv_PreTitulares ppt WHERE ppt.NUP IN ('13865','85469','85486','86036','86070','86121','86132','86290','86439'
,'86701','86779','86793','86815','86874','87166','87415','87573','87605','87632','88054','88833','88907','88958','89187','90944'
,'92865','93259','96638','96650','140490','208248')
SELECT * FROM dbo.Piv_PreTitulares ppt WHERE ppt.IdBeneficio IS NOT NULL
SELECT * FROM PAGOS_P.dbo.Pre_Titulares pt LEFT JOIN CC.dbo.DOC_COMPARATIVO dc ON pt.MATRICULA = dc.MATRICULA WHERE dc.MATRICULA IS NULL

SELECT * FROM dbo.Piv_PreTitulares ppt JOIN dbo.Piv_DOC_COMPARATIVO pdc ON ppt.MATRICULA = pdc.MATRICULA
--PagoU.PreTitulares
/*
* NUP repetidos
* verificamos los NUP repetidos para ubicar otra clave cnadidata
* verificamos IdBeneficio NULL
* verificamos pre_titulares con doc_comparativo para obtener el IdBeneficio 
* */
SELECT ppt.NUP,pdc.NUP,ppt.IdBeneficio,pdc.IdBeneficio,ppt.NUM_IDENTIF,pdc.CI  
FROM dbo.Piv_PreTitulares ppt JOIN dbo.Piv_DOC_COMPARATIVO pdc ON ppt.NUP = pdc.NUP
WHERE ppt.NUP IS NOT NULL
  AND pdc.NUP IS NOT NULL 
  AND pdc.IdBeneficio IS NOT NULL 
  AND ppt.IdBeneficio IS NOT NULL
   
SELECT * FROM dbo.Piv_PreTitulares ppt
WHERE ppt.NUP IS NOT NULL AND ppt.IdBeneficio IS NULL

-----------------------------------------------
SELECT COUNT(*),ba.IdBeneficioOtorgado FROM Beneficio.BeneficioAsegurado ba
GROUP BY ba.IdBeneficioOtorgado HAVING COUNT(*) > 1
/*
* en Beneficio.BeneficioAsegurado tenemos beneficio otorgado 16(cc mensual) y 17(cc global)
* falta los beneficios otrogados de 21(PU) y 19(PMM)
* */
SELECT a.NUP,ba.NUPAsegurado,ba.IdGrupoBeneficio, ba.IdBeneficioOtorgado
FROM SENARITD.dbo.Piv_PreTitulares a  
JOIN SENARITD.Beneficio.BeneficioAsegurado ba ON a.NUP = ba.NUPAsegurado

SELECT a.NUP FROM SENARITD.dbo.Piv_PreTitulares a  
LEFT JOIN SENARITD.Beneficio.BeneficioAsegurado ba ON a.NUP = ba.NUPAsegurado
WHERE ba.NUPAsegurado IS NULL AND a.NUP IS NOT NULL

SELECT CASE WHEN pcpp.Clase_Pago = 'PU' THEN 21
			WHEN pcpp.Clase_Pago = 'PMM' THEN 19
END ,ppt.CLASE_PAGO,pcpp.Clase_Pago,ppt.NUP,pcpp.NUP
FROM dbo.Piv_PreTitulares ppt JOIN dbo.Piv_CERTIF_PMM_PU pcpp ON ppt.NUP = pcpp.NUP
SELECT * FROM PAGOS_P.dbo.param_clase_pago pcp 
SELECT CASE WHEN ppt.CLASE_PAGO = '1' THEN 19
            WHEN ppt.CLASE_PAGO = '2' THEN 21
            WHEN ppt.CLASE_PAGO = '3' THEN 20
            WHEN ppt.CLASE_PAGO = '4' THEN 22
       END,ppt.CLASE_PAGO    
FROM dbo.Piv_PreTitulares ppt
WHERE ppt.NUP IS NOT NULL
SELECT * FROM PagoU.PreTitulares pt
/*
* sacamos los registros que tienen
* */
----------------------------------------------
--cheque pu
SELECT * FROM dbo.Piv_ChequePU pcp 
WHERE pcp.NUPTitular IS NOT NULL

----------------------------------------------
--titulares pu
SELECT * FROM dbo.Piv_TitularPU ptp
WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NOT NULL

SELECT * FROM dbo.Piv_CERTIF_PMM_PU pcpp
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc 
SELECT * FROM dbo.Piv_PreBeneficiarios ppb
SELECT * FROM dbo.Piv_PreTitulares ppt
SELECT * FROM dbo.Piv_ChequePU pcp
SELECT * FROM dbo.Piv_TitularPU ptp
-----------------------------------------------
--faltantes con IdTramite NULL
SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a --NO en pivote
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.CertificadoPMMPU cp WHERE cp.NUP = a.NUP)
      AND a.NUP IS NOT NULL
ORDER BY a.NUP

SELECT * FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a
WHERE NOT EXISTS (SELECT * FROM SENARITD.PagoU.DocumentoComparativo dc WHERE dc.NUP = a.NUP)
      AND a.NUP IS NOT NULL      
ORDER BY a.NUP

-----------------------------------------------
--ID_TRAMITE--CERTIFICADO_PMMPU 
UPDATE a SET a.IdTramite = tp.IdTramite
FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Tramite.TramitePersona tp 
ON a.NUP = tp.NUP	

SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a WHERE a.NUP = '88261'
SELECT * FROM Persona.Persona p WHERE p.NUP LIKE '88261'
SELECT * FROM Tramite.TramitePersona tp WHERE tp.NUP LIKE '88261'
--SELECT * FROM Persona.Persona p WHERE p.NUP LIKE '8826'
SELECT * FROM CC.dbo.CERTIF_PMM_PU cpp

-----------------------------------------------
--caso constraint PK violada
select * from SENARITD.PagoU.CertificadoPMMPU cp where cp.NUP = 13865
select * from dbo.Piv_CERTIF_PMM_PU where NUP = 13865
select * from CC.dbo.CERTIF_PMM_PU where Matricula = '420128CLJ'

--caso con certificado, dato historico 
SELECT * FROM PAGOS_P.dbo.Titular_PU
SELECT * FROM PAGOS_P.dbo.Titular_PMM tp WHERE tp.T_MATRICULA = '420128CLJ'
SELECT * FROM PAGOS_P.dbo.Titular_PU tp WHERE tp.T_MATRICULA = '420128CLJ'

SELECT * FROM CC.dbo.DOC_COMPARATIVO dc WHERE dc.MATRICULA = '420128CLJ'
SELECT * FROM CC.dbo.CERTIFICADO c WHERE c.Matricula = '420128CLJ'
SELECT * FROM CC.dbo.DOC_COMPARATIVO dc WHERE dc.MATRICULA = '581210PPC'
SELECT * FROM CC.dbo.CERTIFICADO c WHERE c.Matricula = '581210PPC'
------------------------------------------
--problema clave primaria
SELECT COUNT(*) AS cont,pdc.MATRICULA --INTO #temp_nupdup 
FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
GROUP BY pdc.MATRICULA HAVING COUNT(*) > 1
SELECT COUNT(*) AS cont,pdc.NUP INTO #temp_nupdup --drop table #temp_nupdup
FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NOT NULL
GROUP BY pdc.NUP HAVING COUNT(*) > 1

SELECT COUNT(*), pcpp.NUP FROM dbo.Piv_CERTIF_PMM_PU pcpp 
WHERE pcpp.NUP IS NOT NULL AND pcpp.IdTramite IS NOT NULL
GROUP BY pcpp.NUP HAVING COUNT(*) > 1

SELECT * FROM #temp_nupdup

--parche para el campo version
SELECT dc.NUP,IdTramite,dc.Version
FROM PagoU.DocumentoComparativo dc 
WHERE dc.NUP IN (SELECT NUP FROM #temp_nupdup)
ORDER BY dc.IdTramite

SELECT p.NUP,p.IdTramite,p.Version,ROW_NUMBER() OVER(PARTITION BY NUP ORDER BY IdTramite ASC) AS [VERSION]
FROM (SELECT dc.NUP,dc.Version,dc.IdTramite 
      FROM PagoU.DocumentoComparativo dc 
      WHERE dc.NUP IN (SELECT NUP FROM #temp_nupdup)      
     )p

SELECT pcpp.MATRICULA,pcpp.NUP,pcpp.TRAMITE
FROM dbo.Piv_DOC_COMPARATIVO pcpp JOIN #temp_nupdup a ON pcpp.NUP = a.NUP
ORDER BY pcpp.MATRICULA

-----------------------------------------
--verificacion de cantidades
SELECT COUNT(*) FROM PagoU.CertificadoPMMPU cp
SELECT COUNT(*) FROM dbo.Piv_CERTIF_PMM_PU pcpp
WHERE pcpp.NUP IS NULL AND pcpp.IdTramite IS NOT NULL
SELECT * FROM dbo.Piv_CERTIF_PMM_PU pcpp WHERE pcpp.Estado = 'U'--no en clasificador

SELECT COUNT(*) FROM PagoU.DocumentoComparativo dc 
SELECT COUNT(*) FROM dbo.Piv_DOC_COMPARATIVO pdc
WHERE pdc.NUP IS NOT NULL AND pdc.IdTramite IS NULL
SELECT * FROM dbo.Piv_DOC_COMPARATIVO pdc WHERE pdc.ESTADO = 'U'

SELECT COUNT(*) FROM PagoU.PreBeneficiarios dc 
SELECT COUNT(*) FROM dbo.Piv_PreBeneficiarios ppb
WHERE ppb.NUP IS NOT NULL AND ppb.IdTramite IS NULL

SELECT COUNT(*) FROM PagoU.PreTitulares dc 
SELECT COUNT(*) FROM dbo.Piv_PreTitulares ppt 
WHERE ppt.NUP IS NOT NULL AND ppt.IdTramite IS NULL

SELECT COUNT(*) FROM PagoU.TitularPU dc 
SELECT COUNT(*) FROM dbo.Piv_TitularPU ptp 
WHERE ptp.NUP IS NOT NULL AND ptp.IdTramite IS NULL

SELECT COUNT(*) FROM PagoU.ChequePU dc 
SELECT COUNT(*) FROM dbo.Piv_ChequePU pcp 
WHERE pcp.NUPTitular IS NULL

---------------------------------------------------
SELECT dbo.fn_CharLTrim('0','0000210215-152')
--soluciona 49 casos de los 117 en CertificacionPMMPU 
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(pcpp.CI)))) 
	FROM dbo.Piv_CERTIF_PMM_PU pcpp WHERE pcpp.NUP IS NULL
)
--soluciona 205 casos de los 535 en DocumentoComparativo
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) 
	FROM dbo.Piv_DOC_COMPARATIVO a WHERE a.NUP IS NULL
)
--soluciona 2 casos de los 10 en PreBeneficiarios
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_PreBeneficiarios a WHERE a.NUP IS NULL
)
--soluciona 40 casos de los 42 en PreTitulares
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_PreTitulares a WHERE a.NUP IS NULL
)
--soluciona 44 casos de los 52 en TitularPU
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_TitularPU a WHERE a.NUP IS NULL
)
--soluciona 41 casos de los 49 en ChequePU
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento IN(
	SELECT dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) 
	FROM dbo.Piv_ChequePU a WHERE a.NUPTitular IS NULL
)

---------------------------------------------------
SELECT * FROM SENARITD.Persona.Persona p WHERE p.NumeroDocumento = '1095808'
SELECT * FROM SENARITD.Persona.Persona p 
WHERE p.PrimerApellido = 'AGUILAR'
	  AND p.SegundoApellido = 'UGARTE'
SELECT * FROM dbo.Piv_CERTIF_PMM_PU pcpp
WHERE pcpp.NUP IS NULL	  

SELECT DISTINCT p.NumeroDocumento,dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(pcpp.CI)))
FROM Persona.Persona p JOIN dbo.Piv_CERTIF_PMM_PU pcpp ON pcpp.NUP = p.NUP

SELECT p.NUP,a.CI,p.NumeroDocumento,p.PrimerApellido+' '+p.SegundoApellido+' '+p.PrimerNombre,a.Paterno+' '+a.Materno+' '+a.Nombres
FROM SENARITD.Persona.Persona p 
JOIN dbo.Piv_CERTIF_PMM_PU a ON 
p.PrimerApellido = a.Paterno AND
p.SegundoApellido = a.Materno AND 
p.PrimerNombre = a.Nombres
WHERE a.NUP IS NULL	  	




