/*
1° revisar esta consulta para identificar los repetidos y que no causen fallos
2° cargar los NUP repetidos en el query para luego pasarlos al insert de mas abajo

1°
select 	count(*),a.NUP--NUPASEGURADO	
from Piv_DOC_COMPARATIVO a
join Piv_CERTIF_PMM_PU b on a.MATRICULA = b.Matricula --los que tienes certificado
where a.ESTADO = 'A' and b.Estado = 'I'
  and a.NUP is not null 
  and a.IdTramite is not null 
  and a.IdBeneficio is not null
  and a.NUP not in (select NUPAsegurado from Beneficio.BeneficioAsegurado)
group by a.NUP having count(*) > 1 
order by a.NUP

2°
select * from Piv_DOC_COMPARATIVO a where a.NUP in (235034,236985)
select * from Piv_CERTIF_PMM_PU b where   b.NUP in (235034,236985)

*/
insert Beneficio.BeneficioAsegurado (
	 NUPAsegurado	,IdGrupoBeneficio	,IdBeneficioOtorgado	,IdCampoAplicacion	,FechaOtorgamiento	,PeridoInicioPago
	,PeriodoFinalPago	,IdEstadoBeneficio	,Observaciones	,FechaConclusionBeneficio	,NroTramiteProceso	,AplicaDescuento
	,IdTipoTramiteProceso	,RegistroActivo
)
select 
	 a.NUP--NUPASEGURADO
	,a.IdGrupoBeneficio---IdGrupoBeneficio
	,a.IdBeneficio
	,''---IdCampoAplicacion
	,a.FECHA_SELECCION---FechaOtorgamiento
	,cast(datepart(year,b.fecha_emi) as char(4)) + case when datepart(month,b.fecha_emi) = 1 then '01'
                                                        when datepart(month,b.fecha_emi) = 2 then '02'
														when datepart(month,b.fecha_emi) = 3 then '03'
														when datepart(month,b.fecha_emi) = 4 then '04'
														when datepart(month,b.fecha_emi) = 5 then '05'
														when datepart(month,b.fecha_emi) = 6 then '06'
														when datepart(month,b.fecha_emi) = 7 then '07'
														when datepart(month,b.fecha_emi) = 8 then '08'
														when datepart(month,b.fecha_emi) = 9 then '09'
														when datepart(month,b.fecha_emi) = 10 then '10'
														when datepart(month,b.fecha_emi) = 11 then '11'
														when datepart(month,b.fecha_emi) = 12 then '12'														
												   end	 ---PeridoInicioPago ---PeridoInicioPago
	,null ---PeriodoFinalPago
	,a.EstadoM
	,'Tramite Migrado PU'---Observaciones
	,null---FechaConclusionBeneficio
	,a.IdTramite---NroTramiteProceso
	,''---AplicaDescuento
	,''---idTipoTramiteProceso
	,0---RegistroActivo
from Piv_DOC_COMPARATIVO a
join Piv_CERTIF_PMM_PU b on a.MATRICULA = b.Matricula --los que tienes certificado
where a.ESTADO = 'A' and b.Estado = 'I'
  and a.NUP is not null 
  and a.IdTramite is not null 
  and a.IdBeneficio is not null
  and a.NUP not in (select NUPAsegurado from Beneficio.BeneficioAsegurado)
  --and a.NUP not in (161972,163915)--si existen repetidos
order by NUP


----si existen repetidos (2°) se completa en eata parte
--insert into Beneficio.BeneficioAsegurado values (161972,3,21,0,'2006-11-20','200611',null,31424,'Tramite Migrado PU',null,106506,0,0,0)
--insert into Beneficio.BeneficioAsegurado values (163915,3,21,0,'2006-04-26','200604',null,31424,'Tramite Migrado PU',null,87461,0,0,0)	