SELECT r.IdTramite,r.FechaSolicitud,r.FechaInicioRepro,r.NUP,r.IdTipoBeneficio,r.NoFormularioCalculo,r.EstadoFormCalcCC,r.MontoCC,r.SIP_impresion,r.NroCertificado,'CertificadosCC' AS CertificadosCC,r.IdUsuario
FROM Reprocesos.ReprocesoCC r
INNER JOIN CertificacionCC.FormularioCalculoCC fc ON r.IdTramite=fc.IdTramite AND r.IdGrupoBeneficio=fc.IdGrupoBeneficio 
AND r.IdTipoFormularioCalculo=fc.IdTipoFormularioCalculo
WHERE r.IdTipoReproceso=31383
/*OBS
*** IdTipoBeneficio no puede ser null y tiene que estar de acuerdo al clasificador
*** NoFormularioCalculo no puede ser NULL y siempre tiene que apuntar al FormularioCalculoCC que da origen al CertificadoCC
*** NFormTipoRepro no existe en Reprocesos.ReprocesoCC (actualizar la estructura)
* EstadoFormCalcCC, MontoCC, SIP_impresion no pueden ser NULL
* Verificar la correspondencia de NroCertificado con CertificadoCC
*** IdUsuario??
*/

SELECT TOP 10 * FROM SENARITD.CertificacionCC.FormularioCalculoCC
/*
*para obtener el EstadoFormCalcCC y el SIP_impresion cruzamos con esta tabla en una etaa posterior - parche
*/

SELECT COUNT(*),rc.IdTipoReproceso FROM Reprocesos.ReprocesoCC rc
GROUP BY rc.IdTipoReproceso HAVING COUNT(*) > 1

--DELETE FROM Reprocesos.ReprocesoCC WHERE IdTipoReproceso <> 31389

SELECT TOP 100 r.IdTipoReproceso
              ,r.FechaSolicitud
              ,r.FechaInicioRepro
              ,r.NUP,r.IdTipoBeneficio
              ,r.NoFormularioCalculo
              ,r.EstadoFormCalcCC
              ,r.MontoCC
              ,r.SIP_impresion
              ,r.NroCertificado
              ,'CertificadosCC' AS CertificadosCC
              ,r.IdUsuario 
FROM SENARITD.Reprocesos.ReprocesoCC r
ORDER BY r.NroFormularioRepro

---------------------------------------------------
SELECT * FROM CC.dbo.REPROCESO_CC rc









