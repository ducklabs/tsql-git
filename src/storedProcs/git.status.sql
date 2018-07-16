USE [tsqlGit]
GO
/****** Object:  StoredProcedure [git].[status]    Script Date: 7/16/2018 4:23:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Joey Lai
-- Create date: July 16, 2018
-- Description:	Get git status
-- =============================================
ALTER PROCEDURE [git].[status]
AS
BEGIN

	declare @gitDirectory varchar(255)
	select @gitDirectory = repoDirectory from git.config

	declare @gitStatusShell varchar(4000) = concat('cd ', @gitDirectory, ' & git status')
	print 'running: ' + @gitStatusShell
	exec xp_cmdshell @gitStatusShell

END
