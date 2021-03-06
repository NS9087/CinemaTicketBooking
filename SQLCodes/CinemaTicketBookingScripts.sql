USE [master]
GO
/****** Object:  Database [CinemaTicketBooking]    Script Date: 2021. 08. 17. 19:11:11 ******/
CREATE DATABASE [CinemaTicketBooking]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CinemaTB', FILENAME = N'D:\NS_Data\VizsgaRemek\DB\CinemaTB.mdf' , SIZE = 22144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 20%), 
 FILEGROUP [FilmImgFg] 
( NAME = N'FilmImgFg', FILENAME = N'D:\NS_Data\VizsgaRemek\DB\FilmImgFg.ndf' , SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'CinemaTB_log', FILENAME = N'D:\NS_Data\VizsgaRemek\DB\CinemaTB_log.ldf' , SIZE = 493760KB , MAXSIZE = 2048GB , FILEGROWTH = 20%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CinemaTicketBooking] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CinemaTicketBooking].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CinemaTicketBooking] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET ARITHABORT OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CinemaTicketBooking] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CinemaTicketBooking] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CinemaTicketBooking] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CinemaTicketBooking] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CinemaTicketBooking] SET  MULTI_USER 
GO
ALTER DATABASE [CinemaTicketBooking] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CinemaTicketBooking] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CinemaTicketBooking] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CinemaTicketBooking] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CinemaTicketBooking] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CinemaTicketBooking] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'CinemaTicketBooking', N'ON'
GO
ALTER DATABASE [CinemaTicketBooking] SET QUERY_STORE = OFF
GO
USE [CinemaTicketBooking]
GO
/****** Object:  User [MoziRapp]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE USER [MoziRapp] FOR LOGIN [MoziRapp] WITH DEFAULT_SCHEMA=[RAppRole]
GO
/****** Object:  User [MoziManager]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE USER [MoziManager] FOR LOGIN [MoziManager] WITH DEFAULT_SCHEMA=[ManagerRole]
GO
/****** Object:  User [MoziEmp]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE USER [MoziEmp] FOR LOGIN [MoziEmp] WITH DEFAULT_SCHEMA=[EmpRole]
GO
/****** Object:  DatabaseRole [RappRole]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE ROLE [RappRole]
GO
/****** Object:  DatabaseRole [ManagerRole]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE ROLE [ManagerRole]
GO
/****** Object:  DatabaseRole [EmpRole]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE ROLE [EmpRole]
GO
ALTER ROLE [db_owner] ADD MEMBER [MoziManager]
GO
/****** Object:  UserDefinedFunction [dbo].[DefaultVATID]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DefaultVATID]
	(@VATCode varchar(10)) 
RETURNS tinyint
AS
BEGIN
	RETURN (SELECT VATID FROM DictVAT WHERE VATCode = @VATCode)
END
GO
/****** Object:  UserDefinedFunction [dbo].[DictTypeIsIN]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DictTypeIsIN]
	(@dictid tinyint, @typename varchar(30))
RETURNS bit AS
BEGIN
	RETURN
	CASE 
		WHEN @typename = 'DictAuditoriumType' 
	AND (SELECT Count(1) FROM DictAuditoriumType WHERE AuditoriumTypeID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictFilmPriceType' 
	AND (SELECT Count(1) FROM DictFilmPriceType WHERE FilmPriceTypeID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictFilmRatingType' 
	AND (SELECT Count(1) FROM DictFilmRatingType WHERE FilmRatingTypeID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictFilmType' 
	AND (SELECT Count(1) FROM DictFilmType WHERE FilmTypeID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictPaymentType' 
	AND (SELECT Count(1) FROM DictPaymentType WHERE PaymentTypeID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictReservationType' 
	AND (SELECT Count(1) FROM DictReservationType WHERE ReservationTypeID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictVAT' 
	AND (SELECT Count(1) FROM DictVAT WHERE VATID = @dictid) > 0 THEN  1
		WHEN @typename = 'DictViewerType' 
	AND (SELECT Count(1) FROM DictViewerType WHERE ViewerTypeID = @dictid) > 0 THEN  1
	ELSE 0
	END
END
GO
/****** Object:  UserDefinedFunction [dbo].[getSeatsNoFromSeat]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[getSeatsNoFromSeat]
(@auditoriumid int)
RETURNS INTEGER
AS
BEGIN
	DECLARE @Result int
	Select @Result = Count(*) from Seat S
    Where S.IsActive = 1 AND S.AuditoriumID = @auditoriumid
	RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[IsNewScreeningCollide]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[IsNewScreeningCollide]
	(@AuditoriumID int, @FilmID int, @ScreeningStart datetime2(0)) 
RETURNS tinyint
AS
BEGIN
	declare @mintime smallint = CAST((SELECT D.DefaultSettingTypeValue 
			FROM DictDefaultSettingType D WHERE D.DefaultSettingTypeCode ='MIN2V') as smallint)
	
	declare @prevstartdate datetime2(0) = (SELECT TOP 1 S.ScreeningStart FROM Screening S
	WHERE S.ScreeningStart < @ScreeningStart AND S.AuditoriumID = @AuditoriumID ORDER BY 1 DESC)
	
	declare @nextstartdate datetime2(0) = (SELECT TOP 1 S.ScreeningStart FROM Screening S
	WHERE S.ScreeningStart > @ScreeningStart AND S.AuditoriumID = @AuditoriumID ORDER BY 1)

	declare @runningfilmduration int = (SELECT F.DurationMin FROM Screening S
			INNER JOIN Film F ON F.FilmID = S.FilmID
			WHERE S.AuditoriumID = @AuditoriumID AND S.ScreeningStart = @prevstartdate)

	declare @newfilmduration int = (SELECT F.DurationMin FROM Film F
	WHERE F.FilmID =  @FilmID)

	IF DATEADD(mi,@runningfilmduration + @mintime,@prevstartdate) > @ScreeningStart RETURN 1
	ELSE IF DATEADD(mi,@newfilmduration + @mintime,@ScreeningStart) > @nextstartdate RETURN 2
	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[IsSeatFreeofScreening]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[IsSeatFreeofScreening]
(@screeningid int, @seatid int)
RETURNS bit
AS
BEGIN
	DECLARE @uditid int = (SELECT S.AuditoriumID FROM Screening S WHERE S.ScreeningID = @screeningid)
	IF EXISTS (SELECT 1 FROM Seat S WHERE S.AuditoriumID = @uditid AND S.SeatID = @seatid 
	AND @seatid IN (SELECT SEA.SeatID
					FROM Seat SEA
					WHERE SEA.AuditoriumID = @uditid AND SEA.SeatID NOT IN 
					(SELECT SR.SeatID
						FROM Screening S
						INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID
						INNER JOIN Seat SEA ON SEA.AuditoriumID = A.AuditoriumID
						INNER JOIN SeatReserved SR ON SR.ScreeningID = S.ScreeningID
						WHERE S.ScreeningID = @screeningid AND SR.AnnulmentTime IS NULL
						GROUP BY SR.SeatReservedID, SR.SeatID))) RETURN 1
	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[TaxPayerNoCheck]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[TaxPayerNoCheck]
	(@TaxPayerNo varchar(20), 
	 @CountryCode char(2))
RETURNS bit
AS
BEGIN
	DECLARE @I smallint
	SET @TaxPayerNo = TRIM(REPLACE(@TaxPayerNo, '-', ''))
    IF @TaxPayerNo IS NULL OR @CountryCode <> 'HU' 
		RETURN NULL
    ELSE IF LEN(@TaxPayerNo) <> 11 OR @TaxPayerNo LIKE '%[^0-9]%' --only numbers 
		RETURN 0
	ELSE IF SUBSTRING(@TaxPayerNo, 9, 1) NOT IN ('1', '2', '3', '4', '5') -- digit#9
		RETURN 0
    ELSE
		BEGIN	--digit#8 is correctly calculated 
	        SET @I = 10 - (LEFT(@TaxPayerNo, 1) * 9 + SUBSTRING(@TaxPayerNo, 2, 1) * 7 + SUBSTRING(@TaxPayerNo, 3, 1) * 3 + 
				SUBSTRING(@TaxPayerNo, 4, 1) + SUBSTRING(@TaxPayerNo, 5, 1) * 9 + SUBSTRING(@TaxPayerNo, 6, 1) * 7 + 
				SUBSTRING(@TaxPayerNo, 7, 1) * 3) % 10
			IF @I = 10 SET @I = 0
			IF @I = SUBSTRING(@TaxPayerNo, 8, 1)
				RETURN 1
		END
	RETURN 0
END
GO
/****** Object:  Table [dbo].[Screening]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Screening](
	[ScreeningID] [int] IDENTITY(1,1) NOT NULL,
	[AuditoriumID] [smallint] NOT NULL,
	[FilmID] [int] NOT NULL,
	[ScreeningStart] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_Screening_ScreeningID] PRIMARY KEY CLUSTERED 
(
	[ScreeningID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Seat]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seat](
	[SeatID] [int] IDENTITY(1,1) NOT NULL,
	[AuditoriumID] [smallint] NOT NULL,
	[SeatNumber] [smallint] NOT NULL,
	[RowNumber] [smallint] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Seat_SeatID] PRIMARY KEY CLUSTERED 
(
	[SeatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[ScreeningID] [int] NOT NULL,
	[ContactReserveID] [int] NULL,
	[ReservationTypeID] [tinyint] NOT NULL,
	[ContactPaidID] [int] NULL,
	[Reserved] [bit] NOT NULL,
	[Paid] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[ReservationDate] [datetime2](0) NOT NULL,
	[ConfirmationDate] [datetime2](0) NULL,
	[ReservationContact] [varchar](200) NULL,
	[ContactEmail] [varchar](80) NULL,
	[ReservationRefNo] [int] NULL,
 CONSTRAINT [PK_Reservation_ReservationID] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SeatReserved]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SeatReserved](
	[SeatReservedID] [int] IDENTITY(1,1) NOT NULL,
	[ReservationID] [int] NOT NULL,
	[ScreeningID] [int] NOT NULL,
	[SeatID] [int] NOT NULL,
	[ViewerTypeID] [tinyint] NOT NULL,
	[AnnulmentTime] [datetime2](0) NULL,
 CONSTRAINT [PK_SeatReserved_SeatReservedID] PRIMARY KEY CLUSTERED 
(
	[SeatReservedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Film]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Film](
	[FilmID] [int] IDENTITY(1,1) NOT NULL,
	[TitleHU] [varchar](100) NOT NULL,
	[TitleOrig] [varchar](100) NULL,
	[ReleaseYear] [smallint] NULL,
	[DurationMin] [smallint] NULL,
	[FilmRatingTypeID] [tinyint] NOT NULL,
	[FilmPriceTypeID] [tinyint] NOT NULL,
	[ShortPlotHU] [text] NULL,
	[ShortPlotEN] [text] NULL,
	[ExternalURL] [varchar](200) NULL,
 CONSTRAINT [PK_Film_FilmID] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Auditorium]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auditorium](
	[AuditoriumID] [smallint] IDENTITY(1,1) NOT NULL,
	[AuditoriumTypeID] [tinyint] NOT NULL,
	[AuditoriumName] [varchar](30) NOT NULL,
	[SeatsNo] [int] NOT NULL,
 CONSTRAINT [PK_Auditorium_AuditoriumID] PRIMARY KEY CLUSTERED 
(
	[AuditoriumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[ContactName] [varchar](100) NOT NULL,
	[ZIP] [varchar](10) NULL,
	[City] [varchar](40) NULL,
	[Address] [varchar](100) NULL,
	[Email] [varchar](80) NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
	[IsCustomer] [bit] NOT NULL,
	[IsSupplier] [bit] NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[IsLogin] [bit] NOT NULL,
	[VATNr] [varchar](20) NULL,
	[Mobile] [varchar](20) NULL,
	[Phone] [varchar](20) NULL,
	[CountryCode] [char](2) NOT NULL,
	[ZIPShip] [varchar](10) NULL,
	[CityShip] [varchar](40) NULL,
	[AddressShip] [varchar](100) NULL,
	[ZIPPostal] [varchar](10) NULL,
	[CityPostal] [varchar](40) NULL,
	[AddressPostal] [varchar](100) NULL,
	[CloseDate] [datetime2](0) NULL,
 CONSTRAINT [PK_Contact_ContactID] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vContactReserveMultipleTimeSameScreening]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vContactReserveMultipleTimeSameScreening]
AS 
SELECT C.ContactName, F.TitleHU, A.AuditoriumName, Count(DISTINCT R.ReservationID) NoofReservation,
Count(1) SumReservedSeat, STRING_AGG(SEA.RowNumber, ', ') RowNo, 
STRING_AGG(SEA.SeatNumber, ', ') SeatNo
FROM Reservation R
INNER JOIN SeatReserved SR ON SR.ReservationID = R.ReservationID
INNER JOIN Screening S ON S.ScreeningID = R.ScreeningID
INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID
INNER JOIN Film F ON F.FilmID = S.FilmID
INNER JOIN Seat SEA ON SEA.SeatID = SR.SeatID
INNER JOIN Contact C ON C.ContactID = R.ContactReserveID
WHERE R.ReservationID IN (
	SELECT TRIM(Y.value)							--Split Reservation Nos into one column 
	FROM (											--Reservation Nos where same ContactReserveID 
		SELECT STRING_AGG(R.ReservationID, ' ,') ReservationIDs
		FROM Reservation R
		INNER JOIN Contact C ON C.ContactID = R.ContactReserveID
		INNER JOIN Screening S ON S.ScreeningID = R.ScreeningID
		INNER JOIN Film F ON F.FilmID = S.FilmID
		WHERE R.ContactReserveID IS NOT NULL --AND R.ScreeningID IS NOT NULL
		GROUP BY C.ContactID, C.ContactName, R.ScreeningID, F.TitleHU
		HAVING COUNT(*) > 1) X
	CROSS APPLY STRING_SPLIT(X.ReservationIDs, ',') Y)
GROUP BY R.ContactReserveID, C.ContactName, F.TitleHU, A.AuditoriumName
GO
/****** Object:  Table [dbo].[FilmStar]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmStar](
	[FilmID] [int] NOT NULL,
	[Star] [varchar](80) NOT NULL,
 CONSTRAINT [PK_FilmStar_FilmID_Star] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC,
	[Star] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FilmStarsCommonFilms]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[FilmStarsCommonFilms](@name1 as varchar(30), @name2 as varchar(30))
RETURNS TABLE
AS RETURN
SELECT X.TitleHU, X.TitleOrig, X.ReleaseYear, STRING_AGG(X.Star, ', ') Stars
FROM 
(SELECT F.FilmID, F.TitleHU, F.TitleOrig, F.ReleaseYear, FS.Star
FROM Film F
inner join FilmStar FS ON F.FilmID = FS.FilmID
WHERE FS.Star LIKE '%' + @name1 +'%' OR  FS.Star LIKE '%'+ @name2 + '%') X
GROUP BY X.FilmID, X.TitleHU, X.TitleOrig, X.ReleaseYear
HAVING Count(*) > 1
GO
/****** Object:  Table [dbo].[Price]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Price](
	[PriceID] [int] IDENTITY(1,1) NOT NULL,
	[PriceName] [varchar](30) NULL,
	[ViewerTypeID] [tinyint] NOT NULL,
	[VATID] [tinyint] NOT NULL,
	[BasePrice] [decimal](7, 2) NOT NULL,
	[IsIncludeVAT] [bit] NOT NULL,
	[StartDate] [date] NOT NULL,
	[ValidUntilDate] [date] NULL,
 CONSTRAINT [PK_Price_PriceID] PRIMARY KEY CLUSTERED 
(
	[PriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TicketSale]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TicketSale](
	[TicketSaleID] [int] IDENTITY(1,1) NOT NULL,
	[ReservationID] [int] NOT NULL,
	[PriceID] [int] NOT NULL,
	[TicketQty] [decimal](5, 2) NULL,
	[TicketPrice] [decimal](7, 2) NULL,
	[SoldTotal] [decimal](9, 2) NULL,
	[PaymentDate] [datetime2](0) NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
 CONSTRAINT [PK_TicketSale_TicketSaleID] PRIMARY KEY CLUSTERED 
(
	[TicketSaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictVAT]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictVAT](
	[VATID] [tinyint] IDENTITY(1,1) NOT NULL,
	[VATName] [varchar](30) NOT NULL,
	[VATCode] [varchar](10) NOT NULL,
	[VATPercent] [decimal](3, 3) NOT NULL,
	[XmlTag] [varchar](10) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DictVAT_VATID] PRIMARY KEY CLUSTERED 
(
	[VATID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictVAT_VATCode] UNIQUE NONCLUSTERED 
(
	[VATCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vWeeklySalesRevenue]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vWeeklySalesRevenue]
AS 
SELECT DATEPART(week, S.ScreeningStart) Week, A.AuditoriumName,
FORMAT(SUM(T.SoldTotal/(1+VAT.VATPercent)),'N0') NetSales, 
FORMAT(SUM(T.SoldTotal), 'N0') GrossSales
FROM TicketSale T
INNER JOIN Reservation R ON R.ReservationID = T.ReservationID
INNER JOIN Screening S ON S.ScreeningID = R.ScreeningID
INNER JOIN Price P ON P.PriceID = T.PriceID
INNER JOIN DictVAT VAT ON VAT.VATID = P.VATID
INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID
GROUP BY DATEPART(week, S.ScreeningStart), A.AuditoriumName
GO
/****** Object:  UserDefinedFunction [dbo].[FilmStarinFilms]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[FilmStarinFilms](@name1 as varchar(30))
RETURNS TABLE
AS RETURN
SELECT F.FilmID, F.TitleHU, F.TitleOrig, F.ReleaseYear, FS.Star
FROM Film F
inner join FilmStar FS ON F.FilmID = FS.FilmID
WHERE FS.Star LIKE '%' + @name1 +'%'
GO
/****** Object:  View [dbo].[vWeeklyAttandanceRatio]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vWeeklyAttandanceRatio]
AS 
SELECT DATEPART(week, S.ScreeningStart) Week, A.AuditoriumName, 
FORMAT(CAST(AVG(X.SRNum) as decimal)/AVG(A.SeatsNo), 'N2') ScreenRatio
FROM Screening S
INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID
INNER JOIN (SELECT SR.ScreeningID, A.AuditoriumName, COUNT(1) SRNum
		FROM SeatReserved SR 
		INNER JOIN Screening S ON S.ScreeningID = SR.ScreeningID
		INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID					
		GROUP BY SR.ScreeningID, A.AuditoriumName) X ON X.ScreeningID = S.ScreeningID
GROUP BY DATEPART(week, S.ScreeningStart), A.AuditoriumName
GO
/****** Object:  View [dbo].[vFilmAttandanceRatio]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vFilmAttandanceRatio]
AS 
SELECT DISTINCT S.FilmID, F.TitleHU, A.AuditoriumName, A.SeatsNo, Y.SRNum, 
FORMAT(CAST(Y.SRNum as decimal)/A.SeatsNo/Y.ScreenNo, 'N2') FilmAttRatio
FROM Screening S
INNER JOIN FILM F ON S.FilmID = F.FilmID
INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID
INNER JOIN (SELECT S.FilmID, S.AuditoriumID, COUNT(1) SRNum, X.ScreenNo
FROM SeatReserved SR
INNER JOIN Screening S ON S.ScreeningID = SR.ScreeningID
INNER JOIN Auditorium A ON S.AuditoriumID = A.AuditoriumID
INNER JOIN (SELECT S.FilmID, S.AuditoriumID, Count(1) ScreenNo
FROM Screening S
GROUP BY S.FilmID, S.AuditoriumID) X ON X.FilmID = S.FilmID AND X.AuditoriumID = S.AuditoriumID
GROUP BY S.FilmID, S.AuditoriumID, X.ScreenNo) Y ON Y.FilmID = F.FilmID AND Y.AuditoriumID = S.AuditoriumID
GO
/****** Object:  Table [dbo].[DictFilmPriceType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictFilmPriceType](
	[FilmPriceTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FilmPriceTypeName] [varchar](50) NOT NULL,
	[FilmPriceTypeNameE] [varchar](50) NULL,
	[FilmPriceTypeCode] [varchar](10) NOT NULL,
	[FilmPriceDiscExtraVal] [smallint] NOT NULL,
 CONSTRAINT [PK_DictFilmPriceType_FilmPriceTypeID] PRIMARY KEY CLUSTERED 
(
	[FilmPriceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictFilmPriceType_FilmPriceTypeCode] UNIQUE NONCLUSTERED 
(
	[FilmPriceTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictFilmPriceType_FilmPriceTypeName] UNIQUE NONCLUSTERED 
(
	[FilmPriceTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictCountry]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictCountry](
	[CountryCode] [char](2) NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[CountryNameE] [varchar](50) NOT NULL,
	[CountryISO3] [char](3) NOT NULL,
	[IsEUMember] [bit] NOT NULL,
	[IsValid] [bit] NOT NULL,
 CONSTRAINT [PK_DictCountry_CountryCode] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictCountry_CountryISO3] UNIQUE NONCLUSTERED 
(
	[CountryISO3] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictCountry_CountryName] UNIQUE NONCLUSTERED 
(
	[CountryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictCountry_CountryNameE] UNIQUE NONCLUSTERED 
(
	[CountryNameE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictFilmType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictFilmType](
	[FilmTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FilmTypeName] [varchar](50) NOT NULL,
	[FilmTypeNameE] [varchar](50) NULL,
	[FilmTypeCode] [varchar](10) NOT NULL,
 CONSTRAINT [PK_DictFilmType_FilmTypeID] PRIMARY KEY CLUSTERED 
(
	[FilmTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictFilmType_FilmTypeCode] UNIQUE NONCLUSTERED 
(
	[FilmTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictFilmType_FilmTypeName] UNIQUE NONCLUSTERED 
(
	[FilmTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilmFilmType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmFilmType](
	[FilmID] [int] NOT NULL,
	[FilmTypeID] [tinyint] NOT NULL,
 CONSTRAINT [PK_FilmFilmType_FilmID_FilmTypeID] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC,
	[FilmTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilmDirector]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmDirector](
	[FilmID] [int] NOT NULL,
	[Director] [varchar](80) NOT NULL,
 CONSTRAINT [PK_FilmDirector_FilmID_Director] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC,
	[Director] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilmCountry]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmCountry](
	[FilmID] [int] NOT NULL,
	[CountryCode] [char](2) NOT NULL,
 CONSTRAINT [PK_FilmCountry_FilmID_Country] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC,
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vNotNormalizedFilmTable_HUN]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vNotNormalizedFilmTable_HUN]
AS 
SELECT F.FilmID, F.TitleHU "Cím", FCI.ProdCountry "Gyártó ország", F.ReleaseYear "Megj. éve", 
F.DurationMin "Hossz min.", FTN.FilmType "Besorolás", FDI.Director "Rendező", 
FSI.Star "Főszereplők", DFP.FilmPriceTypeName "Árbesorolás"
FROM Film F
INNER JOIN DictFilmPriceType DFP ON DFP.FilmPriceTypeID = F.FilmPriceTypeID
INNER JOIN (SELECT F.FilmID, IIF(STRING_AGG(CO.CountryName, ', ') IS NOT NULL, STRING_AGG(CO.CountryName, ', '), '') ProdCountry
FROM Film F
LEFT JOIN FilmCountry FC ON FC.FilmID = F.FilmID
LEFT JOIN DictCountry CO ON CO.CountryCode = FC.CountryCode
GROUP BY F.FilmID) FCI ON FCI.FilmID = F.FilmID
INNER JOIN (SELECT F.FilmID, STRING_AGG(DFT.FilmTypeName, ', ') WITHIN GROUP (ORDER BY DFT.FilmTypeName) FilmType
FROM Film F
LEFT JOIN FilmFilmType FT ON FT.FilmID = F.FilmID
LEFT JOIN DictFilmType DFT ON DFT.FilmTypeID = FT.FilmTypeID
GROUP BY F.FilmID) FTN ON FTN.FilmID = F.FilmID
INNER JOIN (SELECT F.FilmID, IIF(STRING_AGG(FD.Director, ', ') IS NOT NULL, STRING_AGG(FD.Director, ', '), '') Director
FROM FilmDirector FD
RIGHT JOIN Film F ON FD.FilmID = F.FilmID
GROUP BY F.FilmID) FDI ON FDI.FilmID = F.FilmID
INNER JOIN (SELECT F.FilmID, IIF(STRING_AGG(FS.Star, ', ') IS NOT NULL, STRING_AGG(FS.Star, ', '), '')  Star
FROM FilmStar FS
RIGHT JOIN Film F ON FS.FilmID = F.FilmID
GROUP BY F.FilmID) FSI ON FSI.FilmID = F.FilmID
GO
/****** Object:  View [dbo].[vNotNormalizedFilmTable_ENG]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vNotNormalizedFilmTable_ENG]
AS 
SELECT F.FilmID, F.TitleOrig, FCI.ProdCountry, F.ReleaseYear, F.DurationMin, FTN.FilmType
, FDI.Director, FSI.Star, DFP.FilmPriceTypeNameE PriceType
FROM Film F
INNER JOIN DictFilmPriceType DFP ON DFP.FilmPriceTypeID = F.FilmPriceTypeID
INNER JOIN (SELECT F.FilmID, IIF(STRING_AGG(CO.CountryNameE, ', ') IS NOT NULL, STRING_AGG(CO.CountryNameE, ', '), '') ProdCountry
FROM Film F
LEFT JOIN FilmCountry FC ON FC.FilmID = F.FilmID
LEFT JOIN DictCountry CO ON CO.CountryCode = FC.CountryCode
GROUP BY F.FilmID) FCI ON FCI.FilmID = F.FilmID
INNER JOIN (SELECT F.FilmID, STRING_AGG(DFT.FilmTypeNameE, ', ') WITHIN GROUP (ORDER BY DFT.FilmTypeNameE) FilmType
FROM Film F
LEFT JOIN FilmFilmType FT ON FT.FilmID = F.FilmID
LEFT JOIN DictFilmType DFT ON DFT.FilmTypeID = FT.FilmTypeID
GROUP BY F.FilmID) FTN ON FTN.FilmID = F.FilmID
INNER JOIN (SELECT F.FilmID, IIF(STRING_AGG(FD.Director, ', ') IS NOT NULL, STRING_AGG(FD.Director, ', '), '') Director
FROM FilmDirector FD
RIGHT JOIN Film F ON FD.FilmID = F.FilmID
GROUP BY F.FilmID) FDI ON FDI.FilmID = F.FilmID
INNER JOIN (SELECT F.FilmID, IIF(STRING_AGG(FS.Star, ', ') IS NOT NULL, STRING_AGG(FS.Star, ', '), '')  Star
FROM FilmStar FS
RIGHT JOIN Film F ON FS.FilmID = F.FilmID
GROUP BY F.FilmID) FSI ON FSI.FilmID = F.FilmID
GO
/****** Object:  Table [dbo].[DictAuditoriumType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictAuditoriumType](
	[AuditoriumTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[AuditoriumTypeName] [varchar](50) NOT NULL,
	[AuditoriumTypeNameE] [varchar](50) NULL,
	[AuditoriumTypeCode] [varchar](10) NOT NULL,
	[AuditoriumDiscExtraVal] [smallint] NOT NULL,
 CONSTRAINT [PK_DictAuditoriumType_AuditoriumTypeID] PRIMARY KEY CLUSTERED 
(
	[AuditoriumTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictAuditoriumType_AuditoriumTypeCode] UNIQUE NONCLUSTERED 
(
	[AuditoriumTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictAuditoriumType_AuditoriumTypeName] UNIQUE NONCLUSTERED 
(
	[AuditoriumTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictDefaultSettingType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictDefaultSettingType](
	[DefaultSettingTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[DefaultSettingTypeName] [varchar](50) NOT NULL,
	[DefaultSettingTypeNameE] [varchar](50) NULL,
	[DefaultSettingTypeCode] [varchar](10) NOT NULL,
	[DefaultSettingTypeValue] [varchar](20) NOT NULL,
 CONSTRAINT [PK_DictDefaultSettingType_DefaultSettingTypeID] PRIMARY KEY CLUSTERED 
(
	[DefaultSettingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictDefaultSettingType_DefaultSettingTypeCode] UNIQUE NONCLUSTERED 
(
	[DefaultSettingTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictDefaultSettingType_DefaultSettingTypeName] UNIQUE NONCLUSTERED 
(
	[DefaultSettingTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictFilmRatingType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictFilmRatingType](
	[FilmRatingTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FilmRatingTypeName] [varchar](50) NOT NULL,
	[FilmRatingTypeNameE] [varchar](50) NULL,
	[FilmRatingTypeCode] [varchar](10) NOT NULL,
 CONSTRAINT [PK_DictFilmRatingType_FilmRatingTypeID] PRIMARY KEY CLUSTERED 
(
	[FilmRatingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictFilmRatingType_FilmRatingTypeCode] UNIQUE NONCLUSTERED 
(
	[FilmRatingTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictFilmRatingType_FilmRatingTypeName] UNIQUE NONCLUSTERED 
(
	[FilmRatingTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictPaymentType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictPaymentType](
	[PaymentTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PaymentTypeName] [varchar](50) NOT NULL,
	[PaymentTypeNameE] [varchar](50) NULL,
	[PaymentTypeCode] [varchar](10) NOT NULL,
 CONSTRAINT [PK_DictPaymentType_PaymentTypeID] PRIMARY KEY CLUSTERED 
(
	[PaymentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictPaymentType_PaymentTypeCode] UNIQUE NONCLUSTERED 
(
	[PaymentTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictReservationType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictReservationType](
	[ReservationTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReservationTypeName] [varchar](50) NOT NULL,
	[ReservationTypeNameE] [varchar](50) NULL,
	[ReservationTypeCode] [varchar](10) NOT NULL,
	[ReservRefNoRequired] [bit] NOT NULL,
 CONSTRAINT [PK_DictReservationType_ReservationTypeID] PRIMARY KEY CLUSTERED 
(
	[ReservationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictReservationType_ReservationTypeCode] UNIQUE NONCLUSTERED 
(
	[ReservationTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictUser]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[UserLogin] [varchar](100) NULL,
	[ManagerRole] [bit] NOT NULL,
	[EmpRole] [bit] NOT NULL,
	[RappRole] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DictUser_UserID_ContactID] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictViewerType]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictViewerType](
	[ViewerTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ViewerTypeName] [varchar](50) NOT NULL,
	[ViewerTypeNameE] [varchar](50) NULL,
	[ViewerTypeCode] [varchar](10) NOT NULL,
 CONSTRAINT [PK_DictViewerType_ViewerTypeID] PRIMARY KEY CLUSTERED 
(
	[ViewerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DictViewerType_ViewerTypeCode] UNIQUE NONCLUSTERED 
(
	[ViewerTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilmOrig]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmOrig](
	[FilmOrigID] [int] IDENTITY(1,1) NOT NULL,
	[TitleHU] [varchar](100) NOT NULL,
	[TitleOrig] [varchar](100) NULL,
	[FilmCategory] [varchar](100) NULL,
	[ReleaseYear] [smallint] NULL,
	[DurationMin] [varchar](50) NULL,
	[ProdCountry] [varchar](200) NULL,
	[Director] [varchar](400) NULL,
	[Stars] [varchar](600) NULL,
	[FilmRatingType] [varchar](50) NULL,
 CONSTRAINT [PK_Film_FilmOrigID] PRIMARY KEY CLUSTERED 
(
	[FilmOrigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [AK_Contact_Email]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [AK_Contact_Email] ON [dbo].[Contact]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [AK_DictFilmRatingType_FilmRatingTypeNameE]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [AK_DictFilmRatingType_FilmRatingTypeNameE] ON [dbo].[DictFilmRatingType]
(
	[FilmRatingTypeNameE] ASC
)
WHERE ([FilmRatingTypeNameE] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [AK_DictFilmType_FilmTypeNameE]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [AK_DictFilmType_FilmTypeNameE] ON [dbo].[DictFilmType]
(
	[FilmTypeNameE] ASC
)
WHERE ([FilmTypeNameE] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UC_Screening_Auditorium_StartTime]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UC_Screening_Auditorium_StartTime] ON [dbo].[Screening]
(
	[AuditoriumID] ASC,
	[ScreeningStart] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UC_Seat_Auditorium_SeatNumber_RowNumber]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UC_Seat_Auditorium_SeatNumber_RowNumber] ON [dbo].[Seat]
(
	[AuditoriumID] ASC,
	[SeatNumber] ASC,
	[RowNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UC_SeatReserved_Screening_Seat]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UC_SeatReserved_Screening_Seat] ON [dbo].[SeatReserved]
(
	[ScreeningID] ASC,
	[SeatID] ASC
)
WHERE ([AnnulmentTime] IS NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UC_TicketSale_Reservation_Price]    Script Date: 2021. 08. 17. 19:11:12 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UC_TicketSale_Reservation_Price] ON [dbo].[TicketSale]
(
	[ReservationID] ASC,
	[PriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_PaymentTypeID]  DEFAULT ((1)) FOR [PaymentTypeID]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_IsCustomer]  DEFAULT ((1)) FOR [IsCustomer]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_IsSupplier]  DEFAULT ((0)) FOR [IsSupplier]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_IsEmployee]  DEFAULT ((0)) FOR [IsEmployee]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_IsLogin]  DEFAULT ((0)) FOR [IsLogin]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_CountryCode]  DEFAULT ('HU') FOR [CountryCode]
GO
ALTER TABLE [dbo].[DictAuditoriumType] ADD  CONSTRAINT [DF_AuditoriumDiscExtraVal]  DEFAULT ((0)) FOR [AuditoriumDiscExtraVal]
GO
ALTER TABLE [dbo].[DictCountry] ADD  CONSTRAINT [DF_IsEUMember]  DEFAULT ((0)) FOR [IsEUMember]
GO
ALTER TABLE [dbo].[DictCountry] ADD  CONSTRAINT [DF_IsValid]  DEFAULT ((0)) FOR [IsValid]
GO
ALTER TABLE [dbo].[DictFilmPriceType] ADD  CONSTRAINT [DF_FilmPriceDiscExtraVal]  DEFAULT ((0)) FOR [FilmPriceDiscExtraVal]
GO
ALTER TABLE [dbo].[DictReservationType] ADD  CONSTRAINT [DF_ReservRefNoRequired]  DEFAULT ((0)) FOR [ReservRefNoRequired]
GO
ALTER TABLE [dbo].[DictUser] ADD  CONSTRAINT [DF_ManagerRole]  DEFAULT ((0)) FOR [ManagerRole]
GO
ALTER TABLE [dbo].[DictUser] ADD  CONSTRAINT [DF_EmpRole]  DEFAULT ((0)) FOR [EmpRole]
GO
ALTER TABLE [dbo].[DictUser] ADD  CONSTRAINT [DF_RappRole]  DEFAULT ((0)) FOR [RappRole]
GO
ALTER TABLE [dbo].[DictUser] ADD  CONSTRAINT [DF_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DictVAT] ADD  CONSTRAINT [DF_DictVAT_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Price] ADD  CONSTRAINT [DF_Price_VATID]  DEFAULT ([dbo].[DefaultVATID]('27')) FOR [VATID]
GO
ALTER TABLE [dbo].[Price] ADD  CONSTRAINT [DF_Price_BasePrice]  DEFAULT ((0)) FOR [BasePrice]
GO
ALTER TABLE [dbo].[Price] ADD  CONSTRAINT [DF_Price_IsIncludeVAT]  DEFAULT ((0)) FOR [IsIncludeVAT]
GO
ALTER TABLE [dbo].[Price] ADD  CONSTRAINT [DF_Price_StartDate]  DEFAULT (sysdatetime()) FOR [StartDate]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_Reserved]  DEFAULT ((1)) FOR [Reserved]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_Paid]  DEFAULT ((0)) FOR [Paid]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_ReservationDate]  DEFAULT (sysdatetime()) FOR [ReservationDate]
GO
ALTER TABLE [dbo].[Seat] ADD  CONSTRAINT [DF_Seat_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SeatReserved] ADD  CONSTRAINT [DF_SeatReserved_ViewerTypeID]  DEFAULT ((1)) FOR [ViewerTypeID]
GO
ALTER TABLE [dbo].[TicketSale] ADD  CONSTRAINT [DF_TicketSale_PaymentDate]  DEFAULT (sysdatetime()) FOR [PaymentDate]
GO
ALTER TABLE [dbo].[Auditorium]  WITH CHECK ADD  CONSTRAINT [FK_Auditorium_DictAuditoriumType_AuditoriumTypeID] FOREIGN KEY([AuditoriumTypeID])
REFERENCES [dbo].[DictAuditoriumType] ([AuditoriumTypeID])
GO
ALTER TABLE [dbo].[Auditorium] CHECK CONSTRAINT [FK_Auditorium_DictAuditoriumType_AuditoriumTypeID]
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_DictCountry_CountryCode] FOREIGN KEY([CountryCode])
REFERENCES [dbo].[DictCountry] ([CountryCode])
GO
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [FK_Contact_DictCountry_CountryCode]
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_DictPaymentType_PaymentTypeID] FOREIGN KEY([PaymentTypeID])
REFERENCES [dbo].[DictPaymentType] ([PaymentTypeID])
GO
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [FK_Contact_DictPaymentType_PaymentTypeID]
GO
ALTER TABLE [dbo].[DictUser]  WITH CHECK ADD  CONSTRAINT [FK_DictUser_Contact_ContactID] FOREIGN KEY([ContactID])
REFERENCES [dbo].[Contact] ([ContactID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DictUser] CHECK CONSTRAINT [FK_DictUser_Contact_ContactID]
GO
ALTER TABLE [dbo].[Film]  WITH CHECK ADD  CONSTRAINT [FK_Film_FilmPriceType_FilmPriceTypeID] FOREIGN KEY([FilmPriceTypeID])
REFERENCES [dbo].[DictFilmPriceType] ([FilmPriceTypeID])
GO
ALTER TABLE [dbo].[Film] CHECK CONSTRAINT [FK_Film_FilmPriceType_FilmPriceTypeID]
GO
ALTER TABLE [dbo].[Film]  WITH CHECK ADD  CONSTRAINT [FK_Film_FilmRatingType_FilmRatingTypeID] FOREIGN KEY([FilmRatingTypeID])
REFERENCES [dbo].[DictFilmRatingType] ([FilmRatingTypeID])
GO
ALTER TABLE [dbo].[Film] CHECK CONSTRAINT [FK_Film_FilmRatingType_FilmRatingTypeID]
GO
ALTER TABLE [dbo].[FilmCountry]  WITH CHECK ADD  CONSTRAINT [FK_FilmCountry_DictCountry_CountryCode] FOREIGN KEY([CountryCode])
REFERENCES [dbo].[DictCountry] ([CountryCode])
GO
ALTER TABLE [dbo].[FilmCountry] CHECK CONSTRAINT [FK_FilmCountry_DictCountry_CountryCode]
GO
ALTER TABLE [dbo].[FilmCountry]  WITH CHECK ADD  CONSTRAINT [FK_FilmCountry_Film_FilmID] FOREIGN KEY([FilmID])
REFERENCES [dbo].[Film] ([FilmID])
GO
ALTER TABLE [dbo].[FilmCountry] CHECK CONSTRAINT [FK_FilmCountry_Film_FilmID]
GO
ALTER TABLE [dbo].[FilmDirector]  WITH CHECK ADD  CONSTRAINT [FK_FilmDirector_Film_FilmID] FOREIGN KEY([FilmID])
REFERENCES [dbo].[Film] ([FilmID])
GO
ALTER TABLE [dbo].[FilmDirector] CHECK CONSTRAINT [FK_FilmDirector_Film_FilmID]
GO
ALTER TABLE [dbo].[FilmFilmType]  WITH CHECK ADD  CONSTRAINT [FK_FilmFilmType_DictFilmType_FilmTypeID] FOREIGN KEY([FilmTypeID])
REFERENCES [dbo].[DictFilmType] ([FilmTypeID])
GO
ALTER TABLE [dbo].[FilmFilmType] CHECK CONSTRAINT [FK_FilmFilmType_DictFilmType_FilmTypeID]
GO
ALTER TABLE [dbo].[FilmFilmType]  WITH CHECK ADD  CONSTRAINT [FK_FilmFilmType_Film_FilmID] FOREIGN KEY([FilmID])
REFERENCES [dbo].[Film] ([FilmID])
GO
ALTER TABLE [dbo].[FilmFilmType] CHECK CONSTRAINT [FK_FilmFilmType_Film_FilmID]
GO
ALTER TABLE [dbo].[FilmStar]  WITH CHECK ADD  CONSTRAINT [FK_FilmStar_Film_FilmID] FOREIGN KEY([FilmID])
REFERENCES [dbo].[Film] ([FilmID])
GO
ALTER TABLE [dbo].[FilmStar] CHECK CONSTRAINT [FK_FilmStar_Film_FilmID]
GO
ALTER TABLE [dbo].[Price]  WITH CHECK ADD  CONSTRAINT [FK_Price_DictVAT_VATID] FOREIGN KEY([VATID])
REFERENCES [dbo].[DictVAT] ([VATID])
GO
ALTER TABLE [dbo].[Price] CHECK CONSTRAINT [FK_Price_DictVAT_VATID]
GO
ALTER TABLE [dbo].[Price]  WITH CHECK ADD  CONSTRAINT [FK_Price_DictViewerType_ViewerTypeID] FOREIGN KEY([ViewerTypeID])
REFERENCES [dbo].[DictViewerType] ([ViewerTypeID])
GO
ALTER TABLE [dbo].[Price] CHECK CONSTRAINT [FK_Price_DictViewerType_ViewerTypeID]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_ContactPaid_ContactPaidID] FOREIGN KEY([ContactPaidID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_ContactPaid_ContactPaidID]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_ContactReserve_ContactReserveID] FOREIGN KEY([ContactReserveID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_ContactReserve_ContactReserveID]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_DictReservationType_ReservationTypeID] FOREIGN KEY([ReservationTypeID])
REFERENCES [dbo].[DictReservationType] ([ReservationTypeID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_DictReservationType_ReservationTypeID]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Screening_ScreeningID] FOREIGN KEY([ScreeningID])
REFERENCES [dbo].[Screening] ([ScreeningID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_Screening_ScreeningID]
GO
ALTER TABLE [dbo].[Screening]  WITH CHECK ADD  CONSTRAINT [FK_Screening_Auditorium_AuditoriumID] FOREIGN KEY([AuditoriumID])
REFERENCES [dbo].[Auditorium] ([AuditoriumID])
GO
ALTER TABLE [dbo].[Screening] CHECK CONSTRAINT [FK_Screening_Auditorium_AuditoriumID]
GO
ALTER TABLE [dbo].[Screening]  WITH CHECK ADD  CONSTRAINT [FK_Screening_Film_FilmID] FOREIGN KEY([FilmID])
REFERENCES [dbo].[Film] ([FilmID])
GO
ALTER TABLE [dbo].[Screening] CHECK CONSTRAINT [FK_Screening_Film_FilmID]
GO
ALTER TABLE [dbo].[Seat]  WITH CHECK ADD  CONSTRAINT [FK_Seat_Auditorium_AuditoriumID] FOREIGN KEY([AuditoriumID])
REFERENCES [dbo].[Auditorium] ([AuditoriumID])
GO
ALTER TABLE [dbo].[Seat] CHECK CONSTRAINT [FK_Seat_Auditorium_AuditoriumID]
GO
ALTER TABLE [dbo].[SeatReserved]  WITH CHECK ADD  CONSTRAINT [FK_SeatReserved_Reservation_ReservationID] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[Reservation] ([ReservationID])
GO
ALTER TABLE [dbo].[SeatReserved] CHECK CONSTRAINT [FK_SeatReserved_Reservation_ReservationID]
GO
ALTER TABLE [dbo].[SeatReserved]  WITH CHECK ADD  CONSTRAINT [FK_SeatReserved_Screening_ScreeningID] FOREIGN KEY([ScreeningID])
REFERENCES [dbo].[Screening] ([ScreeningID])
GO
ALTER TABLE [dbo].[SeatReserved] CHECK CONSTRAINT [FK_SeatReserved_Screening_ScreeningID]
GO
ALTER TABLE [dbo].[SeatReserved]  WITH CHECK ADD  CONSTRAINT [FK_SeatReserved_Seat_SeatID] FOREIGN KEY([SeatID])
REFERENCES [dbo].[Seat] ([SeatID])
GO
ALTER TABLE [dbo].[SeatReserved] CHECK CONSTRAINT [FK_SeatReserved_Seat_SeatID]
GO
ALTER TABLE [dbo].[SeatReserved]  WITH CHECK ADD  CONSTRAINT [FK_SeatReserved_ViewerType_ViewerTypeID] FOREIGN KEY([ViewerTypeID])
REFERENCES [dbo].[DictViewerType] ([ViewerTypeID])
GO
ALTER TABLE [dbo].[SeatReserved] CHECK CONSTRAINT [FK_SeatReserved_ViewerType_ViewerTypeID]
GO
ALTER TABLE [dbo].[TicketSale]  WITH CHECK ADD  CONSTRAINT [FK_TicketSale_DictPaymentType_PaymentTypeID] FOREIGN KEY([PaymentTypeID])
REFERENCES [dbo].[DictPaymentType] ([PaymentTypeID])
GO
ALTER TABLE [dbo].[TicketSale] CHECK CONSTRAINT [FK_TicketSale_DictPaymentType_PaymentTypeID]
GO
ALTER TABLE [dbo].[TicketSale]  WITH CHECK ADD  CONSTRAINT [FK_TicketSale_Price_PriceID] FOREIGN KEY([PriceID])
REFERENCES [dbo].[Price] ([PriceID])
GO
ALTER TABLE [dbo].[TicketSale] CHECK CONSTRAINT [FK_TicketSale_Price_PriceID]
GO
ALTER TABLE [dbo].[TicketSale]  WITH CHECK ADD  CONSTRAINT [FK_TicketSale_Reservation_ReservationID] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[Reservation] ([ReservationID])
GO
ALTER TABLE [dbo].[TicketSale] CHECK CONSTRAINT [FK_TicketSale_Reservation_ReservationID]
GO
ALTER TABLE [dbo].[Auditorium]  WITH CHECK ADD  CONSTRAINT [CK_Auditorium_AuditoriumTypeID] CHECK  (([dbo].[DictTypeIsIN]([AuditoriumTypeID],'DictAuditoriumType')=(1)))
GO
ALTER TABLE [dbo].[Auditorium] CHECK CONSTRAINT [CK_Auditorium_AuditoriumTypeID]
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD  CONSTRAINT [CK_Contact_PaymentType_Exist] CHECK  (([dbo].[DictTypeIsIN]([PaymentTypeID],'DictPaymentType')=(1)))
GO
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [CK_Contact_PaymentType_Exist]
GO
ALTER TABLE [dbo].[Contact]  WITH NOCHECK ADD  CONSTRAINT [CK_Contact_TaxPayerNoCheck] CHECK  (([dbo].[TaxPayerNoCheck]([VATNr],[CountryCode])=(1)))
GO
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [CK_Contact_TaxPayerNoCheck]
GO
ALTER TABLE [dbo].[Film]  WITH CHECK ADD  CONSTRAINT [CK_Film_FilmPriceTypeID] CHECK  (([dbo].[DictTypeIsIN]([FilmPriceTypeID],'DictFilmPriceType')=(1)))
GO
ALTER TABLE [dbo].[Film] CHECK CONSTRAINT [CK_Film_FilmPriceTypeID]
GO
ALTER TABLE [dbo].[Film]  WITH CHECK ADD  CONSTRAINT [CK_Film_FilmRatingTypeID] CHECK  (([dbo].[DictTypeIsIN]([FilmRatingTypeID],'DictFilmRatingType')=(1)))
GO
ALTER TABLE [dbo].[Film] CHECK CONSTRAINT [CK_Film_FilmRatingTypeID]
GO
ALTER TABLE [dbo].[FilmFilmType]  WITH NOCHECK ADD  CONSTRAINT [CK_FilmFilmType_FilmType_Exist] CHECK  (([dbo].[DictTypeIsIN]([FilmTypeID],'DictFilmType')=(1)))
GO
ALTER TABLE [dbo].[FilmFilmType] CHECK CONSTRAINT [CK_FilmFilmType_FilmType_Exist]
GO
ALTER TABLE [dbo].[FilmFilmType]  WITH CHECK ADD  CONSTRAINT [CK_FilmFilmType_FilmTypeID] CHECK  (([dbo].[DictTypeIsIN]([FilmTypeID],'DictFilmType')=(1)))
GO
ALTER TABLE [dbo].[FilmFilmType] CHECK CONSTRAINT [CK_FilmFilmType_FilmTypeID]
GO
ALTER TABLE [dbo].[Price]  WITH CHECK ADD  CONSTRAINT [CK_Price_VATID] CHECK  (([dbo].[DictTypeIsIN]([VATID],'DictVAT')=(1)))
GO
ALTER TABLE [dbo].[Price] CHECK CONSTRAINT [CK_Price_VATID]
GO
ALTER TABLE [dbo].[Price]  WITH CHECK ADD  CONSTRAINT [CK_Price_ViewerTypeID] CHECK  (([dbo].[DictTypeIsIN]([ViewerTypeID],'DictViewerType')=(1)))
GO
ALTER TABLE [dbo].[Price] CHECK CONSTRAINT [CK_Price_ViewerTypeID]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [CK_Reservation_ReservationTypeID] CHECK  (([dbo].[DictTypeIsIN]([ReservationTypeID],'DictReservationType')=(1)))
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [CK_Reservation_ReservationTypeID]
GO
ALTER TABLE [dbo].[SeatReserved]  WITH CHECK ADD  CONSTRAINT [CK_SeatReserved_ViewerTypeID] CHECK  (([dbo].[DictTypeIsIN]([ViewerTypeID],'DictViewerType')=(1)))
GO
ALTER TABLE [dbo].[SeatReserved] CHECK CONSTRAINT [CK_SeatReserved_ViewerTypeID]
GO
ALTER TABLE [dbo].[TicketSale]  WITH CHECK ADD  CONSTRAINT [CK_TicketSale_PaymentTypeID] CHECK  (([dbo].[DictTypeIsIN]([PaymentTypeID],'DictPaymentType')=(1)))
GO
ALTER TABLE [dbo].[TicketSale] CHECK CONSTRAINT [CK_TicketSale_PaymentTypeID]
GO
/****** Object:  StoredProcedure [dbo].[ContactInsert]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[ContactInsert]
@ContactName varchar(100),@ZIP varchar(10) = NULL, @City varchar(40) = NULL, @Address varchar(100) = NULL,
@Email varchar(80) = NULL, @PaymentTypeID tinyint = 1,
@IsCustomer tinyint = 1, @IsSupplier tinyint = 0, @IsEmployee tinyint = 0, @IsLogin tinyint = 0,
@VATNr varchar(20) = NULL, @Mobile varchar(20) = NULL, @Phone varchar(20) = NULL, @CountryCode char(2) = 'HU', 
@ZIPShip varchar(10) = NULL, @CityShip varchar(40) = NULL, @AddressShip varchar(100) = NULL,
@ZIPPostal varchar(10) = NULL, @CityPostal varchar(40) = NULL, @AddressPostal varchar(100) = NULL
AS
	SET NOCOUNT ON
	IF @ContactName IS NULL OR LEN(@ContactName) < 1 RETURN 1
	ELSE IF @Email IS NULL RETURN 2
	ELSE IF EXISTS (SELECT 1 
				   FROM Contact C WHERE C.Email = @Email) RETURN 3	
	ELSE IF @ZIP IS NOT NULL AND @CountryCode = 'HU' AND LEN(@ZIP)<> 4 RETURN 4	
	ELSE IF @ZIPShip IS NOT NULL AND @CountryCode = 'HU' AND LEN(@ZIPShip)<> 4 RETURN 5
	ELSE IF @ZIPPostal IS NOT NULL AND @CountryCode = 'HU' AND LEN(@ZIPPostal)<> 4 RETURN 6
	ELSE IF @IsCustomer IS NOT NULL AND @IsCustomer NOT IN (0,1) RETURN 7
	ELSE IF @IsSupplier IS NOT NULL AND @IsSupplier NOT IN (0,1) RETURN 8
	ELSE IF @IsEmployee IS NOT NULL AND @IsEmployee NOT IN (0,1) RETURN 9
	ELSE IF @IsLogin IS NOT NULL AND @IsLogin NOT IN (0,1) RETURN 10
	ELSE IF @PaymentTypeID IS NOT NULL AND dbo.DictTypeIsIN(@PaymentTypeID, 'DictPaymentType') = 0 RETURN 11
	ELSE IF @CountryCode IS NULL OR LEN(@CountryCode) < 2 RETURN 12
	ELSE IF NOT EXISTS (SELECT 1 
				   FROM DictCountry DC WHERE DC.CountryCode = @CountryCode) RETURN 13	
	ELSE
		INSERT Contact (ContactName,ZIP,City,Address,Email,PaymentTypeID,IsCustomer,IsSupplier,
				IsEmployee,IsLogin,VATNr,Mobile,Phone,CountryCode,ZIPShip, CityShip, AddressShip,
				ZIPPostal,CityPostal,AddressPostal)
		VALUES (@ContactName, @ZIP, @City, @Address,@Email,@PaymentTypeID,@IsCustomer,@IsSupplier,
				@IsEmployee,@IsLogin,@VATNr,@Mobile,@Phone, @CountryCode, @ZIPShip, @CityShip, @AddressShip,
				@ZIPPostal,@CityPostal,@AddressPostal)
GO
/****** Object:  StoredProcedure [dbo].[INSERTVATCODE]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Insert VATCodes with BULK INSERT
-- Limited, file path inside. Passing it as input parameter: solution dynamic SQL?
CREATE   PROC [dbo].[INSERTVATCODE]
AS
BEGIN
	BULK INSERT DictVAT
	FROM 'D:\SQL_Halado\VizsgRemek\Mozi\Afacodes_1.txt'
	WITH 
	(
		FIRSTROW = 1,
		CODEPAGE = 1250,
		FIELDTERMINATOR = '\t', 
		ROWTERMINATOR = '\n',
		MAXERRORS=4
	)
END
GO
/****** Object:  StoredProcedure [dbo].[ReservationInsert]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[ReservationInsert]
@ScreeningID int, @ContactReserveID int = NULL, @ReservationTypeID tinyint = 2,
@ContactPaidID int = NULL, @Reserved tinyint = 1, @Paid tinyint = 0, @Active tinyint = 1,
@ReservationDate datetime2(0) = NULL, @ConfirmationDate datetime2(0) = NULL,
@ReservationContact varchar(200) = NULL, @ContactEmail varchar(80) = NULL, @SeatID int,
@ReservationRefNo int OUTPUT
AS
	SET NOCOUNT ON
	declare @reservationid int
	SELECT @ReservationRefNo = CEILING(RAND() * 989989989)
	IF @ReservationDate IS NULL OR @ReservationDate < SYSDATETIME() 
		SET @ReservationDate = SYSDATETIME()
	IF @ScreeningID IS NULL OR NOT EXISTS (SELECT 1 
				   FROM Screening S WHERE S.ScreeningID = @ScreeningID) RETURN 1
	ELSE IF @ContactReserveID IS NOT NULL AND NOT EXISTS (SELECT 1 
				   FROM Contact C WHERE C.ContactID = @ContactReserveID) RETURN 2
	ELSE IF @ReservationTypeID IS NOT NULL AND 
			dbo.DictTypeIsIN(@ReservationTypeID,'DictReservationType') = 0 RETURN 3
	ELSE IF @ContactPaidID IS NOT NULL AND NOT EXISTS (SELECT 1 
				   FROM Contact C WHERE C.ContactID = @ContactPaidID) RETURN 4
	ELSE IF @Reserved IS NOT NULL AND @Reserved NOT IN (0,1) RETURN 5
	ELSE IF @Paid IS NOT NULL AND @Paid NOT IN (0,1) RETURN 6
	ELSE IF @Active IS NOT NULL AND @Active NOT IN (0,1) RETURN 7
	ELSE IF @ConfirmationDate IS NOT NULL AND @ConfirmationDate < SYSDATETIME() RETURN 8
	ELSE IF @ContactEmail IS NOT NULL AND @ContactEmail NOT LIKE '%@%' RETURN 9
	ELSE IF @SeatID IS NULL OR dbo.IsSeatFreeofScreening(@ScreeningID,@SeatID) < 1 RETURN 10
	ELSE
		INSERT Reservation (ScreeningID,ContactReserveID,ReservationTypeID,ContactPaidID,
				Reserved,Paid,Active,ReservationDate,ConfirmationDate,ReservationContact,
				ContactEmail,ReservationRefNo)
		VALUES (@ScreeningID, @ContactReserveID, @ReservationTypeID, @ContactPaidID,@Reserved,@Paid,
				@Active,@ReservationDate,@ConfirmationDate,@ReservationContact,@ContactEmail, 
				@ReservationRefNo)
	SELECT @reservationid = IDENT_CURRENT('Reservation')
	EXEC dbo.SeatReservedInsertInLoop @reservationid,@ScreeningID,@SeatID
GO
/****** Object:  StoredProcedure [dbo].[ScreeningInsert]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[ScreeningInsert]
@AuditoriumID int, @FilmID int, @StartingTime datetime2(0)
AS
	SET NOCOUNT ON
	declare @numb tinyint, @viewertypeno tinyint, @i tinyint = 0
	IF @AuditoriumID IS NULL OR @FilmID IS NULL OR @StartingTime IS NULL RETURN 1
	ELSE IF NOT EXISTS (SELECT 1 FROM Auditorium A 
						WHERE A.AuditoriumID = @AuditoriumID) RETURN 2
	ELSE IF NOT EXISTS (SELECT 1 FROM Film F 
						WHERE F.FilmID = @FilmID) RETURN 3
	ELSE IF @StartingTime < SYSDATETIME() RETURN 4
	ELSE IF EXISTS (SELECT 1 FROM Screening S WHERE S.ScreeningStart = @StartingTime
						AND S.AuditoriumID = @AuditoriumID) RETURN 5  --Unique index
	ELSE IF dbo.IsNewScreeningCollide(@AuditoriumID,@FilmID,@StartingTime) = 1 RETURN 6
	ELSE IF dbo.IsNewScreeningCollide(@AuditoriumID,@FilmID,@StartingTime) = 2 RETURN 7
	ELSE
		INSERT Screening (AuditoriumID, FilmID,ScreeningStart)
		VALUES (@AuditoriumID, @FilmID, @StartingTime)
GO
/****** Object:  StoredProcedure [dbo].[SeatReservedInsertInLoop]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[SeatReservedInsertInLoop]
@ReservationID int, @ScreeningID int, @SeatID int
AS
	SET NOCOUNT ON
	declare @numb tinyint, @viewertypeno tinyint, @i tinyint = 0
	IF @ReservationID IS NULL OR @ScreeningID IS NULL OR @SeatID IS NULL RETURN 1
	ELSE
	SELECT @numb = CEILING(RAND() * 5)
	WHILE @i < @numb BEGIN
		SELECT @viewertypeno = CEILING(RAND() * 3)
		SELECT @SeatID += 1
		EXECUTE dbo.SeatReservedInsertOneRow @ReservationID, @ScreeningID, @SeatID, @viewertypeno
		SELECT @i += 1
	END
GO
/****** Object:  StoredProcedure [dbo].[SeatReservedInsertOneRow]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[SeatReservedInsertOneRow]
@ReservationID int, @ScreeningID int, @SeatID int, @ViewerTypeID tinyint = 1
AS
	SET NOCOUNT ON
	IF @ReservationID IS NULL OR NOT EXISTS (SELECT 1 
				   FROM Reservation R WHERE R.ReservationID = @ReservationID) RETURN 1
	ELSE IF @ScreeningID IS NULL OR NOT EXISTS (SELECT 1 
				   FROM Screening S WHERE S.ScreeningID = @ScreeningID) RETURN 2
	ELSE IF @SeatID IS NULL OR NOT EXISTS (SELECT 1 
				   FROM Seat S WHERE S.SeatID = @SeatID) RETURN 3
	ELSE IF @ScreeningID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Screening S 
			INNER JOIN Reservation R ON R.ScreeningID = S.ScreeningID
			WHERE S.ScreeningID = @ScreeningID AND R.ReservationID = @ReservationID) RETURN 4
	ELSE IF @SeatID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Screening S
			INNER JOIN Auditorium A ON A.AuditoriumID = S.AuditoriumID
			INNER JOIN Seat SEA ON SEA.AuditoriumID = A.AuditoriumID
			WHERE S.ScreeningID = @ScreeningID AND SEA.SeatID = @SeatID) RETURN 5
	ELSE IF @ViewerTypeID IS NOT NULL AND 
			dbo.DictTypeIsIN(@ViewerTypeID,'DictViewerType') = 0 RETURN 6
	ELSE IF @ScreeningID IS NOT NULL AND @SeatID IS NOT NULL AND EXISTS (SELECT 1 
				FROM SeatReserved S WHERE S.ScreeningID = @ScreeningID
				AND S.AnnulmentTime IS NULL AND S.SeatID = @SeatID) RETURN 7 --Unique Filtered Index
	ELSE
		INSERT SeatReserved (ReservationID, ScreeningID,SeatID,ViewerTypeID)
		VALUES (@ReservationID, @ScreeningID, @SeatID, @ViewerTypeID)
GO
/****** Object:  StoredProcedure [dbo].[TableIndexesRebuild]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[TableIndexesRebuild]
AS
DECLARE @TableName VARCHAR(255)
DECLARE @sql NVARCHAR(500)
DECLARE @fillfactor INT
SET @fillfactor = 80 
DECLARE TableCursor CURSOR FOR
SELECT QUOTENAME(OBJECT_SCHEMA_NAME([object_id]))+'.' + QUOTENAME(name) AS TableName
FROM sys.tables
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
SET @sql = 'ALTER INDEX ALL ON ' + @TableName + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')'
EXEC (@sql)
FETCH NEXT FROM TableCursor INTO @TableName
END
CLOSE TableCursor
DEALLOCATE TableCursor
GO
/****** Object:  Trigger [dbo].[trgDeleteContact]    Script Date: 2021. 08. 17. 19:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[trgDeleteContact] ON [dbo].[Contact]
	INSTEAD OF DELETE
AS
	SET NOCOUNT ON
	UPDATE dbo.Contact
	SET CloseDate = SYSDATETIME() 
	FROM dbo.Contact C
	INNER JOIN deleted D ON C.ContactID = D.ContactID
GO
ALTER TABLE [dbo].[Contact] ENABLE TRIGGER [trgDeleteContact]
GO
/****** Object:  Trigger [dbo].[trgDeletePrice]    Script Date: 2021. 08. 17. 19:11:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[trgDeletePrice] ON [dbo].[Price]
	INSTEAD OF DELETE
AS
	SET NOCOUNT ON
	UPDATE dbo.Price
	SET ValidUntilDate = SYSDATETIME() 
	FROM dbo.Price P
	INNER JOIN deleted D ON P.PriceID = D.PriceID
GO
ALTER TABLE [dbo].[Price] ENABLE TRIGGER [trgDeletePrice]
GO
/****** Object:  Trigger [dbo].[trgCalcSeatsNo]    Script Date: 2021. 08. 17. 19:11:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[trgCalcSeatsNo] ON [dbo].[Seat] FOR INSERT, UPDATE, DELETE
AS
	SET NOCOUNT ON
	declare @auditoriumid int
	IF EXISTS(SELECT * FROM deleted)
	BEGIN
		SELECT @auditoriumid = AuditoriumID FROM deleted
	--	SET @auditoriumid = (SELECT AuditoriumID FROM deleted)
		UPDATE dbo.Auditorium
		SET SeatsNo = dbo.getSeatsNoFromSeat(@auditoriumid)
		FROM Auditorium A
		INNER JOIN deleted D ON D.AuditoriumID = A.AuditoriumID
	END
    ELSE IF EXISTS(SELECT * FROM inserted)
	BEGIN
		SELECT @auditoriumid = AuditoriumID FROM inserted
 --		SET @auditoriumid = (SELECT AuditoriumID FROM inserted)
		UPDATE dbo.Auditorium
		SET SeatsNo = dbo.getSeatsNoFromSeat(@auditoriumid)
		FROM Auditorium A
		INNER JOIN inserted I ON I.AuditoriumID = A.AuditoriumID	END
    ELSE 
        IF NOT EXISTS(SELECT * FROM inserted) RETURN -- Nothing updated or inserted
GO
ALTER TABLE [dbo].[Seat] ENABLE TRIGGER [trgCalcSeatsNo]
GO
USE [master]
GO
ALTER DATABASE [CinemaTicketBooking] SET  READ_WRITE 
GO
