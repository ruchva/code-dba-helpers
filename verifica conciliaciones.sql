select [PagoU].[FN_ObtieneEstadoCheque](P.NUP) 'IDESTADOCHEQUE',
    (select DescripcionDetalleClasificador from Clasificador.DetalleClasificador where IdDetalleClasificador=[PagoU].[FN_ObtieneEstadoCheque](P.NUP)) 'ESTADOCHEQUE',
    (case when exists(select * from PagoU.ChequePU where NUPTitular=P.NUP) then (select NumeroCheque from PagoU.ChequePU where RegistroActivo=1 and NUPTitular=P.NUP and FechaEmision =(select MAX(FechaEmision) from PagoU.ChequePU where NUPTitular=P.NUP)) else 0 end) 'NumeroCheque',
    (case when exists(select * from PagoU.ChequePU where NUPTitular=P.NUP) then (select FechaEmision from PagoU.ChequePU where RegistroActivo=1 and NUPTitular=P.NUP and FechaEmision =(select MAX(FechaEmision) from PagoU.ChequePU where NUPTitular=P.NUP)) else '01-01-1900' end) 'FECHAEMISIONCHEQUE',
    CE.NumeroCertificado,DC.IdTramite 'Tramite',P.NUP,P.CUA,P.Matricula,B.NroTramiteProceso,P.PrimerApellido,P.SegundoApellido,P.ApellidoCasada,P.PrimerNombre,P.SegundoNombre,P.FechaNacimiento,P.FechaFallecimiento,P.IdTipoDocumento, TD.DescripcionDetalleClasificador 'TIPODOCUMENTO',P.NumeroDocumento,P.IdDocumentoExpedido,EX.DescripcionDetalleClasificador,P.IdEstadoCivil, EC.DescripcionDetalleClasificador,P.IdEntidadGestora,EN.DescripcionDetalleClasificador,P.IdSexo,SE.DescripcionDetalleClasificador,
    CE.HojaRuta,CE.FechaHojaRuta,TP.IdSector, TP.IdOficinaRegistro 'IdRegional',
    DC.FechaEmision,DC.MontoPU,DC.TipoCambio,
    case when (select TPU.AniosInsalubres from PagoU.TitularPU TPU where TPU.FechaAlta=(select max(FechaAlta) from PagoU.TitularPU where RegistroActivo=1 and NUP=P.NUP) and TPU.RegistroActivo=1 and TPU.NUP=P.NUP)>0 then 1 else 0 end 'ANIOSINSALUBRES',
    DC.Descuento8porciento,
    (case DC.Salud when '0' then 0 else DC.NumeroMeses end) 'NROSALUD',
    TP.FechaInicioTramite 'FECHAVALIDAREDAD',
    DC.TipoCambio,CE.Monto 'MONTOPU'
from Persona.Persona P inner join Clasificador.DetalleClasificador TD on TD.IdDetalleClasificador=P.IdTipoDocumento inner join Clasificador.DetalleClasificador EC on EC.IdDetalleClasificador=P.IdEstadoCivil inner join Clasificador.DetalleClasificador EN on EN.IdDetalleClasificador=P.IdEntidadGestora inner join Clasificador.DetalleClasificador SE on SE.IdDetalleClasificador=P.IdSexo inner join Clasificador.DetalleClasificador EX on EX.IdDetalleClasificador=P.IdDocumentoExpedido
inner join Beneficio.BeneficioAsegurado B on B.NUPAsegurado=P.NUP and B.IdBeneficioOtorgado=21
inner join PagoU.CertificadoPMMPU CE on CE.NUP=P.NUP and CE.RegistroActivo=1
inner join PagoU.DocumentoComparativo DC on DC.IdBeneficio in (21,22) and DC.NUP=P.NUP and DC.RegistroActivo=1
inner join Tramite.TramitePersona TP on TP.NUP=P.NUP and DC.IdTramite=TP.IdTramite
where P.RegistroActivo=1 and (select COUNT(*) from Tramite.TramitePersona where IdTipoIniciaTramite=526 and NUP=NUPIniciaTramite and NUP=P.NUP)>0 
and P.Matricula = ''
