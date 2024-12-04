-- Создание таблицы для палат
CREATE TABLE wards (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    capacity INTEGER NOT NULL CHECK (capacity > 0)
);

-- Создание таблицы для диагнозов
CREATE TABLE diagnoses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Создание таблицы для пациентов
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    ward_id INTEGER REFERENCES wards(id) ON DELETE SET NULL,
    diagnoses_id INTEGER REFERENCES diagnoses(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW() --для отслеживания времени создания записей
);

-- Таблица ролей для персонала
CREATE TABLE staff_roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Создание таблицы для персонала
CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role_id INTEGER REFERENCES staff_roles(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Таблица категорий медикаментов
CREATE TABLE medication_categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Создание таблицы для медикаментов
CREATE TABLE medications (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    category_id INTEGER REFERENCES medication_categories(id)
);

-- Создание таблицы для назначений лекарств
CREATE TABLE prescriptions (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    medication_id INTEGER REFERENCES medications(id) ON DELETE CASCADE,
    dosage VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date >= start_date)
);

-- Создание таблицы для визитов
CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    staff_id INTEGER REFERENCES staff(id) ON DELETE SET NULL,
    visit_date DATE NOT NULL,
    notes TEXT
);

-- Таблица контактов пациентов
CREATE TABLE patient_contacts (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    phone_number VARCHAR(15),
    address TEXT
);

-- Таблица истории болезней
CREATE TABLE medical_history (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    diagnosis_id INTEGER REFERENCES diagnoses(id) ON DELETE CASCADE,
    diagnosis_date DATE NOT NULL
);

-- Таблица расписания персонала
CREATE TABLE staff_schedule (
    id SERIAL PRIMARY KEY,
    staff_id INTEGER REFERENCES staff(id) ON DELETE CASCADE,
    shift_start TIMESTAMP NOT NULL,
    shift_end TIMESTAMP NOT NULL CHECK (shift_end > shift_start)
);

-- Заполнение данных

-- Заполнение таблицы палат
INSERT INTO wards (name, capacity)
VALUES
    ('Терапия', 20),
    ('Хирургия', 15),
    ('Педиатрия', 10);

-- Заполнение таблицы диагнозов
INSERT INTO diagnoses (name, description)
VALUES
    ('Грипп', 'Вирусная инфекция верхних дыхательных путей'),
    ('Ангина', 'Инфекционное воспаление миндалин'),
    ('Перелом', 'Нарушение целостности кости');
   
-- Заполнение таблицы пациентов
INSERT INTO patients (first_name, last_name, birth_date, gender, ward_id, diagnoses_id)
VALUES
    ('Анна', 'Иванова', '1990-05-15', 'Female', 1, 1),
    ('Иван', 'Смирнов', '1985-03-22', 'Male', 2, 2),
    ('Мария', 'Петрова', '2010-11-12', 'Female', 3, 3);
   
-- Заполнение таблицы ролей
INSERT INTO staff_roles (role_name)
VALUES 
    ('Доктор'),
    ('Медсестра'),
    ('Хирург'),
    ('Терапевт');

-- Заполнение таблицы персонала
INSERT INTO staff (first_name, last_name, role_id)
VALUES
    ('Елена', 'Кузнецова', 1),
    ('Олег', 'Васильев', 2),
    ('Петр', 'Лазарев', 3);


-- Заполнение таблицы медикаментов и категорий
INSERT INTO medication_categories (category_name)
VALUES
    ('Жаропонижающие'),
    ('Антибиотики'),
    ('Противовоспалительные');

INSERT INTO medications (name, description, price, category_id)
VALUES
    ('Парацетамол', 'Жаропонижающее средство', 50.00, 1),
    ('Амоксициллин', 'Антибиотик широкого спектра', 200.00, 2),
    ('Ибупрофен', 'Противовоспалительное средство', 100.00, 3);

-- Заполнение расписания
INSERT INTO staff_schedule (staff_id, shift_start, shift_end)
VALUES 
    (1, '2024-11-24 08:00:00', '2024-11-24 16:00:00'),
    (2, '2024-11-24 16:00:00', '2024-11-24 23:59:59'),
    (3, '2024-11-25 08:00:00', '2024-11-25 16:00:00');
   
-- Заполнение таблицы назначений лекарств
INSERT INTO prescriptions (patient_id, medication_id, dosage, start_date, end_date)
VALUES
    (1, 1, '500 мг', '2024-11-01', '2024-11-10'),
    (2, 2, '250 мг', '2024-11-05', '2024-11-12'),
    (3, 3, '200 мг', '2024-11-07', '2024-11-14');

-- Заполнение таблицы визитов
INSERT INTO visits (patient_id, staff_id, visit_date, notes)
VALUES
    (1, 1, '2024-11-01', 'Пациентка жаловалась на головную боль.'),
    (2, 2, '2024-11-05', 'Произведена перевязка.'),
    (3, 3, '2024-11-07', 'Обследование перед операцией.');
   
-- Заполнение контактов пациентов
INSERT INTO patient_contacts (patient_id, phone_number, address)
VALUES 
    (1, '+79161234567', 'г. Москва, ул. Ленина, д. 12'),
    (2, '+79169876543', 'г. Санкт-Петербург, пр. Невский, д. 34'),
    (3, '+79167778899', 'г. Екатеринбург, ул. Карла Маркса, д. 56');

-- Наконец, заполнение истории болезней
INSERT INTO medical_history (patient_id, diagnosis_id, diagnosis_date)
VALUES 
    (1, 1, '2024-10-25'),
    (2, 2, '2024-11-01'),
    (3, 3, '2024-11-05');


-- Примеры запросов

--1. Пациенты с диагнозами и палатами
--patient_id|full_name    |ward_name|diagnosis_name|
----------+-------------+---------+--------------+
--         1|Анна Иванова |Терапия  |Грипп         |
--         2|Иван Смирнов |Хирургия |Ангина        |
--         3|Мария Петрова|Педиатрия|Перелом       |
SELECT 
    patients.id AS patient_id,
    patients.first_name || ' ' || patients.last_name AS full_name,
    wards.name AS ward_name,
    diagnoses.name AS diagnosis_name
FROM patients
LEFT JOIN wards ON patients.ward_id = wards.id
LEFT JOIN diagnoses ON patients.diagnoses_id = diagnoses.id
WHERE wards.capacity > 0
LIMIT 10;

--2. Средняя стоимость лекарств дороже 100 и дешевле 500 рублей
--avg_price|total_medications|
---------+-----------------+
--   150.00|                2|
SELECT 
    ROUND(AVG(price), 2) AS avg_price,
    COUNT(*) AS total_medications
FROM medications
WHERE price BETWEEN 100 AND 500 LIMIT 10;

--3. Список палат с количеством пациентов
--ward_name|patient_count|
---------+-------------+
--Хирургия |            1|
--Педиатрия|            1|
--Терапия  |            1|
SELECT 
    wards.name AS ward_name,
    COUNT(patients.id) AS patient_count
FROM wards
LEFT JOIN patients ON wards.id = patients.ward_id
GROUP BY wards.name
HAVING COUNT(patients.id) > 0
ORDER BY patient_count DESC LIMIT 10;

--4. Средняя загрузка палат
--ward_name|patient_count|occupancy_percentage|
---------+-------------+--------------------+
--Педиатрия|            1|               10.00|
--Хирургия |            1|                6.67|
--Терапия  |            1|                5.00|
SELECT 
    wards.name AS ward_name,
    COUNT(patients.id) AS patient_count,
    ROUND(CAST(COUNT(patients.id) AS NUMERIC) / wards.capacity * 100, 2) AS occupancy_percentage
FROM wards
LEFT JOIN patients ON wards.id = patients.ward_id
GROUP BY wards.id
ORDER BY occupancy_percentage DESC LIMIT 10;

--5. Наиболее часто назначаемые лекарства
--medication_name|prescription_count|
---------------+------------------+
--Парацетамол    |                 1|
--Ибупрофен      |                 1|
--Амоксициллин   |                 1|
SELECT 
    medications.name AS medication_name,
    COUNT(prescriptions.id) AS prescription_count
FROM medications
LEFT JOIN prescriptions ON medications.id = prescriptions.medication_id
GROUP BY medications.name
ORDER BY prescription_count DESC
LIMIT 5;

--6. История болезни пациентов (количество диагнозов)
--full_name    |diagnosis_count|
-------------+---------------+
--Иван Смирнов |              1|
--Анна Иванова |              1|
--Мария Петрова|              1|
SELECT 
    patients.first_name || ' ' || patients.last_name AS full_name,
    COUNT(medical_history.id) AS diagnosis_count
FROM patients
LEFT JOIN medical_history ON patients.id = medical_history.patient_id
GROUP BY patients.id
ORDER BY diagnosis_count DESC
LIMIT 10;

--7. Динамика назначений лекарств по месяцам
--month                        |prescription_count|
-----------------------------+------------------+
--2024-11-01 00:00:00.000 +0300|                 3|
SELECT 
    DATE_TRUNC('month', prescriptions.start_date) AS month,
    COUNT(prescriptions.id) AS prescription_count
FROM prescriptions
GROUP BY DATE_TRUNC('month', prescriptions.start_date)
ORDER BY month LIMIT 10;

-- Индексы для ускорения
-- Создадим дополнительные индексы для часто используемых полей.
CREATE INDEX idx_patients_ward_id ON patients(ward_id);
CREATE INDEX idx_prescriptions_medication_id ON prescriptions(medication_id);
CREATE INDEX idx_medications_category_id ON medications(category_id);

-----------
DROP INDEX IF EXISTS idx_patients_ward_id;
DROP INDEX IF EXISTS idx_prescriptions_medication_id;
DROP INDEX IF EXISTS idx_medications_category_id;

-- Удаление таблиц, не зависящих от других
DROP TABLE IF EXISTS patient_contacts;
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS medical_history;
DROP TABLE IF EXISTS staff_schedule;

-- Удаление зависимых таблиц
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS staff;

-- Удаление справочников и таблиц верхнего уровня
DROP TABLE IF EXISTS staff_roles;
DROP TABLE IF EXISTS medication_categories;
DROP TABLE IF EXISTS wards;
DROP TABLE IF EXISTS diagnoses;