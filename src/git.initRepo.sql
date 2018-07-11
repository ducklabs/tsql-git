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

	set nocount on

	--declare @directoryPath varchar(4000) = 'C:\GitHub\'
	--declare @repoName varchar(255) = 'DevDB'

	declare @repoPath varchar(4000) = @directoryPath + @repoName 
	declare @dirTree table (subdirectory varchar(255), depth int)

	insert into @dirTree(subdirectory, depth)
		exec xp_dirtree @directoryPath

	if not exists (select 1 from @dirTree where subdirectory = @repoName)
		exec xp_create_subdir @repoPath

	declare @gitInitShell varchar(4000)= 'git init '-- + @repoPath
	exec xp_cmdshell @gitInitShell

END
