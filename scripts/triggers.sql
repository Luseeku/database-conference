CREATE TRIGGER ValidateBookingSlots
    ON participant
    INSTEAD OF INSERT
AS BEGIN
    DECLARE @InvalidBookingCounts INT;
    SELECT @InvalidBookingCounts = COUNT(*)
    FROM (SELECT
            booking.slots AS max_slots,
            (SELECT COUNT(*) AS inserted_count FROM inserted WHERE inserted.booking_id = booking.id) AS inserted,
            (SELECT COUNT(*) AS existing_count FROM participant WHERE participant.booking_id = booking.id) AS existing
        FROM booking
        WHERE booking.id IN (SELECT booking_id FROM inserted)) data
    WHERE data.max_slots < data.inserted + data.existing;

    IF @InvalidBookingCounts > 0 BEGIN
        RAISERROR ('Not enough slots' ,10,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    INSERT INTO participant SELECT * FROM inserted;
END;
GO

CREATE TRIGGER ValidateConferenceSlots
    ON booking
    INSTEAD OF INSERT
AS BEGIN
    DECLARE @InvalidBookingCounts INT;
    SELECT @InvalidBookingCounts = COUNT(*)
    FROM (SELECT
            conference.slots AS max_slots,
            (SELECT SUM(inserted.slots) AS inserted_count FROM inserted WHERE inserted.conference_id = conference.id) AS inserted,
            (SELECT SUM(booking.slots) AS existing_count FROM booking WHERE booking.conference_id = conference.id AND booking.cancel_reason IS NULL) AS existing
        FROM conference
        WHERE conference.id IN (SELECT conference_id FROM inserted)) data
    WHERE data.max_slots < data.inserted + data.existing;

    IF @InvalidBookingCounts > 0 BEGIN
        RAISERROR ('Not enough slots' ,10,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    INSERT INTO booking SELECT * FROM inserted;
END;
GO

CREATE TRIGGER ValidateParticipantInternalEvent
    ON participant_internal_event
    INSTEAD OF INSERT
AS BEGIN
    DECLARE @InvalidInternalEvents INT;
    SELECT @InvalidInternalEvents = COUNT(*)
    FROM (SELECT
            internal_event.max_slots AS max_slots,
            (SELECT COUNT(*) AS inserted_count FROM inserted WHERE inserted.internal_event_id = internal_event.id) AS inserted,
            (SELECT COUNT(*) AS existing_count FROM participant_internal_event WHERE participant_internal_event.internal_event_id = internal_event.id) AS existing
        FROM internal_event
        WHERE internal_event.id IN (SELECT internal_event_id FROM inserted)) data
    WHERE data.max_slots < data.inserted + data.existing;

    IF @InvalidInternalEvents > 0 BEGIN
        RAISERROR ('Not enough slots' ,10,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    SELECT @InvalidInternalEvents = COUNT(*)
    FROM inserted
    JOIN internal_event ON internal_event.id = inserted.internal_event_id
    JOIN participant ON participant.id = inserted.participant_id
    JOIN selected_date ON selected_date.participant_id = participant.id
    JOIN conference_date ON conference_date.id = selected_date.conference_date_id
    WHERE conference_date.date != CONVERT(DATE, internal_event.date);
    IF @InvalidInternalEvents > 0 BEGIN
        RAISERROR ('internal event is not in selected conference dates' ,10,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    SELECT @InvalidInternalEvents = COUNT(*)
    FROM inserted
    JOIN internal_event ON internal_event.id = inserted.internal_event_id
    JOIN participant ON participant.id = inserted.participant_id
    JOIN participant_internal_event ON participant_internal_event.participant_id = participant.id
    JOIN internal_event ie ON ie.id = participant_internal_event.internal_event_id
    WHERE ie.date < internal_event.date AND ie.end_date > internal_event.date;
    IF @InvalidInternalEvents > 0 BEGIN
        RAISERROR ('internal event date collision' ,10,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    INSERT INTO participant_internal_event SELECT * FROM inserted;
END;
GO

CREATE TRIGGER ValidateBookingDay
    ON selected_date
    INSTEAD OF INSERT
AS BEGIN
    DECLARE @InvalidInserts INT;
    SELECT @InvalidInserts = COUNT(*)
    FROM inserted
    JOIN conference_date ON conference_date.id = inserted.conference_date_id
    JOIN participant ON participant.id = inserted.participant_id
    JOIN booking ON booking.id = participant.booking_id
    WHERE conference_date.conference_id != booking.conference_id;
    IF @InvalidInserts > 0 BEGIN
        RAISERROR ('date is in a different conference' ,10,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    INSERT INTO selected_date SELECT * FROM inserted;
END;
GO
