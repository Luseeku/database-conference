INSERT INTO series (id, name)
VALUES ('3568571f-07d0-44bf-9ff6-e7bf8b9ef5cd', 'Confitura'),
    ('3a5f43b4-d1c0-4600-9ce2-a49fae8908ea', 'JDD'),
    ('776c12d8-4fea-47e7-85c3-f98ea7e4339b', 'JavaZone');

INSERT INTO location (id, address, specific_location, max_slots, price_per_day)
VALUES ('9519c73c-cb74-4e09-bbe9-06ab15bd1a19', 'Sezamkowa 12', 'A4', 10, 100),
    ('5c23fdc5-fbcb-44c7-ba1b-43cc1204f6d2', 'Sezamkowa 12', 'A5', 10, 150),
    ('20785013-8fdc-4656-ac34-7d4f47bf3975', 'Kolejowa 13', 'A5', 10, 200);

INSERT INTO conference (id, series_id, name, location_id, student_discount, slots)
VALUES ('725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac', '3568571f-07d0-44bf-9ff6-e7bf8b9ef5cd', 'Confitura 2020', '9519c73c-cb74-4e09-bbe9-06ab15bd1a19', 0.1, 10),
    ('37a0ef89-d758-4f74-a4d4-7b3007b5da1d', '3568571f-07d0-44bf-9ff6-e7bf8b9ef5cd', 'Confitura 2021', '9519c73c-cb74-4e09-bbe9-06ab15bd1a19', 0.1, 10),
    ('0a6894be-95e5-4c1b-9c76-da6b360ca63b', '3568571f-07d0-44bf-9ff6-e7bf8b9ef5cd', 'Confitura 2022', '9519c73c-cb74-4e09-bbe9-06ab15bd1a19', 0.1, 10);

INSERT INTO price_threshold (id, days_before, price, conference_id, discount_code)
VALUES ('f3a18108-2470-467b-b7ea-ea2066e2c89d', 100000, 100, '725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac', NULL),
    ('8dba0bf2-325d-4927-a6a7-70a903d9f9ac', 100000, 100, '37a0ef89-d758-4f74-a4d4-7b3007b5da1d', NULL),
    ('38863de1-a4da-4013-9ecf-815f841c51aa', 100000, 100, '0a6894be-95e5-4c1b-9c76-da6b360ca63b', NULL);

INSERT INTO conference_date (id, date, conference_id)
VALUES ('67f483b0-a030-4c19-ba80-31fa97ad20bd', '2020-10-10', '725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac'),
    ('58392734-9693-4e2b-9a02-5eaa1a78a1de', '2021-10-10', '37a0ef89-d758-4f74-a4d4-7b3007b5da1d'),
    ('3a75696d-b118-46aa-9151-f3d635165d6e', '2022-10-10', '0a6894be-95e5-4c1b-9c76-da6b360ca63b');

INSERT INTO company (id, name, phone_number)
VALUES ('e85a4207-c82b-4368-be8d-fa076324f5e7', 'JanuszSoft', '123-312-123'),
    ('b2eb401c-d857-47b1-9349-94f68cf7b4e9', 'SuperSoft', '321-123-321');

INSERT INTO company_attributes (id, company_id, name, value)
VALUES ('524587f2-29e7-4d39-ad9d-2a8407047a81', 'e85a4207-c82b-4368-be8d-fa076324f5e7', 'founded', '1990');

INSERT INTO person (id, company_id, first_name, last_name, student_id_number)
VALUES ('04e2514d-2e1c-462c-885d-3a44e1777ed4', NULL, 'Adam', 'Nowak', NULL),
    ('2649461f-3d7c-4800-8b5e-e2c28674e0c9', 'e85a4207-c82b-4368-be8d-fa076324f5e7', 'Adam', 'Janusz', NULL),
    ('5e585cb5-df15-45f2-9f0a-5326f99509a2', 'e85a4207-c82b-4368-be8d-fa076324f5e7', 'Marek', 'Janusz', NULL),
    ('f40c7321-f4bf-4000-ae8a-ef14d317604a', 'b2eb401c-d857-47b1-9349-94f68cf7b4e9', 'Adam', 'Super', NULL);

INSERT INTO booking (id, booking_date, conference_id, slots, company_id)
VALUES ('b906d2a5-a8fc-4175-9399-a169ae1dbec7', '2020-01-01', '725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac', 5, NULL),
    ('63b79347-7b79-4173-ba5f-0b4dce941763', '2020-01-02', '725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac', 2, 'e85a4207-c82b-4368-be8d-fa076324f5e7'),
    ('d7db5fc8-5f73-4f63-bbfd-93062539c23c', '2020-01-03', '725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac', 1, 'b2eb401c-d857-47b1-9349-94f68cf7b4e9');

INSERT INTO participant (id, booking_id, company_id, person_id)
VALUES ('20c3aa4b-161d-4611-982d-c7dcb5ab8f10', 'b906d2a5-a8fc-4175-9399-a169ae1dbec7', NULL, '04e2514d-2e1c-462c-885d-3a44e1777ed4'),
    ('6418caac-e01d-4320-9bee-943a5d0ce68a', '63b79347-7b79-4173-ba5f-0b4dce941763', 'e85a4207-c82b-4368-be8d-fa076324f5e7', '2649461f-3d7c-4800-8b5e-e2c28674e0c9'),
    ('31bdf618-ea62-471d-b9f6-aff9970dd5f0', '63b79347-7b79-4173-ba5f-0b4dce941763', 'e85a4207-c82b-4368-be8d-fa076324f5e7', '5e585cb5-df15-45f2-9f0a-5326f99509a2'),
    ('cebf39a2-1f25-4e63-9ab6-06663ce2415b', 'd7db5fc8-5f73-4f63-bbfd-93062539c23c', 'b2eb401c-d857-47b1-9349-94f68cf7b4e9', 'f40c7321-f4bf-4000-ae8a-ef14d317604a');

INSERT INTO selected_date (id, conference_date_id, participant_id)
VALUES ('798456c5-82b0-4642-9939-4fb4feeca29b', '67f483b0-a030-4c19-ba80-31fa97ad20bd', '20c3aa4b-161d-4611-982d-c7dcb5ab8f10'),
    ('4613dba9-f51f-4175-a4fe-88b5c514d5e9', '67f483b0-a030-4c19-ba80-31fa97ad20bd', '6418caac-e01d-4320-9bee-943a5d0ce68a'),
    ('aaae6a00-49c5-44a7-865c-f4f0ba07ca36', '67f483b0-a030-4c19-ba80-31fa97ad20bd', '31bdf618-ea62-471d-b9f6-aff9970dd5f0'),
    ('342c4dc6-7388-402a-8d4d-71b5285b2f36', '67f483b0-a030-4c19-ba80-31fa97ad20bd', 'cebf39a2-1f25-4e63-9ab6-06663ce2415b');

INSERT INTO internal_event (id, conference_id, price, date, end_date, max_slots)
VALUES ('d270e467-657d-49fb-9562-5236f871b9e1', '725ad7f3-21a7-47d9-92e6-8b9ba5b0bbac', NULL, '2020-10-10 10:10', '2020-10-10 10:15', 2);

INSERT INTO participant_internal_event (participant_id, internal_event_id)
VALUES ('20c3aa4b-161d-4611-982d-c7dcb5ab8f10', 'd270e467-657d-49fb-9562-5236f871b9e1'),
    ('31bdf618-ea62-471d-b9f6-aff9970dd5f0', 'd270e467-657d-49fb-9562-5236f871b9e1');
