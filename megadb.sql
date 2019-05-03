USE master
GO
DROP DATABASE IF EXISTS bostonsa
GO

CREATE DATABASE bostonsa
GO
USE bostonsa
GO

CREATE TABLE [Members] (
	bannerId int NOT NULL IDENTITY,
	firstName varchar(20) NOT NULL,
	lastName varchar(20) NOT NULL,
	uniqueId varchar(20) NOT NULL UNIQUE,
	isOfficer bit NOT NULL DEFAULT '0',
  CONSTRAINT [PK_MEMBERS] PRIMARY KEY CLUSTERED
  (
  [bannerId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Games] (
	gameId int NOT NULL IDENTITY,
	detailId int NOT NULL,
	purchaseDate date NOT NULL,
	digitalLocation int DEFAULT NULL,
  CONSTRAINT [PK_GAMES] PRIMARY KEY CLUSTERED
  (
  [gameId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [GameDetail] (
	detailId int NOT NULL IDENTITY,
	name varchar(50) NOT NULL UNIQUE,
	publisher varchar(50) NOT NULL,
	genreId int NOT NULL,
	consoleId int NOT NULL,
	popularity int NOT NULL DEFAULT '0',
  CONSTRAINT [PK_GAMEDETAIL] PRIMARY KEY CLUSTERED
  (
  [detailId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Genres] (
	genreId int NOT NULL IDENTITY,
	name varchar(50) NOT NULL UNIQUE,
  CONSTRAINT [PK_GENRES] PRIMARY KEY CLUSTERED
  (
  [genreId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Hardware] (
	hardwareId int NOT NULL IDENTITY,
	detailId int NOT NULL,
	purchaseDate date NOT NULL,
  CONSTRAINT [PK_HARDWARE] PRIMARY KEY CLUSTERED
  (
  [hardwareId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [HardwareDetail] (
	detailId int NOT NULL IDENTITY,
	name varchar(50) NOT NULL UNIQUE,
	manufacturer varchar(50) NOT NULL UNIQUE,
	type char(1) NOT NULL,
  CONSTRAINT [PK_HARDWAREDETAIL] PRIMARY KEY CLUSTERED
  (
  [detailId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Rentals] (
	rentalId int NOT NULL IDENTITY,
	renterId int NOT NULL,
	officerId int NOT NULL,
	gameId int NOT NULL,
	date date NOT NULL,
	dueDate date NOT NULL,
	returned bit NOT NULL DEFAULT '0',
  CONSTRAINT [PK_RENTALS] PRIMARY KEY CLUSTERED
  (
  [rentalId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

ALTER TABLE [Games] WITH CHECK ADD CONSTRAINT [Games_fk0] FOREIGN KEY ([detailId]) REFERENCES [GameDetail]([detailId])
ON UPDATE CASCADE
GO
ALTER TABLE [Games] CHECK CONSTRAINT [Games_fk0]
GO

ALTER TABLE [GameDetail] WITH CHECK ADD CONSTRAINT [GameDetail_fk0] FOREIGN KEY ([genreId]) REFERENCES [Genres]([genreId])
ON UPDATE CASCADE
GO
ALTER TABLE [GameDetail] CHECK CONSTRAINT [GameDetail_fk0]
GO
ALTER TABLE [GameDetail] WITH CHECK ADD CONSTRAINT [GameDetail_fk1] FOREIGN KEY ([consoleId]) REFERENCES [HardwareDetail]([detailId])
ON UPDATE CASCADE
GO
ALTER TABLE [GameDetail] CHECK CONSTRAINT [GameDetail_fk1]
GO


ALTER TABLE [Hardware] WITH CHECK ADD CONSTRAINT [Hardware_fk0] FOREIGN KEY ([detailId]) REFERENCES [HardwareDetail]([detailId])
ON UPDATE CASCADE
GO
ALTER TABLE [Hardware] CHECK CONSTRAINT [Hardware_fk0]
GO


ALTER TABLE [Rentals] WITH CHECK ADD CONSTRAINT [Rentals_fk0] FOREIGN KEY ([renterId]) REFERENCES [Members]([bannerId])
ON UPDATE CASCADE
GO
ALTER TABLE [Rentals] CHECK CONSTRAINT [Rentals_fk0]
GO
ALTER TABLE [Rentals] WITH CHECK ADD CONSTRAINT [Rentals_fk1] FOREIGN KEY ([officerId]) REFERENCES [Members]([bannerId])
ON UPDATE NO ACTION
GO
ALTER TABLE [Rentals] CHECK CONSTRAINT [Rentals_fk1]
GO
ALTER TABLE [Rentals] WITH CHECK ADD CONSTRAINT [Rentals_fk2] FOREIGN KEY ([gameId]) REFERENCES [Games]([gameId])
ON UPDATE CASCADE
GO
ALTER TABLE [Rentals] CHECK CONSTRAINT [Rentals_fk2]
GO

CREATE PROCEDURE spGetByConsoleManufacturer
	@manufacturer	VARCHAR(20),
	@count			INT = 500
AS
	SELECT TOP(@count)	gd.name AS 'gameName',
						hd.name AS 'consoleName',
						g.name AS 'genreName',
						gd.publisher,
						gd.popularity
	FROM HardwareDetail AS hd
		JOIN GameDetail AS gd
			ON hd.detailId = gd.consoleId
		JOIN Genres AS g
			ON gd.genreId = g.genreId
	WHERE hd.manufacturer = @manufacturer
GO

--CREATE PROCEDURE spGetByName
--	@name			VARCHAR(20),
--	@count			INT = 500
--AS
--	SELECT TOP(@count)	gd.gameName,
--						hd.hardwareName,
--						g.genreName
--	FROM HardwareDetail AS hd
--		JOIN GameDetail AS gd
--			ON hd.HardwareDetailId = gd.gameConsole
--		JOIN Genre AS g
--			ON gd.gameGenreId = g.genreId
--	WHERE gd.gameName= @name
--GO

--CREATE PROCEDURE spGetByGenre
--	@genre			VARCHAR(20),
--	@count			INT = 500
--AS
--	SELECT TOP(@count)	gd.gameName,
--						hd.hardwareName,
--						g.genreName
--	FROM HardwareDetail AS hd
--		JOIN GameDetail AS gd
--			ON hd.HardwareDetailId = gd.gameConsole
--		JOIN Genre AS g
--			ON gd.gameGenreId = g.genreId
--	WHERE g.genreName = @genre
--GO

--CREATE PROCEDURE spGetByPublisher
--	@publisher		VARCHAR(20),
--	@count			INT = 500
--AS
--	SELECT TOP(@count)	gd.gameName,
--						hd.hardwareName,
--						g.genreName
--	FROM HardwareDetail AS hd
--		JOIN GameDetail AS gd
--			ON hd.HardwareDetailId = gd.gameConsole
--		JOIN Genre AS g
--			ON gd.gameGenreId = g.genreId
--	WHERE gd.gamePublisher = @publisher
--GO

--CREATE PROCEDURE spGetAllGenres
--AS
--	SELECT genreName
--	FROM genre
--GO

--CREATE PROCEDURE spGetAllConsoles
--AS
--	SELECT hardwareName
--	FROM HardwareDetail
--	WHERE hardwareDetailId IN (
--		SELECT itemDetailId
--		FROM Item
--		WHERE itemType = 'c'
--	)
--GO

--CREATE PROCEDURE spGetMemberRentals
--	@rid INT
--AS
--	SELECT	renterId,
--			officerId,
--			rentedItemId
--	FROM Rental
--	WHERE renterId = @rid
--GO

CREATE PROCEDURE spGetAllManufacturers
AS
    SELECT DISTINCT manufacturer
    FROM HardwareDetail
    WHERE type = 'c'
GO

CREATE PROCEDURE spVote
 	@title VARCHAR(50)
AS
	UPDATE GameDetail
	SET popularity = popularity + 1
	FROM GameDetail
	WHERE name = @title

	SELECT popularity
	FROM GameDetail
	WHERE name = @title
GO

INSERT INTO Genres
Values('beat em up')
INSERT INTO Genres
Values('JRPG')

INSERT INTO HardwareDetail
VALUES(
	'Xbox One',
	'Microsoft',
	'c'
)
INSERT INTO HardwareDetail
VALUES(
	'Playstation 4',
	'Sony',
	'c'
)

INSERT INTO Hardware
VALUES(
	1,
	SYSDATETIME()
)
INSERT INTO Hardware
VALUES(
	2,
	SYSDATETIME()
)

INSERT INTO GameDetail
VALUES(
	'Battletoads',
	'Xbox Game Studios',
	1,
	1,
	0
)

INSERT INTO GameDetail
VALUES(
	'Tales of Vesperia: Definitive Edition',
	'Bandai Namco',
	2,
	2,
	0
)
GO