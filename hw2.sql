 -- Создаем таблицу student_courses для связи студентов и курсов
CREATE TABLE student_courses (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    course_id INTEGER REFERENCES courses(id),
    UNIQUE(student_id, course_id)  -- гарантирует уникальные связи студента и курса
);

-- Заполнение таблицы student_courses
INSERT INTO student_courses (student_id, course_id)
VALUES
    (1, 1), (1, 2), (1, 3), (1, 4),
    (2, 1), (2, 2), (2, 3), (2, 4),
    (3, 1), (3, 2), (3, 3), (3, 4),
    (4, 1), (4, 2), (4, 3), (4, 4);

-- Создаем таблицу group_courses для связи групп и курсов
CREATE TABLE group_courses (
    id SERIAL PRIMARY KEY,
    group_id INTEGER REFERENCES groups(id),
    course_id INTEGER REFERENCES courses(id),
    UNIQUE(group_id, course_id)  -- гарантирует уникальные связи группы и курса
);

-- Заполнение таблицы group_courses
INSERT INTO group_courses (group_id, course_id)
VALUES
    (1, 1), (1, 2), (1, 3), (1, 4),
    (2, 1), (2, 2), (2, 3), (2, 4),
    (3, 1), (3, 2), (3, 3), (3, 4);
    
-- Удаляем поле courses_ids из таблицы students, так как теперь связь хранится
-- в student_courses
ALTER TABLE students
DROP COLUMN courses_ids;

-- Добавляем уникальное ограничение на поле name в таблице courses для 
-- предотвращения дублирующих названий курсов:
ALTER TABLE courses
ADD CONSTRAINT unique_course_name UNIQUE (name);

-- Создаем индекс на поле group_id в таблице students для повышения производительности запросов,
-- которые используют поле group_id для фильтрации и объединения таблиц
CREATE INDEX idx_students_group_id ON students(group_id);

-- Пока у нас есть только оценки по алгебре. Создадим таблицы для остальных курсов

-- Создаем таблицу для оценок по логике с буквенной шкалой
CREATE TABLE logic (
    student_id INTEGER REFERENCES students(id),
    grade CHAR(1) CHECK (grade IN ('F', 'E', 'D', 'C', 'B', 'A')),
    grade_str VARCHAR(20)
);

-- Заполнение таблицы logic с оценками для студентов
INSERT INTO logic (student_id, grade, grade_str)
VALUES
    (1, 'E', 'удовлетворительно'),
    (2, 'B', 'хорошо'),
    (3, 'F', 'неудовлетворительно'),
    (4, 'A', 'отлично');

-- Создаем таблицу для оценок по математическому анализу
CREATE TABLE analysis (
    student_id INTEGER REFERENCES students(id),
    grade INTEGER CHECK (grade BETWEEN 2 AND 5),
    grade_str VARCHAR(20)
);

-- Заполнение таблицы analysis с оценками для студентов
INSERT INTO analysis (student_id, grade, grade_str)
VALUES
    (1, 3, 'удовлетворительно'),
    (2, 4, 'хорошо'),
    (3, 2, 'неудовлетворительно'),
    (4, 5, 'отлично');

-- Создаем таблицу для оценок по геометрии
CREATE TABLE geometry (
    student_id INTEGER REFERENCES students(id),
    grade INTEGER CHECK (grade BETWEEN 2 AND 5),
    grade_str VARCHAR(20)
);

-- Заполнение таблицы geometry с оценками для студентов
INSERT INTO geometry (student_id, grade, grade_str)
VALUES
    (1, 4, 'хорошо'),
    (2, 5, 'отлично'),
    (3, 3, 'удовлетворительно'),
    (4, 5, 'отлично');
   
 -- Запрос для списка всех студентов с их курсами из разных таблиц
-- Вывод 
-- first_name|last_name|course_name          |
----------+---------+---------------------+
-- Пётр      |Гринёв   |Алгебра              |
-- Пётр      |Гринёв   |Геометрия            |
-- Пётр      |Гринёв   |Логика               |
-- Пётр      |Гринёв   |Математический анализ|
-- Татьяна   |Ларина   |Алгебра              |
-- Татьяна   |Ларина   |Геометрия            |
-- Татьяна   |Ларина   |Логика               |
-- Татьяна   |Ларина   |Математический анализ|
-- Маша      |Миронова |Алгебра              |
-- Маша      |Миронова |Геометрия            |
-- Маша      |Миронова |Логика               |
-- Маша      |Миронова |Математический анализ|
-- Емельян   |Пугачёв  |Алгебра              |
-- Емельян   |Пугачёв  |Геометрия            |
-- Емельян   |Пугачёв  |Логика               |
-- Емельян   |Пугачёв  |Математический анализ|
SELECT s.first_name, s.last_name, c.name AS course_name
FROM students AS s
JOIN student_courses AS sc ON s.id = sc.student_id
JOIN courses AS c ON sc.course_id = c.id
ORDER BY s.last_name, s.first_name, c.name limit 16;

-- Запрос для нахождения студентов с наивысшей средней оценкой в их группе
-- Так как у нас есть числовые и буквенные оценки, будем работать только с 
-- числовыми оценками (из таблиц algebra, analysis, и geometry). 
-- Рассчитаем среднюю оценку для студентов и сравним ее с максимальными средними оценками в их группах.
-- Вывод:
-- first_name|last_name|group_name|average_grade     |
----------+---------+----------+------------------+
-- Пётр      |Гринёв   |23б13     |4.5000000000000000|
-- Емельян   |Пугачёв  |24м01     |2.3333333333333333|
-- Татьяна   |Ларина   |23м01     |5.0000000000000000|
SELECT s.first_name, s.last_name, g.full_name AS group_name, AVG(grade) AS average_grade
FROM students AS s
JOIN groups AS g ON s.group_id = g.id
LEFT JOIN (
    SELECT student_id, grade
    FROM algebra
    UNION ALL
    SELECT student_id, grade
    FROM analysis
    UNION ALL
    SELECT student_id, grade
    FROM geometry
) AS all_grades ON s.id = all_grades.student_id
GROUP BY s.id, g.id
HAVING AVG(grade) >= ALL (
    SELECT AVG(grade)
    FROM students AS s2
    JOIN groups AS g2 ON s2.group_id = g2.id
    LEFT JOIN (
        SELECT student_id, grade
        FROM algebra 
        UNION ALL
        SELECT student_id, grade
        FROM analysis 
        UNION ALL
        SELECT student_id, grade
        FROM geometry 
    ) AS all_grades2 ON s2.id = all_grades2.student_id
    WHERE g2.id = g.id
    GROUP BY s2.id
);

-- Подсчет количества студентов на каждом курсе
-- Вывод:
-- course_name          |student_count|
---------------------+-------------+
-- Алгебра              |            4|
-- Геометрия            |            4|
-- Логика               |            4|
-- Математический анализ|            4|
SELECT c.name AS course_name, COUNT(sc.student_id) AS student_count
FROM courses AS c
JOIN student_courses AS sc ON c.id = sc.course_id
GROUP BY c.id;

-- Подсчет средней оценки на каждом курсе:
-- course_name          |average_grade     |
---------------------+------------------+
-- Алгебра              |3.5000000000000000|
-- Математический анализ|3.5000000000000000|
-- Геометрия            |4.2500000000000000|
SELECT 'Алгебра' AS course_name, AVG(grade) AS average_grade
FROM algebra
UNION ALL
SELECT 'Математический анализ', AVG(grade)
FROM analysis
UNION ALL
SELECT 'Геометрия', AVG(grade)
FROM geometry;

DROP TABLE IF EXISTS student_courses CASCADE;
DROP TABLE IF EXISTS group_courses CASCADE;
DROP TABLE IF EXISTS logic CASCADE;
DROP TABLE IF EXISTS analysis CASCADE;
DROP TABLE IF EXISTS geometry CASCADE;
DROP TABLE IF EXISTS algebra CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS courses CASCADE;