use tsqlGit

-- To allow advanced options to be changed.
exec sp_configure 'show advanced options', 1
go

-- To update the currently configured value for advanced options.
reconfigure
go

-- To enable the feature.
exec sp_configure 'xp_cmdshell', 1
exec sp_configure 'Ole Automation Procedures', 1
go

-- To update the currently configured value for this feature.
reconfigure
go


-- initialize local repo
exec git.initRepo @directory = 'C:/GitHub', @repoName = 'tSQL', @userName = 'Joey', @userEmail = 'joey@email.com', @remoteUrl = 'http://github.com'

-- commit proc
exec tsqlgit.git.commitProc 'tsqlGit', 'git', 'initRepo', 'first commit'

-- pull changes

-- push procs
