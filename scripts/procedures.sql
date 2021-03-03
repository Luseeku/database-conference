
CREATE PROCEDURE CreateConferenceSeries
    @Name VARCHAR(255),
    @Id VARCHAR(255) OUTPUT
AS
BEGIN
SELECT @Id = NEWID()
INSERT INTO series (id, name) VALUES (@Id, @Name);
END;
GO
CREATE PROCEDURE CreateLocation
    @Address VARCHAR(255),
    @SpecificLocation VARCHAR(255),
    @MaxSlots INT,
    @PricePerDay MONEY,
    @Id VARCHAR(255) OUTPUT
AS
BEGIN
SELECT @Id = NEWID()
INSERT INTO location (id, address, specific_location, max_slots, price_per_day)
VALUES (@Id, @Address, @SpecificLocation, @MaxSlots, @PricePerDay);
END;
GO
CREATE PROCEDURE CreateConference
    @Date DATE,
    @SeriesId VARCHAR(255) = NULL,
    @Name VARCHAR(255),
    @LocationId VARCHAR(255),
    @Slots INT,
    @Price MONEY,
    @StudentDiscount MONEY = 0,
    @ConferenceId VARCHAR(255) OUTPUT
AS
BEGIN
SELECT @ConferenceId = NEWID();
INSERT INTO conference (id, series_id, name, location_id, slots, student_discount)
VALUES (@ConferenceId, @SeriesId, @Name, @LocationId, @Slots, @StudentDiscount);
INSERT INTO price_threshold (id, days_before, price, conference_id)
VALUES (NEWID(), DATEDIFF(day, GETDATE(), @Date), @Price, @ConferenceId);
INSERT INTO conference_date (id, date, conference_id)
VALUES (NEWID(), @Date, @ConferenceId);
END;
GO
CREATE PROCEDURE CancelConference
    @ConferenceId VARCHAR(255),
    @Reason VARCHAR(255)
AS
BEGIN
UPDATE conference SET cancel_reason = @Reason WHERE id = @ConferenceId;
UPDATE booking SET cancel_reason = @Reason WHERE conference_id = @ConferenceId;
UPDATE conference_date SET cancel_reason = @Reason WHERE conference_id = @ConferenceId;
END;
GO
CREATE PROCEDURE AddConferenceDate
    @ConferenceId VARCHAR(255),
    @Date DATE
AS
BEGIN
INSERT INTO conference_date (id, date, conference_id)
VALUES (NEWID(), @Date, @ConferenceId);
END;
GO
CREATE PROCEDURE CancelConferenceDate
    @ConferenceId VARCHAR(255),
    @Date DATE,
    @Reason VARCHAR(255)
AS
BEGIN
UPDATE conference_date SET cancel_reason = @Reason WHERE conference_id = @ConferenceId AND date = @Date;
END;
GO
CREATE PROCEDURE SetSeriesName
    @SeriesId VARCHAR(255),
    @NewName VARCHAR(255)
AS
BEGIN
UPDATE series SET name = @NewName WHERE id = @SeriesId;
END;
GO
CREATE PROCEDURE AddPriceThreshold
    @DaysBefore INT,
    @Price MONEY,
    @ConferenceId VARCHAR(255),
    @DiscountCode VARCHAR(255) = NULL
AS
BEGIN
INSERT INTO price_threshold (id, days_before, price, conference_id, discount_code)
VALUES (NEWID(), @DaysBefore, @Price, @ConferenceId, @DiscountCode);
END;
GO
CREATE PROCEDURE CreateConferenceInternalEvent
    @ConferenceId VARCHAR(255),
    @Price MONEY,
    @Date DATETIME,
    @MaxSlots INTEGER
AS
BEGIN
INSERT INTO internal_event (id, conference_id, price, date, max_slots)
VALUES (NEWID(), @ConferenceId, @Price, @Date, @MaxSlots);
END;
GO
CREATE PROCEDURE CreateCompany
    @Name VARCHAR(255),
    @PhoneNumber VARCHAR(255),
    @Id VARCHAR(255) OUTPUT
AS
BEGIN
SELECT @Id = NEWID();
INSERT INTO company (id, name, phone_number)
VALUES (@Id, @Name, @PhoneNumber);
END;
GO
CREATE PROCEDURE AddCompanyAttribute
    @CompanyId VARCHAR(255),
    @AttributeName VARCHAR(255),
    @AttributeValue VARCHAR(255)
AS
BEGIN
INSERT INTO company_attributes (id, company_id, name, value)
VALUES (NEWID(), @CompanyId, @AttributeName, @AttributeValue);
END;
GO
CREATE PROCEDURE AddCompanyEmployee
    @CompanyId VARCHAR(255),
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @StudentIdNumber VARCHAR(255) = NULL,
    @Id VARCHAR(255) OUTPUT
AS
BEGIN
SELECT @Id = NEWID();
INSERT INTO person (id, company_id, first_name, last_name, student_id_number)
VALUES (@Id, @CompanyId, @FirstName, @LastName, @StudentIdNumber);
END;
GO
CREATE PROCEDURE CreatePerson
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @StudentIdNumber VARCHAR(255) = NULL,
    @Id VARCHAR(255) OUTPUT
AS
BEGIN
SELECT @Id = NEWID();
INSERT INTO person (id, first_name, last_name, student_id_number)
VALUES (@Id, @FirstName, @LastName, @StudentIdNumber);
END;
GO
CREATE PROCEDURE AddPersonAttribute
    @Id VARCHAR(255),
    @AttributeName VARCHAR(255),
    @AttributeValue VARCHAR(255)
AS
BEGIN
INSERT INTO person_attributes (id, person_id, name, value)
VALUES (NEWID(), @Id, @AttributeName, @AttributeValue);
END;
GO
CREATE PROCEDURE SignCompanyForConference
    @CompanyId VARCHAR(255),
    @ConferenceId VARCHAR(255)
AS
BEGIN
DECLARE @AlreadyTakenSlots INTEGER;
DECLARE @MaxSlots INTEGER;
DECLARE @RequiredSlots INTEGER;
SELECT @AlreadyTakenSlots = SUM(slots) FROM booking WHERE conference_id = @ConferenceId AND cancel_reason IS NULL;
SELECT @MaxSlots = slots FROM conference WHERE id = @ConferenceId;
SELECT @RequiredSlots = COUNT(*) FROM person WHERE company_id = @CompanyId;

IF (@AlreadyTakenSlots + @RequiredSlots < @MaxSlots)
    RAISERROR('Not enough slots',16,1)
ELSE
    DECLARE @BookingId VARCHAR(255);
    SELECT @BookingId = NEWID();
    INSERT INTO booking (id, booking_date, conference_id, slots, company_id)
    VALUES (@BookingId, GETDATE(), @ConferenceId, @RequiredSlots, @CompanyId);

    DECLARE @PersonId VARCHAR(255);
    DECLARE PersonCursor CURSOR FOR SELECT id FROM person WHERE company_id = @CompanyId;

    OPEN PersonCursor;
    FETCH NEXT FROM PersonCursor INTO @PersonId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO participant (id, booking_id, company_id, person_id)
        VALUES (NEWID(), @BookingId, @CompanyId, @PersonId);
        FETCH NEXT FROM PersonCursor INTO @PersonId;
    END
END;
GO
CREATE PROCEDURE SignPersonForConference
    @PersonId VARCHAR(255),
    @ConferenceId VARCHAR(255)
AS
BEGIN
DECLARE @AlreadyTakenSlots INTEGER;
DECLARE @MaxSlots INTEGER;
SELECT @AlreadyTakenSlots = SUM(slots) FROM booking WHERE conference_id = @ConferenceId AND cancel_reason IS NULL;
SELECT @MaxSlots = slots FROM conference WHERE id = @ConferenceId;

IF (@AlreadyTakenSlots + 1 < @MaxSlots)
    RAISERROR('Not enough slots',16,1)
ELSE
    DECLARE @BookingId VARCHAR(255);
    SELECT @BookingId = NEWID();
    INSERT INTO booking (id, booking_date, conference_id, slots)
    VALUES (@BookingId, GETDATE(), @ConferenceId, 1);
    INSERT INTO participant (id, booking_id, person_id)
    VALUES (NEWID(), @BookingId, @PersonId);
END;
GO
CREATE PROCEDURE CancelBooking
    @BookingId VARCHAR(255),
    @Reason VARCHAR(255)
AS
BEGIN
    UPDATE booking SET cancel_reason = @Reason WHERE id = @BookingId;
    DELETE FROM participant_internal_event WHERE participant_id IN (SELECT id FROM participant WHERE booking_id = @BookingId);
    DELETE FROM selected_date WHERE participant_id IN (SELECT id FROM participant WHERE booking_id = @BookingId);
END;
GO 

CREATE PROCEDURE SignPersonForInternalEvent
    @ParticipantId VARCHAR(255),
    @InternalEventId VARCHAR(255)
AS
BEGIN
DECLARE @AlreadyTakenSlots INTEGER;
DECLARE @MaxSlots INTEGER;
SELECT @AlreadyTakenSlots = COUNT(participant_id) FROM participant_internal_event  WHERE internal_event_id = @InternalEventId;
SELECT @MaxSlots = max_slots FROM internal_event WHERE id = @InternalEventId;
IF (@AlreadyTakenSlots + 1 < @MaxSlots)
    RAISERROR('Not enough slots',16,1)
ELSE
    INSERT INTO participant_internal_event (participant_id, internal_event_id)
    VALUES (@ParticipantId, @InternalEventId);
END;
GO
