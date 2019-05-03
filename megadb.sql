CREATE TABLE [Members] (
	bannerId int NOT NULL,
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
	gameId int NOT NULL,
	detailId int NOT NULL,
	purchaseDate date NOT NULL,
	digitalLocation int,
  CONSTRAINT [PK_GAMES] PRIMARY KEY CLUSTERED
  (
  [gameId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [GameDetail] (
	detailId int NOT NULL,
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
	genreId int NOT NULL,
	name varchar(20) NOT NULL UNIQUE,
  CONSTRAINT [PK_GENRES] PRIMARY KEY CLUSTERED
  (
  [genreId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Hardware] (
	hardwareId int NOT NULL,
	detailId int NOT NULL,
	purchaseDate date NOT NULL,
  CONSTRAINT [PK_HARDWARE] PRIMARY KEY CLUSTERED
  (
  [hardwareId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [HardwareDetail] (
	detailId int NOT NULL,
	name varchar(20) NOT NULL UNIQUE,
	manufacturer varchar(20) NOT NULL UNIQUE,
	type char(1) NOT NULL,
  CONSTRAINT [PK_HARDWAREDETAIL] PRIMARY KEY CLUSTERED
  (
  [detailId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Rentals] (
	rentalId int NOT NULL,
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
ON UPDATE CASCADE
GO
ALTER TABLE [Rentals] CHECK CONSTRAINT [Rentals_fk1]
GO
ALTER TABLE [Rentals] WITH CHECK ADD CONSTRAINT [Rentals_fk2] FOREIGN KEY ([gameId]) REFERENCES [Games]([gameId])
ON UPDATE CASCADE
GO
ALTER TABLE [Rentals] CHECK CONSTRAINT [Rentals_fk2]
GO

