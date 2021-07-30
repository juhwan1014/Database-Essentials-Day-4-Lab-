USE master
GO
IF NOT EXISTS (
	SELECT name
	FROM sys.databases
	WHERE name = 'Moon_Juhwan_SSD_Ticketing'
)
BEGIN
CREATE DATABASE Moon_Juhwan_SSD_Ticketing
END
GO


USE Moon_Juhwan_SSD_Ticketing
GO



--DROP TABLES

IF OBJECT_ID('EventSeatSale', 'U') IS NOT NULL
DROP TABLE EventSeatSale;
GO
IF OBJECT_ID('EventSeat', 'U') IS NOT NULL
DROP TABLE EventSeat;
GO
IF OBJECT_ID('Seat', 'U') IS NOT NULL
DROP TABLE Seat;
GO
IF OBJECT_ID('Row', 'U') IS NOT NULL
DROP TABLE Row;
GO
IF OBJECT_ID('Section', 'U') IS NOT NULL
DROP TABLE Section;
GO
IF OBJECT_ID('Event', 'U') IS NOT NULL
DROP TABLE Event;
GO
IF OBJECT_ID('EventType', 'U') IS NOT NULL
DROP TABLE EventType;
GO
IF OBJECT_ID('Sale', 'U') IS NOT NULL
DROP TABLE Sale;
GO
IF OBJECT_ID('Customer', 'U') IS NOT NULL
DROP TABLE Customer;
GO
IF OBJECT_ID('dbo.Venue','u') IS NOT NULL
  DROP TABLE dbo.Venue
  GO


  --CREATE Tables
CREATE TABLE Venue (
	VenueId UNIQUEIDENTIFIER PRIMARY KEY, --default NEWID(),
	[Name] VARCHAR(200) NOT NULL,
	City VARCHAR(100) NOT NULL,
	[State] VARCHAR(100) NOT NULL,
	Capacity INT
)

CREATE TABLE Customer(
    CustomerId UNIQUEIDENTIFIER PRIMARY KEY,
	FirstName VARCHAR(30),
    LastName VARCHAR(30)
);

CREATE TABLE Sale(
    SaleId UNIQUEIDENTIFIER PRIMARY KEY,
	CustomerId UNIQUEIDENTIFIER,
	PaymentType VARCHAR(10)
	FOREIGN KEY(CustomerId) REFERENCES Customer(CustomerId)
);

CREATE TABLE EventType (
    EventTypeId UNIQUEIDENTIFIER PRIMARY KEY,
    Name VARCHAR(20)
);

CREATE TABLE Event(
    EventId UNIQUEIDENTIFIER PRIMARY KEY,
    EventTypeId UNIQUEIDENTIFIER,
    VenueId UNIQUEIDENTIFIER,
    [Name] VARCHAR(20),
    EventDate DATE,
    StartTime TIME
	FOREIGN KEY(EventTypeId) REFERENCES EventType(EventTypeId),
	FOREIGN KEY(VenueId) REFERENCES Venue(VenueId)
);

CREATE TABLE Section(
    SectionId UNIQUEIDENTIFIER PRIMARY KEY,
    VenueId UNIQUEIDENTIFIER,
    Name VARCHAR(50)
	FOREIGN KEY(VenueId) REFERENCES Venue(VenueId)
);

CREATE TABLE Row(
    RowId UNIQUEIDENTIFIER PRIMARY KEY,
    SectionId UNIQUEIDENTIFIER,
    RowNumber INT
	FOREIGN KEY(SectionId) REFERENCES Section(SectionId)
);

CREATE TABLE Seat(
    SeatId UNIQUEIDENTIFIER PRIMARY KEY,
    RowId UNIQUEIDENTIFIER,
    SeatNumber INT,
	BasePrice MONEY
	FOREIGN KEY(RowId) REFERENCES Row(RowId)
);

CREATE TABLE EventSeat(
    EventSeatId UNIQUEIDENTIFIER PRIMARY KEY,
    SeatId UNIQUEIDENTIFIER,
	EventId UNIQUEIDENTIFIER,
    EventPrice MONEY
	FOREIGN KEY(SeatId) REFERENCES Seat(SeatId),
	FOREIGN KEY(EventId) REFERENCES Event(EventId)
);

CREATE TABLE EventSeatSale(
    EventSeatId UNIQUEIDENTIFIER,
    SaleId UNIQUEIDENTIFIER,
	SalePrice MONEY,
    SaleStatus INTEGER default 0
	FOREIGN KEY(SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY(EventSeatId) REFERENCES EventSeat(EventSeatId),
	PRIMARY KEY (EventSeatId,SaleId)
);
GO

	





ALTER TABLE EventSeatSale
ADD CONSTRAINT availSaleSatus CHECK(SaleStatus IN (0,1,2,3)) 

ALTER TABLE Sale
ADD CONSTRAINT availPayType CHECK(PaymentType IN ('MC','AMEX','VISA','CASH')) 



INSERT INTO Venue VALUES (NEWID(),'American Airlines Arena','Miami','Florida','19600')
INSERT INTO Venue VALUES (NEWID(),'American Airlines Center','Dallas','Texas','19200')
INSERT INTO Venue VALUES (NEWID(),'Amway Center','Orlando','Florida','18846')
INSERT INTO Venue VALUES (NEWID(),'AT&T Center','San Antonio','Texas','18418')
INSERT INTO Venue VALUES (NEWID(),'Bankers Life Fieldhouse','Indianapolis','Indiana','17923')
INSERT INTO Venue VALUES (NEWID(),'Barclays Center','Brooklyn','New York','17732')
INSERT INTO Venue VALUES (NEWID(),'Capital One Arena','Washington','D.C.','20356')
INSERT INTO Venue VALUES (NEWID(),'Chase Center','San Francisco','California','18064')
INSERT INTO Venue VALUES (NEWID(),'Chesapeake Energy Arena','Oklahoma City','Oklahoma','18203')
INSERT INTO Venue VALUES (NEWID(),'FedExForum','Memphis','Tennessee','17794')
INSERT INTO Venue VALUES (NEWID(),'Fiserv Forum','Milwaukee','Wisconsin','17500')
INSERT INTO Venue VALUES (NEWID(),'Golden 1 Center','Sacramento','California','17583')
INSERT INTO Venue VALUES (NEWID(),'Little Caesars Arena','Detroit','Michigan','20332')
INSERT INTO Venue VALUES (NEWID(),'Madison Square Garden','New York City','New York','19812')
INSERT INTO Venue VALUES (NEWID(),'Moda Center','Portland','Oregon','19441')
INSERT INTO Venue VALUES (NEWID(),'Pepsi Center','Denver','Colorado','19520')
INSERT INTO Venue VALUES (NEWID(),'Rocket Mortgage FieldHouse','Cleveland','Ohio','19432')
INSERT INTO Venue VALUES (NEWID(),'Scotiabank Arena','Toronto','Ontario','19800')
INSERT INTO Venue VALUES (NEWID(),'Smoothie King Center','New Orleans','Louisiana','16867')
INSERT INTO Venue VALUES (NEWID(),'Spectrum Center','Charlotte','North Carolina','19077')
INSERT INTO Venue VALUES (NEWID(),'Staples Center','Los Angeles','California','18997')
INSERT INTO Venue VALUES (NEWID(),'State Farm Arena','Atlanta','Georgia','18118')
INSERT INTO Venue VALUES (NEWID(),'Talking Stick Resort Arena','Phoenix','Arizona','18055')
INSERT INTO Venue VALUES (NEWID(),'Target Center','Minneapolis','Minnesota','18978')
INSERT INTO Venue VALUES (NEWID(),'TD Garden','Boston','Massachusetts','18624')
INSERT INTO Venue VALUES (NEWID(),'Toyota Center','Houston','Texas','18055')
INSERT INTO Venue VALUES (NEWID(),'United Center','Chicago','Illinois','20917')
INSERT INTO Venue VALUES (NEWID(),'Vivint Smart Home Arena','Salt Lake City','Utah','18306')
INSERT INTO Venue VALUES (NEWID(),'Wells Fargo Center','Philadelphia','Pennsylvania','20478')
INSERT INTO Venue VALUES (NEWID(),'Inglewood Basketball and Entertainment Center','Inglewood', 'California','18000')




--INSERT Seed Data--
DECLARE @VenueId UNIQUEIDENTIFIER = (SELECT VenueId FROM Venue WHERE Name = 'Staples Center');
INSERT INTO EventType VALUES (NEWID(), 'Concert');
INSERT INTO EventType VALUES (NEWID(), 'Basketball Game');
INSERT INTO EventType VALUES (NEWID(), 'Hockey Game');

DECLARE @ConcertId UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Concert');


INSERT INTO Event VALUES 
(NEWID(),  @ConcertId, @VenueId, 'Beyonce', ' 2021-04-12 18 : 00 : 00.000 ' , ' 2021-04-12 18 : 00 : 00'),
(NEWID(),  @ConcertId, @VenueId, 'Lady Gaga', '2021-05-17 18:00:00.000','2021-05-17 18:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Disney on Ice', '2019-12-20 16:00:00.000','2019-12-20 16:00:00.000');

INSERT INTO Section VALUES 
(NEWID(), @VenueId, 'UPPERMEZ_10'),
(NEWID(), @VenueId, 'LOWERBOWL_01');

DECLARE @SectionId UNIQUEIDENTIFIER = (SELECT SectionId FROM Section WHERE Name = 'LOWERBOWL_01');

INSERT INTO Row VALUES 
(NEWID(), @SectionId, '01'),
(NEWID(), @SectionId, '02'),
(NEWID(), @SectionId, '03'),
(NEWID(), @SectionId, '04'),
(NEWID(), @SectionId, '05');

DECLARE @RowId UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '01');
DECLARE @RowId2 UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '02');

INSERT INTO Seat VALUES 
(NEWID(), @RowId, '01', 29.88),
(NEWID(), @RowId, '02', 29.88),
(NEWID(), @RowId, '03', 29.88),
(NEWID(), @RowId, '04', 29.88),
(NEWID(), @RowId, '05', 29.88),
(NEWID(), @RowId, '06', 29.88),
(NEWID(), @RowId, '07', 29.88),
(NEWID(), @RowId, '08', 29.88),
(NEWID(), @RowId2, '01', 26.28),
(NEWID(), @RowId2, '02', 26.28),
(NEWID(), @RowId2, '03', 26.28),
(NEWID(), @RowId2, '04', 26.28),
(NEWID(), @RowId2, '05', 26.28),
(NEWID(), @RowId2, '06', 26.28),
(NEWID(), @RowId2, '07', 26.28),
(NEWID(), @RowId2, '08', 26.28);

INSERT INTO Customer VALUES
(NEWID(),'Steve', 'Rogers'),
(NEWID(),'Carol', 'Danvers'),
(NEWID(),'Peter', 'Parker')

INSERT INTO Sale VALUES
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Rogers'), 'MC'),
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Danvers'), 'CASH');



--last version--

--DECLARE @SeatId_1 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '101');
--DECLARE @SeatId_2 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '102');
--DECLARE @SeatId_3 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '103');
--DECLARE @SeatId_4 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '104');
--DECLARE @SeatId_5 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '105');
--DECLARE @SeatId_6 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '106');
--DECLARE @SeatId_7 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '107');
--DECLARE @SeatId_8 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '108');
--DECLARE @SeatId_9 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '201');
--DECLARE @SeatId_10 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '202');
--DECLARE @SeatId_11 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '203');
--DECLARE @SeatId_12 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '204');
--DECLARE @SeatId_13 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '205');
--DECLARE @SeatId_14 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '206');
--DECLARE @SeatId_15 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '207');
--DECLARE @SeatId_16 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '208');


--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_1,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_2,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_3,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_4,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_5,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_6,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_7,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_8,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_9,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_10,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_11,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_12,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_13,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_14,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_15,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_16,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)


--DECLARE @EventSeatId1 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_9);
--DECLARE @EventSeatId2 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_10);
--DECLARE @EventSeatId3 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_11);
--DECLARE @EventSeatId4 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_12);


--Numbwe 7--
INSERT INTO EventSeat 
	SELECT NEWID(), SeatId, (SELECT EventId FROM EVENT WHERE Name = 'Beyonce'), 68.00 FROM Seat;


--last version--

--INSERT INTO EventSeatSale VALUES (@EventSeatId1,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '201')+'68'), 1);
--INSERT INTO EventSeatSale VALUES (@EventSeatId2,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '202')+'68'), 1);
--INSERT INTO EventSeatSale VALUES (@EventSeatId3,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '203')+'68'), 1);
--INSERT INTO EventSeatSale VALUES (@EventSeatId4,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '204')+'68'), 1);

-- Number 8--
INSERT INTO EventSeatSale SELECT EventSeat.EventSeatId, 
(SELECT SaleId FROM Sale 
 INNER JOIN Customer ON Sale.CustomerId = Customer.CustomerId 
  WHERE Customer.FirstName = 'Steve' AND Customer.LastName = 'Rogers'),
 (EventSeat.EventPrice + Seat.BasePrice), 1
 FROM EventSeat
 INNER JOIN Seat ON Seat.SeatId = EventSeat.SeatId
 INNER JOIN Row ON Row.RowId = Seat.RowId
 INNER JOIN Section ON Section.SectionId = Row.SectionId
 WHERE section.name = 'lowerbowl_01'
       AND row.RowNumber = '02' 
       AND (Seat.SeatNumber = '01' OR Seat.SeatNumber = '02' OR Seat.SeatNumber = '03' OR Seat.SeatNumber = '04')


								   
/*
SELECT * FROM Customer
SELECT * FROM Sale
SELECT * FROM EventType
SELECT * FROM Event
SELECT * FROM Section
SELECT * FROM Row
SELECT * FROM Seat
SELECT * FROM EventSeat
SELECT * FROM EventSeatSale
*/


--Number 9--
set language us_english
DELETE FROM Event WHERE EventDate < GETDATE();
SELECT Venue.Name Venue , Event.Name Event , CONVERT(VARCHAR(20), Event.EventDate,107) [Event Date], 
                CAST(Event.StartTime AS VARCHAR(8)) [Start Time] From Event 
                LEFT OUTER JOIN Venue ON Venue.Name = 'Staples Center'


--IF OBJECT_ID('tempdb..#tempEvent1') IS NOT NULL
--DROP TABLE #tempEvent1
--GO

--DELETE FROM Event WHERE EventDate >  '2021-05-01 18 : 00 : 00.000 ';
-- SELECT Event.Name Event , Section.Name Section, Row.RowNumber, sum(case when EventSeatSale.EventSeatId is Null then 1 else 0 end) Avaliable
--INTO #tempEvent1
--FROM Event, Section, EventSeatSale 
--INNER JOIN Row ON (Row.RowNumber = '01'OR Row.RowNumber = '02')


--Number 10--
SELECT Event.Name Event, Section.Name Section, row.RowNumber Row, 
      SUM(CASE WHEN eventseatSale.EventSeatId is Null THEN 1 ELSE 0 END) [Available Seats] FROM Event
INNER JOIN EventSeat ON EventSeat.EventId = Event.eventId
INNER JOIN Seat ON Seat.SeatId = EventSeat.SeatId
INNER JOIN Row ON Seat.RowId = Row.RowId
INNER JOIN Section ON Row.SectionId = Section.SectionId
LEFT JOIN EventSeatSale ON EventSeatSale.EventSeatId = EventSeat.EventSeatId

WHERE EventSeatSale.EventSeatId IS NULL GROUP BY Event.Name, Section.Name, Row.RowNumber





--Number11--
SELECT Customer.FirstName + ' ' + Customer.LastName Customer, Event.Name Event, Section.Name Section, Row.RowNumber Row,
	STRING_AGG(Seat.SeatNumber,',') Seats,
	COUNT(DISTINCT Seat.SeatNumber) [Number of Seats],
	FORMAT(SUM(EventSeatSale.salePrice),'C') [Sale Price],
	Sale.PaymentType
FROM Customer
	INNER JOIN Sale ON Customer.CustomerId = Sale.CustomerId
	INNER JOIN EventSeatSale ON EventSeatSale.SaleId = Sale.SaleId
	INNER JOIN EventSeat ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
	INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
	INNER JOIN Event ON EventSeat.EventId = Event.EventId
	INNER JOIN Row ON Seat.RowId = Row.RowId
	INNER JOIN Section ON row.SectionId = Section.SectionId
	INNER JOIN EventType ON Event.EventTypeId = EventType.EventTypeId
GROUP BY Sale.saleId, (Customer.FirstName+' ' + Customer.LastName), Event.Name, Section.Name, Row.RowNumber, Sale.PaymentType




SELECT Customer.FirstName + ' ' + Customer.LastName Customer, Event.Name Event, Section.Name Section, Row.RowNumber Row,
 STRING_AGG(Seat.SeatNumber,',') Seats, FORMAT(SUM(EventSeatSale.salePrice),'C') [Sale Price], Sale.PaymentType
FROM Customer
    INNER JOIN Sale ON Customer.CustomerId = Sale.CustomerId
	INNER JOIN EventSeatSale ON EventSeatSale.SaleId = Sale.SaleId
	INNER JOIN EventSeat ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
	INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
	INNER JOIN Event ON EventSeat.EventId = Event.EventId
	INNER JOIN Row ON Seat.RowId = Row.RowId
	INNER JOIN Section ON row.SectionId = Section.SectionId
	INNER JOIN EventType ON Event.EventTypeId = EventType.EventTypeId
GROUP BY Sale.saleId, (Customer.FirstName+' ' + Customer.LastName), Event.Name, Section.Name, Row.RowNumber, Sale.PaymentType




/*
SELECT * FROM Venue

SELECT Id,[Name],City,[State],Capacity FROM Venue 
ORDER BY [Name] DESC 

SELECT Id,[Name],City,[State],Capacity FROM Venue
WHERE Name LIKE '%Staples Center%'

DELETE FROM Venue WHERE Id  = (
SELECT Id FROM Venue WHERE Name = 'Staples Center'
)

SELECT COUNT(*) AS [Venue Count]
FROM Venue

INSERT INTO Venue VALUES (default,'Staples Center','Los Angeles','California','18997')

SELECT COUNT(*) AS [Venue Count]
FROM Venue


SELECT Name, City FROM Venue
WHERE State LIKE '%California%'

SELECT Name, Capacity FROM Venue
WHERE Capacity >= 19200


SELECT Name, City, State FROM Venue
WHERE (State = 'California') OR (State = 'Texas') OR (State = 'Colorado') OR (State = 'Tennessee') OR (State = 'Minnesota')
           OR (State = 'Oklahoma') OR (State = 'Louisiana') OR (State = 'Arizona') OR (State = 'Utah') OR (State = 'Oregon')


SELECT SUM(Capacity) AS [Total Venue Capacity]
FROM Venue


SELECT SUM(Capacity) AS [Western Conference Venue Capacity] FROM Venue
WHERE  (State = 'California') OR (State = 'Texas') OR (State = 'Colorado') OR (State = 'Tennessee') OR (State = 'Minnesota')
           OR (State = 'Oklahoma') OR (State = 'Louisiana') OR (State = 'Arizona') OR (State = 'Utah') OR (State = 'Oregon')
	

UPDATE Venue SET State = 'AZ' WHERE State = 'Arizona'
UPDATE Venue SET State = 'CA' WHERE State = 'California'
UPDATE Venue SET State = 'CO' WHERE State = 'Colorado'
UPDATE Venue SET State = 'DC' WHERE State = 'D.C.'
UPDATE Venue SET State = 'FL' WHERE State = 'Florida'
UPDATE Venue SET State = 'GA' WHERE State = 'Georgia'
UPDATE Venue SET State = 'IL' WHERE State = 'Illinois'
UPDATE Venue SET State = 'IN' WHERE State = 'Indiana'
UPDATE Venue SET State = 'LA' WHERE State = 'Louisiana'
UPDATE Venue SET State = 'MA' WHERE State = 'Massachusetts'
UPDATE Venue SET State = 'MI' WHERE State = 'Michigan'
UPDATE Venue SET State = 'MN' WHERE State = 'Minnesota'
UPDATE Venue SET State = 'NY' WHERE State = 'New York'
UPDATE Venue SET State = 'NC' WHERE State = 'North Carolina'
UPDATE Venue SET State = 'OH' WHERE State = 'Ohio'
UPDATE Venue SET State = 'OK' WHERE State = 'Oklahoma'
UPDATE Venue SET State = 'ON' WHERE State = 'Ontario'
UPDATE Venue SET State = 'OR' WHERE State = 'Oregon'
UPDATE Venue SET State = 'PA' WHERE State = 'Pennsylvania'
UPDATE Venue SET State = 'TN' WHERE State = 'Tennessee'
UPDATE Venue SET State = 'TX' WHERE State = 'Texas'
UPDATE Venue SET State = 'UT' WHERE State = 'Utah'
UPDATE Venue SET State = 'WI' WHERE State = 'Wisconsin'



SELECT State, COUNT(State) AS [Venue in State]
FROM Venue
GROUP BY State
*/




--Lab3--

-- 1. A WHILE loop that uses variables, CAST, and a conditional to insert 100 test customers to the Customer table.

DECLARE @name VARCHAR(30);
DECLARE @var INT = 1;
DECLARE @char VARCHAR(1);

WHILE @var <= 100
  BEGIN
     BEGIN
         IF @var % 26 = 1    SET @char = 'A'   IF @var % 26 = 2    SET @char = 'B'
		 IF @var % 26 = 3    SET @char = 'C'   IF @var % 26 = 4    SET @char = 'D'
		 IF @var % 26 = 5    SET @char = 'E'   IF @var % 26 = 6    SET @char = 'F'
		 IF @var % 26 = 7    SET @char = 'G'   IF @var % 26 = 8    SET @char = 'H'
		 IF @var % 26 = 9    SET @char = 'I'   IF @var % 26 = 10    SET @char = 'J'
		 IF @var % 26 = 11    SET @char = 'K'   IF @var % 26 = 12    SET @char = 'L'
		 IF @var % 26 = 13    SET @char = 'M'   IF @var % 26 = 14    SET @char = 'N'
		 IF @var % 26 = 15    SET @char = 'O'   IF @var % 26 = 16    SET @char = 'P'
		 IF @var % 26 = 17    SET @char = 'Q'   IF @var % 26 = 18    SET @char = 'R'
		 IF @var % 26 = 19    SET @char = 'S'   IF @var % 26 = 20    SET @char = 'T'
		 IF @var % 26 = 21    SET @char = 'U'   IF @var % 26 = 22    SET @char = 'V'
		 IF @var % 26 = 23    SET @char = 'W'   IF @var % 26 = 24    SET @char = 'X'
		 IF @var % 26 = 25    SET @char = 'Y'   IF @var % 26 = 0    SET @char = 'Z'

	  END
      INSERT INTO Customer VALUES (NEWID(),'Test'+CAST(@var AS VARCHAR(3)),@char+'name'+CAST(@var AS VARCHAR(3)))
	  SET @var += 1
  END

  SELECT * FROM Customer


-- 2-1. A Venue called "Test Venue" in Vancouver BC with a capacity of 19,000
-- 2-2. 20 sections in Test Venue called "SEC1" - "SEC20"


  INSERT INTO Venue VALUES (NEWID(),'Test Venue','Vancouver','BC','19000')
  DECLARE @T_Venue UNIQUEIDENTIFIER = (SELECT VenueId FROM Venue WHERE Name = 'Test Venue');

DECLARE @var2 INT = 1;

 WHILE @var2 <= 20
 BEGIN
 INSERT INTO Section VALUES (NEWID(), @T_Venue, 'SEC'+CAST(@var2 AS VARCHAR(2)))
 SET @var2 += 1
 END

 SELECT * FROM Section
 




 -- 2-3. In SEC1-SEC15 add 50 Rows numbered 1 through 50

 DECLARE @var3_1 INT = 1;
 DECLARE @var3_2 INT = 1;

 WHILE @var3_1 <= 15
 BEGIN

 WHILE @var3_2 <= 50
 BEGIN
 INSERT INTO Row SELECT NEWID(), (SELECT SectionId FROM Section WHERE Name = 'SEC'+CAST(@var3_1 AS VARCHAR(2))), 
 @var3_2; 
 SET @var3_2 += 1
 END
 
 SET @var3_1 += 1
  SET @var3_2 = 1
 END

 

 --2-4. In SEC16-SEC18 add 5 Rows

  DECLARE @var4_1 INT = 1;
 DECLARE @var4_2 INT = 1;

 WHILE @var4_1 <= 3
 BEGIN
 WHILE @var4_2 <= 5
 BEGIN
 INSERT INTO Row SELECT NEWID(), (SELECT SectionId FROM Section WHERE Name = 'SEC'+CAST(@var4_1+15 AS VARCHAR(2))), 
 @var4_2; 
 SET @var4_2 += 1
 END
 SET @var4_1 += 1
 SET @var4_2 = 1
 END

 --2-5. In the last 2 Sections add 1 Row

INSERT INTO Row SELECT NEWID(), (SELECT SectionId FROM Section WHERE Name = 'SEC19'), 
 1 ;
 INSERT INTO Row SELECT NEWID(), (SELECT SectionId FROM Section WHERE Name = 'SEC20'), 
 1 ;


 SELECT * FROM Row

--2-6. 25 Seats in each Row of Sections 1-15

 DECLARE @var5_1 INT = 1;
 DECLARE @var5_2 INT = 1;
 DECLARE @Seat_RowId UNIQUEIDENTIFIER;
  DECLARE @token INT = 1;

 WHILE @var5_1 <= 15
 BEGIN

--  WHILE @token <= 50
-- BEGIN
-- SET @Seat_RowId  = 
--(SELECT RowId FROM Row r WHERE r.SectionId = 
--(SELECT SectionId FROM Section WHERE Section.Name = 'SEC'+CAST(@var5_1 AS VARCHAR(2)))
--)
 
 WHILE @var5_2 <= 25
 BEGIN
 INSERT INTO Seat SELECT NEWID(),(SELECT RowId 
 FROM Section WHERE Section.Name = 'SEC'+CAST(@var5_1 AS VARCHAR(2))
 ), @var5_2, 29.88
 FROM Row
 JOIN Section ON Row.SectionId = Section.SectionId
 WHERE Section.Name = 'SEC'+CAST(@var5_1 AS VARCHAR(2))
 SET @var5_2 += 1
 END
 
 SET @var5_1 += 1
 
 SET @var5_2 = 1
 END


 

 --2-7. 10 Seats in each Row of Sections 16-18

 DECLARE @var6_1 INT = 1;
 DECLARE @var6_2 INT = 1;

 WHILE @var6_1 <= 3
 BEGIN
 WHILE @var6_2 <= 10
 BEGIN
 INSERT INTO Seat SELECT NEWID(),(SELECT RowId 
 FROM Section WHERE Section.Name = 'SEC'+CAST(@var6_1+15 AS VARCHAR(2))
 ), 
 @var6_2, 29.88
FROM Row
 JOIN Section ON Row.SectionId = Section.SectionId
 WHERE Section.Name = 'SEC'+CAST(@var6_1+15 AS VARCHAR(2))
 SET @var6_2 += 1
 END
 SET @var6_1 += 1
 SET @var6_2 = 1
 END
 
 --2-8. 50 Seats in each Row of Sections 19&20

 DECLARE @var7 INT = 1;

  WHILE @var7 <= 50
 BEGIN
 INSERT INTO Seat SELECT NEWID(),(SELECT RowId 
 FROM Section WHERE Section.Name = 'SEC19')
 , @var7, 29.88 
 FROM Row 
  JOIN Section ON Row.SectionId = Section.SectionId
 WHERE Section.Name = 'SEC19'

INSERT INTO Seat SELECT NEWID(),(SELECT RowId 
 FROM Section WHERE Section.Name = 'SEC20')
 ,@var7, 29.88 FROM Row
   JOIN Section ON Row.SectionId = Section.SectionId
 WHERE Section.Name = 'SEC20'
 
 SET @var7 += 1
 END
 

 SELECT * FROM Seat




-- 3.  Create the following additional test records:

--3-1. An Event called "Test Event" at the Test Venue on June 5th, 2022 from 5pm - 8pm. It is a Basketball Game.
 
 DECLARE @T_Event UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Basketball Game');

 INSERT INTO Event VALUES 
(NEWID(),  @T_Event, @T_Venue, 'Test Event', ' 2022-06-05 17 : 00 : 00.000 ' , ' 2022-06-05 20 : 00 : 00')


--3-2. Add all the Test Venue seats to the Test Event

INSERT INTO EventSeat 
	SELECT NEWID(), SeatId, (SELECT EventId FROM Event WHERE Name = 'Test Event'), 100.00
FROM Seat;





--3-3. Use a CURSOR and a CASE statement to add 1 Sale for each test customer, the Payment Type will check 
--     the value of the last payment type ['MC', 'AMEX', 'VISA', 'CASH'] and 'MC' will insert 'AMEX', 'AMEX' will insert 'VISA', 
--    'VISA' will insert 'CASH', and 'CASH' will insert 'MC'

INSERT INTO Sale 
	SELECT NEWID(), CustomerId, 'CASH' FROM Customer 

--SELECT * FROM Sale




DECLARE @PaymentType VARCHAR(10)
DECLARE @CustomerId   UNIQUEIDENTIFIER
DECLARE @SaleId  UNIQUEIDENTIFIER
DECLARE @default  VARCHAR(10)


DECLARE @getPT CURSOR
SET @getPT = CURSOR FOR 
    SELECT PaymentType, CustomerId ,SaleId 	FROM Sale

	OPEN @getPT 	
	FETCH NEXT FROM @getPT INTO @PaymentType, @CustomerId ,@SaleId

 --SET @default = 0
 SET @default = 'CASH'
	WHILE @@FETCH_STATUS = 0
		BEGIN
		SET @PaymentType  =
		CASE WHEN @default = 'CASH'
		     THEN  'MC'
			 WHEN @default= 'MC'
		     THEN  'AMEX'
			 WHEN @default = 'AMEX'
		     THEN  'VISA'
			 WHEN @default = 'VISA'
		     THEN  'CASH'
	     END
		 UPDATE Sale  SET PaymentType = @PaymentType
		     WHERE CURRENT OF @getPT
			 SET @default = @PaymentType
	     

		  --SET @default += 1
		  --IF @default > 4
		  --BEGIN
		  -- SET @default -=4
		  --END
		  --   UPDATE Sale  SET PaymentType  =
		  --CASE WHEN @default = 1  
		  --   THEN     'MC' 
			 -- WHEN @default = 2
		  --   THEN  'AMEX'
			 --WHEN @default = 3
		  --   THEN 'VISA'
			 --WHEN @default = 4
		  --   THEN 'CASH'
			 --ELSE 'CASH'
		  -- END
		--WHERE CURRENT OF @getPT

		   
		PRINT @paymentType
		  -- FROM Customer
			-- Get the next row
			FETCH NEXT
			FROM @getPT INTO @PaymentType,  @CustomerId ,@SaleId
		END
	-- Close cursor 
	CLOSE @getPT
	-- Deallocate cursor 
	DEALLOCATE @getPT
	





--4.  Add EventSeatSale records for the sales of the first 75 test customers

--4-1. If they are Test1 - Test24 give them 2 seats in SEC 1 in the Row matching their number and 
--     the first seat matching their number. ex: Test1 would get SEC1-Row 1-Seat 1 & 2, Test 24 would get
--     SEC1-Row 24-Seat 24 & 25


--DECLARE @counter INT = 1;
--DECLARE @Saled UNIQUEIDENTIFIER;

--WHILE @counter <= 75
--BEGIN
--SET @Saled = 
--(SELECT SaleId FROM Sale s WHERE s.CustomerId = (SELECT CustomerId FROM Customer WHERE FirstName = 'Test'+CAST(@counter AS VARCHAR(2))))
 

-- IF(@counter <= 24)
-- BEGIN


-- INSERT INTO EventSeatSale SELECT EventSeat.EventSeatId, @Saled,
----(SELECT SaleId FROM Sale INNER JOIN Customer ON Customer.CustomerId = Sale.CustomerId 
---- WHERE Customer.FirstName = 'Test'+CAST(@var8 AS VARCHAR(2))),
-- EventSeat.EventPrice + Seat.BasePrice - 128 , 1
--  FROM EventSeat
--    INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
--    INNER JOIN Row ON Seat.RowId = Row.RowId
--    INNER JOIN Section ON Row.SectionId = Section.SectionId	
--     WHERE Section.Name = 'SEC1' AND Row.RowNumber = @counter
--	       AND Seat.SeatNumber IN (@counter,@counter+1)

-- END

-- SET @counter += 1;
-- END


--  SELECT 
--  c.FirstName + ' ' + c.LastName jgjgjj, e.Name, sec.Name,r.RowNumber, STRING_AGG(Seat.SeatNumber, ',') 
--  FROM
--  Event e, EventSeat es, EventSeatSale ess, Sale s, Customer c, Seat, Row r, Section sec
--  WHERE
--  e.EventId = es.EventId AND es.EventSeatId = ess.EventSeatId AND ess.SaleId = s.SaleId AND
--  c.CustomerId=s.CustomerId AND Seat.SeatId = es.SeatId AND r.RowId = Seat.RowId AND sec.SectionId=r.SectionId
--  GROUP BY
--  s.SaleId, c.FirstName+' '+c.LastName, e.Name, sec.Name,r.RowNumber



DECLARE @temp INT = 1;
DECLARE @Saled UNIQUEIDENTIFIER;

--DECLARE @EventSeatId UNIQUEIDENTIFIER;

WHILE @temp <= 100
BEGIN
SET @Saled = 
(SELECT SaleId FROM Sale s WHERE s.CustomerId = (SELECT CustomerId FROM Customer WHERE FirstName = 'Test'+CAST(@temp AS VARCHAR(2))))
--SET @EventSeatId =  ( SELECT EventSeatId FROM EventSeat es
--  JOIN Seat s ON s.SeatId = es.SeatId
--  JOIN Row r ON r.RowId = s.RowId
--  JOIN Section sec ON sec.SectionId = r.SectionId
--  WHERE r.RowNumber = @temp AND sec.Name = 'SEC1' AND s.SeatNumber IN (@temp, @temp+1))


IF @temp <= 24
  BEGIN

INSERT INTO EventSeatSale SELECT EventSeat.EventSeatId,@Saled,
--(SELECT SaleId FROM Sale INNER JOIN Customer ON Customer.CustomerId = Sale.CustomerId 
-- WHERE Customer.FirstName = 'Test'+CAST(@temp AS VARCHAR(2))),
 128 , 1
  FROM EventSeat
    INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
    INNER JOIN Row ON Seat.RowId = Row.RowId
    INNER JOIN Section ON Row.SectionId = Section.SectionId	
     WHERE Section.Name = 'SEC1' AND Row.RowNumber = @temp
	       AND Seat.SeatNumber IN (@temp,@temp+1)
  SET @temp += 1	 
  END


 --4-2. Test25 - Test49 can each be given 1 Seat in SEC1 Row 25 (this should fill the row)


ELSE IF (24 < @temp AND @temp <= 49)
  BEGIN
INSERT INTO EventSeatSale SELECT EventSeat.EventSeatId,@Saled,
--(SELECT SaleId FROM Sale INNER JOIN Customer ON Customer.CustomerId = Sale.CustomerId 
-- WHERE Customer.FirstName = 'Test'+CAST(@temp AS VARCHAR(2))),
 EventSeat.EventPrice + Seat.BasePrice - 100, 1
  FROM EventSeat
    INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
    INNER JOIN Row ON Seat.RowId = Row.RowId
    INNER JOIN Section ON Row.SectionId = Section.SectionId	

     WHERE Section.Name = 'SEC1' AND Row.RowNumber = 25
	       AND Seat.SeatNumber = @temp-24

  --SET @temp += 1	 
  END


 --4-3. Test50 - Test75 can each be given 1 seat in SEC19

 
 
ELSE IF (49 < @temp AND @temp <= 75)
  BEGIN
INSERT INTO EventSeatSale SELECT EventSeat.EventSeatId,@Saled,
--(SELECT SaleId FROM Sale INNER JOIN Customer ON Customer.CustomerId = Sale.CustomerId 
-- WHERE Customer.FirstName = 'Test'+CAST(@temp AS VARCHAR(2))),
 EventSeat.EventPrice + Seat.BasePrice , 1
  FROM EventSeat
    INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
    INNER JOIN Row ON Seat.RowId = Row.RowId
    INNER JOIN Section ON Row.SectionId = Section.SectionId	

     WHERE Section.Name = 'SEC19' AND Row.RowNumber = 1
	       AND Seat.SeatNumber = @temp-49

  --SET @var10 += 1	 
  END



    --5.  Delete the Sales of any test customers that do not have associated EventSeatSale records.

  --ELSE IF (75 < @temp AND @temp <= 100)
  --BEGIN
  
  --DELETE FROM EventSeatSale  @Saled 	

  --END



SET @temp += 1	
  END



  SELECT * FROM Sale
SELECT * FROM EventSeatSale
  SELECT * FROM EventSeat



  SELECT 
  c.FirstName + ' ' + c.LastName, e.Name, sec.Name,r.RowNumber, STRING_AGG(Seat.SeatNumber, ',') Seats
  FROM
  Event e, EventSeat es, EventSeatSale ess, Sale s, Customer c, Seat, Row r, Section sec
  WHERE
  e.EventId = es.EventId AND es.EventSeatId = ess.EventSeatId AND ess.SaleId = s.SaleId AND
  c.CustomerId=s.CustomerId AND Seat.SeatId = es.SeatId AND r.RowId = Seat.RowId AND sec.SectionId=r.SectionId
  GROUP BY
  s.SaleId, c.FirstName+' '+c.LastName, e.Name, sec.Name,r.RowNumber



    --5.  Delete the Sales of any test customers that do not have associated EventSeatSale records.

 DECLARE @null_check INT = 1;

 WHILE @null_check <= 100
 BEGIN

 DELETE FROM Sale FROM Sale s
  INNER JOIN Customer c ON c.CustomerId = s.CustomerId 
  LEFT JOIN EventSeatSale ess ON ess.SaleId = s.SaleId
  LEFT JOIN EventSeat es ON ess.EventSeatId = es.EventSeatId
   WHERE (es.EventSeatId is NULL) AND c.FirstName = 'Test' + CAST(@null_check AS VARCHAR(2))
 

 SET @null_check += 1
 END


 
  SELECT * FROM Sale


  



  ---- Lab 4 -----
  --1. A scalar function called fnGetFullName
  DROP FUNCTION IF EXISTS fnGetFullName
  GO

  CREATE FUNCTION fnGetFullName(@FirstName VARCHAR(30), @LastName VARCHAR(30))
  RETURNS VARCHAR(50) AS
  BEGIN
  DECLARE @var VARCHAR(50);
  SET @var = @FirstName + ' ' + @LastName
  RETURN @var;
  END
  GO
  
  SELECT dbo.fnGetFullName(Customer.FirstName,Customer.LastName) FROM Customer

  
 


  -- 2. A table function called fnGetTicketLabels that takes a SaleId parameter
  DROP FUNCTION IF EXISTS  dbo.fnGetTicketLabels
  GO

 
  CREATE FUNCTION  dbo.fnGetTicketLabels (@SaleId UNIQUEIDENTIFIER)
  RETURNS TABLE AS
  RETURN
  ( SELECT Event.Name+ ': '+ Section.Name+ '- Row'+ CAST(Row.Rownumber AS VARCHAR(2))
           + '- Seat' + CAST(Seat.SeatNumber AS VARCHAR(2)) AS NEW
  FROM  Event, EventSeat
    INNER JOIN EventSeatSale ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
    INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
    INNER JOIN Row ON Seat.RowId = Row.RowId
    INNER JOIN Section ON Row.SectionId = Section.SectionId	
     WHERE
	       EventSeatSale.SaleId = @SaleId AND
	       Event.Name = 'Test Event' AND
	       Section.Name = 'SEC1' AND Row.RowNumber = 1
	       AND (Seat.SeatNumber= 1 OR Seat.SeatNumber= 2)
 )

  GO



  

 -- 3. A scalar function called fnGetBlock that takes a SaleId

   DROP FUNCTION IF EXISTS dbo.fnGetBlock
  GO

  CREATE FUNCTION dbo.fnGetBlock (@SaleId UNIQUEIDENTIFIER)
  RETURNS VARCHAR(50) AS
  BEGIN
  DECLARE @var VARCHAR(100);
    
  SET @var =
 
  (SELECT Event.Name+ ': '+ Section.Name+ '- Row'+ CAST(Row.Rownumber AS VARCHAR(2))
           + '- (' + STRING_AGG(Seat.SeatNumber, ',') + ')'      
  FROM Customer
  	INNER JOIN Sale ON Customer.CustomerId = Sale.CustomerId
	INNER JOIN EventSeatSale ON EventSeatSale.SaleId = Sale.SaleId
	INNER JOIN EventSeat ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
	INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
	INNER JOIN Event ON EventSeat.EventId = Event.EventId
	INNER JOIN Row ON Seat.RowId = Row.RowId
	INNER JOIN Section ON row.SectionId = Section.SectionId
	INNER JOIN EventType ON Event.EventTypeId = EventType.EventTypeId
     WHERE
	       EventSeatSale.SaleId = @SaleId AND
	       Event.Name = 'Test Event' AND
	       Section.Name = 'SEC1' AND Row.RowNumber = 1
	       AND (Seat.SeatNumber= 1 OR Seat.SeatNumber= 2 OR Seat.SeatNumber= 3 OR Seat.SeatNumber= 4)
	  GROUP BY
  Event.Name, Section.Name, Row.RowNumber
		   )
  RETURN @var;

  END
  GO
  




   DECLARE @SaleId2 UNIQUEIDENTIFIER = (SELECT TOP 1 SaleId FROM Sale s
   --WHERE s.CustomerId = (SELECT CustomerId FROM Customer WHERE FirstName = 'Test1')
   )
   
       DECLARE @SaleId UNIQUEIDENTIFIER = (SELECT SaleId FROM Sale s WHERE s.CustomerId = 
       (SELECT CustomerId FROM Customer WHERE FirstName = 'Test1'))
  
  SELECT * FROM dbo.fnGetTicketLabels(@SaleId)
  SELECT dbo.fnGetBlock(@SaleId) 


  

  --4. A stored procedure that displays the Venue Name, Event Name, Date, Start Time, 
  --   and the number of available seats of all up coming events.

  DROP PROC IF EXISTS EventInformation
GO
CREATE PROCEDURE EventInformation AS
   DELETE FROM Event WHERE EventDate < GETDATE();
   SELECT
   Venue.Name, Event.Name , Event.EventDate, Event.StartTime, 
   SUM(CASE WHEN eventseatSale.EventSeatId is Null THEN 1 ELSE 0 END) [Available Seats]
   FROM
   Venue, Event
   INNER JOIN EventSeat ON EventSeat.EventId = Event.eventId
   INNER JOIN Seat ON Seat.SeatId = EventSeat.SeatId
   INNER JOIN Row ON Seat.RowId = Row.RowId
   INNER JOIN Section ON Row.SectionId = Section.SectionId
   LEFT JOIN EventSeatSale ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
   WHERE EventSeatSale.EventSeatId IS NULL
   GROUP BY
   Venue.Name, Event.Name, Event.EventDate, Event.StartTime
GO


EXECUTE EventInformation



-- 5.   A stored procedure that takes an event id as a parameter and displays two results:
--       a. purchased tickets (CustomerId, TicketBlock)
--       b. available tickets (Section, Row, Seat Count)


 

DROP PROC IF EXISTS ticketInformation
GO

CREATE PROCEDURE ticketInformation (@EventId UNIQUEIDENTIFIER) AS 
 
	 SELECT 
  c.FirstName + ' ' + c.LastName, STRING_AGG(Seat.SeatNumber, ',') Seats
  FROM
  Event e, EventSeat es, EventSeatSale ess, Sale s, Customer c, Seat, Row r, Section sec
  WHERE
  e.EventId = es.EventId AND es.EventSeatId = ess.EventSeatId AND ess.SaleId = s.SaleId AND
  c.CustomerId=s.CustomerId AND Seat.SeatId = es.SeatId AND r.RowId = Seat.RowId AND sec.SectionId=r.SectionId
  GROUP BY
  s.SaleId, c.FirstName+' '+c.LastName



	SELECT 
	Section.Name Section, Row.RowNumber Row, COUNT(DISTINCT Seat.SeatNumber) [Number of Seats]
	FROM Customer
	INNER JOIN Sale ON Customer.CustomerId = Sale.CustomerId
	INNER JOIN EventSeatSale ON EventSeatSale.SaleId = Sale.SaleId
	INNER JOIN EventSeat ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
	INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
	INNER JOIN Event ON EventSeat.EventId = Event.EventId
	INNER JOIN Row ON Seat.RowId = Row.RowId
	INNER JOIN Section ON row.SectionId = Section.SectionId
	INNER JOIN EventType ON Event.EventTypeId = EventType.EventTypeId
	GROUP BY
	Section.Name, Row.RowNumber

GO

DECLARE @EventId UNIQUEIDENTIFIER = (SELECT EventId FROM Event WHERE Event.Name = 'Test Event')
EXEC ticketInformation @EventId;

--DELETE EventSeatSale SELECT EventSeat.EventSeatId, 
--(SELECT SaleId FROM Sale 
-- INNER JOIN Customer ON Sale.CustomerId = Customer.CustomerId 
--  WHERE Customer.FirstName = 'Steve' AND Customer.LastName = 'Rogers'),
-- (EventSeat.EventPrice + Seat.BasePrice), 1
-- FROM EventSeat
-- INNER JOIN Seat ON Seat.SeatId = EventSeat.SeatId
-- INNER JOIN Row ON Row.RowId = Seat.RowId
-- INNER JOIN Section ON Section.SectionId = Row.SectionId
-- WHERE section.name = 'lowerbowl_01'
--       AND row.RowNumber = '02' 
--       AND (Seat.SeatNumber = '01' OR Seat.SeatNumber = '02' OR Seat.SeatNumber = '03' OR Seat.SeatNumber = '04')


 

 

