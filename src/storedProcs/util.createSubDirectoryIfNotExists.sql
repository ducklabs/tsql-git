USE [tsqlGit]
GO
/****** Object:  StoredProcedure [util].[createSubDirectoryIfNotExists]    Script Date: 7/16/2018 4:23:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Joey Lai
-- Create date: July 11, 2018
-- Description:	Creates directory if not exists
-- =============================================
ALTER PROCEDURE [util].[createSubDirectoryIfNotExists]
	@directory varchar(4000),
	@subDirectory varchar(255)
AS
BEGIN
	set nocount on

	declare @dirTree table (subdirectory varchar(255), depth int)

	insert into @dirTree(subdirectory, depth)
		exec xp_dirtree @directory

	declare @directoryPath varchar(5000) = concat(@directory, '\', @subDirectory)
	if not exists (select 1 from @dirTree where subdirectory = @subDirectory)
	begin
		exec xp_create_subdir @directoryPath
		print 'created directory: ' + @directoryPath
	end

END
