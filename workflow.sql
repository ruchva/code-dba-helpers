/** WORKFLOW **/
SELECT ft.* FROM CRENTA.dbo.FUNC_TRAMITE ft 
JOIN CRENTA.dbo.TRAMITE t ON ft.Matricula = t.Matricula AND ft.Tramite = t.Tramite
WHERE t.ClaseRenta = 'U'

SELECT TOP 1000 * FROM CRENTA.dbo.FUNC_TRAMITE ft --expediente esta en Departamento
WHERE ft.Sta = 'P' AND ft.StaRec = 'P' AND ft.FechaSalida IS NULL

SELECT TOP 1000 * FROM CRENTA.dbo.FUNC_TRAMITE ft --ya salieron del departamento
WHERE ft.Sta = 'R' AND ft.StaRec = 'R' AND ft.FechaSalida IS NOT NULL

SELECT TOP 1000 * FROM CRENTA.dbo.FUNC_TRAMITE ft --asignada a otra area sin confirmar
WHERE ft.Sta = 'C' AND ft.StaRec = 'A' 
--SELECT * FROM CRENTA.dbo.FUNC_TRAMITE_ASG fta
--WHERE fta.Matricula = '030222OLE' AND fta.Tramite = '423/24' AND fta.Funcionario = 1945

--dbo.M_TRAMITES_ESTADOIN--217319

SELECT TOP 10 * FROM CRENTA.dbo.FUNCIONARIO f

SELECT TOP 10 * FROM CRENTA.dbo.DEPARTAMENTO d

SELECT TOP 10 * FROM SENARITD.Tramite.TramitePersona tp

SELECT * FROM SENARITD.Seguridad.Usuario u
SELECT * FROM CRENTA.dbo.sysadmusr s--***

---------------------------
SELECT TOP 10 * FROM M_ACTIVIDADFLUJO ma

SELECT TOP 10 * FROM M_ACTIVIDADFLUJO_C mac

SELECT TOP 10 * FROM M_TRAMITESFLUJO mt

SELECT TOP 10 * FROM M_TRAMITES_ESTADOIN mte--

SELECT TOP 10 * FROM M_TRAMITE_INCONSISTENCIASWF mti--no migrados












