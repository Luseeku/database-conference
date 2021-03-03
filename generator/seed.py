import pyodbc
import random
import string
from datetime import datetime

server = 'localhost'
database = 'master'
username = 'sa'
password = 'HardPasswordAsMSSQLShitRequires123!'
driver = '{ODBC Driver 17 for SQL Server}'

conn = pyodbc.connect(
    'DRIVER=' + driver + ';SERVER=' + server + ';PORT=1433;DATABASE=' + database + ';UID=' + username + ';PWD=' + password)
cursor = conn.cursor()


def generate_name():
    return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))


for series_id in range(0, 10):
    cursor.execute("INSERT INTO series (id, name) VALUES (?, ?)", (series_id, generate_name()))
    conn.commit()

for location_id in range(0, 10):
    cursor.execute("""
        INSERT INTO location (id, address, specific_location, max_slots, price_per_day)
        VALUES (?, ?, ?, ?, ?);
    """, (location_id, generate_name(), generate_name(), 1000000000, 10))
    conn.commit()

for conference_id in range(0, 1000):
    cursor.execute("SELECT TOP 1 id FROM series ORDER BY RAND()")
    series_id = cursor.fetchall()[0][0]
    cursor.execute("SELECT TOP 1 id FROM location ORDER BY RAND()")
    location_id = cursor.fetchall()[0][0]
    cursor.execute("""
        INSERT INTO conference (id, series_id, name, location_id, student_discount, slots)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (conference_id, location_id, generate_name(), location_id, 0.1, 1000000000))
    conn.commit()

for price_threshold_id in range(0, 1000):
    cursor.execute("SELECT TOP 1 id FROM conference ORDER BY RAND()")
    conference_id = cursor.fetchall()[0][0]
    cursor.execute("""
        INSERT INTO price_threshold (id, days_before, price, conference_id, discount_code)
        VALUES (?, ?, ?, ?, ?)
    """, (price_threshold_id, random.randrange(1000, 1000000), 100, conference_id, None))
    conn.commit()

for conference_date_id in range(0, 1000):
    cursor.execute("SELECT TOP 1 id FROM conference ORDER BY RAND()")
    conference_id = cursor.fetchall()[0][0]
    date = datetime.utcfromtimestamp(datetime.now().timestamp() + random.randrange(157680000, 315360000))
    cursor.execute("""
        INSERT INTO conference_date (id, date, conference_id)
        VALUES (?, ?, ?)
    """, (conference_date_id, date.date(), conference_id))
    conn.commit()

for internal_event_id in range(0, 1000):
    cursor.execute("SELECT TOP 1 date, conference_id FROM conference_date ORDER BY RAND()")
    date, conference_id = cursor.fetchall()[0]
    cursor.execute("""
        INSERT INTO internal_event (id, conference_id, price, date, end_date, max_slots)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (internal_event_id, conference_id, 10, date, datetime.now(), 1000000000))
    conn.commit()

for company_id in range(0, 100):
    cursor.execute("""
        INSERT INTO company (id, name, phone_number)
        VALUES (?, ?, ?);
    """, (company_id, generate_name(), generate_name()))
    conn.commit()

conn.commit()
for person_id in range(0, 1000):
    company_id = None
    if random.random() < 0.5:
        cursor.execute("SELECT TOP 1 id FROM company ORDER BY RAND()")
        company_id = cursor.fetchall()[0][0]
    cursor.execute("""
        INSERT INTO person (id, company_id, first_name, last_name, student_id_number)
        VALUES (?, ?, ?, ?, ?)
    """, (person_id, company_id, generate_name(), generate_name(), None))
    conn.commit()

for booking_id in range(0, 1000):
    date = datetime.utcfromtimestamp(datetime.now().timestamp() + random.randrange(0, 157680000))
    cursor.execute("SELECT TOP 1 id FROM conference ORDER BY RAND()")
    conference_id = cursor.fetchall()[0][0]
    cursor.execute("SELECT TOP 1 id, company_id FROM person ORDER BY RAND()")
    data = cursor.fetchall()[0]
    company_id = data[1]
    persons = [data[0]]
    if company_id is not None:
        cursor.execute("SELECT id FROM person WHERE company_id = ?", (company_id))
        persons = [row[0] for row in cursor.fetchall()]
    cursor.execute("""
        INSERT INTO booking (id, booking_date, conference_id, slots, company_id)
        VALUES (?, ?, ?, ?, ?)
    """, (booking_id, date, conference_id, len(persons), company_id))
    conn.commit()
    for person in persons:
        participant_id = str(person) + "_participant_" + str(random.random())
        cursor.execute("SELECT TOP 1 id, date FROM conference_date ORDER BY RAND()")
        conference_date_id, date = cursor.fetchall()[0]
        cursor.execute("""
            INSERT INTO participant (id, booking_id, company_id, person_id)
            VALUES (?, ?, ?, ?)
        """, (participant_id, booking_id, company_id, person))
        conn.commit()
        cursor.execute("""
            INSERT INTO selected_date (id, conference_date_id, participant_id)
            VALUES (?, ?, ?)
        """, (str(person) + "_date_" + str(random.random()), conference_date_id, participant_id))
        conn.commit()
        cursor.execute("SELECT TOP 1 id FROM internal_event WHERE conference_id = ? AND date = ? ORDER BY RAND()",
                       (conference_id, date))
        internal_event_id = cursor.fetchall()[0][0]
        cursor.execute("""
            INSERT INTO participant_internal_event (participant_id, internal_event_id)
            VALUES (?, ?)
        """, (participant_id, internal_event_id))
        conn.commit()

conn.commit()
