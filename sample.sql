use tsqlGit

-- To allow advanced options to be changed.
exec sp_configure 'show advanced options', 1
go

-- To update the currently configured value for advanced options.
reconfigure
go

-- To enable the feature.
exec sp_configure 'xp_cmdshell', 1
go

-- To update the currently configured value for this feature.
reconfigure
go


-- initialize local repo
exec git.initRepo @directory = '~/GitHub', @repoName = 'DevDB'

-- commit changes
exec git.commitToMaster @database = 'devDb', @schema = 'dev'

-- pull changes

-- push procs
