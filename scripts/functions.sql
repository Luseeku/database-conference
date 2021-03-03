CREATE FUNCTION GetPriceForConference (
    @ConferenceId VARCHAR(255),
    @Date DATE,
    @DiscountCode VARCHAR(255)
)
RETURNS MONEY
AS
BEGIN
DECLARE @Result as MONEY;
SELECT TOP 1 @Result=price_threshold.price
    FROM price_threshold
    JOIN conference
        ON conference.id = price_threshold.conference_id
    WHERE conference_id = @ConferenceId
        AND ((@DiscountCode IS NULL AND discount_code IS NULL) OR discount_code = @DiscountCode)
        AND days_before > DATEDIFF(day, (SELECT MIN(conference_date.date) FROM conference_date WHERE conference_date.conference_id = conference.id), @Date)
    ORDER BY days_before ASC
RETURN @Result
END;
GO

CREATE FUNCTION GetPaymentsForPerson (
    @PersonId VARCHAR(255)
)
RETURNS TABLE
AS
RETURN
    SELECT
        conference.name AS conference_name,
        dbo.GetPriceForConference(conference.id, booking.booking_date, booking.discount_code) AS price,
        CAST(CASE WHEN booking.company_id IS NULL THEN 1 ELSE 0 END AS BIT) AS payment_required
    FROM person
    JOIN participant
        ON participant.person_id = person.id
    JOIN booking
        ON booking.id = participant.booking_id
    JOIN conference
        ON conference.id = booking.conference_id
    WHERE booking.cancel_reason IS NULL
        AND person.id = @PersonId;
GO

CREATE FUNCTION GetPaymentsForCompany (
    @CompanyId VARCHAR(255)
)
RETURNS TABLE
AS
RETURN
    SELECT
        conference.name AS conference_name,
        SUM(dbo.GetPriceForConference(conference.id, booking.booking_date, booking.discount_code)) AS price
    FROM person
    JOIN participant
        ON participant.person_id = person.id
    JOIN booking
        ON booking.id = participant.booking_id
    JOIN conference
        ON conference.id = booking.conference_id
    WHERE booking.cancel_reason IS NULL
        AND participant.company_id = @CompanyId
    GROUP BY conference.name
GO

CREATE FUNCTION GetConferencesForSeries (
    @SeriesName VARCHAR(255)
)
RETURNS TABLE
AS
RETURN
    SELECT
        conference.id AS conference_id,
        conference.name AS conference_name
    FROM conference
    JOIN series
        ON series.id = conference.series_id
    WHERE series.name = @SeriesName
GO

CREATE FUNCTION GetConferenceParticipants (
    @ConferenceId VARCHAR(255)
)
RETURNS TABLE
AS
RETURN
    SELECT DISTINCT
        person.id AS person_id,
        person.first_name AS first_name,
        person.last_name AS last_name,
        conference_date.date AS selected_date
    FROM participant
    JOIN person
        ON person.id = participant.person_id
    JOIN booking
        ON booking.id = participant.booking_id
    JOIN conference
        ON conference.id = booking.conference_id
    JOIN conference_date
        ON conference_date.conference_id = conference.id
    WHERE conference.id = @ConferenceId
        AND booking.cancel_reason IS NULL
        AND conference_date.cancel_reason IS NULL
GO

CREATE FUNCTION GetInternalEventParticipants (
    @InternalEventId VARCHAR(255)
)
RETURNS TABLE
AS
RETURN
    SELECT DISTINCT
        person.id AS person_id,
        person.first_name AS first_name,
        person.last_name AS last_name
    FROM person
    JOIN participant
        ON participant.person_id = person.id
    JOIN participant_internal_event
        ON participant_internal_event.participant_id = participant.id
    JOIN internal_event
        ON internal_event.id = participant_internal_event.internal_event_id
    JOIN booking
        ON booking.id = participant.booking_id
    WHERE internal_event.id = @InternalEventId
        AND booking.cancel_reason IS NULL;
GO

CREATE FUNCTION GetConferenceLocations (
    @ConferenceId VARCHAR(255)
)
RETURNS TABLE
AS
RETURN
    SELECT DISTINCT location.*
    FROM location
    JOIN conference
        ON conference.location_id = location.id
    WHERE conference.id = @ConferenceId
GO

CREATE FUNCTION GetConferencesInTimeWindow (
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
    SELECT DISTINCT conference.*
    FROM conference
    JOIN conference_date
        ON conference_date.conference_id = conference.id
    WHERE conference.cancel_reason IS NULL
        AND conference_date.date > @StartDate
        AND conference_date.date < @EndDate;
GO
