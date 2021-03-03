CREATE INDEX conference_name_idx ON conference(name);

CREATE INDEX person_booking_id_idx ON participant(booking_id, person_id);

CREATE INDEX first_last_name_idx ON person(first_name, last_name);

CREATE INDEX date_conference_id_internalevent_idx ON internal_event(conference_id, date);

CREATE INDEX name_locationid_slots_conference_idx ON conference(name, location_id, slots);

GO 