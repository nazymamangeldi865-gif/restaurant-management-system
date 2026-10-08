
CREATE DATABASE meiramkhana_db;
GO

USE meiramkhana_db;
GO



CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    aty NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    telefon NVARCHAR(20),
    qupiyasoz NVARCHAR(100) NOT NULL,
    roli NVARCHAR(20) NOT NULL,

    CHECK (roli IN ('client', 'manager', 'waiter', 'admin'))
);
GO


CREATE TABLE restaurants (
    restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
    manager_id INT,
    atauy NVARCHAR(150) NOT NULL,
    mekenzhai NVARCHAR(200) NOT NULL,
    ashana_turi NVARCHAR(100),
    sipattama NVARCHAR(MAX),
    reyting DECIMAL(2,1) DEFAULT 0,
    zhumys_uakyty NVARCHAR(100),

    CHECK (reyting BETWEEN 0 AND 5),

    FOREIGN KEY (manager_id)
        REFERENCES users(user_id)
);
GO



CREATE TABLE restaurant_tables (
    table_id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT NOT NULL,
    ustel_nomeri INT NOT NULL,
    adam_sany INT NOT NULL,
    status NVARCHAR(20) DEFAULT 'available',

    CHECK (adam_sany > 0),

    CHECK (
        status IN (
            'available',
            'reserved',
            'occupied'
        )
    ),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    UNIQUE (restaurant_id, ustel_nomeri)
);
GO


-- 5. Мәзір кестесі

CREATE TABLE menus (
    menu_id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT NOT NULL,
    atauy NVARCHAR(100) NOT NULL,

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
GO


-- 6. Тағамдар кестесі

CREATE TABLE menu_items (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    menu_id INT NOT NULL,
    atauy NVARCHAR(120) NOT NULL,
    sipattama NVARCHAR(MAX),
    sanaty NVARCHAR(50),
    bagasy DECIMAL(10,2) NOT NULL,
    kolzhetimdi BIT DEFAULT 1,

    CHECK (bagasy > 0),

    FOREIGN KEY (menu_id)
        REFERENCES menus(menu_id)
);
GO


-- 7. Бронь кестесі

CREATE TABLE bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    table_id INT NOT NULL,
    kuni DATE NOT NULL,
    uakyty TIME NOT NULL,
    adam_sany INT NOT NULL,
    status NVARCHAR(20) DEFAULT 'pending',

    CHECK (adam_sany > 0),

    CHECK (
        status IN (
            'pending',
            'confirmed',
            'cancelled',
            'completed'
        )
    ),

    FOREIGN KEY (client_id)
        REFERENCES users(user_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    FOREIGN KEY (table_id)
        REFERENCES restaurant_tables(table_id)
);
GO


-- 8. Тапсырыстар кестесі

CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    tapsyrys_uakyty DATETIME2 DEFAULT SYSDATETIME(),
    status NVARCHAR(20) DEFAULT 'new',
    zhalpy_soma DECIMAL(10,2) DEFAULT 0,

    CHECK (zhalpy_soma >= 0),

    CHECK (
        status IN (
            'new',
            'preparing',
            'ready',
            'completed',
            'cancelled'
        )
    ),

    FOREIGN KEY (client_id)
        REFERENCES users(user_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
GO


-- 9. Тапсырыс құрамы

CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    sany INT NOT NULL,
    bir_dana_bagasy DECIMAL(10,2) NOT NULL,

    CHECK (sany > 0),
    CHECK (bir_dana_bagasy > 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id)
);
GO


-- 10. Төлемдер кестесі

CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    soma DECIMAL(10,2) NOT NULL,
    tolem_turi NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) DEFAULT 'pending',
    tolem_uakyty DATETIME2 DEFAULT SYSDATETIME(),

    CHECK (soma > 0),

    CHECK (
        tolem_turi IN (
            'cash',
            'card',
            'online'
        )
    ),

    CHECK (
        status IN (
            'pending',
            'paid',
            'refunded'
        )
    ),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);
GO


-- 11. Пікірлер кестесі

CREATE TABLE reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    bagasy INT NOT NULL,
    pikir NVARCHAR(MAX),
    jazylgan_uakyty DATETIME2 DEFAULT SYSDATETIME(),

    CHECK (bagasy BETWEEN 1 AND 5),

    FOREIGN KEY (client_id)
        REFERENCES users(user_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
GO


-- 12. Хабарламалар кестесі

CREATE TABLE notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    habar NVARCHAR(MAX) NOT NULL,
    turi NVARCHAR(30),
    okyldy BIT DEFAULT 0,
    zhiberilgen_uakyty DATETIME2 DEFAULT SYSDATETIME(),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);
GO


-- 13. Пайдаланушыларды енгізу

INSERT INTO users
(aty, email, telefon, qupiyasoz, roli)
VALUES
(N'Назым Амангелді', 'nazym@gmail.com', '87001111101', '12345', 'client'),
(N'Айгерім Нұрлан', 'aigerim@gmail.com', '87001111102', '12345', 'client'),
(N'Диас Серік', 'dias@gmail.com', '87001111103', '12345', 'client'),
(N'Мадина Асқар', 'madina@gmail.com', '87001111104', '12345', 'client'),
(N'Арман Дәулет', 'arman@gmail.com', '87001111105', '12345', 'client'),

(N'Әлихан Серік', 'alikhan.manager@gmail.com', '87002222201', '12345', 'manager'),
(N'Дана Болат', 'dana.manager@gmail.com', '87002222202', '12345', 'manager'),
(N'Нұрсұлтан Қайрат', 'nursultan.manager@gmail.com', '87002222203', '12345', 'manager'),

(N'Данияр Асқар', 'daniyar.waiter@gmail.com', '87003333301', '12345', 'waiter'),
(N'Әсем Еркін', 'asem.waiter@gmail.com', '87003333302', '12345', 'waiter'),
(N'Бекзат Марат', 'bekzat.waiter@gmail.com', '87003333303', '12345', 'waiter'),

(N'Жүйе әкімшісі', 'admin@gmail.com', '87004444401', '12345', 'admin'),

(N'Камила Руслан', 'kamila@gmail.com', '87005555501', '12345', 'client'),
(N'Руслан Айбек', 'ruslan@gmail.com', '87005555502', '12345', 'client'),
(N'Мирас Ержан', 'miras.waiter@gmail.com', '87005555503', '12345', 'waiter');
GO


-- 14. Мейрамханаларды енгізу

INSERT INTO restaurants
(manager_id, atauy, mekenzhai, ashana_turi, sipattama, reyting, zhumys_uakyty)
VALUES
(6, N'Gastro Prive', N'Алматы, Абылай хан 120',
 N'Еуропалық асхана', N'Заманауи мейрамхана', 4.8, N'10:00-00:00'),

(7, N'Qazaq Gourmet', N'Алматы, Достық 55',
 N'Қазақ асханасы', N'Ұлттық тағамдар мейрамханасы', 4.7, N'09:00-23:00'),

(8, N'Sakura', N'Алматы, Әл-Фараби 77',
 N'Жапон асханасы', N'Суши және жапон тағамдары', 4.6, N'11:00-00:00'),

(6, N'Bella Italia', N'Алматы, Төле би 101',
 N'Итальян асханасы', N'Паста және пицца мейрамханасы', 4.5, N'10:00-23:30'),

(7, N'Steak House', N'Алматы, Назарбаев 88',
 N'Ет тағамдары', N'Стейк және гриль тағамдары', 4.9, N'12:00-01:00');
GO


-- 15. Үстелдерді енгізу

INSERT INTO restaurant_tables
(restaurant_id, ustel_nomeri, adam_sany, status)
VALUES
(1, 1, 2, 'available'),
(1, 2, 4, 'reserved'),
(1, 3, 6, 'available'),
(1, 4, 4, 'occupied'),

(2, 1, 2, 'available'),
(2, 2, 4, 'available'),
(2, 3, 6, 'reserved'),
(2, 4, 8, 'available'),

(3, 1, 2, 'occupied'),
(3, 2, 4, 'available'),
(3, 3, 4, 'reserved'),
(3, 4, 6, 'available'),

(4, 1, 2, 'available'),
(4, 2, 4, 'available'),
(4, 3, 6, 'occupied'),
(4, 4, 8, 'available'),

(5, 1, 2, 'reserved'),
(5, 2, 4, 'available'),
(5, 3, 6, 'available'),
(5, 4, 8, 'available');
GO


-- 16. Мәзірлерді енгізу

INSERT INTO menus
(restaurant_id, atauy)
VALUES
(1, N'Gastro Prive негізгі мәзірі'),
(2, N'Qazaq Gourmet мәзірі'),
(3, N'Sakura мәзірі'),
(4, N'Bella Italia мәзірі'),
(5, N'Steak House мәзірі');
GO


-- 17. Тағамдарды енгізу

INSERT INTO menu_items
(menu_id, atauy, sipattama, sanaty, bagasy)
VALUES
(1, N'Цезарь салаты', N'Тауық еті қосылған салат', N'Салат', 3500),
(1, N'Рибай стейк', N'Сиыр етінен стейк', N'Негізгі тағам', 8500),
(1, N'Тирамису', N'Итальян десерті', N'Десерт', 2800),
(1, N'Латте', N'Сүт қосылған кофе', N'Сусын', 1800),

(2, N'Бешбармақ', N'Қазақтың ұлттық тағамы', N'Негізгі тағам', 5500),
(2, N'Қуырдақ', N'Еттен дайындалатын тағам', N'Негізгі тағам', 4800),
(2, N'Бауырсақ', N'Ұлттық нан өнімі', N'Нан', 1500),
(2, N'Қымыз', N'Ұлттық сусын', N'Сусын', 2000),

(3, N'Филадельфия ролл', N'Лосось қосылған ролл', N'Суши', 4200),
(3, N'Калифорния ролл', N'Краб қосылған ролл', N'Суши', 3900),
(3, N'Рамен', N'Жапон кеспесі', N'Сорпа', 4500),
(3, N'Моти', N'Жапон десерті', N'Десерт', 2200),

(4, N'Маргарита', N'Классикалық итальян пиццасы', N'Пицца', 4000),
(4, N'Карбонара', N'Итальян пастасы', N'Паста', 4600),
(4, N'Лазанья', N'Ет қосылған лазанья', N'Паста', 4800),
(4, N'Панна котта', N'Итальян десерті', N'Десерт', 2500),

(5, N'T-Bone стейк', N'Үлкен сиыр стейкі', N'Стейк', 9500),
(5, N'Филе миньон', N'Жұмсақ сиыр еті', N'Стейк', 10500),
(5, N'Гриль көкөністер', N'Грильде пісірілген көкөніс', N'Гарнир', 2800),
(5, N'Шоколад фондан', N'Ыстық шоколад десерті', N'Десерт', 3200);
GO


-- 18. Броньдарды енгізу

INSERT INTO bookings
(client_id, restaurant_id, table_id, kuni, uakyty, adam_sany, status)
VALUES
(1, 1, 2, '2026-10-10', '19:00', 4, 'confirmed'),
(2, 1, 3, '2026-10-11', '18:30', 5, 'pending'),
(3, 2, 5, '2026-10-12', '20:00', 2, 'confirmed'),
(4, 2, 7, '2026-10-13', '19:30', 6, 'confirmed'),
(5, 3, 10, '2026-10-14', '18:00', 4, 'pending'),

(13, 3, 11, '2026-10-15', '20:30', 4, 'confirmed'),
(14, 4, 13, '2026-10-16', '19:00', 2, 'cancelled'),
(1, 4, 14, '2026-10-17', '20:00', 4, 'confirmed'),
(2, 5, 18, '2026-10-18', '19:30', 4, 'pending'),
(3, 5, 19, '2026-10-19', '18:30', 6, 'confirmed'),

(4, 1, 1, '2026-10-20', '17:00', 2, 'completed'),
(5, 2, 6, '2026-10-21', '18:00', 4, 'confirmed'),
(13, 3, 12, '2026-10-22', '20:00', 6, 'pending'),
(14, 4, 16, '2026-10-23', '19:00', 8, 'confirmed'),
(1, 5, 20, '2026-10-24', '21:00', 8, 'confirmed');
GO


-- 19. Тапсырыстарды енгізу

INSERT INTO orders
(client_id, restaurant_id, status, zhalpy_soma)
VALUES
(1, 1, 'completed', 12000),
(2, 1, 'ready', 6300),
(3, 2, 'completed', 7500),
(4, 2, 'preparing', 10300),
(5, 3, 'new', 8100),

(13, 3, 'completed', 6700),
(14, 4, 'ready', 8600),
(1, 4, 'completed', 7300),
(2, 5, 'preparing', 12300),
(3, 5, 'completed', 13300),

(4, 1, 'new', 5300),
(5, 2, 'ready', 7000),
(13, 3, 'completed', 8400),
(14, 4, 'preparing', 8800),
(1, 5, 'completed', 13300);
GO


-- 20. Тапсырыс құрамын енгізу

INSERT INTO order_items
(order_id, item_id, sany, bir_dana_bagasy)
VALUES
(1, 1, 1, 3500),
(1, 2, 1, 8500),

(2, 1, 1, 3500),
(2, 3, 1, 2800),

(3, 5, 1, 5500),
(3, 8, 1, 2000),

(4, 6, 1, 4800),
(4, 5, 1, 5500),

(5, 9, 1, 4200),
(5, 10, 1, 3900),

(6, 11, 1, 4500),
(6, 12, 1, 2200),

(7, 13, 1, 4000),
(7, 14, 1, 4600),

(8, 15, 1, 4800),
(8, 16, 1, 2500),

(9, 17, 1, 9500),
(9, 19, 1, 2800),

(10, 18, 1, 10500),
(10, 19, 1, 2800);
GO


-- 21. Төлемдерді енгізу

INSERT INTO payments
(order_id, soma, tolem_turi, status)
VALUES
(1, 12000, 'card', 'paid'),
(2, 6300, 'online', 'paid'),
(3, 7500, 'cash', 'paid'),
(4, 10300, 'card', 'pending'),
(5, 8100, 'online', 'pending'),

(6, 6700, 'card', 'paid'),
(7, 8600, 'cash', 'paid'),
(8, 7300, 'online', 'paid'),
(9, 12300, 'card', 'pending'),
(10, 13300, 'card', 'paid'),

(11, 5300, 'cash', 'pending'),
(12, 7000, 'online', 'paid'),
(13, 8400, 'card', 'paid'),
(14, 8800, 'cash', 'pending'),
(15, 13300, 'online', 'paid');
GO


-- 22. Пікірлерді енгізу

INSERT INTO reviews
(client_id, restaurant_id, bagasy, pikir)
VALUES
(1, 1, 5, N'Қызмет көрсету өте жақсы'),
(2, 1, 4, N'Тағамдары дәмді'),
(3, 2, 5, N'Ұлттық тағамдар ұнады'),
(4, 2, 4, N'Қызмет көрсету жақсы'),
(5, 3, 5, N'Суши өте дәмді'),

(13, 3, 4, N'Интерьері ұнады'),
(14, 4, 5, N'Пиццасы керемет'),
(1, 4, 4, N'Паста өте жақсы'),
(2, 5, 5, N'Стейк керемет'),
(3, 5, 5, N'Қызмет жоғары деңгейде'),

(4, 1, 4, N'Жақсы мейрамхана'),
(5, 2, 5, N'Бешбармақ өте дәмді'),
(13, 3, 4, N'Жапон тағамдары ұнады'),
(14, 4, 5, N'Отбасымен келуге жақсы'),
(1, 5, 5, N'Ет тағамдары өте жақсы');
GO


-- 23. Хабарламаларды енгізу

INSERT INTO notifications
(user_id, habar, turi)
VALUES
(1, N'Бронь расталды', N'booking'),
(2, N'Бронь қабылданды', N'booking'),
(3, N'Тапсырыс дайын', N'order'),
(4, N'Бронь расталды', N'booking'),
(5, N'Тапсырыс қабылданды', N'order'),

(13, N'Бронь расталды', N'booking'),
(14, N'Бронь жойылды', N'booking'),
(1, N'Төлем сәтті өтті', N'payment'),
(2, N'Тапсырыс дайындалып жатыр', N'order'),
(3, N'Төлем сәтті өтті', N'payment'),

(4, N'Үстел дайын', N'booking'),
(5, N'Тапсырыс дайын', N'order'),
(13, N'Төлем қабылданды', N'payment'),
(14, N'Тапсырыс қабылданды', N'order'),
(1, N'Бронь туралы еске салу', N'booking');
GO


-- 24. Мәліметтерді көру

SELECT * FROM users;
SELECT * FROM restaurants;
SELECT * FROM restaurant_tables;
SELECT * FROM menus;
SELECT * FROM menu_items;
SELECT * FROM bookings;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;
SELECT * FROM reviews;
SELECT * FROM notifications;
GO


-- 25. Мәліметті өзгерту

UPDATE bookings
SET status = 'confirmed'
WHERE booking_id = 2;
GO

SELECT * FROM bookings;
GO


UPDATE menu_items
SET bagasy = 3800
WHERE item_id = 1;
GO

SELECT * FROM menu_items;
GO


-- 26. Мәліметті жою

DELETE FROM reviews
WHERE review_id = 15;
GO

SELECT * FROM reviews;
GO
