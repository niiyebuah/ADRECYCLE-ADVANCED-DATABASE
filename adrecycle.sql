USE master
GO

IF EXISTS (
	SELECT name
FROM sys.databases
WHERE name = N'adrecycle'
)
BEGIN
	DROP DATABASE adrecycle;
END
GO

IF EXISTS (
	SELECT name
FROM sys.databases
WHERE name = N'adrecycle_backup'
)
BEGIN
	DROP DATABASE adrecycle_backup;
END
GO

CREATE DATABASE adrecycle;
GO

USE adrecycle;
GO


--Table for Customer
CREATE TABLE [Customer](
    customerID int primary key IDENTITY,
    customername varchar(25) not null,
    customeraddress varchar(25) not null,
    phone INT not null,
    collectionPreferences varchar(50) not null,
    paymentPreferences varchar(25) not null
);


-- Tabe for plastic waste
CREATE TABLE plasticwaste(
    wasteid int primary key IDENTITY,
    plasticType varchar(50) not null,
    volume float,
    source varchar(50),
    collectionDate date
);


--Table for Driver
CREATE TABLE Driver(
    driverId int primary key IDENTITY,
    drivername varchar(25) not null,
    driveraddress varchar(25) not null,
    phone int not null,
    licenseNumber varchar(20) not null,
    truckType varchar(50)
);


--Table for waste collection
CREATE TABLE wastecollection(
    collectionID int primary key IDENTITY,
    driverID int foreign key references Driver(driverID),
    wasteID int foreign key references plasticWaste(wasteID),
    collectionDate date,
    collectionTime time,
    collectionLocation varchar(50)
);


--Table for facility
CREATE TABLE facility(
facilityID int primary key IDENTITY,
facilityname varchar(25) not null,
facilityaddress varchar (25) not null,
contactPerson varchar(25) not null,
phonenumber int not null
);

--Table for Recycled plastic
CREATE TABLE recycledplastic(
plasticID int primary key IDENTITY,
facilityID int foreign key references facility(facilityID),
customerID int foreign key references Customer(customerID),
plasticType varchar(25) not null,
composition varchar(25) not null,
quality varchar(25) not null,
potentialApplications varchar(25) not null
);

--Table for transportation route
CREATE TABLE transportationroute(
    driverID int foreign key references Driver(driverID),
    facilityID int foreign key references facility(facilityID),
    plasticID int foreign key references recycledplastic(plasticID),
    startlocation varchar(25) not null,
    endlocation varchar(25) not null,
    distance float not null,
    timetaken time
);



-- Table for Recycling facility
CREATE TABLE RecyclingFacility (
    facilityID int foreign key references facility(facilityID),
    recyclingLimit int,
    facilityLocation varchar(50)
);



--Table for Sorting facility
CREATE TABLE SortingFacility (
    facilityID int references facility(facilityID),
    sortingMechanisms varchar(50),
    sortingRate decimal(10,2)
);


--Table for collection schedule 
CREATE TABLE CollectionSchedule (
    scheduleID int primary key IDENTITY,
    customerID int references Customer(customerID),
    wasteID int references PlasticWaste(wasteID),
    collectionDayOfWeek varchar(255),
    collectionTimeOfDay time
);



--Table for sorting request
CREATE TABLE SortingRequest (
    requestID int primary key IDENTITY,
    customerID int references Customer(customerID),
    wasteID int references PlasticWaste(wasteID),
    requestDate date,
    requestStatus varchar(25)
);



--Table for sorting result
CREATE TABLE SortingResult (
    resultID int primary key IDENTITY,
    requestID int references SortingRequest(requestID),
    facilityID int references facility(facilityID),
    sortedWasteType varchar(255),
    sortedWasteVolume decimal(10,2)
);



--Table for Recycling process
CREATE TABLE RecyclingProcess (
    processID int primary key IDENTITY,
    facilityID int references facility(facilityID),
    wasteID int references PlasticWaste(wasteID),
    plasticID int references RecycledPlastic(plasticID),
    processDate date,
    processStatus varchar(25)
);



--Table for plastic usage
CREATE TABLE PlasticUsage (
    customerID int references Customer(customerID),
    plasticID int references RecycledPlastic(plasticID),
    usageDate date,
    usageVolume decimal(10,2)
);



-- Table for Maintenance Schedule
CREATE TABLE MaintenanceSchedule (
    facilityID int references facility(facilityID),
    maintenanceDate date,
    maintenanceDescription varchar(255)
);



-- Indexes
--Index 1: on plasticwaste table for the wasteID column

CREATE INDEX idx_wasteid
ON plasticwaste (wasteid);
GO


--Index 2: on waste collection table for the wasteID column

CREATE INDEX idx_wastecollection_wasteID
ON wastecollection (wasteID);
GO


--Index 3: on recycled plastic table for the facilityID column
CREATE INDEX idx_recycledplastic_facilityID
ON recycledplastic (facilityID);
GO


--Index 4: on transportation table for the driverID and facilityID columsn
CREATE INDEX idx_transportationroute_driver_facility
ON transportationroute (driverID, facilityID);
GO


-- CREATING BACKUP FOR ADRECYCLE
CREATE DATABASE adrecycle_backup;
GO

USE adrecycle_backup;
GO

--Backup Table for Customer
CREATE TABLE Customer(
    customerID int,
    customername varchar(25),
    customeraddress varchar(25),
    phone int,
    collectionPreferences varchar(50),
    paymentPreferences varchar(25)
);


-- Backup Table for plastic waste
CREATE TABLE plasticwaste(
    wasteid int,
    plasticType varchar(50),
    volume float,
    source varchar(50),
    collectionDate date
);


--Backup Table for Driver
CREATE TABLE Driver(
    driverId int,
    drivername varchar(25),
    driveraddress varchar(25),
    phone int,
    licenseNumber varchar(20),
    truckType varchar(50)
);


--Backup Table for waste collection
CREATE TABLE wastecollection(
    collectionID int,
    driverID int,
    wasteID int,
    collectionDate date,
    collectionTime time,
    collectionLocation varchar(50)
);



--Backup Table for transportation route
CREATE TABLE transportationroute(
    driverID int,
    facilityID int,
    plasticID int,
    startlocation varchar(25),
    endlocation varchar(25),
    distance float,
    timetaken time
);


--Backup Table for Recycling facility
CREATE TABLE facility(
facilityID int,
facilityname varchar(25),
facilityaddress varchar (25),
contactPerson varchar(25),
phonenumber int
);

-- Backup Table for Recycling facility
CREATE TABLE RecyclingFacility (
    facilityID int,
    recyclingLimit int,
    facilityLocation varchar(50)
);



--Backup Table for Sorting facility
CREATE TABLE SortingFacility (
    facilityID int,
    sortingMechanisms varchar(50),
    sortingRate decimal(10,2)
);


--Backup Table for Recycled plastic
CREATE TABLE recycledplastic(
plasticID int,
facilityID int,
customerID int,
plasticType varchar(25),
composition varchar(25),
quality varchar(25),
potentialApplications varchar(25)
);


--Backup Table for collection schedule 
CREATE TABLE CollectionSchedule (
    scheduleID int,
    customerID int,
    wasteID int,
    collectionDayOfWeek varchar(255),
    collectionTimeOfDay time
);



--Backup Table for sorting request
CREATE TABLE SortingRequest (
    requestID int ,
    customerID int,
    wasteid int,
    requestDate date,
    requestStatus varchar(25)
);



--Table for sorting result
CREATE TABLE SortingResult (
    resultID int,
    requestID int,
    facilityID int,
    sortedWasteType varchar(255),
    sortedWasteVolume decimal(10,2)
);



--Backup Table for Recycling process
CREATE TABLE RecyclingProcess (
    processID int,
    facilityID int,
    wasteID int,
    plasticID int,
    processDate date,
    processStatus varchar(25)
);



--Table for plastic usage
CREATE TABLE PlasticUsage (
    customerID int,
    plasticID int,
    usageDate date,
    usageVolume decimal(10,2)
);



-- Table for Maintenance Schedule
CREATE TABLE MaintenanceSchedule (
    facilityID int,
    maintenanceDate date,
    maintenanceDescription varchar(255)
);


USE adrecycle;
GO


--CREATING VIEWS

-- View for customers and their collection preferences
CREATE VIEW CustomerCollectionPreference AS
SELECT customerID, customername, collectionPreferences
FROM Customer;
GO

-- View for drivers and their truck type
CREATE VIEW DriverTruckType AS
SELECT driverID, drivername, truckType
FROM Driver;
GO

-- View for plastic waste source and collection date.
CREATE VIEW WasteSourceCollectionDate AS
SELECT wasteid, source, collectionDate
FROM plasticwaste;
GO

--View for recycling facility conntact innformation.
CREATE VIEW FacilityContact AS
SELECT facilityname, facilityaddress, contactPerson, phonenumber
FROM facility;
GO

USE adrecycle;
GO

-- email procedure
CREATE PROCEDURE SendEmailAlert
    @subject NVARCHAR(255),
    @body NVARCHAR(MAX)
AS
BEGIN
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'Aaron',
        @recipients = 'sampahd@gmail.com',
        @subject = @subject,
        @body = @body;
END;
GO


-- trigger
CREATE TRIGGER trg_Insert_Customer
ON Customer
AFTER INSERT
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Customer
        SELECT * FROM inserted;
END;
GO

CREATE TRIGGER trg_Update_Customer
ON Customer
AFTER UPDATE
AS
BEGIN
    -- Log the updated records in the backup table
    INSERT INTO adrecycle_backup.dbo.Customer
        SELECT * FROM inserted;

    -- Send an email alert for the update action
    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'Customer table updated';
    SET @body = 'The Customer table has been updated. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

UPDATE [Customer] SET customername = 'Aaron' WHERE customerID = 1;
GO

CREATE TRIGGER trg_Delete_Customer
ON Customer
AFTER DELETE
AS
BEGIN
    -- Log the deleted records in the backup table
    INSERT INTO adrecycle_backup.dbo.Customer
        SELECT * FROM deleted;

    -- Send an email alert for the delete action
    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'Customer table record deleted';
    SET @body = 'A record has been deleted from the Customer table. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO
DELETE FROM  [Customer]  WHERE customerID = 2;
GO


-- INSERT trigger
CREATE TRIGGER trg_Insert_Driver
ON Driver
AFTER INSERT
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Driver
        SELECT * FROM inserted;
END;
GO

-- UPDATE trigger
CREATE TRIGGER trg_Update_Driver
ON Driver
AFTER UPDATE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Driver
        SELECT * FROM inserted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'Driver table updated';
    SET @body = 'The Driver table has been updated. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

UPDATE [Driver] SET drivername = 'Aaron' WHERE driverID = 1;
GO


-- DELETE trigger
CREATE TRIGGER trg_Delete_Driver
ON Driver
AFTER DELETE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Driver
        SELECT * FROM deleted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'Driver table record deleted';
    SET @body = 'A record has been deleted from the Driver table. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO
DELETE FROM [Driver] WHERE driverID = 4;
GO


-- INSERT trigger
CREATE TRIGGER trg_Insert_PlasticWaste
ON PlasticWaste
AFTER INSERT
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.PlasticWaste
        SELECT * FROM inserted;
END;
GO

-- UPDATE trigger
CREATE TRIGGER trg_Update_PlasticWaste
ON PlasticWaste
AFTER UPDATE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.PlasticWaste
        SELECT * FROM inserted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'PlasticWaste table updated';
    SET @body = 'The PlasticWaste table has been updated. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

UPDATE [plasticwaste] SET plasticType = 'Disposable' WHERE wasteid = 1;
GO


-- DELETE trigger
CREATE TRIGGER trg_Delete_PlasticWaste
ON PlasticWaste
AFTER DELETE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.PlasticWaste
        SELECT * FROM deleted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'PlasticWaste table record deleted';
    SET @body = 'A record has been deleted from the PlasticWaste table. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

DELETE FROM  [plasticwaste] WHERE wasteid = 4;
GO


-- INSERT trigger
CREATE TRIGGER trg_Insert_WasteCollection
ON WasteCollection
AFTER INSERT
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.WasteCollection
        SELECT * FROM inserted;
END;
GO

-- UPDATE trigger
CREATE TRIGGER trg_Update_WasteCollection
ON WasteCollection
AFTER UPDATE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.WasteCollection
        SELECT * FROM inserted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'WasteCollection table updated';
    SET @body = 'The WasteCollection table has been updated. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

UPDATE [wastecollection] SET collectionLocation = 'Adenta' WHERE collectionID = 2;
GO



CREATE TRIGGER trg_Delete_WasteCollection
ON WasteCollection
AFTER DELETE
AS
BEGIN
        INSERT INTO adrecycle_backup.dbo.WasteCollection
            SELECT * FROM deleted;

        DECLARE @subject NVARCHAR(255);
        DECLARE @body NVARCHAR(MAX);

        SET @subject = 'WasteCollection table record deleted';
        SET @body = 'A record has been deleted from the WasteCollection table. Please review the changes.';

        EXEC SendEmailAlert @subject, @body;
END;
GO

DELETE FROM [wastecollection] WHERE collectionID = 5;
GO



-- INSERT trigger
CREATE TRIGGER trg_Insert_Facility
ON Facility
AFTER INSERT
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Facility
        SELECT * FROM inserted;
END;
GO

-- UPDATE trigger
CREATE TRIGGER trg_Update_Facility
ON Facility
AFTER UPDATE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Facility
        SELECT * FROM inserted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'Facility table updated';
    SET @body = 'The Facility table has been updated. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

UPDATE [facility] SET facilityname = 'Adenta Recycling Plant' WHERE facilityID = 2;

GO
-- DELETE trigger
CREATE TRIGGER trg_Delete_Facility
ON Facility
AFTER DELETE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.Facility
        SELECT * FROM deleted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'Facility table record deleted';
    SET @body = 'A record has been deleted from the Facility table. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

DELETE FROM [facility] WHERE facilityID = 3;
GO


-- INSERT trigger
CREATE TRIGGER trg_Insert_RecycledPlastic
ON RecycledPlastic
AFTER INSERT
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.RecycledPlastic
        SELECT * FROM inserted;
END;
GO

-- UPDATE trigger
CREATE TRIGGER trg_Update_RecycledPlastic
ON RecycledPlastic
AFTER UPDATE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.RecycledPlastic
        SELECT * FROM inserted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'RecycledPlastic table updated';
    SET @body = 'The RecycledPlastic table has been updated. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

UPDATE [recycledplastic] SET composition = 'Biodegradable' WHERE plasticID = 6;
GO


-- DELETE trigger
CREATE TRIGGER trg_Delete_RecycledPlastic
ON RecycledPlastic
AFTER DELETE
AS
BEGIN
    INSERT INTO adrecycle_backup.dbo.RecycledPlastic
        SELECT * FROM deleted;

    DECLARE @subject NVARCHAR(255);
    DECLARE @body NVARCHAR(MAX);

    SET @subject = 'RecycledPlastic table record deleted';
    SET @body = 'A record has been deleted from the RecycledPlastic table. Please review the changes.';

    EXEC SendEmailAlert @subject, @body;
END;
GO

DELETE FROM  [recycledplastic] WHERE plasticID = 1;
GO


CREATE PROCEDURE sp_Insert_Customer
    @customername VARCHAR(25),
    @customeraddress VARCHAR(25),
    @phone INT,
    @collectionPreferences VARCHAR(50),
    @paymentPreferences VARCHAR(25),
	@output_customerID INT OUTPUT
AS
BEGIN
    INSERT INTO Customer(customername, customeraddress, phone, collectionPreferences, paymentPreferences)
    VALUES (@customername, @customeraddress, @phone, @collectionPreferences, @paymentPreferences);

	SET @output_customerID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_PlasticWaste
    @plasticType VARCHAR(50),
    @volume FLOAT,
    @source VARCHAR(50),
    @collectionDate DATE,
	@output_wasteid INT OUTPUT
AS
BEGIN
    INSERT INTO plasticwaste(plasticType, volume, source, collectionDate)
    VALUES (@plasticType, @volume, @source, @collectionDate);

	SET @output_wasteid = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_Driver
    @drivername VARCHAR(25),
    @driveraddress VARCHAR(25),
    @phone INT,
    @licenseNumber VARCHAR(20),
    @truckType VARCHAR(50),
	@output_driverId INT OUTPUT
AS
BEGIN
    INSERT INTO Driver(drivername, driveraddress, phone, licenseNumber, truckType)
    VALUES (@drivername, @driveraddress, @phone, @licenseNumber, @truckType);

	SET @output_driverId = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_WasteCollection
    @driverID INT,
    @wasteID INT,
    @collectionDate DATE,
    @collectionTime TIME,
    @collectionLocation VARCHAR(50),
	@output_collectionID INT OUTPUT
AS
BEGIN
    INSERT INTO wastecollection(driverID, wasteID, collectionDate, collectionTime, collectionLocation)
    VALUES (@driverID, @wasteID, @collectionDate, @collectionTime, @collectionLocation);

	SET @output_collectionID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_Facility
    @facilityname VARCHAR(25),
    @facilityaddress VARCHAR (25),
    @contactPerson VARCHAR(25),
    @phonenumber INT,
	@output_facilityID INT OUTPUT
AS
BEGIN
    INSERT INTO facility(facilityname, facilityaddress, contactPerson, phonenumber)
    VALUES (@facilityname, @facilityaddress, @contactPerson, @phonenumber);

	SET @output_facilityID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_RecycledPlastic
    @facilityID INT,
    @customerID INT,
    @plasticType VARCHAR(25),
    @composition VARCHAR(25),
    @quality VARCHAR(25),
    @potentialApplications VARCHAR(25),
	@output_plasticID INT OUTPUT
AS
BEGIN
    INSERT INTO recycledplastic(facilityID, customerID, plasticType, composition, quality, potentialApplications)
    VALUES (@facilityID, @customerID, @plasticType, @composition, @quality, @potentialApplications);

	SET @output_plasticID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_TransportationRoute
    @driverID INT,
    @facilityID INT,
    @plasticID INT,
    @startlocation VARCHAR(25),
    @endlocation VARCHAR(25),
    @distance FLOAT,
    @timetaken TIME
AS
BEGIN
    INSERT INTO transportationroute(driverID, facilityID, plasticID, startlocation, endlocation, distance, timetaken)
    VALUES (@driverID, @facilityID, @plasticID, @startlocation, @endlocation, @distance, @timetaken)
END;
GO


CREATE PROCEDURE sp_Insert_RecyclingFacility
    @facilityID INT,
    @recyclingLimit INT,
    @facilityLocation VARCHAR(50)
AS
BEGIN
    INSERT INTO RecyclingFacility(facilityID, recyclingLimit, facilityLocation)
    VALUES (@facilityID, @recyclingLimit, @facilityLocation);
END;
GO


CREATE PROCEDURE sp_Insert_SortingFacility
    @facilityID INT,
    @sortingMechanisms VARCHAR(50),
    @sortingRate DECIMAL(10,2)
AS
BEGIN
    INSERT INTO SortingFacility(facilityID, sortingMechanisms, sortingRate)
    VALUES (@facilityID, @sortingMechanisms, @sortingRate);
END;
GO


CREATE PROCEDURE sp_Insert_CollectionSchedule
    @customerID INT,
    @wasteID INT,
    @collectionDayOfWeek VARCHAR(255),
    @collectionTimeOfDay TIME,
	@output_scheduleID INT OUTPUT
AS
BEGIN
    INSERT INTO CollectionSchedule(customerID, wasteID, collectionDayOfWeek, collectionTimeOfDay)
    VALUES (@customerID, @wasteID, @collectionDayOfWeek, @collectionTimeOfDay);

	SET @output_scheduleID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_SortingRequest
    @customerID INT,
    @wasteID INT,
    @requestDate DATE,
    @requestStatus VARCHAR(25),
	@output_requestID INT OUTPUT
AS
BEGIN
    INSERT INTO SortingRequest(customerID, wasteID, requestDate, requestStatus)
    VALUES (@customerID, @wasteID, @requestDate, @requestStatus);

	SET @output_requestID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_SortingResult
    @requestID INT,
    @facilityID INT,
    @sortedWasteType VARCHAR(255),
    @sortedWasteVolume DECIMAL(10,2),
	@output_resultID INT OUTPUT
AS
BEGIN
    INSERT INTO SortingResult(requestID, facilityID, sortedWasteType, sortedWasteVolume)
    VALUES (@requestID, @facilityID, @sortedWasteType, @sortedWasteVolume);

	SET @output_resultID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_RecyclingProcess
    @facilityID INT,
    @wasteID INT,
    @plasticID INT,
    @processDate DATE,
    @processStatus VARCHAR(25),
	@output_processID INT OUTPUT
AS
BEGIN
    INSERT INTO RecyclingProcess(facilityID, wasteID, plasticID, processDate, processStatus)
    VALUES (@facilityID, @wasteID, @plasticID, @processDate, @processStatus);

	SET @output_processID = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_Insert_PlasticUsage
    @customerID INT,
    @plasticID INT,
    @usageDate DATE,
    @usageVolume DECIMAL(10,2)
AS
BEGIN
    INSERT INTO PlasticUsage(customerID, plasticID, usageDate, usageVolume)
    VALUES (@customerID, @plasticID, @usageDate, @usageVolume);
END;
GO


CREATE PROCEDURE sp_Insert_MaintenanceSchedule
    @facilityID INT,
    @maintenanceDate DATE,
    @maintenanceDescription VARCHAR(255)
AS
BEGIN
	INSERT INTO MaintenanceSchedule(facilityID,maintenanceDate, maintenanceDescription)
	VALUES (@facilityID,@maintenanceDate, @maintenanceDescription)
END;
GO



--DATA POPULATION
DECLARE @CustomerID1 int;
DECLARE @CustomerID2 int;
DECLARE @CustomerID3 int;
DECLARE @CustomerID4 int;
DECLARE @CustomerID5 int;

-- Populate Customer
EXEC sp_Insert_Customer 'John Mensah', '123 Main St', 5551234, 'weekly', 'credit card', @output_customerID = @CustomerID1 OUTPUT;
EXEC sp_Insert_Customer 'Jane Smith', '456 Oak St', 5555678, 'biweekly', 'cash', @output_customerID = @CustomerID2 OUTPUT;
EXEC sp_Insert_Customer 'Bob Johnson', '789 Maple Ave', 5559012, 'monthly', 'debit card', @output_customerID = @CustomerID3 OUTPUT;
EXEC sp_Insert_Customer 'Sara Lee', '111 Cherry Ln', 5553456, 'on demand', 'check', @output_customerID = @CustomerID4 OUTPUT;
EXEC sp_Insert_Customer 'David Kim', '222 Pine Rd', 5557890, 'weekly', 'credit card', @output_customerID = @CustomerID5 OUTPUT;

DECLARE @DriverID1 int;
DECLARE @DriverID2 int;
DECLARE @DriverID3 int;
DECLARE @DriverID4 int;
DECLARE @DriverID5 int;

EXEC sp_Insert_Driver 'John Rawlings', '321 Elm St', 5552468, '123456', 'pickup', @output_driverId = @DriverID1 OUTPUT;
EXEC sp_Insert_Driver 'Jane Johnson', '654 Cedar Ave', 5551357, '654321', 'dump truck', @output_driverId = @DriverID2 OUTPUT;
EXEC sp_Insert_Driver 'Bob Lee', '987 Birch Blvd', 5559753, '789123', 'garbage truck', @output_driverId =@DriverID3 OUTPUT;
EXEC sp_Insert_Driver 'Sara Taylor', '555 Oak Ave', 5554567, '456789', 'pickup', @output_driverId = @DriverID4 OUTPUT;
EXEC sp_Insert_Driver 'David Lee', '777 Pine St', 5558642, '987654', 'garbage truck', @output_driverId = @DriverID5 OUTPUT;

DECLARE @wasteID1 INT;
DECLARE @wasteID2 INT;
DECLARE @wasteID3 INT;
DECLARE @wasteID4 INT;
DECLARE @wasteID5 INT;

EXEC sp_Insert_PlasticWaste 'PET', 10.5, 'residential', '2023-04-26', @output_wasteid = @wasteID1 OUTPUT;
EXEC sp_Insert_PlasticWaste 'PET', 10.5, 'residential', '2023-04-26', @output_wasteid = @wasteID2 OUTPUT;
EXEC sp_Insert_PlasticWaste 'PET', 10.5, 'residential', '2023-04-26', @output_wasteid = @wasteID3 OUTPUT;
EXEC sp_Insert_PlasticWaste 'PET', 10.5, 'residential', '2023-04-26', @output_wasteid = @wasteID4 OUTPUT;
EXEC sp_Insert_PlasticWaste 'PET', 10.5, 'residential', '2023-04-26', @output_wasteid = @wasteID5 OUTPUT;
GO

CREATE PROCEDURE [dbo].[getPlasticWasteDetails]
AS
BEGIN
    SELECT plasticType, volume, source, collectionDate
    FROM plasticWaste
    ORDER BY collectionDate DESC;
END;
GO


CREATE PROCEDURE [dbo].[getTransportationRoutes]
AS
BEGIN
    SELECT d.drivername, f.facilityname, tr.startlocation, tr.endlocation, tr.distance, tr.timetaken
    FROM Driver d
    INNER JOIN transportationroute tr ON d.driverID = tr.driverID
    INNER JOIN facility f ON f.facilityID = tr.facilityID
    ORDER BY tr.startlocation ASC;
END


CREATE PROCEDURE [dbo].[getRecyclingFacilityDetails]
AS
BEGIN
    SELECT f.facilityname, SUM(rp.volume) as totalVolume
    FROM facility f
    INNER JOIN recycledplastic rp ON f.facilityID = rp.facilityID
    GROUP BY f.facilityname
    ORDER BY totalVolume DESC;
END;
GO


CREATE PROCEDURE [dbo].[getMaintenanceSchedule]
AS
BEGIN
    SELECT facilityname, maintenanceDate, maintenanceDescription
    FROM MaintenanceSchedule ms
    INNER JOIN facility f ON f.facilityID = ms.facilityID
    ORDER BY maintenanceDate ASC;
END;
GO


CREATE PROCEDURE [dbo].[getCustomerDetails]
AS
BEGIN
    SELECT customername, customeraddress, phone, collectionPreferences, paymentPreferences
    FROM Customer
    ORDER BY customername ASC;
END;
GO


CREATE PROCEDURE [dbo].[getRecycledPlasticDetails]
AS
BEGIN
    SELECT plasticType, composition, quality, potentialApplications
    FROM recycledplastic
    ORDER BY plasticType ASC;
END;
GO