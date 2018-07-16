use tsqlGit

create table git.config (
	repoDirectory varchar(4000) null,
	userName varchar(255) null,
	userEmail varchar(255) null,
	remoteUrl varchar(4000)  null
)
