

use SENASIR 

exec [dbo].[CreaPivoteTablasCC];
exec [dbo].[CreaPivoteTablasPAGOS_PU];
-----------------------------------
delete from PagoU.CertificadoPMMPU
delete from PagoU.DocumentoComparativo
delete from PagoU.PreBeneficiarios
delete from PagoU.PreTitulares
delete from PagoU.ChequePU
delete from PagoU.TitularPU
delete from Beneficio.BeneficioAsegurado where Observaciones = 'Tramite Migrado PU'
--delete from Persona.Persona where

exec [dbo].[MigraPagoUnico];
exec [dbo].[MigraBeneficioAsegurado];
exec [dbo].[MigraPersona];


















