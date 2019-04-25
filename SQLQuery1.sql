	SELECT hardwareName
	FROM HardwareDetail
	WHERE hardwareDetailId IN (
		SELECT itemDetailId
		FROM Item
		WHERE itemType = 'c'
	)
	FOR XML PATH('Console'), ROOT('Consoles')

DECLARE @myid uniqueidentifier = NEWID()
INSERT INTO Item (itemId, itemBarcode, itemDetailId, itemType, itemStatus, itemPurchaseDate)
VALUES(
	12,
	260001342,
	@myid,
	'g',
	'a',
	SYSDATETIME()
)


INSERT INTO Genre(genreId, genreName)
Values(4, 'beat em up')

INSERT INTO GameDetail(gameDetailId, gameName, gamePublisher, gameGenreId, gameConsole, popularity)
VALUES(
	@myid,
	'Battletoads',
	'Xbox Game Studios',
	4,
	'41AFDEBF-588B-4C28-91A9-370A462C98D6',
	0
)

select * from GameDetail

SELECT * FROM HardwareDetail

EXEC spGetByConsoleManufacturer --@manufacturer = 'Sony'
GO

CREATE PROCEDURE spGetAllManufacturers
AS
	SELECT DISTINCT hardwareManufacturer
	FROM HardwareDetail
	WHERE hardwareDetailId IN (
		SELECT itemDetailId
		FROM Item
		WHERE itemType = 'c'
	)