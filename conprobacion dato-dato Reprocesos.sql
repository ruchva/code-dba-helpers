--*****EN ORIGEN Y NO EN DESTINO*****--

SELECT * FROM SENARITD.dbo.Piv_REPROCESO_CC a
WHERE NOT EXISTS (SELECT * FROM SENARITD.Reprocesos.ReprocesoCC rc WHERE rc.NUP = a.NUP)
ORDER BY a.NUP

---------------------------------------
SELECT * FROM Persona.Persona p WHERE p.NUP = 57374
SELECT * FROM SENARITD.Reprocesos.ReprocesoCC rc WHERE rc.NroFormularioRepro = 1200
SELECT * FROM dbo.Piv_REPROCESO_CC_rows prcr WHERE prcr.rownumber = 1200
SELECT * FROM CC.dbo.REPROCESO_CC rc WHERE rc.NRO_FORM = 4005

---------------------------------------






