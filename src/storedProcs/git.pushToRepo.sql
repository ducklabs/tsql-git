USE [tsqlGit]
GO
/****** Object:  StoredProcedure [git].[pushToRepo]    Script Date: 7/16/2018 4:09:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joey Lai
-- Create date: July 16, 2018
-- Description:	Push changes to remote repo
-- =============================================
ALTER PROCEDURE [git].[pushToRepo]
AS
BEGIN

	declare @gitDirectory varchar(255)
	select @gitDirectory = repoDirectory from git.config

	declare @gitPushShell varchar(4000) = concat('cd ', @gitDirectory, ' & git push')
	print 'running: ' + @gitPushShell
	exec xp_cmdshell @gitPushShell

END

-- exec git.pushToRepo
