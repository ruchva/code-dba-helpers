select * from Piv_CERTIF_PMM_PU where NUP is null 
select * from Piv_CERTIF_PMM_PU where NUP is not null and IdTramite is null
select * from Piv_CERTIF_PMM_PU where EstadoM is null
/*********************************************************************************************/
select distinct *--p.MATRICULA,p.MATERNO,p.PATERNO,p.NOMBRES 
from Piv_DOC_COMPARATIVO p where NUP is null
select distinct *--p.MATRICULA,p.MATERNO,p.PATERNO,p.NOMBRES 
from Piv_DOC_COMPARATIVO p where NUP is not null and IdTramite is null
select * from Piv_DOC_COMPARATIVO p where EstadoM is null
--verificamos si estan los casos de CertificadoPMMPU  
select distinct *--p.MATRICULA,p.MATERNO,p.PATERNO,p.NOMBRES 
from Piv_DOC_COMPARATIVO p 
where p.NUP is null 
  and p.MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is null)

select distinct *--p.MATRICULA,p.MATERNO,p.PATERNO,p.NOMBRES 
from Piv_DOC_COMPARATIVO p 
where p.NUP is not null 
  and p.IdTramite is null 
  and p.MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is not null and IdTramite is null)
/*********************************************************************************************/
select distinct *--p.MATRICULA 
from Piv_PreTitulares p where NUP is null
select distinct *--p.MATRICULA from Piv_PreTitulares p 
where NUP is not null and IdTramite is null
--verificamos si estan los casos de PreTitulares
select distinct *--p.MATRICULA 
from Piv_PreTitulares p
where p.NUP is null
  and p.MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is null)  

select distinct *--p.MATRICULA 
from Piv_PreTitulares p
where p.NUP is not null
  and p.IdTramite is null
  and p.MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is not null and IdTramite is null)
/*********************************************************************************************/
select distinct p.T_MATRICULA from Piv_TitularPU p where NUP is null
select distinct p.T_MATRICULA from Piv_TitularPU p where NUP is not null and IdTramite is null
--verificamos si estan los casos de TitularPU
select distinct *--p.T_MATRICULA 
from Piv_TitularPU p 
where p.NUP is null
  and p.T_MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is null)

select distinct *--p.T_MATRICULA 
from Piv_TitularPU p 
where p.NUP is not null
  and p.IdTramite is null
  and p.T_MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is not null and IdTramite is null)
/*********************************************************************************************/
select distinct c.T_MATRICULA from Piv_ChequePU c where NUPTitular is null
--verificamos si estan los casos de ChequePU
select distinct *--c.T_MATRICULA 
from Piv_ChequePU c 
where c.NUPTitular is null
  and c.T_MATRICULA not in (select distinct p.Matricula from Piv_CERTIF_PMM_PU p where NUP is null)



