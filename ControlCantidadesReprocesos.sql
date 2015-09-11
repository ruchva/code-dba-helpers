CREATE PROCEDURE ControlCantidadesReprocesos
AS
BEGIN	
	declare @cReprocesoCC int, @mig int
	select @cReprocesoCC = count(*) from Reprocesos.ReprocesoCC r where IdTipoReproceso <> 31389
	select @mig = count(*) from dbo.Piv_REPROCESO_CC_rows where IdTramite IS NOT NULL AND IdTipoTramite IS NOT NULL
	print '    REGISTROS MIGRADOS:  '+ CAST(@cReprocesoCC AS CHAR(5)) +'| ORIGEN:  '+ CAST(@mig AS CHAR(5))+'| OBSERVADOS:  '+CAST(@mig - @cReprocesoCC AS CHAR(5))
	print '------------------------------------------------------------------------------------------'

END	






