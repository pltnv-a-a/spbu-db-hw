------Создание таблиц------

-- Таблица товаров
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Таблица заказов
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    order_date DATE NOT NULL
);

-- Таблица истории изменений
CREATE TABLE changes_history (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    change_type VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

------Создание триггеров------

--1. BEFORE INSERT
--Логирование добавления новых продуктов в таблицу products.

CREATE OR REPLACE FUNCTION before_insert_products()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Adding new product: %', NEW.name;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_on_products
BEFORE INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION before_insert_products();

--2. AFTER UPDATE
--Логирование обновления данных о продукте.

CREATE OR REPLACE FUNCTION after_update_products()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO changes_history (product_id, change_type, old_value, new_value)
    VALUES (
        OLD.id,
        'UPDATE',
        CONCAT('Old Price: ', OLD.price, ', Old Stock: ', OLD.stock_quantity),
        CONCAT('New Price: ', NEW.price, ', New Stock: ', NEW.stock_quantity)
    );
    RETURN NEW; -- Продолжить обновление
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_on_products
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION after_update_products();

--3. INSTEAD OF INSERT (на представление)

-- Создаем представление для заказов
CREATE OR REPLACE VIEW order_summary AS
SELECT o.id AS order_id, p.name AS product_name, o.quantity, o.order_date
FROM orders o
JOIN products p ON o.product_id = p.id;

-- Триггер INSTEAD OF INSERT
CREATE OR REPLACE FUNCTION instead_of_insert_order_summary()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO orders (product_id, quantity, order_date)
    VALUES (
        (SELECT id FROM products WHERE name = NEW.product_name),
        NEW.quantity,
        NEW.order_date
    );
    RETURN NULL; -- Останавливаем дальнейшее выполнение
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instead_of_insert_on_order_summary
INSTEAD OF INSERT ON order_summary
FOR EACH ROW
EXECUTE FUNCTION instead_of_insert_order_summary();

--4. AFTER TRUNCATE (операционный триггер)
--Логирование очистки таблицы orders.

CREATE OR REPLACE FUNCTION after_truncate_orders()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO changes_history (change_type, old_value)
    VALUES ('TRUNCATE', 'All orders deleted');
    RETURN NULL; -- Завершаем
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_truncate_on_orders
AFTER TRUNCATE ON orders
FOR EACH STATEMENT
EXECUTE FUNCTION after_truncate_orders();

------Создание транзакций------

--1. Успешная транзакция

-- Начинаем транзакцию
BEGIN;

-- Добавляем два новых товара
INSERT INTO products (name, price, stock_quantity) 
VALUES ('Laptop', 1200, 50);

INSERT INTO products (name, price, stock_quantity) 
VALUES ('Tablet', 800, 30);

-- Завершаем транзакцию
COMMIT;

-- Результат: оба товара добавлены в таблицу products, 
-- триггер BEFORE INSERT отобразит сообщение о добавлении каждого товара.

--2. Неуспешная транзакция

-- Начинаем транзакцию
BEGIN;

-- Добавляем один новый товар
INSERT INTO products (name, price, stock_quantity) 
VALUES ('Smartphone', 900, 25);

-- Добавляем товар с некорректными данными (отрицательный запас)
INSERT INTO products (name, price, stock_quantity) 
VALUES ('Smartwatch', 500, -10); -- Ошибка из-за проверки данных

-- Откат транзакции
ROLLBACK;

-- Результат: все изменения отменены, ни один товар не добавлен в таблицу products.

------Проверка работы триггеров------

INSERT INTO products (name, price, stock_quantity) 
VALUES ('Headphones', 150, 100);

-- Результат: триггер BEFORE INSERT выведет сообщение:
-- NOTICE: Adding new product: Headphones

UPDATE products 
SET price = 140, stock_quantity = 90
WHERE name = 'Headphones';

-- Результат: триггер AFTER UPDATE создаст запись в changes_history:
-- Тип изменения: UPDATE
-- Старые значения: Old Price: 150, Old Stock: 100
-- Новые значения: New Price: 140, New Stock: 90

INSERT INTO order_summary (product_name, quantity, order_date) 
VALUES ('Headphones', 10, CURRENT_DATE);

-- Результат: триггер INSTEAD OF INSERT создаст запись в таблице orders.
-- В таблицу changes_history изменений не добавляется, 
-- но заказ успешно будет создан.

DELETE FROM products 
WHERE name = 'Headphones';

-- Результат: триггер AFTER DELETE создаст запись в changes_history:
-- Тип изменения: DELETE
-- Старые значения: Name: Headphones, Price: 140, Stock: 90
-- Новые значения: NULL

TRUNCATE TABLE orders;

-- Результат: триггер AFTER TRUNCATE добавит запись в changes_history:
-- Тип изменения: TRUNCATE
-- Старые значения: All orders deleted

------Добавление триггеров с использованием RAISE------

--1. BEFORE INSERT для логирования добавления товаров

CREATE OR REPLACE FUNCTION log_before_insert_on_products()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Inserting new product: % with price: % and stock: %', NEW.name, NEW.price, NEW.stock_quantity;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_on_products2
BEFORE INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_before_insert_on_products();

--2. AFTER UPDATE для логирования обновления товаров

CREATE OR REPLACE FUNCTION log_after_update_on_products()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Product updated: %', NEW.name;
    RAISE NOTICE 'Old Price: %, Old Stock: %', OLD.price, OLD.stock_quantity;
    RAISE NOTICE 'New Price: %, New Stock: %', NEW.price, NEW.stock_quantity;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_on_products2
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_after_update_on_products();

------Проверка работы------

INSERT INTO products (name, price, stock_quantity)
VALUES ('Smartphone', 900, 20);

-- Результат:
-- NOTICE:  Inserting new product: Smartphone with price: 900 and stock: 20

UPDATE products
SET price = 850, stock_quantity = 18
WHERE name = 'Smartphone';

-- Результат:
-- NOTICE:  Product updated: Smartphone
-- NOTICE:  Old Price: 900, Old Stock: 20
-- NOTICE:  New Price: 850, New Stock: 18


-- Удаление триггеров
DROP TRIGGER IF EXISTS before_insert_on_products ON products;
DROP TRIGGER IF EXISTS after_update_on_products ON products;
DROP TRIGGER IF EXISTS before_insert_on_products2 ON products;
DROP TRIGGER IF EXISTS after_update_on_products2 ON products;
DROP TRIGGER IF EXISTS instead_of_insert_on_order_summary ON order_summary;
DROP TRIGGER IF EXISTS after_truncate_on_orders ON orders;

-- Удаление функций
DROP FUNCTION IF EXISTS log_before_insert_on_products;
DROP FUNCTION IF EXISTS log_after_update_on_products;

DROP VIEW IF EXISTS order_summary CASCADE;
DROP TABLE IF EXISTS changes_history CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
