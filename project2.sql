----Вставка кода из предыдущего задания----

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

-- Индексы для ускорения
-- Создадим дополнительные индексы для часто используемых полей.
CREATE INDEX idx_patients_ward_id ON patients(ward_id);
CREATE INDEX idx_prescriptions_medication_id ON prescriptions(medication_id);
CREATE INDEX idx_medications_category_id ON medications(category_id);

----Конец вставки----

--1. Временные таблицы
--Создадим временную таблицу для пациентов, у которых есть текущие назначения медикаментов.

-- Создание временной таблицы
CREATE TEMP TABLE temp_active_prescriptions AS
SELECT 
    p.id AS patient_id,
    p.first_name || ' ' || p.last_name AS full_name,
    pr.medication_id,
    pr.start_date,
    pr.end_date
FROM patients p
JOIN prescriptions pr ON p.id = pr.patient_id
WHERE CURRENT_DATE BETWEEN pr.start_date AND pr.end_date LIMIT 10;

-- Посмотрим содержимое временной таблицы
-- Пусто, активных назначений нет
SELECT * FROM temp_active_prescriptions LIMIT 10;

--2. CTE (Common Table Expressions)
--CTE для подсчета среднего возраста пациентов в разрезе пола.
--gender|avg_age|total_patients|
------+-------+--------------+
--Female|   24.0|             2|
--Male  |   39.0|             1|
WITH age_data AS (
    SELECT 
        gender,
        DATE_PART('year', AGE(birth_date)) AS age
    FROM patients
)
SELECT 
    gender,
    AVG(age) AS avg_age,
    COUNT(*) AS total_patients
FROM age_data
GROUP BY gender LIMIT 10;

--3. Иерархическая структура
--Создадим иерархическую структуру ролей персонала. Например, роли можно разбить на уровни.

-- Обновим таблицу staff_roles для добавления родительской роли
ALTER TABLE staff_roles ADD COLUMN parent_role_id INTEGER REFERENCES staff_roles(id);

-- Добавим связи
UPDATE staff_roles
SET parent_role_id = NULL WHERE role_name = 'Доктор'; -- Главная роль
UPDATE staff_roles
SET parent_role_id = (SELECT id FROM staff_roles WHERE role_name = 'Доктор') 
WHERE role_name IN ('Хирург', 'Терапевт');
UPDATE staff_roles
SET parent_role_id = (SELECT id FROM staff_roles WHERE role_name = 'Терапевт') 
WHERE role_name = 'Медсестра';

-- Иерархический запрос
--id|role_name|parent_role_id|
----+---------+--------------+
-- 1|Доктор   |              |
-- 3|Хирург   |             1|
-- 4|Терапевт |             1|
-- 2|Медсестра|             4|
WITH RECURSIVE role_hierarchy AS (
    SELECT id, role_name, parent_role_id
    FROM staff_roles
    WHERE parent_role_id IS NULL
    UNION ALL
    SELECT sr.id, sr.role_name, sr.parent_role_id
    FROM staff_roles sr
    JOIN role_hierarchy rh ON sr.parent_role_id = rh.id
)
SELECT * FROM role_hierarchy LIMIT 10;

--4. Проверка влияния индекса на производительность
--Сравним время выполнения запроса с индексом и без индекса.

-- Включаем трассировку для анализа
--Planning Time: 0.085 ms 
--Execution Time: 0.026 ms
EXPLAIN ANALYZE 
SELECT * 
FROM prescriptions 
WHERE medication_id = 1 LIMIT 10;

-- Удаляем индекс и повторяем запрос
DROP INDEX IF EXISTS idx_prescriptions_medication_id;

--Planning Time: 0.371 ms 
--Execution Time: 0.039 ms
EXPLAIN ANALYZE 
SELECT * 
FROM prescriptions 
WHERE medication_id = 1 LIMIT 10;

-- Создаём индекс обратно
CREATE INDEX idx_prescriptions_medication_id ON prescriptions(medication_id);

--5. Представление
--Создадим представление для частого запроса: список пациентов с назначениями и данными о медикаментах.

CREATE VIEW vw_patient_prescriptions AS
SELECT 
    p.id AS patient_id,
    p.first_name || ' ' || p.last_name AS full_name,
    m.name AS medication_name,
    pr.dosage,
    pr.start_date,
    pr.end_date
FROM patients p
JOIN prescriptions pr ON p.id = pr.patient_id
JOIN medications m ON pr.medication_id = m.id LIMIT 10;

-- Использование представления
--patient_id|full_name   |medication_name|dosage|start_date|end_date  
------------+------------+---------------+------+----------+----------
--         1|Анна Иванова|Парацетамол    |500 мг|2024-11-01|2024-11-10
SELECT * FROM vw_patient_prescriptions WHERE medication_name = 'Парацетамол' LIMIT 10;

--6. Валидация запросов
--Добавим валидацию для предотвращения некорректных данных:

--Проверка на пересечение интервалов назначений медикаментов:
--(всё в порядке)
SELECT 
    p.id AS patient_id,
    p.first_name || ' ' || p.last_name AS full_name,
    pr1.start_date, pr1.end_date, pr2.start_date, pr2.end_date
FROM prescriptions pr1
JOIN prescriptions pr2 ON pr1.patient_id = pr2.patient_id AND pr1.id != pr2.id
JOIN patients p ON p.id = pr1.patient_id
WHERE pr1.start_date <= pr2.end_date AND pr1.end_date >= pr2.start_date LIMIT 10;

--Проверка на некорректные временные интервалы:
--(всё в порядке)
SELECT * 
FROM staff_schedule
WHERE shift_start >= shift_end LIMIT 10;

--7. Параметризация запросов
--Для повышения безопасности и производительности запросы можно параметризовать.
PREPARE get_patients_by_ward(INT) AS
SELECT id, first_name, last_name 
FROM patients
WHERE ward_id = $1 LIMIT 10;

-- Использование подготовленного запроса
--id|first_name|last_name|
----+----------+---------+
-- 2|Иван      |Смирнов  |
EXECUTE get_patients_by_ward(2);

----

DEALLOCATE get_patients_by_ward;

DROP INDEX IF EXISTS idx_patients_ward_id;
DROP INDEX IF EXISTS idx_prescriptions_medication_id;
DROP INDEX IF EXISTS idx_medications_category_id;

DROP VIEW IF EXISTS vw_active_prescriptions;

DROP TABLE IF exists temp_active_prescriptions;

DROP TABLE IF EXISTS staff_schedule CASCADE;
DROP TABLE IF EXISTS medical_history CASCADE;
DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS patient_contacts CASCADE;

DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS staff_roles CASCADE;

DROP TABLE IF EXISTS medications CASCADE;
DROP TABLE IF EXISTS medication_categories CASCADE;

DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS diagnoses CASCADE;
DROP TABLE IF EXISTS wards CASCADE;