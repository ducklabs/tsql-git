USE [tsqlGit]
GO
/****** Object:  StoredProcedure [util].[writeToFile]    Script Date: 7/16/2018 4:23:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Joey Lai
-- Create date: July 12, 2018
-- Description:	Util proc to Write to file
-- =============================================
ALTER PROCEDURE [util].[writeToFile]
	@file varchar(4000),
	@text varchar(max)
AS
BEGIN
	declare @ole int
	declare @fileId int

	execute sp_OACreate 'Scripting.FileSystemObject', @ole out

	execute sp_OAMethod @ole
		,'OpenTextFile'
		,@fileId OUT
		,@file
		,2 -- overwrite file
		,1

	execute sp_OAMethod @fileId
		,'WriteLine'
		,NULL
		,@text

	print 'wrote to file: ' + @file

	execute sp_OADestroy @fileId
	execute sp_OADestroy @ole

END
