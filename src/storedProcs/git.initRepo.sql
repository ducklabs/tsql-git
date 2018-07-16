USE [tsqlGit]
GO
/****** Object:  StoredProcedure [git].[initRepo]    Script Date: 7/16/2018 10:58:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joey Lai
-- Create date: July 10, 2018
-- Description:	Initialize Local Git Repository
-- =============================================
ALTER PROCEDURE [git].[initRepo]
	@directoryPath varchar(4000),
	@repoName varchar(255),
	@userName varchar(255),
	@userEmail varchar(255),
	@remoteUrl varchar(255) = ''
AS
BEGIN
	set nocount on

	--declare @directoryPath varchar(4000) = 'C:/GitHub'
	--declare @repoName varchar(255) = 'tSQL'
	--declare @remoteUrl varchar(255) = 'http://github.com'

	truncate table git.config

	-- create directory
	exec util.createSubDirectoryIfNotExists @directoryPath , @repoName

	-- initialize git project
	declare @repoPath varchar(4000) = concat(@directoryPath, '/', @repoName)
	declare @gitInitShell varchar(4000)= 'git init ' + @repoPath
	exec xp_cmdshell @gitInitShell

	-- git user config
	declare @gitUserNameConfig varchar(4000) = concat('cd ', @repoPath, ' & git config user.name "', @userName, '"')
	exec xp_cmdshell @gitUserNameConfig

	declare @gitUserEmailConfig varchar(4000) = concat('cd ', @repoPath, ' & git config user.email "', @userEmail, '"')
	exec xp_cmdshell @gitUserEmailConfig

	-- update config
	insert into git.config (repoDirectory, userName, userEmail, remoteUrl) values (@repoPath, @userName, @userEmail, @remoteUrl)

END

-- exec tsqlgit.git.initRepo 'C:/GitHub', 'tSQL', 'Joey', 'j.lai@live.ca', 'http://github.com'
