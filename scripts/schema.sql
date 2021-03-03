CREATE TABLE series (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
);
CREATE TABLE location (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    specific_location VARCHAR(255) NOT NULL,
    max_slots INTEGER NOT NULL,
    price_per_day MONEY NOT NULL
);
CREATE TABLE price_threshold (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    days_before INTEGER NOT NULL,
    price MONEY NOT NULL,
    conference_id VARCHAR(255) NOT NULL,
    discount_code VARCHAR(255) NULL
);
CREATE TABLE conference (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    series_id VARCHAR(255) NULL,
    name VARCHAR(255) NOT NULL,
    location_id VARCHAR(255) NOT NULL,
    student_discount NUMERIC(10,5) NOT NULL,
    cancel_reason VARCHAR(255) NULL,
    slots INTEGER NOT NULL,

);
CREATE TABLE conference_date (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    cancel_reason VARCHAR(255) NULL,
    conference_id VARCHAR(255) NOT NULL
);
CREATE TABLE internal_event (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    conference_id VARCHAR(255) NOT NULL,
    price MONEY,
    date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    max_slots INTEGER
);
CREATE TABLE company (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) NOT NULL
);
CREATE TABLE company_attributes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    company_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    value VARCHAR(255) NOT NULL
);
CREATE TABLE booking (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    booking_date DATE NOT NULL,
    cancel_reason VARCHAR(255) NULL,
    conference_id VARCHAR(255) NULL,
    slots INTEGER,
    company_id VARCHAR(255) NULL,
    discount_code VARCHAR(255) NULL,
    is_paid BIT NOT NULL DEFAULT 0
);
CREATE TABLE selected_date (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    conference_date_id VARCHAR(255) NOT NULL,
    participant_id VARCHAR(255) NOT NULL
);
CREATE TABLE participant_internal_event (
    participant_id VARCHAR(255) NOT NULL,
    internal_event_id VARCHAR(255) NOT NULL
);
CREATE TABLE participant (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    booking_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NULL,
    person_id VARCHAR(255) NOT NULL
);
CREATE TABLE person (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    company_id VARCHAR(255) NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    student_id_number VARCHAR(255) NULL
);
CREATE TABLE person_attributes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    person_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    value VARCHAR(255) NOT NULL
);

ALTER TABLE [conference] WITH CHECK ADD CONSTRAINT [CK_conference_StudentDiscountNotNegative] CHECK ([student_discount] >= 0)

ALTER TABLE [conference] CHECK CONSTRAINT [CK_conference_StudentDiscountNotNegative]

ALTER TABLE [conference] WITH CHECK ADD CONSTRAINT [CK_conference_SlotsNotNegative ] CHECK ([slots] > 0)

ALTER TABLE [conference] CHECK CONSTRAINT [CK_conference_SlotsNotNegative]

ALTER TABLE [conference] WITH CHECK ADD CONSTRAINT [FK_conference_SeriesExist] FOREIGN KEY ([series_id]) REFERENCES [series]([id])

ALTER TABLE [conference] CHECK CONSTRAINT [FK_conference_SeriesExist]

ALTER TABLE [conference] WITH CHECK ADD CONSTRAINT [FK_conference_LocationExist] FOREIGN KEY(location_id) REFERENCES [location]([id])

ALTER TABLE [conference] CHECK CONSTRAINT [FK_conference_LocationExist]

ALTER TABLE [booking] WITH CHECK ADD CONSTRAINT [CK_booking_SlotsNotNegative] CHECK ([slots] > 0)

ALTER TABLE [booking] CHECK CONSTRAINT [CK_booking_SlotsNotNegative]

ALTER TABLE [booking] WITH CHECK ADD CONSTRAINT [CK_booking_is_paid_default] CHECK ([is_paid] IS NOT NULL )

ALTER TABLE[booking] CHECK CONSTRAINT [CK_booking_is_paid_default]

ALTER TABLE[booking] WITH CHECK ADD CONSTRAINT [FK_booking_ConferenceExist] FOREIGN KEY ([conference_id]) REFERENCES [conference]([id])

ALTER TABLE[booking] CHECK CONSTRAINT [FK_booking_ConferenceExist]

ALTER TABLE [booking] WITH CHECK ADD CONSTRAINT [FK_booking_CompanyExist] FOREIGN KEY ([company_id]) REFERENCES [company]([id])

ALTER TABLE [booking] CHECK CONSTRAINT [FK_booking_CompanyExist]

ALTER TABLE [participant] WITH CHECK ADD CONSTRAINT [FK_participant_CompanyExist] FOREIGN KEY ([company_id]) REFERENCES [company]([id])

ALTER TABLE [participant] CHECK CONSTRAINT [FK_participant_CompanyExist]

ALTER TABLE [participant] WITH CHECK ADD CONSTRAINT [FK_Participant_BookingExist] FOREIGN KEY ([booking_id]) REFERENCES [booking]([id])

ALTER TABLE [participant] CHECK CONSTRAINT [FK_Participant_BookingExist]

ALTER TABLE [participant] WITH CHECK ADD CONSTRAINT [FK_Participant_PersonExist] FOREIGN KEY ([person_id]) REFERENCES [person]([id])

ALTER TABLE [participant] CHECK CONSTRAINT [FK_Participant_PersonExist]

ALTER TABLE [person] WITH CHECK ADD CONSTRAINT [FK_Person_CompanyExist] FOREIGN KEY ([company_id]) REFERENCES [company]([id])

ALTER TABLE [person] CHECK CONSTRAINT [FK_Person_CompanyExist]

ALTER TABLE [person] WITH CHECK ADD CONSTRAINT [CK_Person_FirstNameExist] CHECK ([first_name] IS NOT NULL)

ALTER TABLE [person] CHECK CONSTRAINT [CK_Person_FirstNameExist]

ALTER TABLE [person] WITH CHECK ADD CONSTRAINT [CK_Person_LastNameExist ] CHECK ([last_name] IS NOT NULL)

ALTER TABLE [person] CHECK CONSTRAINT [CK_Person_LastNameExist]

ALTER TABLE [person_attributes] WITH CHECK ADD CONSTRAINT [FK_Person_attributes_PersonExist] FOREIGN KEY ([person_id]) REFERENCES [person]([id])

ALTER TABLE [person_attributes] CHECK CONSTRAINT [FK_Person_attributes_PersonExist]

ALTER TABLE [person_attributes] WITH CHECK ADD CONSTRAINT [CK_Person_attributes_NameNotNull ] CHECK ([name] IS NOT NULL)

ALTER TABLE [person_attributes]  CHECK CONSTRAINT [CK_Person_attributes_NameNotNull]

ALTER TABLE[company] WITH CHECK ADD CONSTRAINT [CK_company_PersonExist ] CHECK ([name] IS NOT NULL)

ALTER TABLE [company] CHECK CONSTRAINT [CK_company_PersonExist]

ALTER TABLE [company] WITH CHECK ADD CONSTRAINT [CK_company_PhoneNotNull] CHECK ([phone_number] IS NOT NULL)

ALTER TABLE [company] CHECK CONSTRAINT [CK_Company_PhoneNotNull]

ALTER TABLE [company_attributes] WITH CHECK ADD CONSTRAINT [FK_Company_attributes_CompanyExist] FOREIGN KEY ([company_id]) REFERENCES [company]([id])

ALTER TABLE[company_attributes] CHECK CONSTRAINT [FK_Company_attributes_CompanyExist]

ALTER TABLE [company_attributes] WITH CHECK ADD CONSTRAINT [CK_Company_attributes_NameNotNull ] CHECK ([name] IS NOT NULL)

ALTER TABLE [company_attributes] CHECK CONSTRAINT [CK_Company_attributes_NameNotNull]

ALTER TABLE [company_attributes] WITH CHECK ADD CONSTRAINT [CK_Company_attributes_ValueNotNull ] CHECK ([value] IS NOT NULL)

ALTER TABLE [company_attributes] CHECK CONSTRAINT [CK_Company_attributes_ValueNotNull]

ALTER TABLE [location] WITH CHECK ADD CONSTRAINT [CK_Location_AdressNotNull ] CHECK ([address] IS NOT NULL)

ALTER TABLE [location] CHECK CONSTRAINT [CK_Location_AdressNotNull]

ALTER TABLE [location] WITH CHECK ADD CONSTRAINT [CK_Location_SpecyficLocationNotNull] CHECK ([specific_location] IS NOT NULL)

ALTER TABLE [location] CHECK CONSTRAINT [CK_Location_SpecyficLocationNotNull]

ALTER TABLE [location] WITH CHECK ADD CONSTRAINT [CK_location_SlotsNotNegative ] CHECK ([max_slots] > 0)

ALTER TABLE [location] CHECK CONSTRAINT [CK_location_SlotsNotNegative]

ALTER TABLE [location] WITH CHECK ADD CONSTRAINT [CK_location_PricePerDayNotNegative] CHECK ([price_per_day] >= 0)

ALTER TABLE [location] CHECK CONSTRAINT [CK_location_PricePerDayNotNegative]

ALTER TABLE [series] WITH CHECK ADD CONSTRAINT [CK_series_NameNotNull] CHECK ([name] IS NOT NULL)

ALTER TABLE [series] CHECK CONSTRAINT [CK_series_NameNotNull]

ALTER TABLE [price_threshold] WITH CHECK ADD CONSTRAINT [CK_Price_threshold_DaysBeforeNotNegative] CHECK ([days_before] >= 0)

ALTER TABLE [price_threshold] CHECK CONSTRAINT [CK_Price_threshold_DaysBeforeNotNegative]

ALTER TABLE [price_threshold] WITH CHECK ADD CONSTRAINT [CK_price_threshold_PriceNotNegative] CHECK ([price] >= 0)

ALTER TABLE [price_threshold]  CHECK CONSTRAINT [CK_price_threshold_PriceNotNegative]

ALTER TABLE [price_threshold] WITH CHECK ADD CONSTRAINT [FK_Price_threshold_ConferenceExist] FOREIGN KEY ([conference_id]) REFERENCES [conference]([id])

ALTER TABLE [price_threshold] CHECK CONSTRAINT [FK_Price_threshold_ConferenceExist]

ALTER TABLE [conference_date] WITH CHECK ADD CONSTRAINT [CK_Conference_date_StartDateNotInPast] CHECK ([date] > GETDATE())

ALTER TABLE [conference_date] CHECK CONSTRAINT [CK_Conference_date_StartDateNotInPast]

ALTER TABLE [conference_date] WITH CHECK ADD CONSTRAINT [FK_Conference_date_ConferenceExist] FOREIGN KEY ([conference_id]) REFERENCES [conference]([id])

ALTER TABLE [conference_date] CHECK CONSTRAINT [FK_Conference_date_ConferenceExist]

ALTER TABLE [selected_date] WITH CHECK ADD CONSTRAINT [FK_Selected_date_ConferenceDateExist] FOREIGN KEY ([conference_date_id]) REFERENCES [conference_date]([id])

ALTER TABLE [selected_date] CHECK CONSTRAINT [FK_Selected_date_ConferenceDateExist]

ALTER TABLE [selected_date] WITH CHECK ADD CONSTRAINT [FK_Selected_date_ParticipantExist] FOREIGN KEY ([participant_id])REFERENCES [participant]([id])

ALTER TABLE [selected_date] CHECK CONSTRAINT [FK_Selected_date_ParticipantExist]

ALTER TABLE [internal_event] WITH CHECK ADD CONSTRAINT [FK_Internal_event_ConferenceExist] FOREIGN KEY ([conference_id]) REFERENCES [conference]([id])

ALTER TABLE [internal_event] CHECK CONSTRAINT [FK_Internal_event_ConferenceExist]

ALTER TABLE [internal_event] WITH CHECK ADD CONSTRAINT [CK_Internal_event_SlotsNotNegative ] CHECK ([max_slots] > 0)

ALTER TABLE [internal_event] CHECK CONSTRAINT [CK_Internal_event_SlotsNotNegative]

ALTER TABLE [participant_internal_event] WITH CHECK ADD CONSTRAINT [FK_Participant_internal_event_ParticipantExist] FOREIGN KEY ([participant_id]) REFERENCES [participant]([id])

ALTER TABLE [participant_internal_event] CHECK CONSTRAINT [FK_Participant_internal_event_ParticipantExist]

ALTER TABLE [participant_internal_event] WITH CHECK ADD CONSTRAINT [FK_Participant_internal_event_InternalEventExist] FOREIGN KEY ([internal_event_id]) REFERENCES [internal_event]([id])

ALTER TABLE [participant_internal_event] CHECK CONSTRAINT [FK_Participant_internal_event_InternalEventExist]

ALTER TABLE [selected_date]  ADD CONSTRAINT UC_date UNIQUE (conference_date_id, participant_id);
GO
