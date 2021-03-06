USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'exec_query', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SENASIR\Rchiara', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'exec_query', @server_name = N'UTI_PROC10'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'exec_query', @step_name=N'abrir query', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=3, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'

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
delete from Beneficio.BeneficioAsegurado where Observaciones = ''Tramite Migrado PU''
--delete from Persona.Persona where

exec [dbo].[MigraPagoUnico];
exec [dbo].[MigraBeneficioAsegurado];
exec [dbo].[MigraPersona];

', 
		@database_name=N'SENASIR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'exec_query', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SENASIR\Rchiara', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'exec_query', @name=N'inicia', 
		@enabled=1, 
		@freq_type=1, 
		@freq_interval=1, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150930, 
		@active_end_date=99991231, 
		@active_start_time=123000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
