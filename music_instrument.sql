

DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS customer_order CASCADE;
DROP TABLE IF EXISTS sale_item CASCADE;
DROP TABLE IF EXISTS sale CASCADE;
DROP TABLE IF EXISTS supply_item CASCADE;
DROP TABLE IF EXISTS supply CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS brand CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;



-- 1. СОЗДАНИЕ ТАБЛИЦ


CREATE TABLE category (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE brand (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(100)
);

CREATE TABLE customer (
    id BIGSERIAL PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255),
    registration_date DATE NOT NULL
);

CREATE TABLE employee (
    id BIGSERIAL PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE supplier (
    id BIGSERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(500),
    contact_person VARCHAR(255)
);

CREATE TABLE product (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    retail_price DECIMAL(10,2) NOT NULL CHECK (retail_price > 0),
    quantity_in_stock INT NOT NULL DEFAULT 0 CHECK (quantity_in_stock >= 0),
    minimum_stock INT DEFAULT 0,
    category_id BIGINT,
    brand_id BIGINT,
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES brand(id) ON DELETE SET NULL
);

CREATE TABLE supply (
    id BIGSERIAL PRIMARY KEY,
    supply_date DATE NOT NULL,
    supplier_id BIGINT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON DELETE CASCADE
);

CREATE TABLE supply_item (
    id BIGSERIAL PRIMARY KEY,
    supply_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    purchase_price DECIMAL(10,2) NOT NULL CHECK (purchase_price >= 0),
    FOREIGN KEY (supply_id) REFERENCES supply(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

CREATE TABLE sale (
    id BIGSERIAL PRIMARY KEY,
    datetime TIMESTAMP NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    customer_id BIGINT,
    employee_id BIGINT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE RESTRICT
);

CREATE TABLE sale_item (
    id BIGSERIAL PRIMARY KEY,
    sale_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_sale DECIMAL(10,2) NOT NULL CHECK (price_at_sale >= 0),
    FOREIGN KEY (sale_id) REFERENCES sale(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

CREATE TABLE customer_order (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    order_datetime TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Принят',
    FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

CREATE TABLE review (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    datetime TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);


-- 2. ВСТАВКА ДАННЫХ 


-- Категории (10 записей)
INSERT INTO category (name, description) VALUES
('Электрогитары', 'Электрические гитары различных форм и конфигураций'),
('Акустические гитары', 'Классические и акустические гитары'),
('Клавишные', 'Синтезаторы, цифровые пианино и MIDI-контроллеры'),
('Ударные', 'Барабанные установки и перкуссия'),
('Аксессуары', 'Струны, медиаторы, чехлы и другое оборудование'),
('Звуковое оборудование', 'Усилители, колонки и микшерные пульты'),
('Духовые', 'Саксофоны, трубы, флейты и другие духовые инструменты'),
('Смычковые', 'Скрипки, виолончели и контрабасы'),
('Нотные издания', 'Ноты, учебники и методические пособия'),
('Студийное оборудование', 'Микрофоны, наушники, аудиоинтерфейсы');

-- Бренды (12 записей)
INSERT INTO brand (name, country) VALUES
('Fender', 'США'),
('Gibson', 'США'),
('Yamaha', 'Япония'),
('Roland', 'Япония'),
('Ibanez', 'Япония'),
('Marshall', 'Великобритания'),
('Taylor', 'США'),
('Korg', 'Япония'),
('Shure', 'США'),
('ESP', 'Япония'),
('Epiphone', 'США'),
('Sennheiser', 'Германия');

-- Клиенты (12 записей)
INSERT INTO customer (last_name, first_name, middle_name, phone, email, registration_date) VALUES
('Иванов', 'Иван', 'Иванович', '+79161234567', 'ivanov@mail.ru', '2024-01-15'),
('Петрова', 'Екатерина', 'Алексеевна', '+79162345678', 'petrova@yandex.ru', '2024-02-20'),
('Сидоров', 'Алексей', 'Владимирович', '+79163456789', 'sidorov@gmail.com', '2024-03-10'),
('Кузнецова', 'Мария', 'Сергеевна', '+79164567890', 'kuznetsova@mail.ru', '2024-03-25'),
('Смирнов', 'Дмитрий', 'Николаевич', '+79165678901', 'smirnov@yandex.ru', '2024-04-05'),
('Васильева', 'Анна', 'Петровна', '+79166789012', 'vasilyeva@gmail.com', '2024-04-18'),
('Попов', 'Константин', 'Андреевич', '+79167890123', 'popov@mail.ru', '2024-05-01'),
('Соколова', 'Татьяна', 'Игоревна', '+79168901234', 'sokolova@yandex.ru', '2024-05-15'),
('Михайлов', 'Артём', 'Дмитриевич', '+79169012345', 'mikhailov@gmail.com', '2024-06-10'),
('Фёдорова', 'Ольга', 'Владимировна', '+79170123456', 'fedorova@mail.ru', '2024-06-25'),
('Николаев', 'Павел', 'Сергеевич', '+79171234567', 'nikolaev@yandex.ru', '2024-07-01'),
('Алексеева', 'Ирина', 'Валерьевна', '+79172345678', 'alekseeva@gmail.com', '2024-07-15');

-- Сотрудники (10 записей)
INSERT INTO employee (last_name, first_name, middle_name, position, hire_date, phone) VALUES
('Волков', 'Андрей', 'Сергеевич', 'Продавец-консультант', '2023-09-01', '+79161234500'),
('Морозова', 'Елена', 'Викторовна', 'Старший продавец', '2023-06-15', '+79162345600'),
('Лебедев', 'Павел', 'Александрович', 'Продавец-консультант', '2023-11-20', '+79163456700'),
('Новикова', 'Ирина', 'Дмитриевна', 'Администратор', '2023-05-10', '+79164567800'),
('Козлов', 'Максим', 'Игоревич', 'Продавец-консультант', '2024-01-25', '+79165678900'),
('Соловьёв', 'Денис', 'Андреевич', 'Продавец-консультант', '2024-02-10', '+79166789001'),
('Егорова', 'Наталья', 'Владимировна', 'Кассир', '2024-03-01', '+79167890112'),
('Тимофеев', 'Алексей', 'Петрович', 'Грузчик', '2024-01-15', '+79168901223'),
('Павлова', 'Елена', 'Сергеевна', 'Уборщица', '2023-12-01', '+79169012334'),
('Степанов', 'Олег', 'Иванович', 'Охранник', '2023-10-01', '+79170123445');

-- Поставщики (10 записей)
INSERT INTO supplier (company_name, phone, email, address, contact_person) VALUES
('ООО "Музыкальный мир"', '+74951234567', 'sales@musicworld.ru', 'г. Москва, ул. Тверская, д. 15', 'Алексей Петров'),
('ИП "Гитара-Про"', '+74952345678', 'info@guitarpro.ru', 'г. Санкт-Петербург, Невский пр-т, д. 50', 'Мария Сидорова'),
('ЗАО "Клавишные технологии"', '+74953456789', 'order@keyboards.ru', 'г. Новосибирск, пр. Красный, д. 100', 'Сергей Иванов'),
('ООО "Звук-Сервис"', '+74954567890', 'info@zvuk-service.ru', 'г. Екатеринбург, ул. Ленина, д. 25', 'Дмитрий Смирнов'),
('Группа компаний "Драм-Бит"', '+74955678901', 'sales@drumbit.ru', 'г. Казань, ул. Баумана, д. 10', 'Андрей Козлов'),
('ООО "Смычок"', '+74956789012', 'info@smichok.ru', 'г. Нижний Новгород, ул. Большая Покровская, д. 20', 'Елена Васильева'),
('ИП "Нотный двор"', '+74957890123', 'sales@noty.ru', 'г. Самара, ул. Ленинградская, д. 15', 'Игорь Соколов'),
('ООО "Студия-Звук"', '+74958901234', 'info@studiya.ru', 'г. Ростов-на-Дону, ул. Большая Садовая, д. 10', 'Павел Морозов'),
('ЗАО "Аккорд"', '+74959012345', 'sales@akkord.ru', 'г. Уфа, пр. Октября, д. 50', 'Анна Новикова'),
('ООО "Мелодия"', '+74960123456', 'info@melodia.ru', 'г. Красноярск, ул. Мира, д. 30', 'Денис Петров');

-- Товары (15 записей)
INSERT INTO product (name, description, retail_price, quantity_in_stock, minimum_stock, category_id, brand_id) VALUES
('Fender Stratocaster', 'Классическая электрогитара с 3 синглами', 85000.00, 5, 2, 1, 1),
('Gibson Les Paul', 'Электрогитара с хамбакерами и массивным корпусом', 120000.00, 3, 1, 1, 2),
('Yamaha FG800', 'Акустическая гитара для начинающих', 25000.00, 10, 3, 2, 3),
('Roland FP-30X', 'Цифровое пианино с взвешенной клавиатурой', 55000.00, 4, 2, 3, 4),
('Ibanez RG550', 'Электрогитара для рока и металла', 95000.00, 2, 1, 1, 5),
('Marshall DSL40CR', 'Ламповый гитарный комбоусилитель 40 Вт', 75000.00, 2, 1, 6, 6),
('Roland TD-1DMK', 'Электронная барабанная установка', 65000.00, 3, 1, 4, 4),
('Taylor 214ce', 'Акустическая гитара премиум-класса', 110000.00, 2, 1, 2, 7),
('Korg Minilogue XD', 'Аналоговый полифонический синтезатор', 60000.00, 4, 2, 3, 8),
('Shure SM58', 'Вокальный микрофон', 12000.00, 15, 5, 6, 9),
('ESP LTD EC-1000', 'Электрогитара для металла', 105000.00, 1, 1, 1, 10),
('Epiphone Les Paul', 'Доступная версия Gibson Les Paul', 35000.00, 8, 3, 1, 11),
('Yamaha P-125', 'Компактное цифровое пианино', 48000.00, 6, 2, 3, 3),
('Струны Fender Super 250s', 'Набор струн для электрогитары', 800.00, 50, 10, 5, 1),
('Медиаторы Fender', 'Набор медиаторов 12 шт', 300.00, 100, 20, 5, 1);

-- Поставки (12 записей)
INSERT INTO supply (supply_date, supplier_id) VALUES
('2024-05-10', 1),
('2024-05-15', 2),
('2024-06-05', 3),
('2024-06-20', 4),
('2024-07-01', 5),
('2024-07-15', 1),
('2024-07-20', 2),
('2024-08-01', 6),
('2024-08-10', 7),
('2024-08-15', 8),
('2024-08-20', 9),
('2024-08-25', 10);

-- Состав поставок (15 записей)
INSERT INTO supply_item (supply_id, product_id, quantity, purchase_price) VALUES
(1, 1, 3, 60000.00),
(1, 2, 2, 90000.00),
(1, 3, 5, 18000.00),
(2, 4, 3, 38000.00),
(2, 5, 2, 70000.00),
(3, 6, 2, 55000.00),
(3, 7, 3, 48000.00),
(4, 8, 1, 85000.00),
(4, 9, 3, 42000.00),
(5, 10, 10, 8000.00),
(5, 11, 1, 80000.00),
(6, 12, 5, 25000.00),
(6, 13, 4, 35000.00),
(7, 14, 30, 500.00),
(8, 15, 50, 150.00);

-- Продажи (12 записей)
INSERT INTO sale (datetime, total_amount, customer_id, employee_id) VALUES
('2024-06-01 14:30:00', 85000.00, 1, 1),
('2024-06-03 11:15:00', 120000.00, 2, 2),
('2024-06-05 16:45:00', 25000.00, 3, 1),
('2024-06-10 12:00:00', 55000.00, 4, 3),
('2024-06-12 15:20:00', 95000.00, 5, 2),
('2024-06-15 10:30:00', 75000.00, 6, 3),
('2024-06-18 17:00:00', 65000.00, 7, 1),
('2024-06-20 13:45:00', 110000.00, 8, 2),
('2024-06-22 14:10:00', 60000.00, 9, 3),
('2024-06-25 11:30:00', 105000.00, 10, 1),
('2024-07-01 15:00:00', 12000.00, 11, 2),
('2024-07-05 12:30:00', 35000.00, 12, 3);

-- Состав продаж (15 записей)
INSERT INTO sale_item (sale_id, product_id, quantity, price_at_sale) VALUES
(1, 1, 1, 85000.00),
(2, 2, 1, 120000.00),
(3, 3, 1, 25000.00),
(4, 4, 1, 55000.00),
(5, 5, 1, 95000.00),
(6, 6, 1, 75000.00),
(7, 7, 1, 65000.00),
(8, 8, 1, 110000.00),
(9, 9, 1, 60000.00),
(10, 11, 1, 105000.00),
(11, 10, 1, 12000.00),
(12, 12, 1, 35000.00),
(1, 14, 2, 800.00),
(5, 15, 3, 300.00),
(8, 13, 2, 48000.00);

-- Заказы клиентов (10 записей)
INSERT INTO customer_order (customer_id, product_id, order_datetime, status) VALUES
(1, 2, '2024-07-20 10:30:00', 'В пути'),
(2, 6, '2024-07-21 14:15:00', 'Принят'),
(3, 9, '2024-07-22 09:45:00', 'Готов к выдаче'),
(4, 11, '2024-07-23 16:00:00', 'Принят'),
(5, 2, '2024-07-24 11:20:00', 'В пути'),
(6, 8, '2024-07-25 13:30:00', 'Выдан'),
(7, 10, '2024-07-26 15:45:00', 'Принят'),
(8, 13, '2024-07-27 10:00:00', 'Принят'),
(9, 4, '2024-07-28 14:30:00', 'В пути'),
(10, 12, '2024-07-29 12:15:00', 'Готов к выдаче');

-- Отзывы (12 записей)
INSERT INTO review (customer_id, product_id, rating, comment, datetime) VALUES
(1, 1, 5, 'Отличная гитара! Звук просто потрясающий. Очень доволен покупкой.', '2024-06-10 18:00:00'),
(2, 2, 5, 'Классика, которая никогда не подводит. Цена оправдана.', '2024-06-15 20:30:00'),
(3, 3, 4, 'Хорошая гитара для начала. Звук приятный.', '2024-06-18 19:15:00'),
(4, 4, 5, 'Отличное пианино для дома! Клавиши как у акустического.', '2024-06-22 17:45:00'),
(5, 5, 5, 'Ibanez RG550 — мечта! Очень удобная гитара.', '2024-06-25 16:30:00'),
(6, 6, 5, 'Marshall — это легенда! Усилитель бомба.', '2024-06-28 14:20:00'),
(7, 7, 4, 'Хорошая установка для практики, но маловато тарелок.', '2024-07-01 13:00:00'),
(8, 8, 5, 'Taylor — это нечто. Акустика премиум-класса.', '2024-07-05 12:15:00'),
(9, 9, 4, 'Хороший синтезатор для домашней студии.', '2024-07-08 11:30:00'),
(10, 10, 4, 'Надежный микрофон. Рекомендую.', '2024-07-10 18:45:00'),
(11, 12, 5, 'Отличная гитара за свои деньги!', '2024-07-12 20:00:00'),
(12, 14, 5, 'Струны отличные, держат строй хорошо.', '2024-07-14 17:30:00');


-- 3. ОБНОВЛЕНИЕ ДАННЫХ


-- Обновление остатков на складе после поставок
UPDATE product p
SET quantity_in_stock = COALESCE(
    (SELECT SUM(si.quantity)
     FROM supply_item si
     WHERE si.product_id = p.id), 0
);

-- Обновление общей суммы продаж
UPDATE sale s
SET total_amount = (
    SELECT SUM(si.quantity * si.price_at_sale)
    FROM sale_item si
    WHERE si.sale_id = s.id
);



-- 4. ПРОСМОТР ВСЕХ ДАННЫХ


-- Все категории
SELECT * FROM category;

-- Все бренды
SELECT * FROM brand;

-- Все клиенты
SELECT * FROM customer;

-- Все сотрудники
SELECT * FROM employee;

-- Все поставщики
SELECT * FROM supplier;

-- Все товары
SELECT * FROM product;

-- Все поставки
SELECT * FROM supply;

-- Состав всех поставок
SELECT * FROM supply_item;

-- Все продажи
SELECT * FROM sale;

-- Состав всех продаж
SELECT * FROM sale_item;

-- Все заказы клиентов
SELECT * FROM customer_order;

-- Все отзывы
SELECT * FROM review;

insert into brand (name, country) values 
('dkdkdk', 'skssk');

alter table brand 
add column hh VARCHAR(20)

update brand b set country = '123a'
where b.id = '13'

delete from brand 
where brand.id = '13'


-- ============================================================
-- РАЗДЕЛ 1: ЗАПРОСЫ ПО ФУНКЦИОНАЛЬНЫМ ТРЕБОВАНИЯМ (10 шт.)
-- ============================================================

-- [ФТ-1] Оперативный: Поиск товаров Fender в наличии
SELECT
    p.name AS наименование,
    b.name AS бренд,
    c.name AS категория,
    p.retail_price AS цена,
    p.quantity_in_stock AS остаток
FROM product p
INNER JOIN brand b ON b.id = p.brand_id
INNER JOIN category c ON c.id = p.category_id
WHERE b.name = 'Fender'
  AND p.quantity_in_stock > 0
ORDER BY p.retail_price;

-- [ФТ-2] Оперативный: Карточка клиента по номеру телефона
SELECT
    c.last_name AS фамилия,
    c.first_name AS имя,
    c.middle_name AS отчество,
    c.phone AS телефон,
    c.email AS email,
    c.registration_date AS дата_регистрации
FROM customer c
WHERE c.phone = '+79161234567';

-- [ФТ-3] Оперативный: Остатки синтезаторов Yamaha на складе
SELECT
    p.name AS товар,
    b.name AS бренд,
    p.quantity_in_stock AS остаток_на_складе,
    p.minimum_stock AS минимальный_запас
FROM product p
INNER JOIN brand b ON b.id = p.brand_id
WHERE b.name = 'Yamaha'
  AND p.category_id = (SELECT id FROM category WHERE name = 'Клавишные');

-- [ФТ-4] Оперативный: Поставщик товаров бренда Gibson
SELECT DISTINCT
    s.company_name AS поставщик,
    s.contact_person AS контактное_лицо,
    s.phone AS телефон,
    s.email AS email,
    s.address AS адрес
FROM supplier s
INNER JOIN supply sup ON sup.supplier_id = s.id
INNER JOIN supply_item si ON si.supply_id = sup.id
INNER JOIN product p ON p.id = si.product_id
INNER JOIN brand b ON b.id = p.brand_id
WHERE b.name = 'Gibson';

-- [ФТ-5] Оперативный: История продаж продавца Волкова Андрея
SELECT
    s.datetime AS дата_и_время,
    s.total_amount AS сумма,
    c.last_name AS клиент
FROM sale s
LEFT JOIN customer c ON c.id = s.customer_id
INNER JOIN employee e ON e.id = s.employee_id
WHERE e.last_name = 'Волков'
  AND e.first_name = 'Андрей'
ORDER BY s.datetime DESC;

-- [ФТ-6] Аналитический: Топ-10 продаваемых товаров за период
SELECT
    p.name AS товар,
    SUM(si.quantity) AS продано_штук,
    SUM(si.quantity * si.price_at_sale) AS выручка
FROM sale_item si
INNER JOIN product p ON p.id = si.product_id
INNER JOIN sale s ON s.id = si.sale_id
WHERE s.datetime >= '2024-06-01'
GROUP BY p.name
ORDER BY продано_штук DESC
LIMIT 10;

-- [ФТ-7] Аналитический: Выручка по категориям
SELECT
    c.name AS категория,
    COUNT(DISTINCT si.sale_id) AS количество_продаж,
    SUM(si.quantity) AS продано_единиц,
    SUM(si.quantity * si.price_at_sale) AS выручка
FROM sale_item si
INNER JOIN product p ON p.id = si.product_id
INNER JOIN category c ON c.id = p.category_id
INNER JOIN sale s ON s.id = si.sale_id
WHERE s.datetime >= '2024-06-01'
GROUP BY c.name
ORDER BY выручка DESC;

-- [ФТ-8] Аналитический: Динамика продаж по дням
SELECT
    DATE(s.datetime) AS день,
    COUNT(DISTINCT s.id) AS количество_продаж,
    SUM(s.total_amount) AS дневная_выручка
FROM sale s
WHERE s.datetime >= '2024-06-01'
GROUP BY DATE(s.datetime)
ORDER BY день;

-- [ФТ-9] Аналитический: Эффективность продавцов-консультантов
SELECT
    e.last_name || ' ' || e.first_name AS сотрудник,
    e.position AS должность,
    COUNT(s.id) AS количество_продаж,
    SUM(s.total_amount) AS общая_сумма_продаж,
    ROUND(AVG(s.total_amount), 2) AS средний_чек
FROM sale s
INNER JOIN employee e ON e.id = s.employee_id
WHERE e.position = 'Продавец-консультант'
GROUP BY e.id, e.last_name, e.first_name, e.position
ORDER BY общая_сумма_продаж DESC;

-- [ФТ-10] Аналитический: Товары ниже минимального запаса
-- Добавим товар, которого мало на складе
INSERT INTO product (name, description, retail_price, quantity_in_stock, minimum_stock, category_id, brand_id)
VALUES ('ESP LTD EC-1000', 'Электрогитара для металла', 105000.00, 1, 5, 1, 10);

SELECT
    p.name AS товар,
    p.quantity_in_stock AS остаток,
    p.minimum_stock AS минимум,
    p.minimum_stock - p.quantity_in_stock AS дефицит,
    b.name AS бренд,
    s.company_name AS поставщик,
    s.contact_person AS контакт
FROM product p
LEFT JOIN brand b ON b.id = p.brand_id
LEFT JOIN supply_item si ON si.product_id = p.id
LEFT JOIN supply sup ON sup.id = si.supply_id
LEFT JOIN supplier s ON s.id = sup.supplier_id
WHERE p.quantity_in_stock < p.minimum_stock
ORDER BY p.id, дефицит DESC;


-- ============================================================
-- РАЗДЕЛ 2: UPDATE (7 запросов)
-- ============================================================

-- [UPD-1] Пересчёт складских остатков из поставок
UPDATE product p
SET quantity_in_stock = COALESCE(
    (SELECT SUM(si.quantity)
     FROM supply_item si
     WHERE si.product_id = p.id),
    0
);

-- [UPD-2] Пересчёт итоговой суммы продажи из позиций
UPDATE sale s
SET total_amount = (
    SELECT SUM(si.quantity * si.price_at_sale)
    FROM sale_item si
    WHERE si.sale_id = s.id
);

-- [UPD-3] Исправление email клиента Иванова Ивана
UPDATE customer
SET email = 'ivan.ivanov@mail.ru'
WHERE last_name = 'Иванов' AND first_name = 'Иван';

-- [UPD-4] Повышение цены на 10% для товаров Fender
UPDATE product
SET retail_price = ROUND(retail_price * 1.10, 2)
WHERE brand_id = (SELECT id FROM brand WHERE name = 'Fender');

-- [UPD-5] Перевод принятых заказов в статус «Подтверждён»
UPDATE customer_order
SET status = 'Подтверждён'
WHERE status = 'Принят'
  AND order_datetime < NOW() - INTERVAL '2 days';

-- [UPD-6] Обновление контактного лица поставщика «Звук-Сервис»
UPDATE supplier
SET contact_person = 'Алина Кравцова',
    phone = '+74954500000'
WHERE company_name = 'ООО "Звук-Сервис"';

-- [UPD-7] Повышение минимального запаса для аксессуаров
UPDATE product
SET minimum_stock = 15
WHERE category_id = (SELECT id FROM category WHERE name = 'Аксессуары')
  AND minimum_stock < 15;


-- ============================================================
-- РАЗДЕЛ 3: DELETE (7 запросов + подготовка)
-- ============================================================

-- PREP. Добавление тестовых данных для демонстрации DELETE
INSERT INTO category (name, description) VALUES ('ТЕСТ_УДАЛИТЬ', 'Временная тестовая категория');
INSERT INTO brand (name, country) VALUES ('ТЕСТ_БРЕНД', 'Нигде');
INSERT INTO customer (last_name, first_name, phone, email, registration_date) VALUES ('Тестов', 'Тест', '+70000000000', 'test@test.com', '2000-01-01');
INSERT INTO review (customer_id, product_id, rating, comment, datetime) VALUES ((SELECT id FROM customer WHERE phone = '+70000000000'), 1, 1, 'Тест — удалить', NOW());

-- [DEL-1] Удаление тестовой категории
DELETE FROM category WHERE name = 'ТЕСТ_УДАЛИТЬ';

-- [DEL-2] Удаление тестового бренда
DELETE FROM brand WHERE name = 'ТЕСТ_БРЕНД';

-- [DEL-3] Удаление тестового отзыва
DELETE FROM review WHERE comment = 'Тест — удалить';

-- [DEL-4] Удаление тестового клиента
DELETE FROM customer WHERE phone = '+70000000000';

-- [DEL-5] Удаление выданных заказов старше 30 дней
DELETE FROM customer_order WHERE status = 'Выдан' AND order_datetime < NOW() - INTERVAL '30 days';

-- [DEL-6] Удаление пустых отзывов с низкой оценкой
DELETE FROM review WHERE comment IS NULL AND rating < 3;

-- [DEL-7] Удаление поставок без позиций
DELETE FROM supply WHERE id NOT IN (SELECT DISTINCT supply_id FROM supply_item);


-- ============================================================
-- РАЗДЕЛ 4: SELECT (16 запросов)
-- ============================================================

-- [SEL-1] DISTINCT: уникальные страны брендов
SELECT DISTINCT country AS страна_производства FROM brand ORDER BY страна_производства;

-- [SEL-2] WHERE + AND: дорогие товары в наличии
SELECT name, retail_price, quantity_in_stock FROM product 
WHERE retail_price > 50000 AND quantity_in_stock > 0 ORDER BY retail_price DESC;

-- [SEL-3] WHERE + OR: продавцы и кассиры
SELECT last_name, first_name, position, hire_date FROM employee 
WHERE position = 'Продавец-консультант' OR position = 'Кассир';

-- [SEL-4] WHERE + NOT: все, кроме администраторов
SELECT last_name, first_name, position FROM employee 
WHERE NOT position = 'Администратор' ORDER BY last_name;

-- [SEL-5] IN: товары двух категорий
SELECT p.name AS товар, p.retail_price AS цена, c.name AS категория FROM product p 
INNER JOIN category c ON c.id = p.category_id 
WHERE c.name IN ('Электрогитары', 'Клавишные') ORDER BY p.retail_price DESC;

-- [SEL-6] BETWEEN: товары в ценовом диапазоне
SELECT name, retail_price FROM product 
WHERE retail_price BETWEEN 20000 AND 100000 ORDER BY retail_price;

-- [SEL-7] BETWEEN + дата: клиенты Q2 2024
SELECT last_name, first_name, registration_date FROM customer 
WHERE registration_date BETWEEN '2024-04-01' AND '2024-06-30' ORDER BY registration_date;

-- [SEL-8] IS NULL: товары без указанной категории

-- Временный бренд для теста (если нет подходящего)
INSERT INTO brand (name, country) VALUES ('Тестовый бренд', 'Россия') 
ON CONFLICT (name) DO NOTHING;

-- Добавляем товар без категории
INSERT INTO product (name, description, retail_price, quantity_in_stock, minimum_stock, category_id, brand_id)
VALUES (
    'Тестовый товар без категории',
    'Этот товар создан для проверки запроса SEL-8',
    9999.00,
    1,
    1,
    NULL,  -- категория не указана
    (SELECT id FROM brand WHERE name = 'Тестовый бренд')
);

SELECT id, name AS товар, retail_price AS цена
FROM product 
WHERE category_id IS NULL;

-- [SEL-9] AS: цена со скидкой 10% и экономия
SELECT name AS наименование, retail_price AS цена_руб, ROUND(retail_price * 0.9, 2) AS цена_со_скидкой_10_проц, retail_price - ROUND(retail_price * 0.9, 2) AS экономия_руб FROM product ORDER BY экономия_руб DESC;

-- [SEL-10] Число дней с момента регистрации клиента
SELECT last_name || ' ' || first_name AS клиент, registration_date AS дата_регистрации, CURRENT_DATE - registration_date AS дней_с_регистрации FROM customer ORDER BY дней_с_регистрации DESC;

-- [SEL-11] Коэффициент запаса
SELECT name, quantity_in_stock AS остаток, minimum_stock AS минимум, quantity_in_stock::NUMERIC / NULLIF(minimum_stock, 0) AS коэф_запаса FROM product WHERE quantity_in_stock >= minimum_stock * 2 ORDER BY коэф_запаса DESC;

-- [SEL-12] DISTINCT + WHERE: должности сотрудников 2024 года
SELECT DISTINCT position AS должность FROM employee WHERE hire_date >= '2024-01-01';

-- [SEL-13] COALESCE: клиенты без email
INSERT INTO customer (last_name, first_name, middle_name, phone, email, registration_date)
VALUES ('Тестовый', 'Клиент', 'Без Email', '+79999999999', NULL, CURRENT_DATE);

-- Добавляем клиента с пустым email (пустая строка)
INSERT INTO customer (last_name, first_name, middle_name, phone, email, registration_date)
VALUES ('Пустой', 'Email', NULL, '+78888888888', '', CURRENT_DATE);

SELECT last_name, first_name, phone, COALESCE(email, 'не указан') AS email FROM customer WHERE email IS NULL OR email = '';

-- [SEL-14] Арифметика: наценка в процентах
SELECT p.name AS товар, p.retail_price AS розница, si.purchase_price AS закупка, ROUND((p.retail_price - si.purchase_price) / si.purchase_price * 100, 1) AS наценка_проц FROM product p INNER JOIN supply_item si ON si.product_id = p.id ORDER BY наценка_проц DESC;

-- [SEL-15] BETWEEN + дата: заказы июля 2024
SELECT co.id AS номер_заказа, c.last_name AS клиент, p.name AS товар, co.order_datetime AS дата, co.status AS статус FROM customer_order co INNER JOIN customer c ON c.id = co.customer_id INNER JOIN product p ON p.id = co.product_id WHERE co.order_datetime BETWEEN '2024-07-01' AND '2024-07-31 23:59:59' ORDER BY co.order_datetime;

-- [SEL-16] EXTRACT: поставки по месяцам
SELECT EXTRACT(YEAR FROM supply_date) AS год, EXTRACT(MONTH FROM supply_date) AS месяц, COUNT(*) AS поставок_за_месяц FROM supply GROUP BY год, месяц ORDER BY год, месяц;


-- ============================================================
-- РАЗДЕЛ 5: LIKE и работа со строками (7 запросов)
-- ============================================================

-- [STR-1] LIKE: товары с «гитара» в описании
SELECT name, description, retail_price FROM product WHERE LOWER(description) LIKE '%гитара%' ORDER BY retail_price;

-- [STR-2] LIKE: поставщики из городов на «М»
SELECT company_name, address FROM supplier WHERE address LIKE 'г. М%';

-- [STR-3] LIKE: клиенты с gmail-адресом
SELECT last_name, first_name, email FROM customer WHERE email LIKE '%@gmail.com';

-- [STR-4] NOT LIKE: бренды не из США
SELECT name, country FROM brand WHERE country NOT LIKE '%США%';

-- [STR-5] LIKE с _: телефоны на +7916
SELECT last_name, first_name, phone FROM customer WHERE phone LIKE '+7916_______';

-- [STR-6] UPPER, LENGTH: ФИО в верхнем регистре
SELECT UPPER(last_name || ' ' || first_name) AS ФИО_заглавными, LENGTH(last_name) AS длина_фамилии, position FROM employee ORDER BY длина_фамилии DESC;

-- [STR-7] CONCAT + LIKE: описание синтезаторов
SELECT CONCAT(b.name, ' ', p.name) AS полное_наименование, p.description FROM product p INNER JOIN brand b ON b.id = p.brand_id WHERE LOWER(p.description) LIKE '%синтезатор%';


-- ============================================================
-- РАЗДЕЛ 6: INSERT SELECT (3 запроса)
-- ============================================================

-- IS-0. Создание вспомогательных таблиц
CREATE TABLE IF NOT EXISTS top_products_report (product_name VARCHAR(255), total_sold INT, total_revenue DECIMAL(12,2), avg_price DECIMAL(10,2));
CREATE TABLE IF NOT EXISTS low_stock_alert (product_name VARCHAR(255), current_stock INT, minimum_stock INT, deficit INT);

-- [IS-1] INSERT SELECT: отчёт по продажам товаров
INSERT INTO top_products_report (product_name, total_sold, total_revenue, avg_price)
SELECT p.name, SUM(si.quantity), SUM(si.quantity * si.price_at_sale), AVG(si.price_at_sale)
FROM sale_item si INNER JOIN product p ON p.id = si.product_id GROUP BY p.name ORDER BY total_sold DESC;

-- [IS-2] INSERT SELECT: товары с дефицитом
INSERT INTO low_stock_alert (product_name, current_stock, minimum_stock, deficit)
SELECT name, quantity_in_stock, minimum_stock, minimum_stock - quantity_in_stock FROM product WHERE quantity_in_stock < minimum_stock;

-- [IS-3] Проверка скопированных данных
SELECT * FROM top_products_report ORDER BY total_sold DESC;
SELECT * FROM low_stock_alert ORDER BY deficit DESC;


-- ============================================================
-- РАЗДЕЛ 7: JOIN (16 запросов)
-- ============================================================

-- [JN-1] INNER JOIN: товары с категорией и брендом
SELECT p.name AS товар, c.name AS категория, b.name AS бренд, p.retail_price AS цена FROM product p 
INNER JOIN category c ON c.id = p.category_id 
INNER JOIN brand b ON b.id = p.brand_id ORDER BY c.name, p.retail_price;

-- [JN-2] LEFT JOIN: клиенты с числом и суммой покупок
SELECT c.last_name || ' ' || c.first_name AS клиент, COUNT(s.id) AS количество_покупок, COALESCE(SUM(s.total_amount), 0) AS сумма_покупок FROM customer c 
LEFT JOIN sale s ON s.customer_id = c.id 
GROUP BY c.id, c.last_name, c.first_name ORDER BY сумма_покупок DESC;

-- [JN-3] LEFT JOIN: товары без продаж
SELECT p.name, p.retail_price, p.quantity_in_stock FROM product p 
LEFT JOIN sale_item si ON si.product_id = p.id 
WHERE si.id IS NULL;

-- [JN-4] RIGHT JOIN: сотрудники с числом продаж
SELECT e.last_name || ' ' || e.first_name AS сотрудник, e.position, COUNT(s.id) AS продаж FROM sale s 
RIGHT JOIN employee e ON e.id = s.employee_id 
GROUP BY e.id, e.last_name, e.first_name, e.position ORDER BY продаж DESC;

-- [JN-5] FULL OUTER JOIN: клиенты и заказы
SELECT c.last_name AS клиент, co.id AS заказ, co.status AS статус FROM customer c 
FULL OUTER JOIN customer_order co ON co.customer_id = c.id ORDER BY c.last_name NULLS LAST;

-- [JN-6] M:N через sale_item: товары, купленные вместе
SELECT p1.name AS товар_1, p2.name AS товар_2, COUNT(*) AS совместных_покупок FROM sale_item si1 
INNER JOIN sale_item si2 ON si2.sale_id = si1.sale_id AND si2.product_id > si1.product_id 
INNER JOIN product p1 ON p1.id = si1.product_id 
INNER JOIN product p2 ON p2.id = si2.product_id 
GROUP BY p1.name, p2.name ORDER BY совместных_покупок DESC;

-- [JN-7] M:N через supply_item: число поставщиков на товар
SELECT p.name AS товар, COUNT(DISTINCT sup.supplier_id) AS количество_поставщиков FROM product p 
INNER JOIN supply_item si ON si.product_id = p.id 
INNER JOIN supply sup ON sup.id = si.supply_id 
GROUP BY p.name ORDER BY количество_поставщиков DESC;

-- [JN-8] 4 таблицы: состав продаж с полной информацией
SELECT s.datetime AS дата, c.last_name AS клиент, e.last_name AS продавец, p.name AS товар, si.quantity AS кол_во, si.price_at_sale AS цена_продажи FROM sale_item si 
INNER JOIN sale s ON s.id = si.sale_id 
INNER JOIN product p ON p.id = si.product_id LEFT JOIN customer c ON c.id = s.customer_id 
INNER JOIN employee e ON e.id = s.employee_id ORDER BY s.datetime;

-- [JN-9] JOIN + агрегация: закупочная стоимость по поставщикам
SELECT s.company_name AS поставщик, COUNT(DISTINCT sup.id) AS поставок, SUM(si.quantity * si.purchase_price) AS общая_закупочная_сумма FROM supplier s 
INNER JOIN supply sup ON sup.supplier_id = s.id 
INNER JOIN supply_item si ON si.supply_id = sup.id 
GROUP BY s.company_name ORDER BY общая_закупочная_сумма DESC;

-- [JN-10] JOIN: отзывы с именем клиента и товаром
SELECT c.last_name || ' ' || c.first_name AS клиент, p.name AS товар, r.rating AS оценка, r.comment AS комментарий, r.datetime AS дата FROM review r 
INNER JOIN customer c ON c.id = r.customer_id 
INNER JOIN product p ON p.id = r.product_id ORDER BY r.rating DESC;

-- [JN-11] CROSS JOIN: все пары «категория × бренд»
SELECT c.name AS категория, b.name AS бренд FROM category c 
CROSS JOIN brand b ORDER BY c.name, b.name LIMIT 20;

-- [JN-12] INNER JOIN (вместо NATURAL): состав поставок
SELECT si.id AS позиция_id, si.quantity AS количество, si.purchase_price AS закупочная_цена, sup.supply_date AS дата_поставки FROM supply_item si 
INNER JOIN supply sup ON sup.id = si.supply_id LIMIT 10;

-- [JN-13] 3 таблицы: заказы с клиентом и товаром
SELECT co.order_datetime AS дата_заказа, c.last_name || ' ' || c.first_name AS клиент, c.phone AS телефон, p.name AS товар, p.retail_price AS цена, co.status AS статус FROM customer_order co 
INNER JOIN customer c ON c.id = co.customer_id INNER JOIN product p ON p.id = co.product_id ORDER BY co.order_datetime DESC;

-- [JN-14] LEFT JOIN: товары без отзывов
SELECT p.name, p.retail_price FROM product p 
LEFT JOIN review r ON r.product_id = p.id 
WHERE r.id IS NULL;

-- [JN-15] JOIN + HAVING: сотрудники с выручкой выше средней
SELECT e.last_name || ' ' || e.first_name AS сотрудник, SUM(s.total_amount) AS итого_продаж FROM sale s 
INNER JOIN employee e ON e.id = s.employee_id 
GROUP BY e.id, e.last_name, e.first_name HAVING SUM(s.total_amount) > (SELECT AVG(total_amount) FROM sale) ORDER BY итого_продаж DESC;

-- [JN-16] 5 таблиц: товар, бренд, поставщик и цены
SELECT p.name AS товар, b.name AS бренд, s.company_name AS поставщик, si.purchase_price AS закупочная_цена, p.retail_price AS розничная_цена FROM product p 
INNER JOIN brand b ON b.id = p.brand_id 
INNER JOIN supply_item si ON si.product_id = p.id 
INNER JOIN supply sup ON sup.id = si.supply_id 
INNER JOIN supplier s ON s.id = sup.supplier_id ORDER BY p.name;


-- ============================================================
-- РАЗДЕЛ 8: GROUP BY + агрегатные функции (16 запросов)
-- ============================================================

-- [GB-1] COUNT: товары в каждой категории
SELECT c.name AS категория, COUNT(p.id) AS количество_товаров FROM category c 
LEFT JOIN product p ON p.category_id = c.id GROUP BY c.name ORDER BY количество_товаров DESC;

-- [GB-2] SUM: выручка по продавцам
SELECT e.last_name || ' ' || e.first_name AS продавец, SUM(s.total_amount) AS выручка FROM sale s 
INNER JOIN employee e ON e.id = s.employee_id GROUP BY e.id, e.last_name, e.first_name ORDER BY выручка DESC;

-- [GB-3] AVG + ROUND: средняя оценка товаров
SELECT p.name AS товар, COUNT(r.id) AS отзывов, ROUND(AVG(r.rating), 2) AS средняя_оценка FROM product p 
INNER JOIN review r ON r.product_id = p.id GROUP BY p.name ORDER BY средняя_оценка DESC;

-- [GB-4] MAX + MIN + AVG: ценовой диапазон по категориям
SELECT c.name AS категория, MAX(p.retail_price) AS максимум, MIN(p.retail_price) AS минимум, ROUND(AVG(p.retail_price), 2) AS среднее FROM category c 
INNER JOIN product p ON p.category_id = c.id GROUP BY c.name ORDER BY максимум DESC;

-- [GB-5] HAVING: категории с более чем 2 товарами
SELECT c.name AS категория, COUNT(p.id) AS товаров FROM category c 
INNER JOIN product p ON p.category_id = c.id GROUP BY c.name HAVING COUNT(p.id) > 2 ORDER BY товаров DESC;

-- [GB-6] LIMIT: топ-3 бренда по числу товаров
SELECT b.name AS бренд, COUNT(p.id) AS товаров FROM brand b INNER JOIN product p ON p.brand_id = b.id GROUP BY b.name ORDER BY товаров DESC LIMIT 3;

-- [GB-7] HAVING: поставщики с суммой поставок > 200 000
SELECT s.company_name AS поставщик, SUM(si.quantity * si.purchase_price) AS сумма_поставок FROM supplier s INNER JOIN supply sup ON sup.supplier_id = s.id INNER JOIN supply_item si ON si.supply_id = sup.id GROUP BY s.company_name HAVING SUM(si.quantity * si.purchase_price) > 200000 ORDER BY сумма_поставок DESC;

-- [GB-8] COUNT + GROUP BY: заказы по статусам
SELECT status AS статус, COUNT(id) AS количество FROM customer_order GROUP BY status ORDER BY количество DESC;

-- [GB-9] TO_CHAR + GROUP BY: выручка по месяцам
SELECT TO_CHAR(datetime, 'YYYY-MM') AS месяц, SUM(total_amount) AS выручка, COUNT(id) AS продаж FROM sale GROUP BY TO_CHAR(datetime, 'YYYY-MM') ORDER BY месяц;

-- [GB-10] AVG + HAVING: бренды со средней ценой > 50 000
SELECT b.name AS бренд, ROUND(AVG(p.retail_price), 2) AS средняя_цена FROM brand b INNER JOIN product p ON p.brand_id = b.id GROUP BY b.name HAVING AVG(p.retail_price) > 50000 ORDER BY средняя_цена DESC;

-- [GB-11] ORDER BY DESC + LIMIT: 5 самых дорогих товаров
SELECT name, retail_price FROM product ORDER BY retail_price DESC LIMIT 5;

-- [GB-12] COUNT DISTINCT: клиенты с покупками
SELECT COUNT(DISTINCT customer_id) AS клиентов_с_покупками FROM sale WHERE customer_id IS NOT NULL;

-- [GB-13] MAX: максимальная оценка по категориям
SELECT c.name AS категория, MAX(r.rating) AS максимальная_оценка FROM review r INNER JOIN product p ON p.id = r.product_id INNER JOIN category c ON c.id = p.category_id GROUP BY c.name ORDER BY максимальная_оценка DESC;

-- [GB-14] Несколько агрегатов: статистика поставок по месяцам
SELECT EXTRACT(MONTH FROM sup.supply_date) AS месяц, COUNT(DISTINCT sup.id) AS поставок, SUM(si.quantity) AS единиц_получено, SUM(si.quantity * si.purchase_price) AS на_сумму FROM supply sup INNER JOIN supply_item si ON si.supply_id = sup.id GROUP BY EXTRACT(MONTH FROM sup.supply_date) ORDER BY месяц;

-- [GB-15] ORDER BY + LIMIT: топ-5 клиентов по сумме
SELECT c.last_name || ' ' || c.first_name AS клиент, COUNT(s.id) AS покупок, SUM(s.total_amount) AS итого FROM customer c INNER JOIN sale s ON s.customer_id = c.id GROUP BY c.id, c.last_name, c.first_name ORDER BY итого DESC LIMIT 5;

-- [GB-16] Среднее число позиций в продаже
SELECT ROUND(AVG(cnt), 2) AS среднее_позиций_в_продаже FROM (SELECT sale_id, COUNT(*) AS cnt FROM sale_item GROUP BY sale_id) sub;


-- ============================================================
-- РАЗДЕЛ 9: UNION / EXCEPT / INTERSECT (5 запросов)
-- ============================================================

-- [SET-1] UNION: все люди в системе
SELECT last_name, first_name, 'Клиент' AS роль FROM customer UNION SELECT last_name, first_name, 'Сотрудник' AS роль FROM employee ORDER BY last_name;

-- [SET-2] UNION ALL: все телефоны клиентов и поставщиков
SELECT phone, 'Клиент' AS тип FROM customer WHERE phone IS NOT NULL UNION ALL SELECT phone, 'Поставщик' AS тип FROM supplier WHERE phone IS NOT NULL ORDER BY тип, phone;

-- [SET-3] EXCEPT: клиенты без отзывов
SELECT id, last_name, first_name FROM customer EXCEPT SELECT c.id, c.last_name, c.first_name FROM customer c INNER JOIN review r ON r.customer_id = c.id ORDER BY last_name;

-- [SET-4] INTERSECT: клиенты, и покупавшие, и оставлявшие отзывы
SELECT customer_id AS id FROM sale WHERE customer_id IS NOT NULL INTERSECT SELECT customer_id AS id FROM review ORDER BY id;

-- [SET-5] UNION: все события клиента Иванова
SELECT 'Продажа' AS тип, s.datetime AS дата, s.total_amount::TEXT AS сумма_или_оценка FROM sale s INNER JOIN customer c ON c.id = s.customer_id WHERE c.last_name = 'Иванов' AND c.first_name = 'Иван' UNION SELECT 'Отзыв' AS тип, r.datetime AS дата, r.rating::TEXT AS сумма_или_оценка FROM review r INNER JOIN customer c ON c.id = r.customer_id WHERE c.last_name = 'Иванов' AND c.first_name = 'Иван' ORDER BY дата;


-- ============================================================
-- РАЗДЕЛ 10: Вложенные SELECT (5 запросов)
-- ============================================================

-- [SUB-1] EXISTS: клиенты с активным заказом
SELECT last_name, first_name, phone FROM customer c 
WHERE EXISTS (SELECT 1 FROM customer_order co 
WHERE co.customer_id = c.id AND co.status IN ('Принят', 'В пути', 'Подтверждён'));

-- [SUB-2] NOT EXISTS: товары без отзывов
SELECT name, retail_price FROM product p WHERE NOT EXISTS (SELECT 1 FROM review r WHERE r.product_id = p.id);

-- [SUB-3] ALL: товары дороже всех аксессуаров
SELECT name, retail_price FROM product WHERE retail_price > ALL (SELECT retail_price FROM product WHERE category_id = (SELECT id FROM category WHERE name = 'Аксессуары')) ORDER BY retail_price;

-- [SUB-4] ANY: товары дешевле хоть одной электрогитары
SELECT name, retail_price FROM product WHERE retail_price < ANY (SELECT retail_price FROM product WHERE category_id = (SELECT id FROM category WHERE name = 'Электрогитары')) AND category_id IS DISTINCT FROM (SELECT id FROM category WHERE name = 'Электрогитары') ORDER BY retail_price;

-- [SUB-5] Вложенный SELECT + HAVING: бренды выше средней цены
SELECT b.name AS бренд, ROUND(AVG(p.retail_price), 2) AS средняя_цена FROM brand b INNER JOIN product p ON p.brand_id = b.id GROUP BY b.name HAVING AVG(p.retail_price) > (SELECT AVG(retail_price) FROM product) ORDER BY средняя_цена DESC;


-- ============================================================
-- РАЗДЕЛ 11: STRING_AGG и другие функции SQL (3 запроса)
-- ============================================================

-- [AGG-1] STRING_AGG: список товаров каждой категории
SELECT c.name AS категория, STRING_AGG(p.name, ', ' ORDER BY p.name) AS товары FROM category c INNER JOIN product p ON p.category_id = c.id GROUP BY c.name ORDER BY c.name;

-- [AGG-2] STRING_AGG: покупатели каждого товара
SELECT p.name AS товар, STRING_AGG(DISTINCT c.last_name || ' ' || c.first_name, ', ' ORDER BY c.last_name || ' ' || c.first_name) AS покупатели FROM product p INNER JOIN sale_item si ON si.product_id = p.id INNER JOIN sale s ON s.id = si.sale_id INNER JOIN customer c ON c.id = s.customer_id GROUP BY p.name;

-- [AGG-3] ARRAY_AGG: бренды по странам в виде массива
SELECT country AS страна, ARRAY_AGG(name ORDER BY name) AS бренды, COUNT(*) AS количество FROM brand GROUP BY country ORDER BY количество DESC;


-- ============================================================
-- РАЗДЕЛ 12: Запросы с WITH (CTE) (3 запроса)
-- ============================================================

-- [CTE-1] CTE + RANK: топ продаж с местом
WITH product_sales AS (SELECT p.name AS товар, SUM(si.quantity) AS продано, SUM(si.quantity * si.price_at_sale) AS выручка FROM sale_item si INNER JOIN product p ON p.id = si.product_id GROUP BY p.name) SELECT товар, продано, выручка, RANK() OVER (ORDER BY выручка DESC) AS место FROM product_sales ORDER BY место;

-- [CTE-2] CTE: клиенты с категорией лояльности
WITH customer_stats AS (
SELECT 
c.id, 
c.last_name || ' ' || c.first_name AS клиент, 
COUNT(s.id) AS покупок, COALESCE(SUM(s.total_amount), 0) AS сумма FROM customer c 
LEFT JOIN sale s ON s.customer_id = c.id GROUP BY c.id, c.last_name, c.first_name) 
SELECT клиент, покупок, сумма, 
CASE WHEN покупок = 0 THEN 'Новый' WHEN покупок BETWEEN 1 AND 2 THEN 'Активный' ELSE 'Постоянный' END AS статус_клиента FROM customer_stats ORDER BY сумма DESC;

-- [CTE-3] Два CTE: поставки и продажи в одном запросе
WITH supply_chain AS (
    SELECT 
        s.company_name AS поставщик,
        sup.supply_date AS дата,
        si.quantity AS количество,
        si.purchase_price AS цена_закупки,
        p.name AS товар
    FROM supplier s
    INNER JOIN supply sup ON sup.supplier_id = s.id
    INNER JOIN supply_item si ON si.supply_id = sup.id
    INNER JOIN product p ON p.id = si.product_id
),
sales_data AS (
    SELECT 
        p.name AS товар,
        SUM(si.quantity) AS продано
    FROM sale_item si
    INNER JOIN product p ON p.id = si.product_id
    GROUP BY p.name
)
SELECT 
    sc.товар,
    sc.поставщик,
    sc.дата,
    sc.количество AS поставлено,
    COALESCE(sd.продано, 0) AS продано
FROM supply_chain sc
LEFT JOIN sales_data sd ON sd.товар = sc.товар
ORDER BY sc.товар, sc.дата;


select country
from brand b
where b.country like 'СШ%' ;

--РАЗДЕЛ 13. Строковые, датные и арифметические функции (7 запросов)



--FN-1. INITCAP, LEFT, REGEXP_REPLACE — форматирование клиентов
--Вывести фамилию в формате Initcap, инициалы и телефон только из цифр.
SELECT
    INITCAP(last_name)                                 AS фамилия,
    LEFT(first_name, 1) || '.'
        || COALESCE(LEFT(middle_name, 1) || '.', '')   AS инициалы,
    REGEXP_REPLACE(phone, '[^0-9]', '', 'g')          AS телефон_цифры
FROM customer;



--FN-2. AGE + EXTRACT — стаж сотрудников
--Рассчитать, сколько полных лет каждый сотрудник работает в компании.
SELECT
    last_name || ' ' || first_name                  AS сотрудник,
    hire_date                                        AS принят,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))  AS лет_в_компании
FROM employee
ORDER BY лет_в_компании DESC;



--FN-3. TO_CHAR — читаемый формат даты продажи (исправлено)
--Форматировать дату и время продажи в строку вида «01 Июня 2024 г., 14:30». Исправлено: 'г.' заключён в двойные кавычки.
SELECT
    id,
    TO_CHAR(datetime, 'DD Month YYYY "г.", HH24:MI') AS дата_продажи,
    total_amount
FROM sale
ORDER BY datetime;



--FN-4. Арифметика — расчёт НДС 20%
--Для каждого товара рассчитать цену без НДС и сумму самого НДС.
SELECT
    name                                                  AS товар,
    retail_price                                          AS цена_с_НДС,
    ROUND(retail_price / 1.2, 2)                         AS цена_без_НДС,
    ROUND(retail_price - retail_price / 1.2, 2)          AS НДС_20_проц
FROM product
ORDER BY retail_price DESC;



--FN-5. CASE — ценовой сегмент товара
--Присвоить каждому товару ценовой сегмент через условное выражение CASE.
SELECT
    name,
    retail_price,
    CASE
        WHEN retail_price <  10000                THEN 'Бюджетный'
        WHEN retail_price BETWEEN 10000 AND 60000 THEN 'Средний'
        WHEN retail_price >  60000                THEN 'Премиум'
    END AS ценовой_сегмент
FROM product
ORDER BY retail_price;



--FN-6. DATE_TRUNC + INTERVAL — поставки за последние 3 месяца
--Вывести поставки за последние 3 месяца с суммой и усечённым месяцем.
SELECT
    s.company_name                       AS поставщик,
    sup.supply_date                      AS дата,
    DATE_TRUNC('month', sup.supply_date) AS месяц,
    SUM(si.quantity * si.purchase_price) AS сумма
FROM supply sup
    INNER JOIN supplier    s  ON s.id         = sup.supplier_id
    INNER JOIN supply_item si ON si.supply_id = sup.id
WHERE sup.supply_date >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY s.company_name, sup.supply_date, DATE_TRUNC('month', sup.supply_date)
ORDER BY дата;



--FN-7. NULLIF + ROUND — коэффициент оборачиваемости
--Рассчитать отношение проданных единиц к текущему остатку. NULLIF защищает от деления на ноль.
SELECT
    name,
    quantity_in_stock,
    COALESCE(
        (SELECT SUM(si.quantity) FROM sale_item si WHERE si.product_id = product.id),
        0
    )                                                    AS продано,
    ROUND(
        COALESCE(
            (SELECT SUM(si.quantity) FROM sale_item si WHERE si.product_id = product.id),
            0
        )::NUMERIC
        / NULLIF(quantity_in_stock, 0),
        2
    )                                                    AS коэф_оборачиваемости
FROM product
ORDER BY коэф_оборачиваемости DESC NULLS LAST;



--РАЗДЕЛ 14. Сложные запросы (5 запросов)



--CMPLX-1. Полный отчёт по продажам: 5 JOIN + GROUP BY + HAVING + LIMIT
--Сводный отчёт по каждому товару: категория, бренд, выручка, рейтинг, число продаж. Данные с 2024 года.
SELECT
    c.name                               AS категория,
    b.name                               AS бренд,
    p.name                               AS товар,
    SUM(si.quantity)                     AS продано_штук,
    SUM(si.quantity * si.price_at_sale)  AS выручка,
    ROUND(AVG(r.rating), 2)              AS рейтинг,
    COUNT(DISTINCT s.id)                 AS продаж
FROM sale_item si
    INNER JOIN product  p ON p.id = si.product_id
    INNER JOIN category c ON c.id = p.category_id
    INNER JOIN brand    b ON b.id = p.brand_id
    INNER JOIN sale     s ON s.id = si.sale_id
    LEFT  JOIN review   r ON r.product_id = p.id
WHERE s.datetime >= '2024-01-01'
GROUP BY c.name, b.name, p.name
HAVING SUM(si.quantity) > 0
ORDER BY выручка DESC
LIMIT 10;



--CMPLX-2. Эффективность продавцов по категориям
--Для каждого продавца и каждой категории: число продаж и выручка.
SELECT
    e.last_name || ' ' || e.first_name   AS сотрудник,
    e.position                           AS должность,
    c.name                               AS категория,
    COUNT(DISTINCT s.id)                 AS продаж,
    SUM(si.quantity * si.price_at_sale)  AS выручка_в_категории
FROM sale s
    INNER JOIN employee  e  ON e.id       = s.employee_id
    INNER JOIN sale_item si ON si.sale_id = s.id
    INNER JOIN product   p  ON p.id       = si.product_id
    INNER JOIN category  c  ON c.id       = p.category_id
WHERE e.position LIKE '%продавец%'
   OR e.position LIKE '%Продавец%'
GROUP BY e.id, e.last_name, e.first_name, e.position, c.name
ORDER BY выручка_в_категории DESC;



--CMPLX-3. CTE — портрет покупателя
--Сводный профиль каждого клиента: покупки, сумма, отзывы и средняя оценка.
WITH клиент_покупки AS (
    SELECT
        c.id,
        c.last_name || ' ' || c.first_name AS клиент,
        c.registration_date,
        COUNT(DISTINCT s.id)               AS покупок,
        SUM(s.total_amount)                AS потрачено,
        COUNT(DISTINCT r.id)               AS отзывов,
        ROUND(AVG(r.rating), 2)            AS ср_оценка
    FROM customer c
        LEFT JOIN sale   s ON s.customer_id = c.id
        LEFT JOIN review r ON r.customer_id = c.id
    GROUP BY c.id, c.last_name, c.first_name, c.registration_date
)
SELECT *
FROM клиент_покупки
WHERE покупок > 0
ORDER BY потрачено DESC;



--CMPLX-4. Товары с активными заказами и малым остатком
--Найти товары, на которые есть активные заказы, но которых мало на складе.
SELECT
    p.name                AS товар,
    p.quantity_in_stock   AS остаток,
    COUNT(co.id)          AS активных_заказов,
    b.name                AS бренд,
    s.company_name        AS последний_поставщик
FROM customer_order co
    INNER JOIN product  p ON p.id = co.product_id
    INNER JOIN brand    b ON b.id = p.brand_id
    LEFT JOIN (
        SELECT DISTINCT ON (si.product_id)
            si.product_id,
            sup.supplier_id
        FROM supply_item si
            INNER JOIN supply sup ON sup.id = si.supply_id
        ORDER BY si.product_id, sup.supply_date DESC
    ) last_sup ON last_sup.product_id = p.id
    LEFT JOIN supplier s ON s.id = last_sup.supplier_id
WHERE co.status IN ('Принят', 'В пути', 'Подтверждён')
  AND p.quantity_in_stock < 2
GROUP BY p.name, p.quantity_in_stock, b.name, s.company_name
ORDER BY активных_заказов DESC;



--CMPLX-5. Рейтинг поставщиков: объём, ассортимент, период
--Полная аналитика по каждому поставщику: число поставок, ассортимент, объём и временной диапазон.
SELECT
    s.company_name AS поставщик,
    COUNT(DISTINCT sup.id) AS поставок,
    COUNT(DISTINCT si.product_id) AS ассортимент_позиций,
    SUM(si.quantity) AS единиц_поставлено,
    SUM(si.quantity * si.purchase_price) AS на_сумму,
    MIN(sup.supply_date) AS первая_поставка,
    MAX(sup.supply_date) AS последняя_поставка
FROM supplier s
INNER JOIN supply sup ON sup.supplier_id = s.id
INNER JOIN supply_item si ON si.supply_id = sup.id
GROUP BY s.id, s.company_name
ORDER BY на_сумму DESC;


-- Добавить позиции для существующих поставок (supply_id от 1 до 8)
INSERT INTO supply_item (supply_id, product_id, quantity, purchase_price) VALUES
-- Поставка 1 (supplier_id = 1)
(1, 1, 3, 60000.00),
(1, 2, 2, 90000.00),
(1, 3, 5, 18000.00),
-- Поставка 2 (supplier_id = 2)
(2, 4, 3, 38000.00),
(2, 5, 2, 70000.00),
-- Поставка 3 (supplier_id = 3)
(3, 6, 2, 55000.00),
(3, 7, 3, 48000.00),
-- Поставка 4 (supplier_id = 4)
(4, 8, 1, 85000.00),
(4, 9, 3, 42000.00),
-- Поставка 5 (supplier_id = 5)
(5, 10, 10, 8000.00),
(5, 11, 1, 80000.00),
-- Поставка 6 (supplier_id = 1)
(6, 12, 5, 25000.00),
(6, 13, 4, 35000.00),
-- Поставка 7 (supplier_id = 2)
(7, 14, 30, 500.00),
-- Поставка 8 (supplier_id = 6)
(8, 15, 50, 150.00);

-- ЛАБОРАТОРНАЯ РАБОТА №5


-- ============================================================
-- ЧАСТЬ 0: ГЕНЕРАЦИЯ И ЗАГРУЗКА ТЕСТОВЫХ ДАННЫХ (10 000+ записей)
-- ============================================================

-- Полная очистка
TRUNCATE TABLE review CASCADE;
TRUNCATE TABLE sale_item CASCADE;
TRUNCATE TABLE sale CASCADE;
TRUNCATE TABLE product CASCADE;
TRUNCATE TABLE customer CASCADE;

-- Сброс последовательностей (чтобы ID начинались с 1)
ALTER SEQUENCE IF EXISTS customer_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS product_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS sale_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS sale_item_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS review_id_seq RESTART WITH 1;

SELECT 'customer' AS name, COUNT(*) FROM customer
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'sale', COUNT(*) FROM sale
UNION ALL SELECT 'sale_item', COUNT(*) FROM sale_item
UNION ALL SELECT 'review', COUNT(*) FROM review;

-- Шаг 1: сгенерировать CSV-файлы с помощью Python-скрипта
-- (файл generate_csv.py прилагается).
-- Шаг 2: выполнить COPY-команды ниже, указав путь к CSV.

-- Загрузка клиентов (10 000 записей)
COPY customer (last_name, first_name, middle_name, phone, email, registration_date)
FROM '/Users/elizavetasingareva/бд/customers_bulk.csv'
DELIMITER ',' CSV HEADER;

-- Загрузка товаров (10 000 записей)

COPY product (name, description, retail_price, quantity_in_stock, minimum_stock, category_id, brand_id)
FROM '/Users/elizavetasingareva/бд/products_bulk.csv'
DELIMITER ',' CSV HEADER;


-- Загрузка продаж
-- Теперь customer_id от 13 до 5012 существуют в таблице customer
COPY sale (datetime, total_amount, customer_id, employee_id)
FROM '/Users/elizavetasingareva/бд/sales_bulk.csv'
DELIMITER ',' CSV HEADER;

-- Загрузка позиций продаж
COPY sale_item (sale_id, product_id, quantity, price_at_sale)
FROM '/Users/elizavetasingareva/бд/sale_items_bulk.csv'
DELIMITER ',' CSV HEADER;

-- Загрузка отзывов
COPY review (customer_id, product_id, rating, comment, datetime)
FROM '/Users/elizavetasingareva/бд/reviews_bulk.csv'
DELIMITER ',' CSV HEADER;


-- ============================================================
-- ЧАСТЬ 1: ИНДЕКСЫ
-- ============================================================

-- ── 1.1 Анализ до индексов (EXPLAIN ANALYZE) ─────────────────

-- Запрос ИНД-1: Полный отчёт по продажам (CMPLX-1 из ЛР4)
EXPLAIN ANALYZE
SELECT
    c.name                               AS категория,
    b.name                               AS бренд,
    p.name                               AS товар,
    SUM(si.quantity)                     AS продано_штук,
    SUM(si.quantity * si.price_at_sale)  AS выручка,
    ROUND(AVG(r.rating), 2)              AS рейтинг,
    COUNT(DISTINCT s.id)                 AS продаж
FROM sale_item si
    INNER JOIN product  p ON p.id = si.product_id
    INNER JOIN category c ON c.id = p.category_id
    INNER JOIN brand    b ON b.id = p.brand_id
    INNER JOIN sale     s ON s.id = si.sale_id
    LEFT  JOIN review   r ON r.product_id = p.id
WHERE s.datetime >= '2024-01-01'
GROUP BY c.name, b.name, p.name
HAVING SUM(si.quantity) > 0
ORDER BY выручка DESC
LIMIT 10;

-- Запрос ИНД-2: Поиск товара по бренду и наличию (ФТ-1 из ЛР4)
EXPLAIN ANALYZE
SELECT
    p.name              AS наименование,
    b.name              AS бренд,
    c.name              AS категория,
    p.retail_price      AS цена,
    p.quantity_in_stock AS остаток
FROM product p
    INNER JOIN brand    b ON b.id = p.brand_id
    INNER JOIN category c ON c.id = p.category_id
WHERE b.name = 'Fender'
  AND p.quantity_in_stock > 0
ORDER BY p.retail_price;

-- Запрос ИНД-3: Топ клиентов по сумме покупок (GB-15 из ЛР4)
EXPLAIN ANALYZE
SELECT
    c.last_name || ' ' || c.first_name AS клиент,
    COUNT(s.id)                        AS покупок,
    SUM(s.total_amount)                AS итого
FROM customer c
    INNER JOIN sale s ON s.customer_id = c.id
GROUP BY c.id, c.last_name, c.first_name
ORDER BY итого DESC
LIMIT 5;

-- Запрос ИНД-4: Рейтинг поставщиков (CMPLX-5 из ЛР4)
EXPLAIN ANALYZE
SELECT
    s.company_name                        AS поставщик,
    COUNT(DISTINCT sup.id)                AS поставок,
    COUNT(DISTINCT si.product_id)         AS ассортимент_позиций,
    SUM(si.quantity)                      AS единиц_поставлено,
    SUM(si.quantity * si.purchase_price)  AS на_сумму,
    MIN(sup.supply_date)                  AS первая_поставка,
    MAX(sup.supply_date)                  AS последняя_поставка
FROM supplier s
    INNER JOIN supply      sup ON sup.supplier_id = s.id
    INNER JOIN supply_item si  ON si.supply_id    = sup.id
GROUP BY s.id, s.company_name
ORDER BY на_сумму DESC;

-- Запрос ИНД-5: Поиск отзывов по товарам (JN-10 из ЛР4)
EXPLAIN ANALYZE
SELECT
    c.last_name || ' ' || c.first_name AS клиент,
    p.name                             AS товар,
    r.rating                           AS оценка,
    r.comment                          AS комментарий,
    r.datetime                         AS дата
FROM review r
    INNER JOIN customer c ON c.id = r.customer_id
    INNER JOIN product  p ON p.id = r.product_id
ORDER BY r.rating DESC;


-- ── 1.2 Создание индексов ────────────────────────────────────

-- Индекс 1: поиск товаров по бренду (ФТ-1, ИНД-2)
-- Бренд — частый фильтр в поисковых запросах магазина. 1 2
CREATE INDEX IF NOT EXISTS idx_product_brand_id
    ON product (brand_id);

-- Индекс 2: поиск товаров по категории 1 2
CREATE INDEX IF NOT EXISTS idx_product_category_id
    ON product (category_id);

-- Индекс 3: остаток на складе — часто фильтруем > 0  2
CREATE INDEX IF NOT EXISTS idx_product_stock
    ON product (quantity_in_stock);

-- Индекс 4: дата продажи — фильтрация по периоду (ИНД-1) 1
CREATE INDEX IF NOT EXISTS idx_sale_datetime
    ON sale (datetime);

-- Индекс 5: связь sale_item → sale (JOIN в большинстве запросов) 1
CREATE INDEX IF NOT EXISTS idx_sale_item_sale_id
    ON sale_item (sale_id);

-- Индекс 6: связь sale_item → product 1
CREATE INDEX IF NOT EXISTS idx_sale_item_product_id
    ON sale_item (product_id);

-- Индекс 7: sale.customer_id — JOIN и GROUP BY по клиенту (ИНД-3) 3
CREATE INDEX IF NOT EXISTS idx_sale_customer_id
    ON sale (customer_id);

-- Индекс 8: review.product_id — агрегация оценок по товару 1 5
CREATE INDEX IF NOT EXISTS idx_review_product_id
    ON review (product_id);

-- Индекс 9: review.customer_id — запросы по истории отзывов клиента 5
CREATE INDEX IF NOT EXISTS idx_review_customer_id
    ON review (customer_id);

-- Индекс 10: supply.supplier_id — JOIN поставщик → поставки (ИНД-4) 4
CREATE INDEX IF NOT EXISTS idx_supply_supplier_id
    ON supply (supplier_id);

-- Индекс 11: supply_item.supply_id 4
CREATE INDEX IF NOT EXISTS idx_supply_item_supply_id
    ON supply_item (supply_id);

-- Индекс 12: supply_item.product_id 4
CREATE INDEX IF NOT EXISTS idx_supply_item_product_id
    ON supply_item (product_id);

-- Составной индекс 13: поиск товара по бренду + наличию (ФТ-1)
-- Покрывает оба условия WHERE одним индексом. 2
CREATE INDEX IF NOT EXISTS idx_product_brand_stock
    ON product (brand_id, quantity_in_stock);

-- Составной индекс 14: дата + клиент в таблице sale
CREATE INDEX IF NOT EXISTS idx_sale_datetime_customer
    ON sale (datetime, customer_id);

-- Индекс 15: customer.phone — поиск клиента по телефону (ФТ-2)
-- phone уже UNIQUE (автоматически создан индекс), но явно добавим для наглядности:
-- CREATE INDEX IF NOT EXISTS idx_customer_phone ON customer (phone);
-- (уже существует как UNIQUE constraint — пропускаем дублирование)

-- ============================================================
-- ЧАСТЬ 2: ХРАНИМЫЕ ПРОЦЕДУРЫ (3 шт.)
-- ============================================================

-- ── Процедура 1: Регистрация новой продажи ──────────────────────
-- Принимает: id клиента, id сотрудника, массив пар (product_id, quantity).
-- Создаёт запись в sale, вставляет позиции в sale_item,
-- обновляет остатки и пересчитывает total_amount.
CREATE OR REPLACE PROCEDURE sp_register_sale(
    p_customer_id  BIGINT,
    p_employee_id  BIGINT,
    p_product_ids  BIGINT[],
    p_quantities   INT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_sale_id     BIGINT;
    v_total       DECIMAL(10,2) := 0;
    v_price       DECIMAL(10,2);
    v_stock       INT;
    v_prod_id     BIGINT;
    v_qty         INT;
    v_i           INT;
BEGIN
    -- Проверяем, что массивы одинаковой длины
    IF array_length(p_product_ids, 1) <> array_length(p_quantities, 1) THEN
        RAISE EXCEPTION 'Массивы product_ids и quantities должны быть одной длины';
    END IF;

    -- Создаём заголовок продажи
    INSERT INTO sale (datetime, total_amount, customer_id, employee_id)
    VALUES (NOW(), 0, p_customer_id, p_employee_id)
    RETURNING id INTO v_sale_id;

    -- Обходим товары
    FOR v_i IN 1 .. array_length(p_product_ids, 1) LOOP
        v_prod_id := p_product_ids[v_i];
        v_qty     := p_quantities[v_i];

        -- Получаем текущую цену и остаток
        SELECT retail_price, quantity_in_stock
        INTO   v_price, v_stock
        FROM   product
        WHERE  id = v_prod_id;

        -- Проверяем наличие
        IF v_stock IS NULL THEN
            RAISE EXCEPTION 'Товар с id=% не найден', v_prod_id;
        END IF;

        IF v_stock < v_qty THEN
            RAISE EXCEPTION 'Недостаточно товара id=% на складе (есть: %, нужно: %)',
                v_prod_id, v_stock, v_qty;
        END IF;

        -- Вставляем позицию
        INSERT INTO sale_item (sale_id, product_id, quantity, price_at_sale)
        VALUES (v_sale_id, v_prod_id, v_qty, v_price);

        -- Уменьшаем остаток
        UPDATE product
        SET quantity_in_stock = quantity_in_stock - v_qty
        WHERE id = v_prod_id;

        -- Накапливаем сумму
        v_total := v_total + v_price * v_qty;
    END LOOP;

    -- Обновляем total_amount в чеке
    UPDATE sale
    SET total_amount = v_total
    WHERE id = v_sale_id;

    RAISE NOTICE 'Продажа #% зарегистрирована, сумма: % руб.', v_sale_id, v_total;
END;
$$;

-- Тестовый вызов процедуры 1:
-- Продаём клиенту 1 (через сотрудника 2): 1 шт. товара id=3 и 2 шт. товара id=14
CALL sp_register_sale(1, 2, ARRAY[3, 14]::BIGINT[], ARRAY[1, 2]::INT[]);
CALL sp_register_sale(1, 5, ARRAY[3, 14]::BIGINT[], ARRAY[1, 2]::INT[]);
-- Проверяем результат:
SELECT s.id, s.datetime, s.total_amount, s.customer_id, s.employee_id
FROM sale s
ORDER BY s.datetime DESC
LIMIT 3;

SELECT si.sale_id, si.product_id, si.quantity, si.price_at_sale
FROM sale_item si
ORDER BY si.sale_id DESC
LIMIT 5;


-- ── Процедура 2: Обновление минимального запаса товаров категории ──
-- Принимает: название категории, новый минимальный запас.
-- Обновляет minimum_stock для всех товаров категории,
-- если новый порог отличается от текущего.
CREATE OR REPLACE PROCEDURE sp_set_category_min_stock(
    p_category_name VARCHAR(100),
    p_new_min_stock INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_category_id BIGINT;
    v_updated_cnt INT;
BEGIN
    -- Проверяем входной параметр
    IF p_new_min_stock < 0 THEN
        RAISE EXCEPTION 'Минимальный запас не может быть отрицательным';
    END IF;

    -- Находим id категории
    SELECT id INTO v_category_id
    FROM category
    WHERE name = p_category_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Категория "%" не найдена', p_category_name;
    END IF;

    -- Обновляем только те, у которых значение отличается
    UPDATE product
    SET minimum_stock = p_new_min_stock
    WHERE category_id    = v_category_id
      AND minimum_stock <> p_new_min_stock;

    GET DIAGNOSTICS v_updated_cnt = ROW_COUNT;

    CASE
        WHEN v_updated_cnt = 0 THEN
            RAISE NOTICE 'Все товары категории "%" уже имеют minimum_stock = %',
                p_category_name, p_new_min_stock;
        ELSE
            RAISE NOTICE 'Обновлено % товаров в категории "%": minimum_stock = %',
                v_updated_cnt, p_category_name, p_new_min_stock;
    END CASE;
END;
$$;

-- Тестовый вызов процедуры 2:
CALL sp_set_category_min_stock('Аксессуары', 20);

-- Проверяем:
SELECT name, minimum_stock
FROM product
WHERE category_id = (SELECT id FROM category WHERE name = 'Аксессуары');


-- ── Процедура 3: Автосоздание заказа при дефиците ──────────────────
-- Для каждого товара, у которого quantity_in_stock < minimum_stock,
-- создаёт запись в customer_order для специального клиента (менеджера),
-- если заказ ещё не создан.
CREATE OR REPLACE PROCEDURE sp_auto_create_deficit_orders(
    p_manager_customer_id BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rec      RECORD;
    v_exists   BOOLEAN;
    v_cnt      INT := 0;
BEGIN
    -- Перебираем товары с дефицитом
    FOR v_rec IN
        SELECT id, name, quantity_in_stock, minimum_stock
        FROM product
        WHERE quantity_in_stock < minimum_stock
        ORDER BY (minimum_stock - quantity_in_stock) DESC
    LOOP
        -- Проверяем, нет ли уже активного заказа на этот товар
        SELECT EXISTS (
            SELECT 1 FROM customer_order
            WHERE product_id    = v_rec.id
              AND customer_id   = p_manager_customer_id
              AND status NOT IN ('Выдан', 'Отменён')
        ) INTO v_exists;

        IF NOT v_exists THEN
            INSERT INTO customer_order
                (customer_id, product_id, order_datetime, status)
            VALUES
                (p_manager_customer_id, v_rec.id, NOW(), 'Принят');
            v_cnt := v_cnt + 1;
            RAISE NOTICE 'Создан заказ для товара "%": дефицит % шт.',
                v_rec.name, v_rec.minimum_stock - v_rec.quantity_in_stock;
        ELSE
            RAISE NOTICE 'Товар "%" — активный заказ уже существует', v_rec.name;
        END IF;
    END LOOP;

    RAISE NOTICE 'Всего создано новых заказов: %', v_cnt;
END;
$$;

-- Тестовый вызов процедуры 3:
CALL sp_auto_create_deficit_orders(1);

-- Проверяем:
SELECT co.id, c.last_name, p.name, co.status, co.order_datetime
FROM customer_order co
    INNER JOIN customer c ON c.id = co.customer_id
    INNER JOIN product  p ON p.id = co.product_id
ORDER BY co.order_datetime DESC
LIMIT 10;


-- ============================================================
-- ЧАСТЬ 3: ФУНКЦИИ (3 шт.)
-- ============================================================

-- ── Функция 1: Общая сумма покупок клиента ─────────────────────
-- Принимает: телефон клиента (строка).
-- Возвращает: DECIMAL — суммарно потрачено.

-- Найти клиента с этим номером (в любом формате)
CREATE OR REPLACE FUNCTION fn_customer_total_spent(
    p_phone VARCHAR(20)
)
RETURNS DECIMAL(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id BIGINT;
    v_total       DECIMAL(12,2);
BEGIN
    -- Находим клиента по телефону
    SELECT id INTO v_customer_id
    FROM customer
    WHERE phone = p_phone;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Клиент с телефоном % не найден', p_phone;
    END IF;

    -- Суммируем его покупки
    SELECT COALESCE(SUM(total_amount), 0)
    INTO   v_total
    FROM   sale
    WHERE  customer_id = v_customer_id;

    RETURN v_total;
END;
$$;

-- Тестовый вызов функции 1:
SELECT fn_customer_total_spent('+79314797776') AS потрачено_руб;

-- Вывод для нескольких клиентов:
SELECT
    c.last_name || ' ' || c.first_name          AS клиент,
    c.phone,
    fn_customer_total_spent(c.phone)             AS потрачено_руб
FROM customer c
ORDER BY потрачено_руб DESC
LIMIT 5;


-- ── Функция 2: Средний рейтинг товара по названию ──────────────
-- Принимает: название товара (или часть названия, LIKE).
-- Возвращает: таблицу с названием, числом отзывов и средней оценкой.
CREATE OR REPLACE FUNCTION fn_product_rating_by_name(
    p_name_pattern VARCHAR(255)
)
RETURNS TABLE (
    товар           VARCHAR(255),
    количество_отзывов INT,
    средняя_оценка  NUMERIC(4,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.name::VARCHAR(255),
        COUNT(r.id)::INT,
        ROUND(AVG(r.rating)::NUMERIC, 2)
    FROM product p
        LEFT JOIN review r ON r.product_id = p.id
    WHERE LOWER(p.name) LIKE LOWER('%' || p_name_pattern || '%')
    GROUP BY p.name
    ORDER BY средняя_оценка DESC NULLS LAST;
END;
$$;

-- Тестовый вызов функции 2:
SELECT * FROM fn_product_rating_by_name('комплект');


-- ── Функция 3: Товары с дефицитом и рекомендацией заказа ──────
-- Принимает: множитель заказа (во сколько раз закупить сверх минимума).
-- Возвращает: таблицу с товарами, дефицитом и рекомендуемым объёмом заказа.
CREATE OR REPLACE FUNCTION fn_deficit_report(
    p_order_multiplier NUMERIC DEFAULT 2.0
)
RETURNS TABLE (
    товар           VARCHAR(255),
    остаток         INT,
    минимум         INT,
    дефицит         INT,
    рекомендуем_заказать INT,
    бренд           VARCHAR(100),
    категория       VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_deficit INT;
BEGIN
    -- Проверяем множитель
    IF p_order_multiplier <= 0 THEN
        RAISE EXCEPTION 'Множитель заказа должен быть > 0';
    END IF;

    -- Считаем общий дефицит для NOTICE
    SELECT COALESCE(SUM(minimum_stock - quantity_in_stock), 0)
    INTO   v_total_deficit
    FROM   product
    WHERE  quantity_in_stock < minimum_stock;

    RAISE NOTICE 'Суммарный дефицит по всем товарам: % единиц', v_total_deficit;

    RETURN QUERY
    SELECT
        p.name::VARCHAR(255),
        p.quantity_in_stock,
        p.minimum_stock,
        (p.minimum_stock - p.quantity_in_stock),
        CEIL((p.minimum_stock - p.quantity_in_stock) * p_order_multiplier)::INT,
        b.name::VARCHAR(100),
        c.name::VARCHAR(100)
    FROM product p
        LEFT JOIN brand    b ON b.id = p.brand_id
        LEFT JOIN category c ON c.id = p.category_id
    WHERE p.quantity_in_stock < p.minimum_stock
    ORDER BY (p.minimum_stock - p.quantity_in_stock) DESC;
END;
$$;

-- Тестовый вызов функции 3 (умножитель по умолчанию = 2):
SELECT * FROM fn_deficit_report();

-- С умножителем 3:
SELECT * FROM fn_deficit_report(3.0);


-- ============================================================
-- ЧАСТЬ 4: ПРЕДСТАВЛЕНИЯ (3 шт.)
-- ============================================================

-- ── Представление 1: Детальный список продаж ───────────────────
-- Объединяет sale, sale_item, product, category, brand, customer, employee.
-- Каждая строка — одна позиция в чеке с полной информацией.
CREATE OR REPLACE VIEW v_sale_details AS
SELECT
    s.id                                     AS id_продажи,
    s.datetime                               AS дата_продажи,
    s.total_amount                           AS сумма_чека,
    -- Клиент
    COALESCE(
        c.last_name || ' ' || c.first_name,
        'Анонимный'
    )                                        AS клиент,
    c.phone                                  AS телефон_клиента,
    -- Сотрудник
    e.last_name || ' ' || e.first_name       AS продавец,
    e.position                               AS должность,
    -- Позиция
    p.name                                   AS товар,
    cat.name                                 AS категория,
    b.name                                   AS бренд,
    si.quantity                              AS количество,
    si.price_at_sale                         AS цена_продажи,
    si.quantity * si.price_at_sale           AS сумма_позиции
FROM sale s
    INNER JOIN sale_item si  ON si.sale_id    = s.id
    INNER JOIN product   p   ON p.id          = si.product_id
    INNER JOIN category  cat ON cat.id        = p.category_id
    INNER JOIN brand     b   ON b.id          = p.brand_id
    INNER JOIN employee  e   ON e.id          = s.employee_id
    LEFT  JOIN customer  c   ON c.id          = s.customer_id;

-- Вызов представления 1:
SELECT * FROM v_sale_details ORDER BY дата_продажи DESC LIMIT 20;

-- Агрегация поверх представления:
SELECT категория, SUM(сумма_позиции) AS выручка
FROM v_sale_details
GROUP BY категория
ORDER BY выручка DESC;


-- ── Представление 2: Каталог товаров со статусом наличия ───────
-- Объединяет product, category, brand.
-- Добавляет поле статус_склада на основе остатков.
CREATE OR REPLACE VIEW v_product_catalog AS
SELECT
    p.id                                     AS id_товара,
    p.name                                   AS наименование,
    b.name                                   AS бренд,
    c.name                                   AS категория,
    p.retail_price                           AS цена_руб,
    p.quantity_in_stock                      AS остаток,
    p.minimum_stock                          AS минимум,
    CASE
        WHEN p.quantity_in_stock = 0              THEN 'Нет в наличии'
        WHEN p.quantity_in_stock < p.minimum_stock THEN 'Дефицит'
        WHEN p.quantity_in_stock < p.minimum_stock * 2 THEN 'Мало'
        ELSE                                           'В наличии'
    END                                      AS статус_склада,
    ROUND(AVG(r.rating), 2)                  AS средний_рейтинг,
    COUNT(r.id)                              AS отзывов
FROM product p
    LEFT JOIN category c ON c.id = p.category_id
    LEFT JOIN brand    b ON b.id = p.brand_id
    LEFT JOIN review   r ON r.product_id = p.id
GROUP BY p.id, p.name, b.name, c.name,
         p.retail_price, p.quantity_in_stock, p.minimum_stock;

-- Вызов представления 2:
SELECT * FROM v_product_catalog ORDER BY цена_руб DESC;

-- Только дефицитные:
SELECT наименование, бренд, остаток, минимум
FROM v_product_catalog
WHERE статус_склада IN ('Дефицит', 'Нет в наличии')
ORDER BY остаток;


-- ── Представление 3: Статистика поставщиков ────────────────────
-- Объединяет supplier, supply, supply_item, product.
-- Одна строка на поставщика с агрегированной статистикой.
CREATE OR REPLACE VIEW v_supplier_stats AS
SELECT
    s.id                                      AS id_поставщика,
    s.company_name                            AS поставщик,
    s.contact_person                          AS контактное_лицо,
    s.phone                                   AS телефон,
    COUNT(DISTINCT sup.id)                    AS поставок,
    COUNT(DISTINCT si.product_id)             AS товарных_позиций,
    SUM(si.quantity)                          AS единиц_поставлено,
    SUM(si.quantity * si.purchase_price)      AS общая_сумма_поставок,
    ROUND(AVG(si.purchase_price), 2)          AS средняя_закупочная_цена,
    MIN(sup.supply_date)                      AS первая_поставка,
    MAX(sup.supply_date)                      AS последняя_поставка
FROM supplier s
    LEFT JOIN supply      sup ON sup.supplier_id = s.id
    LEFT JOIN supply_item si  ON si.supply_id    = sup.id
GROUP BY s.id, s.company_name, s.contact_person, s.phone;

-- Вызов представления 3:
SELECT * FROM v_supplier_stats ORDER BY общая_сумма_поставок DESC;

-- Поставщики, с которыми давно не работали:
SELECT поставщик, последняя_поставка
FROM v_supplier_stats
WHERE последняя_поставка < CURRENT_DATE - INTERVAL '60 days'
   OR последняя_поставка IS NULL
ORDER BY последняя_поставка NULLS FIRST;


-- ============================================================
-- ЧАСТЬ 5: ТРИГГЕР
-- ============================================================

-- ── Таблица аудита для триггера ─────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_stock_changes (
    id           BIGSERIAL PRIMARY KEY,
    product_id   BIGINT        NOT NULL,
    product_name VARCHAR(255),
    operation    VARCHAR(10)   NOT NULL,  -- 'SALE' | 'SUPPLY' | 'MANUAL'
    delta        INT           NOT NULL,  -- изменение остатка (отрицательное = списание)
    old_stock    INT,
    new_stock    INT,
    changed_at   TIMESTAMP     NOT NULL DEFAULT NOW(),
    changed_by   VARCHAR(100)
);

-- ── Триггер: автоматический аудит изменений остатка товара ──────
-- Срабатывает AFTER UPDATE на таблице product,
-- когда изменяется поле quantity_in_stock.
-- Записывает: кто, когда, на сколько изменил остаток.
CREATE OR REPLACE FUNCTION fn_trg_stock_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_delta INT;
    v_op    VARCHAR(10);
BEGIN
    v_delta := NEW.quantity_in_stock - OLD.quantity_in_stock;

    -- Определяем тип операции
    IF v_delta < 0 THEN
        v_op := 'SALE';       -- списание = продажа
    ELSIF v_delta > 0 THEN
        v_op := 'SUPPLY';     -- пополнение = поставка
    ELSE
        RETURN NEW;           -- остаток не изменился — ничего не пишем
    END IF;

    INSERT INTO audit_stock_changes
        (product_id, product_name, operation, delta,
         old_stock,  new_stock,   changed_by)
    VALUES
        (NEW.id,     NEW.name,    v_op,      v_delta,
         OLD.quantity_in_stock, NEW.quantity_in_stock,
         current_user);

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_stock_audit
    AFTER UPDATE OF quantity_in_stock
    ON product
    FOR EACH ROW
    EXECUTE FUNCTION fn_trg_stock_audit();

-- ── Тестирование триггера ────────────────────────────────────────

-- 1. Искусственно уменьшаем остаток товара (имитация продажи):
UPDATE product
SET quantity_in_stock = quantity_in_stock - 7
WHERE name = 'Цифровой комплект #4';

-- 2. Увеличиваем остаток (имитация поставки):
UPDATE product
SET quantity_in_stock = quantity_in_stock + 5
WHERE name = 'Yamaha FG800';

-- 3. Вызываем процедуру продажи — она тоже уменьшит остаток:
CALL sp_register_sale(2, 1, ARRAY[3]::BIGINT[], ARRAY[1]::INT[]);

-- Проверяем журнал аудита:
SELECT
    asc2.id,
    asc2.product_name AS товар,
    asc2.operation    AS операция,
    asc2.delta        AS изменение,
    asc2.old_stock    AS было,
    asc2.new_stock    AS стало,
    asc2.changed_at   AS дата_изменения,
    asc2.changed_by   AS пользователь
FROM audit_stock_changes asc2
ORDER BY asc2.changed_at DESC;




DROP INDEX IF EXISTS idx_product_brand_id;
DROP INDEX IF EXISTS idx_product_category_id;
DROP INDEX IF EXISTS idx_product_stock;
DROP INDEX IF EXISTS idx_sale_datetime;
DROP INDEX IF EXISTS idx_sale_item_sale_id;
DROP INDEX IF EXISTS idx_sale_item_product_id;
DROP INDEX IF EXISTS idx_sale_customer_id;
DROP INDEX IF EXISTS idx_review_product_id;
DROP INDEX IF EXISTS idx_review_customer_id;
DROP INDEX IF EXISTS idx_supply_supplier_id;
DROP INDEX IF EXISTS idx_supply_item_supply_id;
DROP INDEX IF EXISTS idx_supply_item_product_id;
DROP INDEX IF EXISTS idx_product_brand_stock;
DROP INDEX IF EXISTS idx_sale_datetime_customer;
