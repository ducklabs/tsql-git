USE [tsqlGit]
GO
/****** Object:  StoredProcedure [git].[pullLatest]    Script Date: 7/16/2018 4:22:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joey Lai
-- Create date: July 16, 2018
-- Description:	Pulls latest changes to remote repo
-- =============================================
ALTER PROCEDURE [git].[pullLatest]
AS
BEGIN

	declare @gitDirectory varchar(255)
	select @gitDirectory = repoDirectory from git.config

	declare @gitPullShell varchar(4000) = concat('cd ', @gitDirectory, ' & git pull')
	print 'running: ' + @gitPullShell
	exec xp_cmdshell @gitPullShell

END

-- exec git.pullLatest
