USE [tsqlGit]
GO
/****** Object:  StoredProcedure [util].[getSqlForProc]    Script Date: 7/16/2018 11:22:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Author:		Joey Lai
-- Create date: July 11, 2018
-- Description:	Gets sql for stored proc
-- =============================================
ALTER PROCEDURE [util].[getSqlForProc]
	@procName varchar(255)
AS
BEGIN

	select
		@procName as name,
		sm.Definition
	from sys.sql_modules as sm
		join sys.objects as obj on sm.object_id = obj.object_id
	where obj.Type = 'P'
	and sm.object_id = object_id(@procName)

END
