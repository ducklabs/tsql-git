USE [tsqlGit]
GO
/****** Object:  StoredProcedure [git].[commitProc]    Script Date: 7/16/2018 4:21:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Joey Lai
-- Create date: July 11, 2018
-- Description:	Commit stored proc changes locally
-- =============================================
ALTER PROCEDURE [git].[commitProc]
	@databaseName varchar(255),
	@schema varchar(255),
	@procName varchar(255) = '',
	@message varchar(4000)
AS
BEGIN
	set nocount on

	-------------------------------------------------------------
	-- 1. Setup
	-------------------------------------------------------------
	declare @gitDirectory varchar(255)
	select @gitDirectory = repoDirectory from git.config

	-- create db directory in repo if not exists
	exec util.createSubDirectoryIfNotExists @gitDirectory, @databaseName
	declare @dbDirectory varchar(4000) = concat(@gitDirectory, '/', @databaseName)

	-- create schema directory in repo if not exists
	exec util.createSubDirectoryIfNotExists @dbDirectory, @schema
	declare @schemaDirectory varchar(4000) = concat(@dbDirectory, '/', @schema)


	-------------------------------------------------------------
	-- 2. Export Procs
	-------------------------------------------------------------
	create table #sqlExports (name varchar(255), sqlBody varchar(max))

	if (@procName = '')
	begin
		print 'todo commit all'
	end
	else
	begin
		declare @fullProcName varchar(4000) = concat(@databaseName, '.', @schema, '.', @procName)
		insert into #sqlExports
			exec util.getSqlForProc @fullProcName
	end


	declare @name varchar(255)
	declare @sqlBody varchar(max)

	declare sqlExport_cur cursor for
		select name, sqlBody from #sqlExports

	open sqlExport_cur
	fetch next from sqlExport_cur into @name, @sqlBody

	while @@FETCH_STATUS = 0
	begin
		declare @filePath varchar(4000) = concat(@schemaDirectory, '/', @name, '.sql')
		exec util.writeToFile @filePath, @sqlBody

		fetch next from sqlExport_cur into @name, @sqlBody
	end

	close sqlExport_cur
	deallocate sqlExport_cur

	drop table #sqlExports


	-------------------------------------------------------------
	-- 3. Commit
	-------------------------------------------------------------

	declare @gitAddAllShell varchar(4000) = concat('cd ', @gitDirectory, ' & git add -A')
	print 'running: ' + @gitAddAllShell
	exec xp_cmdshell @gitAddAllShell

	declare @gitCommitShell varchar(4000) = concat('cd ', @gitDirectory, ' & git commit -m "', @message, '"')
	print 'running: ' + @gitCommitShell
	exec xp_cmdshell @gitCommitShell

END

-- exec tsqlgit.git.commitProc 'tsqlGit', 'git', 'initRepo', 'test commit'
