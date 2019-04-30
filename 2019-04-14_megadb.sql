CREATE DATABASE bostonsa
GO
USE bostonsa
GO

CREATE TABLE [Members] (
	memberBannerId int NOT NULL,
	memberFirstName varchar(20) NOT NULL,
	memberLastName varchar(20) NOT NULL,
	memberOfficerStatus bit NOT NULL DEFAULT '0',
  CONSTRAINT [PK_MEMBERS] PRIMARY KEY CLUSTERED
  (
  [memberBannerId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Rental] (
	renterId int NOT NULL,
	officerId int NOT NULL,
	rentalId int NOT NULL,
	rentedItemId int NOT NULL,
	rentalDate date NOT NULL,
	rentalDueDate date NOT NULL,
	rentalReturnStatus bit NOT NULL DEFAULT '0',
  CONSTRAINT [PK_RENTAL] PRIMARY KEY CLUSTERED
  (
  [rentalId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Item] (
	itemId int NOT NULL,
	itemBarcode bigint NOT NULL UNIQUE,
	itemDetailId uniqueidentifier NOT NULL,
	itemType char(1) NOT NULL,
	itemStatus char(1) NOT NULL,
	itemPurchaseDate date NOT NULL,
  CONSTRAINT [PK_ITEM] PRIMARY KEY CLUSTERED
  (
  [itemId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [DigitalItem] (
	digitalItemId int NOT NULL,
	digitalItemConsole int NOT NULL,
	digitalItemDetailId int NOT NULL,
  CONSTRAINT [PK_DIGITALITEM] PRIMARY KEY CLUSTERED
  (
  [digitalItemId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [HardwareDetail] (
	hardwareDetailId uniqueidentifier NOT NULL,
	hardwareName varchar(20) NOT NULL,
	hardwareManufacturer varchar(20) NOT NULL,
  CONSTRAINT [PK_HARDWAREDETAIL] PRIMARY KEY CLUSTERED
  (
  [hardwareDetailId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [GameDetail] (
	gameDetailId uniqueidentifier NOT NULL,
	gameName varchar(20) NOT NULL,
	gamePublisher varchar(20) NOT NULL,
	gameGenreId int NOT NULL,
	gameConsole uniqueidentifier NOT NULL,
	popularity INT DEFAULT 0,
  CONSTRAINT [PK_GAMEDETAIL] PRIMARY KEY CLUSTERED
  (
  [gameDetailId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Genre] (
	genreId int NOT NULL,
	genreName varchar(20) NOT NULL,
  CONSTRAINT [PK_GENRE] PRIMARY KEY CLUSTERED
  (
  [genreId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

ALTER TABLE [Rental] WITH CHECK ADD CONSTRAINT [Rental_fk0] FOREIGN KEY ([renterId]) REFERENCES [Members]([memberBannerId])
ON UPDATE CASCADE
GO
ALTER TABLE [Rental] CHECK CONSTRAINT [Rental_fk0]
GO
ALTER TABLE [Rental] WITH CHECK ADD CONSTRAINT [Rental_fk1] FOREIGN KEY ([officerId]) REFERENCES [Members]([memberBannerId])
ON UPDATE NO ACTION
GO
ALTER TABLE [Rental] CHECK CONSTRAINT [Rental_fk1]
GO
ALTER TABLE [Rental] WITH CHECK ADD CONSTRAINT [Rental_fk2] FOREIGN KEY ([rentedItemId]) REFERENCES [Item]([itemId])
ON UPDATE CASCADE
GO
ALTER TABLE [Rental] CHECK CONSTRAINT [Rental_fk2]
GO


ALTER TABLE [DigitalItem] WITH CHECK ADD CONSTRAINT [DigitalItem_fk0] FOREIGN KEY ([digitalItemConsole]) REFERENCES [Item]([itemId])
ON UPDATE CASCADE
GO
ALTER TABLE [DigitalItem] CHECK CONSTRAINT [DigitalItem_fk0]
GO


ALTER TABLE [GameDetail] WITH CHECK ADD CONSTRAINT [GameDetail_fk0] FOREIGN KEY ([gameGenreId]) REFERENCES [Genre]([genreId])
ON UPDATE CASCADE
GO
ALTER TABLE [GameDetail] CHECK CONSTRAINT [GameDetail_fk0]
GO
ALTER TABLE [GameDetail] WITH CHECK ADD CONSTRAINT [GameDetail_fk1] FOREIGN KEY ([gameConsole]) REFERENCES [HardwareDetail]([hardwareDetailId])
ON UPDATE CASCADE
GO
ALTER TABLE [GameDetail] CHECK CONSTRAINT [GameDetail_fk1]
GO




/*
 * 4/13/2019
 * @Sean Boston
 * I basically copy/pasted from my notes. Add, Update, and Delete when provided XML.
 * I have not done SELECT statements. Those still need doing.
 *
 * XML Input Format:
 * <TableName>
 *		<add column1="value1" column2="value2"... />
 *		<update column1="value1" column2="value2"... />
 *		<delete column1="value1" column2="value2"... />
 * </TableName>
 */

/* Members */
--======================================= ADD
CREATE PROCEDURE spAddMembersFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.Members(memberBannerId, memberFirstName, memberLastName, memberOfficerStatus)
	SELECT	ent.value('@memberBannerId', 'int'),
			ent.value('@memberFirstName', 'varchar(20)'),
			ent.value('@memberLastName', 'varchar(20)'),
			ent.value('@memberOfficerStatus', 'bit')
	FROM @xml.nodes('/Members/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteMembersFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.Members
	WHERE memberBannerId IN (
		SELECT ent.value('@memberBannerId', 'int')
		FROM @xml.nodes('/Members/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateMembersFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.Members
	SET memberBannerId = tbl.mId,
		memberFirstName = tbl.mFirst,
		memberLastName = tbl.mLast,
		memberOfficerStatus = tbl.mOfficer
	FROM (
		SELECT	[mId] = ent.value('@memberBannerId', 'int'),
				[mFirst] = ent.value('@memberFirstName', 'varchar(20)'),
				[mLast] = ent.value('@memberLastName', 'varchar(20)'),
				[mOfficer] = ent.value('@memberOfficerStatus', 'bit')
		FROM @xml.nodes('/Members/update') foo(ent)
	) AS tbl
	WHERE tbl.mId = Members.memberBannerId
GO
/* Rental */
--======================================= ADD
CREATE PROCEDURE spAddRentalFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.Rental(renterId, officerId, rentalId, rentedItemId, rentalDate, rentalDueDate, rentalReturnStatus)
	SELECT	ent.value('@renterId', 'int'),
			ent.value('@officerId', 'int'),
			ent.value('@rentalId', 'int'),
			ent.value('@rentedItemId', 'int'),
			ent.value('@rentalDate', 'date'),
			ent.value('@rentalDueDate', 'date'),
			ent.value('@rentalReturnStatus', 'bit')
	FROM @xml.nodes('/Rental/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteRentalFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.Rental
	WHERE rentalId IN (
		SELECT ent.value('@rentalId', 'int')
		FROM @xml.nodes('/Rental/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateRentalFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.Rental
	SET renterId = tbl.rId,
		officerId = tbl.rOfficer,
		rentalId = tbl.rRental,
		rentedItemId = tbl.rItem,
		rentalDate = tbl.rDate,
		rentalDueDate = tbl.rDue,
		rentalReturnStatus = tbl.rReturned
	FROM (
		SELECT	[rId] = ent.value('@renterId', 'int'),
				[rOfficer] = ent.value('@officerId', 'int'),
				[rRental] = ent.value('@rentalId', 'int'),
				[rItem] = ent.value('@rentedItemId', 'int'),
				[rDate] = ent.value('@rentalDate', 'date'),
				[rDue] = ent.value('@rentalDueDate', 'date'),
				[rReturned] = ent.value('@rentalReturnStatus', 'bit')
		FROM @xml.nodes('/Rental/update') foo(ent)
	) AS tbl
	WHERE tbl.rId = Rental.rentalId
GO
/* Item */
--======================================= ADD
CREATE PROCEDURE spAddItemFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.Item(itemId, itemBarcode, itemDetailId, itemType, itemStatus, itemPurchaseDate)
	SELECT	ent.value('@itemId', 'int'),
			ent.value('@itemBarcode', 'bigint'),
			ent.value('@itemDetailId', 'uniqueidentifier'),
			ent.value('@itemType', 'char(1)'),
			ent.value('@itemStatus', 'char(1)'),
			ent.value('@itemPurchaseDate', 'date')
	FROM @xml.nodes('/Item/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteItemFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.Item
	WHERE itemId IN (
		SELECT ent.value('@itemId', 'int')
		FROM @xml.nodes('/Item/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateItemFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.Item
	SET itemId = tbl.iId,
		itemBarcode = tbl.iBarcode,
		itemDetailId = tbl.iDetail,
		itemType = tbl.iType,
		itemStatus = tbl.iStatus,
		itemPurchaseDate = tbl.iPurchase
	FROM (
		SELECT	[iId] = ent.value('@itemId', 'int'),
				[iBarcode] = ent.value('@itemBarcode', 'bigint'),
				[iDetail] = ent.value('@itemDetailId', 'uniqueidentifier'),
				[iType] = ent.value('@itemType', 'char(1)'),
				[iStatus] = ent.value('@itemStatus', 'char(1)'),
				[iPurchase] = ent.value('@itemPurchaseDate', 'date')
		FROM @xml.nodes('/Item/update') foo(ent)
	) AS tbl
	WHERE tbl.iId = Item.itemId
GO
/* DigitalItem */
--======================================= ADD
CREATE PROCEDURE spAddDigitalItemFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.DigitalItem(digitalItemId, digitalItemConsole, digitalItemDetailId)
	SELECT	ent.value('@digitalItemId', 'int'),
			ent.value('@digitalItemConsole', 'int'),
			ent.value('@digitalItemDetailId', 'int')
	FROM @xml.nodes('/DigitalItem/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteDigitalItemFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.DigitalItem
	WHERE digitalItemId IN (
		SELECT ent.value('@digitalItemId', 'int')
		FROM @xml.nodes('/DigitalItem/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateDigitalItemFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.DigitalItem
	SET digitalItemId = tbl.diId,
		digitalItemConsole = tbl.diConsole,
		digitalItemDetailId = tbl.diDetail
	FROM (
		SELECT	[diId] = ent.value('@digitalItemId', 'int'),
				[diConsole] = ent.value('@digitalItemConsole', 'int'),
				[diDetail] = ent.value('@digitalItemDetailId', 'int')
		FROM @xml.nodes('/DigitalItem/update') foo(ent)
	) AS tbl
	WHERE tbl.diId = DigitalItem.digitalItemId
GO
/* HardwareDetail */
--======================================= ADD
CREATE PROCEDURE spAddHardwareDetailFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.HardwareDetail(hardwareDetailId, hardwareName, hardwareManufacturer)
	SELECT	ent.value('@hardwareDetailId', 'uniqueidentifier'),
			ent.value('@hardwareName', 'varchar(20)'),
			ent.value('@hardwareManufacturer', 'varchar(20)')
	FROM @xml.nodes('/HardwareDetail/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteHardwareDetailFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.HardwareDetail
	WHERE hardwareDetailId IN (
		SELECT ent.value('@hardwareDetailId', 'uniqueidentifier')
		FROM @xml.nodes('/HardwareDetail/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateHardwareDetailFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.HardwareDetail
	SET hardwareDetailId = tbl.hdId,
		hardwareName = tbl.hdName,
		hardwareManufacturer = tbl.hdManufacturer
	FROM (
		SELECT	[hdId] = ent.value('@hardwareDetailId', 'uniqueidentifier'),
				[hdName] = ent.value('@hardwareName', 'varchar(20)'),
				[hdManufacturer] = ent.value('@hardwareManufacturer', 'varchar(20)')
		FROM @xml.nodes('/HardwareDetail/update') foo(ent)
	) AS tbl
	WHERE tbl.hdId = HardwareDetail.hardwareDetailId
GO
/* GameDetail*/
--======================================= ADD
CREATE PROCEDURE spAddGameDetailFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.GameDetail(gameDetailId, gameName, gamePublisher, gameGenreId, gameConsole)
	SELECT	ent.value('@gameDetailId', 'uniqueidentifier'),
			ent.value('@gameName', 'varchar(20)'),
			ent.value('@gamePublisher', 'varchar(20)'),
			ent.value('@gameGenreId', 'int'),
			ent.value('@gameConsole', 'uniqueidentifier')
	FROM @xml.nodes('/GameDetail/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteGameDetailFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.GameDetail
	WHERE gameDetailId IN (
		SELECT ent.value('@gameDetailId', 'uniqueidentifier')
		FROM @xml.nodes('/GameDetail/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateGameDetailFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.GameDetail
	SET gameDetailId = tbl.gdId,
		gameName = tbl.gdName,
		gamePublisher = tbl.gdPublisher,
		gameGenreId = tbl.gdGenre,
		gameConsole = tbl.gdConsole
	FROM (
		SELECT	[gdId] = ent.value('@gameDetailId', 'uniqueidentifier'),
				[gdName] = ent.value('@gameName', 'varchar(20)'),
				[gdPublisher] = ent.value('@gamePublisher', 'varchar(20)'),
				[gdGenre] = ent.value('@gameGenreId', 'int'),
				[gdConsole] = ent.value('@gameConsole', 'uniqueidentifier')
		FROM @xml.nodes('/GameDetail/update') foo(ent)
	) AS tbl
	WHERE tbl.gdId = GameDetail.gameDetailId
GO
/* Genre */
--======================================= ADD
CREATE PROCEDURE spAddGenreFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	INSERT INTO dbo.Genre(genreId, genreName)
	SELECT	ent.value('@genreId', 'int'),
			ent.value('@genreName', 'varchar(20)')
	FROM @xml.nodes('/Genre/add') foo(ent)
GO
--======================================= DELETE
CREATE PROCEDURE spDeleteGenreFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	DELETE FROM dbo.Genre
	WHERE genreId IN (
		SELECT	ent.value('@genreId', 'int')
		FROM @xml.nodes('/Genre/delete') foo(ent)
	)
GO
--======================================= UPDATE
CREATE PROCEDURE spUpdateGenreFromXML
	@XMLstatement VARCHAR(MAX)
AS
	DECLARE @XML AS XML = @XMLstatement
	UPDATE dbo.Genre
	SET genreId = tbl.gId,
		genreName = tbl.gName
	FROM (
		SELECT	[gId] = ent.value('@genreId', 'int'),
				[gName] = ent.value('@genreName', 'varchar(20)')
		FROM @xml.nodes('/Genre/update') foo(ent)
	) AS tbl
	WHERE tbl.gId = Genre.genreId
GO
/*
* SELECT
*/


CREATE PROCEDURE spGetByConsoleManufacturer
	@manufacturer	VARCHAR(20),
	@count			INT = 500
AS
	SELECT TOP(@count)	gd.gameName,
						hd.hardwareName,
						g.genreName,
						gd.gamePublisher,
						gd.popularity
	FROM HardwareDetail AS hd
		JOIN GameDetail AS gd
			ON hd.HardwareDetailId = gd.gameConsole
		JOIN Genre AS g
			ON gd.gameGenreId = g.genreId
	WHERE hd.hardwareManufacturer = @manufacturer
	FOR XML PATH('Game'), ROOT('Games')
GO

/*
 * 4/25/2019
 * @Sean Boston
 * edited spGetByConsoleManufacturer to return more values
 */
ALTER PROCEDURE spGetByConsoleManufacturer
	@manufacturer	VARCHAR(20),
	@count			INT = 500
AS
	SELECT TOP(@count)	gd.gameName,
						hd.hardwareName,
						g.genreName,
						gd.gamePublisher,
						gd.popularity
	FROM HardwareDetail AS hd
		JOIN GameDetail AS gd
			ON hd.HardwareDetailId = gd.gameConsole
		JOIN Genre AS g
			ON gd.gameGenreId = g.genreId
	WHERE hd.hardwareManufacturer = @manufacturer
	--FOR XML PATH('Game'), ROOT('Games')
GO

CREATE PROCEDURE spGetByName
	@name			VARCHAR(20),
	@count			INT = 500
AS
	SELECT TOP(@count)	gd.gameName,
						hd.hardwareName,
						g.genreName
	FROM HardwareDetail AS hd
		JOIN GameDetail AS gd
			ON hd.HardwareDetailId = gd.gameConsole
		JOIN Genre AS g
			ON gd.gameGenreId = g.genreId
	WHERE gd.gameName= @name
	FOR XML PATH('Game'), ROOT('Games')
GO

CREATE PROCEDURE spGetByGenre
	@genre			VARCHAR(20),
	@count			INT = 500
AS
	SELECT TOP(@count)	gd.gameName,
						hd.hardwareName,
						g.genreName
	FROM HardwareDetail AS hd
		JOIN GameDetail AS gd
			ON hd.HardwareDetailId = gd.gameConsole
		JOIN Genre AS g
			ON gd.gameGenreId = g.genreId
	WHERE g.genreName = @genre
	FOR XML PATH('Game'), ROOT('Games')
GO

CREATE PROCEDURE spGetByPublisher
	@publisher		VARCHAR(20),
	@count			INT = 500
AS
	SELECT TOP(@count)	gd.gameName,
						hd.hardwareName,
						g.genreName
	FROM HardwareDetail AS hd
		JOIN GameDetail AS gd
			ON hd.HardwareDetailId = gd.gameConsole
		JOIN Genre AS g
			ON gd.gameGenreId = g.genreId
	WHERE gd.gamePublisher = @publisher
	FOR XML PATH('Game'), ROOT('Games')
GO

CREATE PROCEDURE spGetAllGenres
AS
	SELECT genreName
	FROM genre
	FOR XML PATH('Genre'), ROOT('Genres')
GO

CREATE PROCEDURE spGetAllConsoles
AS
	SELECT hardwareName
	FROM HardwareDetail
	WHERE hardwareDetailId IN (
		SELECT itemDetailId
		FROM Item
		WHERE itemType = 'c'
	)
	FOR XML PATH('Console'), ROOT('Consoles')
GO

CREATE PROCEDURE spGetMemberRentals
	@rid INT
AS
	SELECT	renterId,
			officerId,
			rentedItemId
	FROM Rental
	WHERE renterId = @rid
	FOR XML PATH('Rental'), ROOT('Rentals')
GO

CREATE PROCEDURE spVote
	@title VARCHAR(20)
AS
	UPDATE gameDetail
	SET popularity = popularity + 1
	FROM gameDetail
	WHERE gameName = @title
GO

/*
 * 4/25/2019
 * @Sean Boston
 * changed spVote so that it returns the new value
 */
ALTER PROCEDURE spVote
 	@title VARCHAR(20)
AS
	UPDATE gameDetail
	SET popularity = popularity + 1
	FROM gameDetail
	WHERE gameName = @title

	SELECT popularity
	FROM GameDetail
	WHERE gameName = @title
	--FOR XML PATH('Game'), ROOT('Games')
GO

/*
 * 4/25/2019
 * @Sean Boston
 * added missing stored procedure
 */
CREATE PROCEDURE spGetAllManufacturers
AS
    SELECT DISTINCT hardwareManufacturer
    FROM HardwareDetail
    WHERE hardwareDetailId IN (
        SELECT itemDetailId
        FROM Item
        WHERE itemType = 'c'
    )

/*
 * 4/25/2019
 * @Sean Boston
 * moved over insert statements from SQLquery1.sql. Do not run SQLquery1.sql. Run all declare and insert statements simultaneously.
 */
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

/*
 * 4/30/2019
 * @Sean Boston
 * Added another console for testing styles
 */
DECLARE @myid4 uniqueidentifier = NEWID()
INSERT INTO Item (itemId, itemBarcode, itemDetailId, itemType, itemStatus, itemPurchaseDate)
VALUES(
	14,
	260001350,
	@myid4,
	'c',
	'a',
	SYSDATETIME()
)
INSERT INTO HardwareDetail
VALUES(
	@myid4,
	'Playstation 4',
	'Sony'
)
INSERT INTO Genre(genreId, genreName)
Values(5, 'JRPG')

ALTER TABLE [GameDetail] 
ALTER COLUMN
	gameName varchar(50) NOT NULL
GO

ALTER PROCEDURE spVote
 	@title VARCHAR(50)
AS
	UPDATE gameDetail
	SET popularity = popularity + 1
	FROM gameDetail
	WHERE gameName = @title

	SELECT popularity
	FROM GameDetail
	WHERE gameName = @title
	--FOR XML PATH('Game'), ROOT('Games')
GO

DECLARE @myid5 uniqueidentifier = NEWID()
INSERT INTO GameDetail(gameDetailId, gameName, gamePublisher, gameGenreId, gameConsole, popularity)
VALUES(
	@myid5,
	'Tales of Vesperia: Definitive Edition',
	'Bandai Namco',
	5,
	@myid4,
	0
)
GO