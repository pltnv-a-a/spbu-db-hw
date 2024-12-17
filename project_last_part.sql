----Вставка кода с созданием и заполнением таблиц----


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

-- Создаем представление для пациентов
CREATE OR REPLACE VIEW patients_view AS
SELECT 
    id,
    first_name,
    last_name,
    birth_date,
    gender,
    ward_id,
    diagnoses_id
FROM 
    patients;

----Конец вставки----

--1. Триггеры со всеми ключевыми словами

-- Таблица логирования изменений
CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP DEFAULT NOW(),
    event_type VARCHAR(50),
    description TEXT
);

-- BEFORE INSERT: Запрещаем добавление медикаментов без категории
CREATE OR REPLACE FUNCTION check_medication_category()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.category_id IS NULL THEN
        RAISE EXCEPTION 'Категория медикамента не указана!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_medication_insert
BEFORE INSERT ON medications
FOR EACH ROW
EXECUTE FUNCTION check_medication_category();


-- AFTER INSERT: Логируем добавление пациента
CREATE OR REPLACE FUNCTION log_patient_insertion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs(event_type, description)
    VALUES ('INSERT', 'Добавлен новый пациент: ' || NEW.first_name || ' ' || NEW.last_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_patient_insert
AFTER INSERT ON patients
FOR EACH ROW
EXECUTE FUNCTION log_patient_insertion();


-- BEFORE INSERT OR UPDATE: Обновляем число свободных мест в палатах
CREATE OR REPLACE FUNCTION update_ward_capacity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ward_id IS DISTINCT FROM OLD.ward_id THEN
        -- Увеличиваем доступные места в старой палате
        UPDATE wards
        SET capacity = capacity + 1
        WHERE id = OLD.ward_id;

        -- Уменьшаем доступные места в новой палате
        UPDATE wards
        SET capacity = capacity - 1
        WHERE id = NEW.ward_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_patient_update
BEFORE INSERT OR UPDATE OF ward_id ON patients
FOR EACH ROW
EXECUTE FUNCTION update_ward_capacity();


-- AFTER DELETE: Логируем удаление пациентов
CREATE OR REPLACE FUNCTION log_patient_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs(event_type, description)
    VALUES ('DELETE', 'Удален пациент с ID ' || OLD.id);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_patient_delete
AFTER DELETE ON patients
FOR EACH ROW
EXECUTE FUNCTION log_patient_deletion();


-- INSTEAD OF UPDATE: Обновляем представление пациентов
-- Функция для обработки обновлений представления
CREATE OR REPLACE FUNCTION update_patients_view()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE patients
    SET first_name = NEW.first_name,
        last_name = NEW.last_name,
        birth_date = NEW.birth_date,
        gender = NEW.gender,
        ward_id = NEW.ward_id,
        diagnoses_id = NEW.diagnoses_id
    WHERE id = OLD.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер INSTEAD OF UPDATE для представления patients_view
CREATE TRIGGER instead_of_update_patients
INSTEAD OF UPDATE ON patients_view
FOR EACH ROW
EXECUTE FUNCTION update_patients_view();

--2. Операционные триггеры

-- Обновление статуса пациента на основании возраста
CREATE OR REPLACE FUNCTION auto_update_patient_category()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT(YEAR FROM AGE(NEW.birth_date)) >= 65 THEN
        NEW.ward_id = 1; -- Переводим в палату терапии
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_patient_insert_update
BEFORE INSERT OR UPDATE ON patients
FOR EACH ROW
EXECUTE FUNCTION auto_update_patient_category();

--3. Пример транзакций

BEGIN;

-- Добавляем нового пациента
INSERT INTO patients (first_name, last_name, birth_date, gender, ward_id, diagnoses_id)
VALUES ('Алексей', 'Новиков', '1960-12-15', 'Male', 1, 1);

-- Фиксируем изменения
COMMIT;

--4. Логирование с RAISE

CREATE OR REPLACE FUNCTION log_with_raise()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Событие: % -> ID записи: %', TG_OP, NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_patient_operations
AFTER INSERT OR UPDATE ON patients
FOR EACH ROW
EXECUTE FUNCTION log_with_raise();

--5. Дополнительное улучшение

--Добавим автоматическое удаление старых записей в логах (архивация).
--Создадим расписание вызова pg_cron для очистки записей, старше 90 дней:
CREATE OR REPLACE FUNCTION clean_old_logs()
RETURNS VOID AS $$
BEGIN
    DELETE FROM logs WHERE event_time < NOW() - INTERVAL '90 days';
END;
$$ LANGUAGE plpgsql;

-- Планировщик задач (pg_cron должен быть установлен)
-- SELECT cron.schedule('0 0 * * *', $$CALL clean_old_logs();$$);

--6. Тестирование триггеров

--Проверка триггера INSTEAD OF UPDATE на представлении patients_view
UPDATE patients_view
SET first_name = 'Обновленный',
    last_name = 'Пациент'
WHERE id = 1;

SELECT * FROM patients WHERE id = 1 LIMIT 10;
SELECT * FROM patients_view WHERE id = 1 LIMIT 10;

--Тестирование операционных триггеров
INSERT INTO patients (first_name, last_name, birth_date, gender, ward_id, diagnoses_id)
VALUES ('Новый', 'Пациент', '2000-01-01', 'Male', 1, 1);

SELECT capacity FROM wards WHERE id = 1 LIMIT 10;

-- Удаление триггеров и функций
DROP TRIGGER IF EXISTS before_medication_insert ON medications;
DROP TRIGGER IF EXISTS after_patient_insert ON patients;
DROP TRIGGER IF EXISTS before_patient_update ON patients;
DROP TRIGGER IF EXISTS after_patient_delete ON patients;
DROP TRIGGER IF EXISTS instead_of_update_patients ON patients_view;
DROP TRIGGER IF EXISTS before_patient_insert_update ON patients;
DROP TRIGGER IF EXISTS log_patient_operations ON patients;

DROP FUNCTION IF EXISTS check_medication_category();
DROP FUNCTION IF EXISTS log_patient_insertion();
DROP FUNCTION IF EXISTS update_ward_capacity();
DROP FUNCTION IF EXISTS log_patient_deletion();
DROP FUNCTION IF EXISTS update_patients_view();
DROP FUNCTION IF EXISTS auto_update_patient_category();
DROP FUNCTION IF EXISTS log_with_raise();
DROP FUNCTION IF EXISTS clean_old_logs();

-- Удаление представлений
DROP VIEW IF EXISTS patients_view CASCADE;

-- Удаление индексов
DROP INDEX IF EXISTS idx_patients_ward_id;
DROP INDEX IF EXISTS idx_prescriptions_medication_id;
DROP INDEX IF EXISTS idx_medications_category_id;

-- Удаление таблиц
DROP TABLE IF EXISTS logs CASCADE;
DROP TABLE IF EXISTS staff_schedule CASCADE;
DROP TABLE IF EXISTS medical_history CASCADE;
DROP TABLE IF EXISTS patient_contacts CASCADE;
DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS medications CASCADE;
DROP TABLE IF EXISTS medication_categories CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS staff_roles CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS diagnoses CASCADE;
DROP TABLE IF EXISTS wards CASCADE;

-- Удаление задач pg_cron
--SELECT cron.unschedule(jobid) FROM cron.job;