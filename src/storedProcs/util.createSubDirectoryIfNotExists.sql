
-- =============================================
-- Author:		Joey Lai
-- Create date: July 11, 2018
-- Description:	Creates directory if not exists
-- =============================================
CREATE PROCEDURE [util].[createSubDirectoryIfNotExists]
	@directory varchar(4000),
	@subDirectory varchar(255)
AS
BEGIN
	set nocount on

	declare @dirTree table (subdirectory varchar(255), depth int)

	insert into @dirTree(subdirectory, depth)
		exec xp_dirtree @directory

	declare @directoryPath varchar(5000) = @directory + @subDirectory
	if not exists (select 1 from @dirTree where subdirectory = @subDirectory)
		exec xp_create_subdir @directoryPath

END
