-- Создание таблицы courses
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_exam BOOLEAN NOT NULL,
    min_grade VARCHAR(2) NOT NULL,
    max_grade VARCHAR(2) NOT NULL
);

-- Заполнение таблицы courses
INSERT INTO courses (name, is_exam, min_grade, max_grade)
VALUES
    ('Алгебра', TRUE, '2', '5'),
    ('Математический анализ', TRUE, '2', '5'),
    ('Геометрия', TRUE, '2', '5'),
    ('Логика', FALSE, 'F', 'A');

-- Создание таблицы groups
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    short_name VARCHAR(50) NOT NULL,
    students_ids INTEGER[] NOT NULL
);

-- Заполнение таблицы groups
INSERT INTO groups (full_name, short_name, students_ids)
VALUES
    ('23б13', '2313', ARRAY[1, 2]),
    ('24м01', '241', ARRAY[3]),
    ('23м01', '231', ARRAY[4]);

-- Создание таблицы students
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    group_id INTEGER REFERENCES groups(id),
    courses_ids INTEGER[] NOT NULL
);

-- Заполнение таблицы students
INSERT INTO students (first_name, last_name, group_id, courses_ids)
VALUES
    ('Маша', 'Миронова', 1, ARRAY[1, 2, 3, 4]),
    ('Пётр', 'Гринёв', 1, ARRAY[1, 2, 3, 4]),
    ('Емельян', 'Пугачёв', 2, ARRAY[1, 2, 3, 4]),
    ('Татьяна', 'Ларина', 3, ARRAY[1, 2, 3, 4]);

-- Создание таблицы algebra
CREATE TABLE algebra (
    student_id INTEGER REFERENCES students(id),
    grade INTEGER CHECK (grade BETWEEN 2 AND 5),
    grade_str VARCHAR(20)
);

-- Заполнение таблицы algebra с оценками для студентов
INSERT INTO algebra (student_id, grade, grade_str)
VALUES
    (1, 2, 'неудовлетворительно'),
    (1, 3, 'удовлетворительно'),
    (2, 4, 'хорошо'),
    (2, 5, 'отлично'),
    (3, 2, 'неудовлетворительно'),
    (4, 5, 'отлично');
    
-- Фильтрация: Запрос на получение всех студентов из 
-- группы 23б13 с оценкой 5 по предмету "Алгебра".
-- Вывод: Пётр Гринёв 5 отлично
SELECT s.first_name, s.last_name, a.grade, a.grade_str
FROM students as s
JOIN algebra as a ON s.id = a.student_id
JOIN groups as g ON s.group_id = g.id
WHERE g.full_name = '23б13' AND a.grade = 5;

-- Агрегация: Подсчёт среднего балла по алгебре для каждого студента.
-- Используем функцию AVG для расчёта значений на уровне групп данных. 
-- Группировка выполняется с помощью GROUP BY.
-- Вывод: 
-- first_name|last_name|average_grade     |
----------+---------+------------------+
-- Татьяна   |Ларина   |5.0000000000000000|
-- Пётр      |Гринёв   |4.5000000000000000|
-- Маша      |Миронова |2.5000000000000000|
-- Емельян   |Пугачёв  |2.0000000000000000|

SELECT s.first_name, s.last_name, AVG(a.grade) AS average_grade
FROM students as s
JOIN algebra as a ON s.id = a.student_id
GROUP BY s.id
;

-- Фильтрация и агрегация: Подсчёт количества студентов с оценками 
-- "неудовлетворительно" по алгебре в каждой группе.
-- Вывод: full_name|excellent_count|
---------+---------------+
-- 23б13    |              1|
-- 24м01    |              1|
SELECT g.full_name, COUNT(*) AS excellent_count
FROM students as s
JOIN algebra as a ON s.id = a.student_id
JOIN groups as g ON s.group_id = g.id
WHERE a.grade_str = 'неудовлетворительно'
GROUP BY g.full_name;

DROP TABLE IF EXISTS algebra;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS courses;



