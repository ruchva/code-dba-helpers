/** inserta personas de la tabla PreBeneficiarios que no se encuentran en Persona ni en otras bases **/

--insert into Persona.Persona(IdTipoDocumento,IdEstadoCivil,IdEntidadGestora,IdSexo,CUA,Matricula,NUB,NumeroDocumento,ComplementoSEGIP,IdDocumentoExpedido,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,ApellidoCasada,FechaNacimiento,FechaFallecimiento,IdPaisResidencia,CorreoElectronico,Celular,Direccion,IdLocalidad,Telefono,RegistroActivo,IdHuella,FechaRegistroPersona,IdUsuarioRegistro)
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
	  ,case when NUM_IDENTIF <> '0' then dbo.fn_CharLTrim('0',NUM_IDENTIF)
	        when NUM_IDENTIF =  '0' then '9999999'
       end'NumeroDocumento'
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
	  ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end'PrimerNombre'
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then RIGHT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), len(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) - charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(DH_NOMBRES)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else '' end'SegundoNombre'
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

/*
--luego de introducir las personas debemos actualziar los NUPDH en el pivote Piv_PreBeneficiarios
--antes de vaciar a la tabla destino PreBeneficiarios ejecutando:
	
	UPDATE a SET NUPDH = p.NUP
	FROM dbo.Piv_PreBeneficiarios a
	JOIN Persona.Persona p ON p.Matricula = a.DH_MATRICULA
	where a.NUP is not null and a.NUPDH is null
*/	


