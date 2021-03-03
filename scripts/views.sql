CREATE VIEW UpComingConference AS
SELECT conference.id, name, date, slots 
FROM conference INNER JOIN conference_date 
ON conference.id= conference_date.conference_id
WHERE date >GETDATE();
GO

CREATE VIEW AvailableConferenceDays AS
SELECT name, date, (slots-(SELECT COUNT(*) FROM booking WHERE conference.id = booking.conference_id)) AS AvailableSlots
FROM conference INNER JOIN conference_date 
ON conference.id = conference_date.conference_id
WHERE (SELECT COUNT(*) FROM booking WHERE conference.id = booking.conference_id) > 0;
GO

CREATE VIEW AvailableInternalEvents AS
SELECT id,conference_id, date, (max_slots-(SELECT COUNT(*) FROM participant_internal_event WHERE internal_event.id = participant_internal_event.internal_event_id )) AS AvailableSlots
FROM internal_event 
WHERE (max_slots-(SELECT COUNT(*) FROM participant_internal_event WHERE internal_event.id = participant_internal_event.internal_event_id )) > 0;
GO 

CREATE VIEW InternalEventsPopularity AS 
SELECT internal_event.id,
((SELECT COUNT (*) FROM participant_internal_event WHERE participant_internal_event.internal_event_id=internal_event.id)/max_slots*100) AS TakenPlaces
	FROM internal_event
	INNER JOIN participant_internal_event ON participant_internal_event.internal_event_id=internal_event.id
	WHERE ((SELECT COUNT (*) FROM participant_internal_event WHERE participant_internal_event.internal_event_id=internal_event.id)/max_slots*100)
	IN(SELECT TOP 30 ((SELECT COUNT (*) FROM participant_internal_event WHERE participant_internal_event.internal_event_id=internal_event.id)/max_slots*100)
		FROM participant_internal_event
		INNER JOIN internal_event ON participant_internal_event.internal_event_id=internal_event.id
		ORDER BY ((SELECT COUNT (*) FROM participant_internal_event WHERE participant_internal_event.internal_event_id=internal_event.id)/max_slots*100)
DESC)
GO

CREATE VIEW ConferenceDayPopularity AS 
SELECT conference.id,
((SELECT COUNT (*) FROM booking WHERE booking.conference_id=conference.id)/(conference.slots)*100) AS TakenPlaces
	FROM conference
	INNER JOIN booking ON booking.conference_id=conference.id
	WHERE ((SELECT COUNT (*) FROM participant_internal_event WHERE booking.conference_id=conference.id)/(conference.slots)*100)
	IN(SELECT TOP 30 ((SELECT COUNT (*) FROM booking WHERE booking.conference_id=conference.id)/(conference.slots)*100)
		FROM booking
		INNER JOIN conference ON booking.conference_id=conference.id
		ORDER BY ((SELECT COUNT (*) FROM booking WHERE booking.conference_id=conference.id)/(conference.slots)*100)
DESC)
GO

CREATE VIEW CancelledReservations AS 
SELECT id
FROM booking
WHERE cancel_reason IS NOT NULL
GO

CREATE VIEW UnPaidBooking AS
SELECT id
FROM booking
WHERE is_paid = 0
GO

CREATE VIEW PaidBooking AS
SELECT id
FROM booking
WHERE is_paid = 1
GO

CREATE VIEW CompanyCall AS
SELECT company.id, conference_id
FROM company 
INNER JOIN booking ON booking.company_id=company.id
WHERE ((SELECT COUNT(slots) FROM booking WHERE booking.company_id = company_id) > (SELECT COUNT(*) FROM participant WHERE participant.company_id=company.id ))
GO

CREATE VIEW ParticipantsFrequency AS
SELECT participant.id, 
(SELECT COUNT(*) FROM selected_date WHERE participant.id= selected_date.participant_id) AS BookedDays
FROM participant
INNER JOIN selected_date ON participant.id= selected_date.participant_id
WHERE (SELECT COUNT(*) FROM selected_date WHERE participant.id= selected_date.participant_id)
IN (SELECT TOP 30 (SELECT COUNT(*) FROM selected_date WHERE participant.id= selected_date.participant_id)
		FROM booking
		INNER JOIN participant ON participant.id= selected_date.participant_id
		ORDER BY (SELECT COUNT(*) FROM selected_date WHERE participant.id= selected_date.participant_id)
		DESC)
GO




