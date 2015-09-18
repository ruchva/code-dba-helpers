select * from Beneficio.BeneficioAsegurado

select d.NUP --NUPAsegurado
      ,d.IdGrupoBeneficio --IdGrupoBeneficio
	  ,null --IdBeneficioOtorgado *
	  ,null --IdCampoAplicacion *
	  ,null --FechaOtorgamiento *
	  ,null --PeriodoInicioPago *
	  ,null --PeriodoFinalPago *
	  ,null --IdEstadoBeneficio *
	  ,'TramiteMigrado' --Observaciones
	  ,null --FechaConclusionBeneficio
	  ,null --NroTramiteProceso
	  ,null --AplicaDescuento
	  ,0 --RegistroActivo
	  ,null --IdTipoTramiteProceso

from PagoU.DocumentoComparativo d






