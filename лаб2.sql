CREATE TABLE senders (
    sender_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    address TEXT NOT NULL,
    passport_data VARCHAR(20) NOT NULL,
    contact_phone VARCHAR(20)
);
CREATE TABLE parcels (
track_number VARCHAR(30) PRIMARY KEY,
    correspondence_type_id INTEGER NOT NULL,
    weight real,
    length real,
    width real,
    height real,
    sender_id INTEGER REFERENCES senders(sender_id),
    stamps_amount NUMERIC(10,2)
);
SELECT * FROM public.senders
ORDER BY sender_id ASC; 
INSERT INTO senders (last_name, first_name, middle_name, address, passport_data, contact_phone) VALUES
('Иванов',    'Иван',     'Иванович',   'г. Москва, ул. Ленина, д. 1, кв. 10',        '4501 123456', '+7 (901) 111-11-11'),
('Петров',    'Пётр',     'Петрович',   'г. Санкт-Петербург, Невский пр., д. 25, кв. 5','4002 234567', '+7 (902) 222-22-22'),
('Сидорова',  'Анна',     'Сергеевна',  'г. Казань, ул. Баумана, д. 7, кв. 3',        '9201 345678', '+7 (903) 333-33-33'),
('Кузнецов',  'Алексей',  'Владимирович','г. Екатеринбург, ул. Мира, д. 12, кв. 8',  '6501 456789', '+7 (904) 444-44-44'),
('Смирнова',  'Мария',    'Андреевна',  'г. Новосибирск, ул. Кирова, д. 45, кв. 21', '5401 567890', '+7 (905) 555-55-55'),
('Попов',     'Дмитрий',  'Николаевич', 'г. Нижний Новгород, ул. Горького, д. 3, кв. 7','2201 678901','+7 (906) 666-66-66'),
('Васильева', 'Елена',    'Игоревна',   'г. Самара, ул. Победы, д. 18, кв. 14',       '3601 789012', '+7 (907) 777-77-77'),
('Морозов',   'Сергей',   'Александрович','г. Омск, ул. Лермонтова, д. 9, кв. 2',    '5501 890123', '+7 (908) 888-88-88'),
('Новикова',  'Ольга',    'Дмитриевна', 'г. Ростов-на-Дону, ул. Садовая, д. 33, кв. 6','6101 901234','+7 (909) 999-99-99'),
('Фёдоров',   'Михаил',   'Юрьевич',    'г. Краснодар, ул. Красная, д. 50, кв. 11',   '0301 012345', '+7 (910) 000-00-00');

ORDER BY track_number ASC;
INSERT INTO parcels (track_number, correspondence_type_id, weight, length, width, height, sender_id, stamps_amount) VALUES
('RU123456789',  1, 0.02, 22.0, 11.0,  0.5, 1,  25.00),
('RU123456790',  2, 0.05, 22.0, 11.0,  1.0, 2,  60.00),
('RU123456791',  3, 0.08, 25.0, 15.0,  1.5, 3, 120.00),
('RU123456792',  4, 0.30, 30.0, 20.0,  5.0, 4,  80.00),
('RU123456793',  5, 1.50, 40.0, 30.0, 20.0, 5, 250.00),
('RU123456794',  6, 8.20, 60.0, 40.0, 35.0, 6, 450.00),
('RU123456795',  7, 0.01, 20.0, 10.0,  0.3, 7,  35.00),
('RU123456796',  8, 0.50, 35.0, 25.0, 10.0, 8, 300.00),
('RU123456797',  9, 2.00, 45.0, 35.0, 25.0, 9, 900.00),
('RU123456798', 10, 0.01, 15.0, 10.0,  0.2, 10, 15.00);
--1.вывести информацию обовсех отправителях корресподенции весом больше 300 граммов--
SELECT DISTINCT
    s.sender_id,
    s.last_name,
    s.first_name,
    s.middle_name,
    s.address,
    s.passport_data,
    s.contact_phone
FROM senders AS s
JOIN parcels AS p
    ON p.sender_id = s.sender_id
WHERE p.weight > 0.3
ORDER BY s.sender_id;
--2. вывести трек-номера корресподенции от отправителей с неизвестным контактным телефоном.--
SELECT
    p.track_number
FROM parcels AS p
JOIN senders AS s
    ON s.sender_id = p.sender_id
WHERE s.contact_phone IS NULL
   OR BTRIM(s.contact_phone) = ''
ORDER BY p.track_number;
--3. создатьтаблицу,содержащую данные вторпого запросас указанием информации оботправителях и параметров корресподенции--
SELECT 
    s.sender_id, 
    s.last_name, 
    s.first_name, 
    s.middle_name, 
    s.address, 
    s.passport_data, 
    s.contact_phone, 
    p.track_number, 
    p.correspondence_type_id, 
    p.weight, 
    p.length, 
    p.width, 
    p.height, 
    p.stamps_amount
INTO rezultat_27 
FROM parcels AS p
JOIN senders AS s 
    ON s.sender_id = p.sender_id
WHERE s.contact_phone IS NULL 
   OR BTRIM(s.contact_phone) = '';

ALTER TABLE rezultat_27
    ADD PRIMARY KEY (track_number);

--4 добавить в созданную таблицу всю корресподенцию от отправителей, адреса которых  содержатдве улицы--
INSERT INTO rezultat_27 (
    sender_id,
    last_name,
    first_name,
    middle_name,
    address,
    passport_data,
    contact_phone,
    track_number,
    correspondence_type_id,
    weight,
    length,
    width,
    height,
    stamps_amount
)
SELECT
    s.sender_id,
    s.last_name,
    s.first_name,
    s.middle_name,
    s.address,
    s.passport_data,
    s.contact_phone,
    p.track_number,
    p.correspondence_type_id,
    p.weight,
    p.length,
    p.width,
    p.height,
    p.stamps_amount
FROM senders AS s
JOIN parcels AS p
    ON p.sender_id = s.sender_id
WHERE s.address ~* '(ул\\.?|улица|пр\\.?|проспект|пер\\.?|переулок).*(ул\\.?|улица|пр\\.?|проспект|пер\\.?|переулок)'
  AND NOT EXISTS (
      SELECT 1
      FROM rezultat_27 AS r
      WHERE r.track_number = p.track_number
  );
--5 в созданой таблице убрать все пробелы и специальные символы из трек-номеров отправителей--
UPDATE rezultat_27
SET track_number = REGEXP_REPLACE(track_number, '[^[:alnum:]]', '', 'g');
--6 Удалить всю корреспонденцию от отправителей с номером телефона, начинающимся и заканчивающимся на одинаковые цифры в части после кода.--
DELETE FROM rezultat_27 AS r
WHERE EXISTS (
    SELECT 1
    FROM senders AS s
    WHERE s.sender_id = r.sender_id
      AND s.contact_phone IS NOT NULL
      AND (
          SELECT
              LEFT(SUBSTRING(REGEXP_REPLACE(s.contact_phone, '[^0-9]', '', 'g')
                              FROM 5), 1)
              =
              RIGHT(SUBSTRING(REGEXP_REPLACE(s.contact_phone, '[^0-9]', '', 'g')
                              FROM 5), 1)
      )
      AND LENGTH(SUBSTRING(
              REGEXP_REPLACE(s.contact_phone, '[^0-9]', '', 'g')
              FROM 5
          )) = 7
);
--7 Посчитать средний вес и максимальные по объему параметры корреспонденции для каждого отправителя.--
SELECT
    s.sender_id,
    s.last_name,
    s.first_name,
    s.middle_name,
    ROUND(AVG(p.weight)::NUMERIC, 3) AS average_weight_kg,
    MAX(p.length) AS max_length,
    MAX(p.width) AS max_width,
    MAX(p.height) AS max_height
FROM senders AS s
JOIN parcels AS p
    ON p.sender_id = s.sender_id
GROUP BY
    s.sender_id,
    s.last_name,
    s.first_name,
    s.middle_name
ORDER BY s.sender_id;
