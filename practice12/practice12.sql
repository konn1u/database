create DATABASE practice12;


-- Филиалы
CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    opened_at TIME NOT NULL,
    closed_at TIME NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Сотрудники
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    branch_id INT NOT NULL REFERENCES branches(branch_id) ON DELETE RESTRICT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL CHECK (role IN ('barista', 'manager', 'courier', 'cleaner')),
    salary NUMERIC(10, 2) NOT NULL CHECK (salary >= 0),
    hired_at DATE DEFAULT CURRENT_DATE
);

-- Клиенты
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    loyalty_points INT DEFAULT 0 CHECK (loyalty_points >= 0),
    registered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Категории
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Меню
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    is_available BOOLEAN DEFAULT TRUE
);

-- Ингридиенты
CREATE TABLE ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    unit VARCHAR(10) NOT NULL CHECK (unit IN ('g', 'ml', 'pcs')),
    unit_cost NUMERIC(10, 4) NOT NULL CHECK (unit_cost >= 0)
);

-- Рецепты
CREATE TABLE recipes (
    item_id INT NOT NULL REFERENCES menu_items(item_id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredients(ingredient_id) ON DELETE RESTRICT,
    amount NUMERIC(8, 2) NOT NULL CHECK (amount > 0),
    PRIMARY KEY (item_id, ingredient_id)
);

-- Заказы
CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE SET NULL,
    branch_id INT NOT NULL REFERENCES branches(branch_id) ON DELETE RESTRICT,
    employee_id INT NOT NULL REFERENCES employees(employee_id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' 
        CHECK (status IN ('pending', 'preparing', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Позиции заказа
CREATE TABLE order_items (
    order_item_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    item_id INT NOT NULL REFERENCES menu_items(item_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    CONSTRAINT uq_order_item UNIQUE (order_id, item_id)
);



-- Заполнение таблицы (нейрослоп)




-- Очистка существующих данных с перезапуском счетчиков (аккуратно на проде!)
TRUNCATE TABLE order_items, recipes, orders, menu_items, ingredients, employees, customers, branches RESTART IDENTITY CASCADE;

-- 1. Филиалы (branches)
INSERT INTO branches (name, address, phone, opened_at, closed_at) VALUES
('Центральный', 'ул. Ленина, д. 14', '+7-3462-11-22-33', '07:30', '23:00'),
('Университетский', 'пр-т Мира, д. 42', '+7-3462-44-55-66', '08:00', '22:00'),
('ТЦ Сургут Сити', 'Югорский тракт, д. 38', '+7-3462-77-88-99', '10:00', '22:00'),
('Аэропорт Экспресс', 'ул. Аэрофлотская, д. 50', '+7-3462-99-00-11', '06:00', '00:00');

-- 2. Сотрудники (employees)
INSERT INTO employees (branch_id, first_name, last_name, role, salary, hired_at) VALUES
(1, 'Алексей', 'Морозов', 'manager', 75000.00, '2025-02-10'),
(1, 'Дмитрий', 'Соколов', 'barista', 48000.00, '2025-04-15'),
(1, 'Екатерина', 'Волкова', 'barista', 46000.00, '2025-08-01'),
(2, 'Ольга', 'Смирнова', 'manager', 70000.00, '2025-01-20'),
(2, 'Никита', 'Кузнецов', 'barista', 45000.00, '2025-06-12'),
(2, 'Михаил', 'Попов', 'courier', 42000.00, '2025-09-01'),
(3, 'Анна', 'Лебедева', 'manager', 68000.00, '2025-03-05'),
(3, 'Роман', 'Ковалев', 'barista', 46000.00, '2025-07-22'),
(4, 'Артем', 'Семенов', 'barista', 50000.00, '2025-05-18'),
(4, 'Полина', 'Егорова', 'cleaner', 35000.00, '2025-06-01');

-- 3. Клиенты (customers)
INSERT INTO customers (phone, email, first_name, loyalty_points, registered_at) VALUES
('+79001112233', 'gleb.cyber@example.com', 'Глеб', 240, '2025-09-10 14:20:00'),
('+79123456789', 'ivan.turing@yandex.ru', 'Иван', 85, '2025-10-02 11:15:00'),
('+79224445566', 'maria.art@mail.ru', 'Мария', 510, '2025-08-14 09:30:00'),
('+79825556677', 'denis.code@gmail.com', 'Денис', 0, '2026-01-18 18:45:00'),
('+79508889900', 'sofia.design@inbox.ru', 'София', 130, '2026-02-05 12:00:00'),
('+79612223344', 'timur.dev@list.ru', 'Тимур', 65, '2026-03-12 16:10:00'),
('+79321114455', 'elena.hr@outlook.com', 'Елена', 320, '2025-11-20 10:05:00');

-- 4. Категории меню (categories)
INSERT INTO categories (category_id, name, description) VALUES
(1, 'Кофе', 'Классические и авторские напитки на базе эспрессо'),
(2, 'Чай', 'Листовой черный, зеленый и травяной чай'),
(3, 'Выпечка', 'Свежие круассаны и мучные изделия'),
(4, 'Десерты', 'Торты, чизкейки и пирожные');

SELECT setval('categories_category_id_seq', (SELECT MAX(category_id) FROM categories));

-- 5. Ингредиенты (ingredients)
INSERT INTO ingredients (name, unit, unit_cost) VALUES
('Зерно Колумбия Уила', 'g', 2.1000),      -- id: 1
('Зерно Эфиопия Иргачефф', 'g', 2.4500),  -- id: 2
('Молоко пастеризованное 3.2%', 'ml', 0.0850), -- id: 3
('Овсяное молоко Barista', 'ml', 0.1900), -- id: 4
('Сироп Соленая карамель', 'ml', 0.5500), -- id: 5
('Сироп Ваниль Мадагаскар', 'ml', 0.5000),-- id: 6
('Чай зелёный Сенча', 'g', 1.2000),       -- id: 7
('Круассан классический п/ф', 'pcs', 65.0000), -- id: 8
('Чизкейк Нью-Йорк п/ф', 'pcs', 110.0000),     -- id: 9
('Сливки 10%', 'ml', 0.1600);            -- id: 10

-- 6. Меню (menu_items) — привязка через category_id
INSERT INTO menu_items (item_id, category_id, name, price, is_available) VALUES
(1, 1, 'Эспрессо 30мл', 140.00, TRUE),
(2, 1, 'Капучино 300мл', 240.00, TRUE),
(3, 1, 'Флэт Уайт 200мл', 260.00, TRUE),
(4, 1, 'Латте Карамель 400мл', 310.00, TRUE),
(5, 1, 'Раф Ванильный 300мл', 320.00, TRUE),
(6, 2, 'Зеленый чай Сенча 400мл', 190.00, TRUE),
(7, 3, 'Круассан сливочный', 180.00, TRUE),
(8, 4, 'Чизкейк Нью-Йорк', 260.00, TRUE),
(9, 1, 'Капучино на овсяном 300мл', 290.00, TRUE);

SELECT setval('menu_items_item_id_seq', (SELECT MAX(item_id) FROM menu_items));

-- 7. Рецепты (recipes)
INSERT INTO recipes (item_id, ingredient_id, amount) VALUES
-- Эспрессо: 18г зерна
(1, 1, 18.00),
-- Капучино: 18г зерна + 220мл молока
(2, 1, 18.00),
(2, 3, 220.00),
-- Флэт Уайт: 20г зерна Эфиопия + 140мл молока
(3, 2, 20.00),
(3, 3, 140.00),
-- Латте Карамель: 18г зерна + 280мл молока + 25мл сиропа
(4, 1, 18.00),
(4, 3, 280.00),
(4, 5, 25.00),
-- Раф Ванильный: 18г зерна + 180мл сливок + 20мл сиропа
(5, 1, 18.00),
(5, 10, 180.00),
(5, 6, 20.00),
-- Зеленый чай: 6г чая
(6, 7, 6.00),
-- Круассан: 1 шт
(7, 8, 1.00),
-- Чизкейк: 1 шт
(8, 9, 1.00),
-- Капучино на овсяном: 18г зерна + 220мл овсяного молока
(9, 1, 18.00),
(9, 4, 220.00);

-- 8. Заказы (orders) — колонка total_price удалена
INSERT INTO orders (order_id, customer_id, branch_id, employee_id, status, created_at) VALUES
(101, 1, 1, 2, 'completed', '2026-03-10 08:15:00+03'),
(102, 2, 1, 3, 'completed', '2026-03-10 09:40:00+03'),
(103, NULL, 2, 5, 'completed', '2026-03-10 11:20:00+03'),
(104, 3, 2, 5, 'completed', '2026-03-10 13:05:00+03'),
(105, 4, 3, 8, 'completed', '2026-03-11 12:10:00+03'),
(106, 5, 1, 2, 'completed', '2026-03-11 15:30:00+03'),
(107, NULL, 4, 9, 'completed', '2026-03-11 17:45:00+03'),
(108, 1, 1, 3, 'completed', '2026-03-12 08:30:00+03'),
(109, 7, 2, 5, 'completed', '2026-03-12 14:15:00+03'),
(110, 6, 3, 8, 'preparing', '2026-03-12 16:00:00+03'),
(111, NULL, 1, 2, 'cancelled', '2026-03-12 16:20:00+03');

SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));

-- 9. Состав заказа (order_items)
INSERT INTO order_items (order_id, item_id, quantity, unit_price) VALUES
-- Заказ 101: Капучино (240) + Круассан (180)
(101, 2, 1, 240.00),
(101, 7, 1, 180.00),

(102, 2, 1, 240.00),-- Заказ 102: Капучино (240)

(103, 5, 1, 310.00),-- Заказ 103: Раф Ванильный (310) + Чизкейк (260)
(103, 8, 1, 260.00),

(104, 3, 2, 260.00),-- Заказ 104: 2x Флэт Уайт (260 * 2)

(105, 7, 1, 180.00),-- Заказ 105: Круассан (180)

(106, 5, 1, 320.00),-- Заказ 106: Раф Ванильный (320) + Чизкейк (260)
(106, 8, 1, 260.00),

(107, 9, 1, 290.00),-- Заказ 107: Капучино на овсяном (290)

(108, 3, 1, 260.00),-- Заказ 108: Флэт Уайт (260)

(109, 2, 2, 240.00),-- Заказ 109: 2x Капучино (240*2) + 2x Круассан (180*2)
(109, 7, 2, 180.00),

(110, 4, 1, 310.00),-- Заказ 110: Латте Карамель (310)

(111, 1, 1, 140.00);-- Заказ 111: Эспрессо (140)