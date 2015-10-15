/*--NUASNO
select ROW_NUMBER() over(PARTITION BY Pa_nua order by Pa_nua)as cuenta,*
into NUASNO from PIVOTE..migratitularoficial
--migratitularoficial
select * into PIVOTE..migratitularoficial from PIVOTE..Migra_titulares 
--Migra_titulares
select * --grupo grande
into Migra_titulares from PAGOCCOFICIAL a join #tmp_titularH b on a.no_certi =b.no_certi and a.nua=b.nua and a.tipo_cc =b.tipo_cc and a.identificador =b.num_ide
--#tmp_titularH 
select d.*,e.CApli, e.ClaseRenta, e.FlagTipo, e.Fecha_IngresoT, e.Flag_Asignado, e.Flag_Culminado,e.TRBASICA, e.TRCOMPLEMENTARIA, e.TRCALIFICADO
into #tmp_titularH from #2daparte d join CC..MARCA_CC f ON f.Matricula=d.Matricula and f.Tipo_CC=case when d.Clase_CC='A' then '6'
																							          when d.Clase_CC='M' then '7' end 
																				   and f.Tramite=d.Tramite
                                    join CRENTA..TRAMITE e on d.Tramite=e.Tramite and f.Matricula_cys=e.Matricula and e.Tramite=f.Tramite
--#2daparte
select c.*,d.Matricula, d.componente, d.fecha_pro, d.fecha_apro,d.estado, d.fecha_calculo, d.fecha_emision, d.monto_CC as montocc_certif, d.ref_componente
into #2daparte from #1ERAPARTE c join #tmp_certificado d on c.Tramite=d.Tramite and c.No=d.no_certif and c.tipo_cc =d.tipo_cc
--#1ERAPARTE
select b.cod_fuente, b.nua, b.no_certi, b.tipo_cc, b.tipo_ide, b.num_ide, b.ext_ide,b.pri_ape, b.seg_ape, b.pri_nomb, b.seg_nomb, b.sexo, b.fech_nac, b.fech_sol,
b.fech_fall,b.tipo_cam1,b.monto_or, b.tipo_cam2, b.tipo_ajus, b.porc_ajus,b.salario_base, b.anios_insalub, b.monto_ajus, b.est_titu, b.no_solic, b.periodo_sol, 
b.num_com, b.complementaria_tgn, b.FFAA, c.Correlativo2, c.Fecha_CC, c.Clase_CC,c.P_Apellido, c.S_Apellido, c.Nom1_Sol, c.Nom2_Sol, c.Monto_CC, c.Tipo_Cambio, 
c.Codigo_Act, c.Tipo_Id, c.Densidad, c.Lug_Emi, c.A_Conyuge, c.Fecha_RA,c.Num_RA, c.No_Aportes, c.Tramite as Tramite, c.Salario_actualizado, c.Periodo, c.Simultaneo,
c.Num_Comp_Alfanumerico,c.No
into #1ERAPARTE from #tmp_titular b join mediosmag c on b.nua = c.NUA and b.no_certi = c.No and dbo.eliminaLetras(dbo.eliminapuntos(dbo.eliminaCerosIzqui( b.num_ide)))= dbo.eliminaCerosIzqui(c.Num_Id)
where c.Num_Id not like '%E%'
--#tmp_titular
select TITULAR_CC.cod_fuente, TITULAR_CC.nua, TITULAR_CC.no_certi, 
       TITULAR_CC.tipo_cc, TITULAR_CC.tipo_ide, TITULAR_CC.num_ide, TITULAR_CC.ext_ide,
       TITULAR_CC.pri_ape, TITULAR_CC.seg_ape, TITULAR_CC.pri_nomb, TITULAR_CC.seg_nomb, 
       TITULAR_CC.sexo, TITULAR_CC.fech_nac, TITULAR_CC.fech_sol, TITULAR_CC.fech_fall, 
       TITULAR_CC.tipo_cam1, TITULAR_CC.monto_or, TITULAR_CC.tipo_cam2, TITULAR_CC.tipo_ajus,
       TITULAR_CC.porc_ajus, TITULAR_CC.salario_base, TITULAR_CC.anios_insalub, 
       TITULAR_CC.monto_ajus, TITULAR_CC.est_titu, TITULAR_CC.no_solic, 
       TITULAR_CC.periodo_sol, TITULAR_CC.num_com, 000000000.00 as complementaria_tgn, 0 as FFAA
--into #tmp_titular 
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
union
(  
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
)*/
/**************************************************************************************************************************************************/
insert into Persona.Persona
(IdTipoDocumento,IdEstadoCivil,IdEntidadGestora,IdSexo,CUA,Matricula,NUB,NumeroDocumento,ComplementoSEGIP,IdDocumentoExpedido,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,ApellidoCasada,
FechaNacimiento,FechaFallecimiento,IdPaisResidencia,CorreoElectronico,Celular,Direccion,IdLocalidad,Telefono,RegistroActivo,IdHuella,FechaRegistroPersona,IdUsuarioRegistro)
select top 5 
      MG_Tipo_Id = case 
						when MG_Tipo_Id = 'I' then '25'   
						when isnull(MG_Tipo_Id,'') = '' and isnull(Tit_num_ide,'') = '' then '30'  
						when isnull(MG_Tipo_Id,'') = '' and (Tit_num_ide is not null) then '24'
						when MG_Tipo_Id = 'E' then '26'
						when MG_Tipo_Id = 'R' then '26'
						when MG_Tipo_Id is null then '30'
						when MG_Tipo_Id = 'P' then '30'
				   end,--IdTipoDocumento      
      'EstadoCivil' = case 
						 when(select [Estado Civil] from CRENTA..PERSONA c where a.Cer_Matricula = Matricula) = '0' then '20'
						 when(select [Estado Civil] from CRENTA..PERSONA c where a.Cer_Matricula = Matricula) = '1' then '21'
						 when(select [Estado Civil] from CRENTA..PERSONA c where a.Cer_Matricula = Matricula) = '2' then '17'
						 when(select [Estado Civil] from CRENTA..PERSONA c where a.Cer_Matricula = Matricula) = '3' then '23'
						 when(select [Estado Civil] from CRENTA..PERSONA c where a.Cer_Matricula = Matricula) = '4' then '19'
						 when(select [Estado Civil] from CRENTA..PERSONA c where a.Cer_Matricula = Matricula) = '5' then '20'
                         else '20' 
					  end,--IdEstadoCivil
      Pa_cod_fuen = case 
					    when Tit_cod_fuente = '01' then '344'  
					    when Tit_cod_fuente = '02' then '345' 
					    when Tit_cod_fuente = '203' then '346' 
					    when Tit_cod_fuente = '205' then '347'       
					end,--IdEntidadGestora      
      Tit_sexo = case 
					when Tit_sexo = 'F' then '1'
					when Tit_sexo = 'M' then '2'
			     end,--IdSexo   
      cast(Tit_nua as bigint)'CUA',--CUA
      Cer_Matricula,--Matricula    
      --(select distinct NUB from RENTA_D..RD_PRESTACION where a.Cer_Matricula=T_MATRICULA AND TIPO='T' and a.Tit_pri_nomb=NOMBRE1 and a.Tit_pri_ape=PATERNO),-- nub de RENTA_D.RD_Prestacion
      'NUB',
	  dbo.eliminaCerosIzqui((dbo.eliminaLetras(dbo.eliminapuntos(Tit_num_ide)))),--NumeroDocumento
      Tit_num_com,--ComplementoSEGIP
      Tit_ext_ide = case 
				       when Tit_ext_ide = 'LP' then '46'
				       when Tit_ext_ide = 'LP.' then '46'
				       when Tit_ext_ide = 'LPZ' then '46'
				       when Tit_ext_ide = 'ORU' then '47'   
				       when Tit_ext_ide = 'PDO' then '48'
				       when Tit_ext_ide = 'PTS' then '49'
				       when Tit_ext_ide = 'SA' then '50'
				       when Tit_ext_ide = 'SCZ' then '50'
				       when Tit_ext_ide = 'TJA' then '51'
				       when Tit_ext_ide = 'TPZ' then '31505'
				       when Tit_ext_ide = 'TRJ' then '51'
				       when Tit_ext_ide = 'TZA' then '31505'    
				       when Tit_ext_ide = 'YAC' then '31507'
				       when Tit_ext_ide = 'YBA' then '31507'
				    end,--IdDocumentoExpedido   
      Tit_pri_nomb = case when Tit_pri_nomb = 'NULL' then '' else isnull(Tit_pri_nomb,'') end,--PrimerNombre
      Tit_seg_nomb = case when Tit_seg_nomb = 'NULL' then '' else isnull(Tit_seg_nomb,'') end,--SegundoNombre
      Tit_pri_ape  = case when Tit_pri_ape  = 'NULL' then '' else isnull(Tit_pri_ape,'')  end,--PrimerApellido 
      Tit_seg_ape  = case when Tit_seg_ape  = 'NULL' then '' else isnull(Tit_seg_ape,'')  end,--SegundoApellido
      MG_A_Conyuge = case when MG_A_Conyuge = 'NULL' then '' else isnull(MG_A_Conyuge,'') end,--ApellidoCasada
      cast (Tit_fech_nac as date),--FechaNacimiento
      '',--Fecha Fallecimiento
      83,--IdPaisResidencia
      '',--correo electronico
      '',--celular
      (select Direccion from CRENTA..PERSONA c where Cer_Matricula = c.Matricula),--Direccion
      0,--idlocalidad --ninguno     
      (select Telefono from CRENTA..PERSONA c where Cer_Matricula = c.Matricula),--Telefono
      1,--RegistroActivo
      '',--IdHuella
      fechareg,--FechaRegistroPersona
      (select IdUsuario from Seguridad.Usuario b where b.CuentaUsuario=a.usuarioreg)--IdUsuarioRegistro
from NUASNO a
where cuenta = 1 and Pa_nua not in('000000020083181','000000100025626','000000100434371')--Palominos,trigo,cuba
/*******************************************************************************************************************/
insert into Persona.Persona(IdTipoDocumento,IdEstadoCivil,IdEntidadGestora,IdSexo,CUA,Matricula,NUB,NumeroDocumento,ComplementoSEGIP,IdDocumentoExpedido,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,ApellidoCasada,FechaNacimiento,FechaFallecimiento,IdPaisResidencia,CorreoElectronico,Celular,Direccion,IdLocalidad,Telefono,RegistroActivo,IdHuella,FechaRegistroPersona,IdUsuarioRegistro)
--select IdTipoDocumento,IdEstadoCivil,IdEntidadGestora,IdSexo,CUA,Matricula,NUB,NumeroDocumento,ComplementoSEGIP,IdDocumentoExpedido,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,ApellidoCasada,FechaNacimiento,FechaFallecimiento,IdPaisResidencia,CorreoElectronico,Celular,Direccion,IdLocalidad,Telefono,RegistroActivo,IdHuella,FechaRegistroPersona,IdUsuarioRegistro from Persona.Persona
select case when TIPO_IDENTIF = 1 then 25
			when TIPO_IDENTIF = 2 then 29
			when TIPO_IDENTIF = 3 then 24
			when TIPO_IDENTIF = 4 then 28
			when TIPO_IDENTIF = 5 then 24
	   end'TipoDocumento'
      ,case when ECIVIL = 0 then 20
	        when ECIVIL = 1 then 21
			when ECIVIL = 2 then 17
			when ECIVIL = 3 then 23
			when ECIVIL = 4 then 19
			when ECIVIL = 5 then 20
	   end'EstadoCovil'
	  ,31511'EntidadGestora'--ninguno
	  ,case	when SEXO = 'F' then '1'
			when SEXO = 'M' then '2'
	   end'IdSexo'
	  ,0'CUA'--no tiene
	  ,DH_MATRICULA
	  ,null'NUB'--no tiene
	  ,NUM_IDENTIF
	  ,null'ComplementoSEGIP'
	  ,case when EXPEDIDO = '1' then 46
			when EXPEDIDO = '2' then 43
			when EXPEDIDO = '3' then 50
			when EXPEDIDO = '4' then 47
			when EXPEDIDO = '5' then 49
			when EXPEDIDO = '6' then 44
			when EXPEDIDO = '7' then 51
			when EXPEDIDO = '8' then 42
			when EXPEDIDO = '9' then 48
			when EXPEDIDO = 'C' then 44
			when EXPEDIDO = 'E' then 45
			when EXPEDIDO = 'L' then 31508
			when EXPEDIDO = 'T' then 31505
			when EXPEDIDO = '' then 31512
			when EXPEDIDO is null then 31512
	   end'IdDocumentoExpedido'   
	  ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then RIGHT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), len(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) - charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else '' end
      ,DH_PATERNO'PrimerApellido'
	  ,DH_MATERNO'SegundoApellido'
	  ,null'ApellidoCasada'  
	  ,FECHA_NAC'FechaNacimiento'
	  ,FECHA_FALL'FechaFallecimiento'
	  ,83'IdPaisResidencia'
	  ,null'CorreoElectronico'
	  ,null'Celular'
	  ,null'Direccion'
	  ,0'IdLocalidad'
	  ,null'Telefono'
	  ,1'RegistroActivo'
	  ,0'IdHuella'
	  ,getdate()'FechaRegistroPersona'
	  ,812'IdUsuarioRegistro'
from Piv_PreBeneficiarios

--------------------------------------------------------
select * from PAGOS_P..param_tipo_identif
select * from PAGOS_P..param_ecivil
select * from PAGOS_P..param_expedido
--------------------------------------------------------
select * from Piv_PreBeneficiarios a 
--join CRENTA.dbo.BENEFICIARIO b on a.DH_MATRICULA = b.BMatricula
join CRENTA.dbo.PERSONA b on a.DH_MATRICULA = b.Matricula   





