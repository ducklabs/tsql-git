USE [tsqlGit]
GO
/****** Object:  StoredProcedure [git].[initRepo]    Script Date: 7/16/2018 4:22:14 PM ******/
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

	truncate table git.config

	-- create directory
	exec util.createSubDirectoryIfNotExists @directoryPath , @repoName


	-- initialize git project
	declare @repoPath varchar(4000) = concat(@directoryPath, '/', @repoName)
	declare @gitInitShell varchar(4000)= 'git init ' + @repoPath
	print 'running: ' + @gitInitShell
	exec xp_cmdshell @gitInitShell


	-- git user config
	declare @gitUserNameConfig varchar(4000) = concat('cd ', @repoPath, ' & git config user.name "', @userName, '"')
	print 'running: ' + @gitUserNameConfig
	exec xp_cmdshell @gitUserNameConfig

	declare @gitUserEmailConfig varchar(4000) = concat('cd ', @repoPath, ' & git config user.email "', @userEmail, '"')
	print 'running: ' + @gitUserEmailConfig
	exec xp_cmdshell @gitUserEmailConfig

	declare @gitStoreCredentials varchar(4000) = concat('cd ', @repoPath, ' & git config credential.helper store')
	print 'running: ' + @gitStoreCredentials
	exec xp_cmdshell @gitStoreCredentials


	-- set up remote
	declare @gitRemoteRmConfig varchar(4000) = concat('cd ', @repoPath, ' & git remote remove remote')
	print 'running: ' + @gitRemoteRmConfig
	exec xp_cmdshell @gitRemoteRmConfig

	declare @gitRemoteAddConfig varchar(4000) = concat('cd ', @repoPath, ' & git remote add remote ', @remoteUrl)
	print 'running: ' + @gitRemoteAddConfig
	exec xp_cmdshell @gitRemoteAddConfig


	-- update config
	insert into git.config (repoDirectory, userName, userEmail, remoteUrl) values (@repoPath, @userName, @userEmail, @remoteUrl)

	select * from git.config

END

-- exec git.initRepo 'C:/GitHub', 'tSQL', 'jlai403', 'j.lai@live.ca', 'https://github.com/jlai403/tsql-git.git'
