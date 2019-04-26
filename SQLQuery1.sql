USE bostonsa
GO

DECLARE @myid uniqueidentifier = NEWID()
DECLARE @myid2 uniqueidentifier = NEWID()
INSERT INTO Item (itemId, itemBarcode, itemDetailId, itemType, itemStatus, itemPurchaseDate)
VALUES(
	13,
	260001346,
	@myid2,
	'c',
	'a',
	SYSDATETIME()
),(
	12,
	260001342,
	@myid,
	'g',
	'a',
	SYSDATETIME()
)

INSERT INTO Genre(genreId, genreName)
Values(4, 'beat em up')

INSERT INTO HardwareDetail
VALUES(
	@myid2,
	'Xbox One',
	'Microsoft'
)

DECLARE @myid3 uniqueidentifier = NEWID()
INSERT INTO GameDetail(gameDetailId, gameName, gamePublisher, gameGenreId, gameConsole, popularity)
VALUES(
	@myid3,
	'Battletoads',
	'Xbox Game Studios',
	4,
	@myid2,
	0
)

--	SELECT hardwareName
--	FROM HardwareDetail
--	WHERE hardwareDetailId IN (
--		SELECT itemDetailId
--		FROM Item
--		WHERE itemType = 'c'
--	)
--	FOR XML PATH('Console'), ROOT('Consoles')

--select * from GameDetail

--SELECT * FROM HardwareDetail

--EXEC spGetByConsoleManufacturer --@manufacturer = 'Sony'
--GO

--EXEC spVote @title = 'Battletoads'
--GO

--ALTER PROCEDURE spGetAllManufacturers
--AS
--	SELECT DISTINCT hardwareManufacturer
--	FROM HardwareDetail
--	WHERE hardwareDetailId IN (
--		SELECT itemDetailId
--		FROM Item
--		WHERE itemType = 'c'
--	)