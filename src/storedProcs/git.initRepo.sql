USE [tsqlGit]
GO

-- =============================================
-- Author:		Joey Lai
-- Create date: July 10, 2018
-- Description:	Initialize Local Git Repository
-- =============================================
CREATE PROCEDURE [git].[initRepo]
	@directory varchar(255),
	@repoName varchar(255),
	@remoteUrl varchar(255) = ''
AS
BEGIN

	--declare @directoryPath varchar(4000) = 'C:\GitHub\'
	--declare @repoName varchar(255) = 'tSQL'
	--declare @remoteUrl varchar(255) = 'http://github.com'

	truncate table git.config

	-- create directory
	exec util.createSubDirectoryIfNotExists @directoryPath , @repoName

	-- initialize git project
	declare @repoPath varchar(4000) = @directoryPath + @repoName
	declare @gitInitShell varchar(4000)= 'git init ' + @repoPath
	exec xp_cmdshell @gitInitShell

	-- update config
	insert into git.config (repoDirectory, remoteUrl) values (@repoPath, @remoteUrl)

END
