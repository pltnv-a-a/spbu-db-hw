--Вставка кода с семинара
-------------------------
CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    manager_id INT REFERENCES employees(employee_id)
);

-- Пример данных
INSERT INTO employees (name, position, department, salary, manager_id)
VALUES
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Frank Miller', 'Intern', 'IT', 35000, 5);


CREATE TABLE IF NOT EXISTS sales(
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_date DATE NOT NULL
);

-- Пример данных
INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES
    (2, 1, 20, '2024-11-13'),
    (2, 2, 15, '2024-11-12'),
    (3, 1, 10, '2024-11-11'),
    (3, 3, 5, '2024-11-10'),
    (4, 2, 8, '2024-11-9'),
    (2, 1, 12, '2024-11-8');



CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

-- Пример данных
INSERT INTO products (name, price)
VALUES
    ('Product A', 150.00),
    ('Product B', 200.00),
    ('Product C', 100.00);
   
INSERT INTO employees (name, position, department, salary, manager_id)
VALUES
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Frank Miller', 'Intern', 'IT', 35000, 5);
   
---------------------
--Начало домашнего задания
   
   
--Создадим временную таблицу high_sales_products, 
--которая будет содержать продукты, проданные в 
--количестве более 10 единиц за последние 7 дней   
CREATE TEMP TABLE high_sales_products AS
SELECT p.name AS product_name, s.quantity, s.sale_date
FROM sales AS s
JOIN products AS p ON s.product_id = p.product_id
WHERE s.quantity > 10 AND s.sale_date >= CURRENT_DATE - INTERVAL '7 days';

-- Запрос для вывода данных из таблицы high_sales_products
-- Вывод:
-- product_name|quantity|sale_date 
------------+--------+----------
--Product A   |      20|2024-11-13
--Product B   |      15|2024-11-12
--Product A   |      12|2024-11-08
SELECT * FROM high_sales_products LIMIT 10;

--Создадим CTE, который посчитает общее и среднее 
--количество продаж для каждого сотрудника за последние
-- 30 дней. Далее выведем сотрудников с количеством продаж 
-- выше среднего по компании
WITH employee_sales_stats AS (
    SELECT 
        s.employee_id,
        e.name AS employee_name,
        COUNT(*) AS total_sales,
        AVG(s.quantity) AS avg_sales
    FROM sales AS s
    JOIN employees AS e ON s.employee_id = e.employee_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY s.employee_id, e.name
)

-- Запрос на вывод сотрудников с количеством продаж выше среднего по компании
-- Вывод: 
-- employee_name|total_sales|
-------------+-----------+
-- Bob Smith    |          3|
SELECT employee_name, total_sales
FROM employee_sales_stats
WHERE total_sales > (SELECT AVG(total_sales) FROM employee_sales_stats) LIMIT 10;

-- Иерархический CTE для структуры подчинения сотрудников
WITH RECURSIVE employee_hierarchy AS (
    SELECT e.employee_id, e.name, e.manager_id, e.position
    FROM employees AS e
    WHERE e.manager_id IS NULL  -- Начинаем с топ-менеджеров

    UNION ALL

    SELECT e.employee_id, e.name, e.manager_id, e.position
    FROM employees AS e
    JOIN employee_hierarchy AS eh ON e.manager_id = eh.employee_id
)

-- Запрос для отображения иерархии подчинённых для конкретного менеджера, например,
-- manager_id = 1
-- Вывод:
-- employee_id|name     |manager_id|position       |
-----------+---------+----------+---------------+
--          2|Bob Smith|         1|Sales Associate|
--          3|Carol Lee|         1|Sales Associate|
--          8|Bob Smith|         1|Sales Associate|
--          9|Carol Lee|         1|Sales Associate|
--         13|Bob Smith|         1|Sales Associate|
--         14|Carol Lee|         1|Sales Associate|
--       18|Bob Smith|         1|Sales Associate|
--       19|Carol Lee|         1|Sales Associate|
--       23|Bob Smith|         1|Sales Associate|
--       24|Carol Lee|         1|Sales Associate|
SELECT * FROM employee_hierarchy WHERE manager_id = 1 LIMIT 10;

-- CTE для топ-3 продуктов за текущий и прошлый месяц
WITH monthly_top_products AS (
    SELECT 
        p.name AS product_name,
        DATE_TRUNC('month', s.sale_date) AS sale_month,
        SUM(s.quantity) AS total_quantity,
        RANK() OVER (PARTITION BY DATE_TRUNC('month', s.sale_date) ORDER BY SUM(s.quantity) DESC) AS rank
    FROM sales AS s
    JOIN products AS p ON s.product_id = p.product_id
    WHERE s.sale_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    GROUP BY p.name, DATE_TRUNC('month', s.sale_date)
)

-- Запрос на вывод топ-3 продуктов
-- Вывод:
--product_name|sale_month                   |total_quantity
------------+-----------------------------+--------------
--Product A   |2024-11-01 00:00:00.000 +0300|            42
--Product B   |2024-11-01 00:00:00.000 +0300|            23
--Product C   |2024-11-01 00:00:00.000 +0300|             5
SELECT product_name, sale_month, total_quantity
FROM monthly_top_products
WHERE rank <= 3;

-- Создадим индекс по полям employee_id и sale_date, чтобы ускорить запросы, 
-- фильтрующие данные по сотрудникам и датам. После создания индекса 
-- используем EXPLAIN ANALYZE для проверки влияния на производительность.
CREATE INDEX idx_sales_employee_date ON sales (employee_id, sale_date);

DROP INDEX idx_sales_employee_date;

-- Запрос для проверки производительности с использованием индекса
-- Вывод: 
--Planning Time: 1.187 ms с индексом  
--Execution Time: 0.035 ms с индексом
--Planning Time: 0.371 ms без индекса  
--Execution Time: 0.034 ms без индекса
EXPLAIN ANALYZE 
SELECT * FROM sales 
WHERE employee_id = 2 AND sale_date BETWEEN '2024-11-01' AND '2024-11-30' LIMIT 10;

-- Запрос с анализом на нахождение общего количества проданных единиц каждого продукта
-- Вывод: 
--Planning Time: 0.247 ms с индексом   
--Execution Time: 0.120 ms с индексом
--Planning Time: 0.257 ms без индекса 
--Execution Time: 0.184 ms без индекса
EXPLAIN ANALYZE 
SELECT p.name AS product_name, SUM(s.quantity) AS total_sold
FROM sales AS s
JOIN products AS p ON s.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC LIMIT 10;


DROP TABLE IF EXISTS employees, sales, products, high_sales_products CASCADE;