create procedure dbo.CompletaReprocesos
as
begin
	
	select f.EstadoCalculoCC,f.SIP_impresion
	from CertificacionCC.FormularioCalculoCC f 
	join Reprocesos.ReprocesoCC r on f.IdTramite = r.IdTramite

	---***ESTA SERIA LA SOLUCION?
	update r set r.EstadoFormCalcCC = f.EstadoCalculoCC, r.SIP_impresion = f.SIP_impresion
	from CertificacionCC.FormularioCalculoCC f 
	join Reprocesos.ReprocesoCC r on f.IdTramite = r.IdTramite

	
end 