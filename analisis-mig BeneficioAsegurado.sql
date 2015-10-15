/*
--TRAZA BeneficioAsegurado
insert Beneficio.BeneficioAsegurado(
	 NUPAsegurado	,IdGrupoBeneficio	,IdBeneficioOtorgado	,IdCampoAplicacion	,FechaOtorgamiento	,PeridoInicioPago	,PeriodoFinalPago
	,IdEstadoBeneficio	,Observaciones	,FechaConclusionBeneficio	,NroTramiteProceso	,AplicaDescuento	,IdTipoTramiteProceso	,RegistroActivo
)
select 
	 NUP--NUPASEGURADO
	,3---IdGrupoBeneficio
	,case when Pa_tipo_cc='M' then '16' ---***cambiar para PU  
		  when Pa_tipo_cc='G' then '17' ---***cambiar para PU
	 end---idBeneficioOtorgado			
	,''---IdCampoAplicacion
	,fech_sol---FechaOtorgamiento
	,periodo_sol---PeridoInicioPago
	,periodo_pla---PeriodoFinalPago
	,case 
		when estadotitular1='F' then '363'
		when estadotitular1='A' then '364'
		when estadotitular1='B' then '365'
		when estadotitular1='G' then '366'
		when estadotitular1='H' then '367'
		when estadotitular1='X' then '368'
		when estadotitular1='Y' then '704'
		when estadotitular1='J' then '705'
		when estadotitular1='K' then '706'
		when estadotitular1='S' then '707'
		when estadotitular1='D' then '708'
		when estadotitular1='Q' then '709'
		when estadotitular1='V' then '710'
		when estadotitular1='R' then '711'
		when estadotitular1='I' then '712'
		when estadotitular1='T' then '712'
		when estadotitular1='N' then '712'
		when estadotitular1='P' then '712'
		when estadotitular1 is null then '712'
		when estadotitular1='' then '712'
	 end
	,'Tramite Migrado'---Observaciones
	,null---FechaConclusionBeneficio
	,IdTramite---NroTramiteProceso
	,''---AplicaDescuento
	,''---idTipoTramiteProceso
	,1---RegistroActivo
from #pagos111
--#pagos111
select ROW_NUMBER() over(PARTITION BY NUP
      ,3
      ,case when Pa_tipo_cc='M' then '358'   
            when Pa_tipo_cc='G' then '359'            
       end order by Pa_nua,periodo_pla desc)as cuenta3
	  ,* 
into #pagos111 
from #pagos11
--#pagos11
select ROW_NUMBER() over(PARTITION BY Pa_nua,Pa_identificador,Pa_tipo_cc,Tra_FlagTipo,Pa_no_certi order by Pa_nua,periodo_pla desc )as cuenta,* 
into #pagos11 
from #pagos12
--#pagos12
select * 
into #pagos12
from #pagos
union 
select * from #pagos1
--#pagos
select distinct dbo.eliminaLetras(a.Tit_num_ide) as Pa_identificador
               ,a.Pa_nua
			   ,a.Cer_Matricula
			   ,a.Pa_tipo_cc
			   ,a.Pa_no_certi
			   ,a.Tra_FlagTipo
			   ,max(a.Tit_fech_sol) as fech_sol
			   ,a.Tit_fech_fall
			   ,min(a.Tit_periodo_sol) as periodo_sol
			   ,max(a.Pa_periodo_pla) as periodo_pla
			   ,b.NUP
			   ,c.IdTramite
into #pagos
from NUASNOO a  
join Persona.Persona b on dbo.eliminaCerosIzqui(a.Pa_nua)=b.CUA and dbo.eliminaLetras(dbo.eliminaCerosIzqui(dbo.eliminapuntos(a.Tit_num_ide)))=b.NumeroDocumento
join Tramite.TramitePersona c on b.NUP=c.NUP
group by Pa_nua,Cer_Matricula,a.Pa_tipo_cc,Pa_no_certi,Tra_FlagTipo,Tit_num_ide,Tit_fech_fall,Tit_periodo_sol,Pa_periodo_pla,Tit_fech_sol,b.NUP,c.IdTramite
--#pagos1
select distinct dbo.eliminaLetras(num_ide) AS Pa_identificador
      ,nua,a.Matricula
	  ,a.tipo_cc
	  ,no_certi,FlagTipo
	  ,max(fech_sol) as fech_sol
	  ,fech_fall
	  ,min(periodo_sol) as periodo_sol
  	  ,0 as periodo_pla
      ,b.NUP
      ,c.IdTramite
into #pagos1 
from dbo.NUASNOO2 a  
join Persona.Persona b ON dbo.eliminaCerosIzqui(a.nua)=b.CUA and dbo.eliminaLetras(dbo.eliminaCerosIzqui(dbo.eliminapuntos(a.num_ide)))=b.NumeroDocumento
join Tramite.TramitePersona c on b.NUP=c.NUP
group by nua,a.Matricula,a.tipo_cc,no_certi,FlagTipo,num_ide,fech_fall,periodo_sol,fech_sol,b.NUP,c.IdTramite

--NUASNOO
select ROW_NUMBER() over(PARTITION BY Pa_nua,Pa_tipo_cc order by Pa_nua)as cuenta,*
into NUASNOO
from PIVOTE..migratitularoficial 
-----------------------
alter table NUASNOO add marca varchar(50)

--migratitularoficial
select * 
into PIVOTE..migratitularoficial
from PIVOTE..Migra_titulares 
union (select * from PIVOTE..Migra_titulares3)
--Migra_titulares
select * --conjunto especifico 
into PIVOTE..Migra_titulares
from PAGOCCOFICIAL a 
join #tmp_titularH b on a.no_certi =b.no_certi and a.nua=b.nua and a.tipo_cc =b.tipo_cc and a.identificador =b.num_ide
--Migra_titulares3
select * --conjunto especifico 
into PIVOTE..Migra_titulares3
from PAGOCCOFICIAL a 
join #tmp_titularH1 b on a.no_certi =b.no_certi and a.nua=b.nua and a.tipo_cc =b.tipo_cc

--PAGOCCOFICIAL
SELECT * 
INTO PAGOCCOFICIAL 
FROM PAGO_CC..PAGO_CC
UNION (SELECT * FROM PAGO_CC..PAGO_CCFA)
--#tmp_titularH
select d.*,e.CApli, e.ClaseRenta, e.FlagTipo, e.Fecha_IngresoT, e.Flag_Asignado, e.Flag_Culminado,
	   e.TRBASICA, e.TRCOMPLEMENTARIA, e.TRCALIFICADO
into #tmp_titularH
from #2daparte d join CC..MARCA_CC f on f.Matricula=d.Matricula and f.Tipo_CC=case when d.Clase_CC='A' then '6'
																				   when d.Clase_CC='M' then '7' 
																		      end and f.Tramite=d.Tramite
                 join CRENTA..TRAMITE e on d.Tramite=e.Tramite and f.Matricula_cys=e.Matricula and e.Tramite=f.Tramite
--#tmp_titularH1
drop table #tmp_titularH1
select * into #tmp_titularH1 from #tmp_titularH where cuenta=1

--#2daparte
select c.*,d.Matricula, d.componente, d.fecha_pro, d.fecha_apro, 
       d.estado, d.fecha_calculo, d.fecha_emision, d.monto_CC as montocc_certif, d.ref_componente
into #2daparte
from #1ERAPARTE c 
join #tmp_certificado d on c.Tramite=d.Tramite and c.No=d.no_certif and c.tipo_cc =d.tipo_cc
--#1ERAPARTE
select * --conjunto especifico
into #1ERAPARTE
from #tmp_titular b 
join mediosmag c on b.nua=c.NUA and b.no_certi=c.No and dbo.eliminaLetras(dbo.eliminapuntos(dbo.eliminaCerosIzqui( b.num_ide)))= dbo.eliminaCerosIzqui(c.Num_Id)
where c.Num_Id not like '%E%'
--#tmp_certificado
select a.Matricula,a.Tramite,a.componente,a.no_certif,a.fecha_pro,a.fecha_apro,
b.tipo_cc,b.estado,b.fecha_calculo,b.fecha_emision,b.monto_CC,b.ref_componente 
into #tmp_certificado_nh
from CC..CERTIFICADO a inner join CC..CALCULO_CC b on a.Matricula=b.Matricula and a.Tramite=b.Tramite and a.componente=b.componente 
---------los que no estan en el HIS
select a.Matricula,a.Tramite,a.componente,a.no_certif,a.fecha_pro,a.fecha_apro,
b.tipo_cc,b.estado,b.fecha_calculo,b.fecha_emision,b.monto_CC,b.ref_componente ,b.fecha_eli
into #tmp_certificado_h
from CC..CERTIFICADO_HIS a inner join CC..CALCULO_CC_HIS b on a.Matricula=b.Matricula and a.Tramite=b.Tramite and a.componente=b.componente and cast(a.fecha_eli as date)= cast(b.fecha_eli as date)
where b.estado in ('8','11')
---------union de ambos para tener un solo resultado 
select Matricula,Tramite,componente,no_certif,fecha_pro,fecha_apro,tipo_cc,estado,fecha_calculo,fecha_emision,monto_CC,ref_componente,0 as fecha_eli
into #tmp_certificado
from #tmp_certificado_nh 
union all
select Matricula,Tramite,componente,no_certif,fecha_pro,fecha_apro,tipo_cc,estado,fecha_calculo,fecha_emision,monto_CC,ref_componente,fecha_eli from #tmp_certificado_h 

--#tmp_titular
select TITULAR_CC.cod_fuente, TITULAR_CC.nua, TITULAR_CC.no_certi, 
       TITULAR_CC.tipo_cc, TITULAR_CC.tipo_ide, TITULAR_CC.num_ide, TITULAR_CC.ext_ide,
       TITULAR_CC.pri_ape, TITULAR_CC.seg_ape, TITULAR_CC.pri_nomb, TITULAR_CC.seg_nomb, 
       TITULAR_CC.sexo, TITULAR_CC.fech_nac, TITULAR_CC.fech_sol, TITULAR_CC.fech_fall, 
       TITULAR_CC.tipo_cam1, TITULAR_CC.monto_or, TITULAR_CC.tipo_cam2, TITULAR_CC.tipo_ajus,
       TITULAR_CC.porc_ajus, TITULAR_CC.salario_base, TITULAR_CC.anios_insalub, 
       TITULAR_CC.monto_ajus, TITULAR_CC.est_titu, TITULAR_CC.no_solic, 
       TITULAR_CC.periodo_sol, TITULAR_CC.num_com, 000000000.00 as complementaria_tgn, 0 as FFAA
into #tmp_titular 
from PAGO_CC..TITULAR_CC 
where nua+ cast(no_certi as varchar(100)) not in (select nua+ cast(no_certi as varchar(100))
												  from [PAGO_CC].[dbo].[TITULAR_CC]
												  group by nua,no_certi
												  having count(*)>1) 
union 
select TITULAR_CC.cod_fuente, TITULAR_CC.nua, TITULAR_CC.no_certi, 
       TITULAR_CC.tipo_cc, TITULAR_CC.tipo_ide, TITULAR_CC.num_ide, TITULAR_CC.ext_ide,
       TITULAR_CC.pri_ape, TITULAR_CC.seg_ape, TITULAR_CC.pri_nomb, TITULAR_CC.seg_nomb, 
       TITULAR_CC.sexo, TITULAR_CC.fech_nac, TITULAR_CC.fech_sol, TITULAR_CC.fech_fall, 
       TITULAR_CC.tipo_cam1, TITULAR_CC.monto_or, TITULAR_CC.tipo_cam2, TITULAR_CC.tipo_ajus,
       TITULAR_CC.porc_ajus, TITULAR_CC.salario_base, TITULAR_CC.anios_insalub, 
       TITULAR_CC.monto_ajus, TITULAR_CC.est_titu, TITULAR_CC.no_solic, 
       TITULAR_CC.periodo_sol, TITULAR_CC.num_com, 000000000.00 as complementaria_tgn, 0 as FFAA 
from PAGO_CC..TITULAR_CC 
where nua+no_certi in (select nua+no_certi
					   from [PAGO_CC].[dbo].[TITULAR_CC]
					   group by nua,no_certi
					   having count(*)>1)
union(  -- Encontrar registros unicos NUA y Certificado en Titular CC FA
		select TITULAR_CCFA.cod_fuente, TITULAR_CCFA.nua, TITULAR_CCFA.no_certi, 
			   TITULAR_CCFA.tipo_cc, TITULAR_CCFA.tipo_ide, TITULAR_CCFA.num_ide, TITULAR_CCFA.ext_ide,
			   TITULAR_CCFA.pri_ape, TITULAR_CCFA.seg_ape, TITULAR_CCFA.pri_nomb, TITULAR_CCFA.seg_nomb, 
			   TITULAR_CCFA.sexo, TITULAR_CCFA.fech_nac, TITULAR_CCFA.fech_sol, TITULAR_CCFA.fech_fall, 
			   TITULAR_CCFA.tipo_cam1, TITULAR_CCFA.monto_or, TITULAR_CCFA.tipo_cam2, TITULAR_CCFA.tipo_ajus,
			   TITULAR_CCFA.porc_ajus, TITULAR_CCFA.salario_base, TITULAR_CCFA.anios_insalub, 
			   TITULAR_CCFA.monto_ajus, TITULAR_CCFA.est_titu, TITULAR_CCFA.no_solic, 
			   TITULAR_CCFA.periodo_sol, TITULAR_CCFA.num_com, TITULAR_CCFA.complementaria_tgn, 1 as FFAA
		from PAGO_CC..TITULAR_CCFA 
		where nua+ cast(no_certi as varchar(100)) not in (select nua+ cast(no_certi as varchar(100))
														  from [PAGO_CC].[dbo].[TITULAR_CCFA]
														  group by nua,no_certi
														  having count(*)>1)
		union 
		select TITULAR_CCFA.cod_fuente, TITULAR_CCFA.nua, TITULAR_CCFA.no_certi, 
			   TITULAR_CCFA.tipo_cc, TITULAR_CCFA.tipo_ide, TITULAR_CCFA.num_ide, TITULAR_CCFA.ext_ide,
			   TITULAR_CCFA.pri_ape, TITULAR_CCFA.seg_ape, TITULAR_CCFA.pri_nomb, TITULAR_CCFA.seg_nomb, 
			   TITULAR_CCFA.sexo, TITULAR_CCFA.fech_nac, TITULAR_CCFA.fech_sol, TITULAR_CCFA.fech_fall, 
			   TITULAR_CCFA.tipo_cam1, TITULAR_CCFA.monto_or, TITULAR_CCFA.tipo_cam2, TITULAR_CCFA.tipo_ajus,
			   TITULAR_CCFA.porc_ajus, TITULAR_CCFA.salario_base, TITULAR_CCFA.anios_insalub, 
			   TITULAR_CCFA.monto_ajus, TITULAR_CCFA.est_titu, TITULAR_CCFA.no_solic, 
			   TITULAR_CCFA.periodo_sol, TITULAR_CCFA.num_com, TITULAR_CCFA.complementaria_tgn, 1 as FFAA 
		from PAGO_CC..TITULAR_CCFA 
		where nua+no_certi in (select nua+no_certi
							   from [PAGO_CC].[dbo].[TITULAR_CCFA]
							   group by nua,no_certi
							   having count(*)>1)
)
-- 
*/

select * from PagoU.DocumentoComparativo
select * from Piv_DOC_COMPARATIVO 
select * from Beneficio.BeneficioAsegurado
--
select count(*),a.MATRICULA from CC.dbo.DOC_COMPARATIVO a
where a.MATRICULA in (select Matricula from CC.dbo.CERTIF_PMM_PU) --and a.ESTADO = 'A'
group by a.MATRICULA having count(*) > 1

select * from CC.dbo.DOC_COMPARATIVO a where a.MATRICULA = '535910SGL' 
select * from CC.dbo.CERTIF_PMM_PU b where b.Matricula = '535910SGL'

select a.MATRICULA,a.FECHA_SELECCION,b.fecha_emi,a.SELEC 
from CC.dbo.DOC_COMPARATIVO a
join CC.dbo.CERTIF_PMM_PU b on a.MATRICULA = b.Matricula
where a.ESTADO = 'A' and b.Estado = 'I'

select a.NUP,a.IdBeneficio,a.FECHA_SELECCION,b.fecha_emi,a.EstadoM,a.IdTramite,a.SELEC 
from Piv_DOC_COMPARATIVO a
join Piv_CERTIF_PMM_PU b on a.MATRICULA = b.Matricula
where a.ESTADO = 'A' and b.Estado = 'I'
  and a.NUP is not null
  and a.IdTramite is not null
  and a.IdBeneficio is not null
  and a.NUP in (161972,163915)
order by NUP

select * from Piv_DOC_COMPARATIVO a where a.NUP in (161972,163915)
select * from Piv_CERTIF_PMM_PU b where   b.NUP in (161972,163915)

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
  and a.NUP not in (161972,163915)
order by NUP

insert into Beneficio.BeneficioAsegurado values (161972,3,21,0,'2006-11-20','200611',null,31424,'Tramite Migrado PU',null,106506,0,0,0)
insert into Beneficio.BeneficioAsegurado values (163915,3,21,0,'2006-04-26','200604',null,31424,'Tramite Migrado PU',null,87461,0,0,0)
--insert into Beneficio.BeneficioAsegurado values (132577,3,16,0,'2004-05-31','200411',NULL,31424,'Tramite Migrado PU',NULL,59935,0,0,0)--concatenado

/****************************************************************************************************************************************/
select cast(datepart(year,getdate()) as char(4)) + case when datepart(month,getdate()) = 1 then '01'
                                                        when datepart(month,getdate()) = 2 then '02'
														when datepart(month,getdate()) = 3 then '03'
														when datepart(month,getdate()) = 4 then '04'
														when datepart(month,getdate()) = 5 then '05'
														when datepart(month,getdate()) = 6 then '06'
														when datepart(month,getdate()) = 7 then '07'
														when datepart(month,getdate()) = 8 then '08'
														when datepart(month,getdate()) = 9 then '09'
														when datepart(month,getdate()) = 10 then '10'
														when datepart(month,getdate()) = 11 then '11'
														when datepart(month,getdate()) = 12 then '12'														
												   end	
/****************************************************************************************************************************************/

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

select * from Beneficio.BeneficioAsegurado a where a.Observaciones = 'Tramite Migrado PU'










