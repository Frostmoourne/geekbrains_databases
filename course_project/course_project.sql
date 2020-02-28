DROP DATABASE IF EXISTS advertising_site;
CREATE DATABASE advertising_site;
use advertising_site;

-- Таблица категорий объявлений
DROP TABLE IF EXISTS ads_category;
CREATE TABLE ads_category (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO ads_category (name) VALUES
	('Недвижимость'),
	('Транспорт'),
	('Электроника'),
	('Хобби, отдых, спорт'),
	('Личные вещи'),
	('Бизнес и услуги'),
	('Работа'),
	('Животные');

-- Таблица регионов РФ
DROP TABLE IF EXISTS region;
CREATE TABLE region (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60)
);

-- Вставка нескольких регионов для примера
INSERT INTO region (name) VALUES 
	('Республика Адыгея'),
	('Республика Алтай'),
	('Республика Башкортостан'),
	('Республика Бурятия'),
	('Республика Дагестан'),
	('Республика Ингушетия'),
	('Кабардино-Балкарская Республика'),
	('Республика Калмыкия'),
	('Карачаево-Черкесская Республика'),
	('Республика Карелия'),
	('Республика Коми');

-- Таблица городов РФ
DROP TABLE IF EXISTS city;
CREATE TABLE city (
	id SERIAL PRIMARY KEY,
	region_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(60),	
	FOREIGN KEY (region_id) REFERENCES region(id)	
);

-- Вставка нескольких городов для примера
INSERT INTO city (region_id, name) VALUES
	(1, 'Майкоп'),
	(1, 'Адыгейск'),
	(2, 'Горно-Алтайск'),
	(2, 'Майма'),
	(3, 'Уфа'),
	(3, 'Стерлитамак'),
	(3, 'Салават'),
	(4, 'Улан-Удэ'),
	(4, 'Северобайкальск');


-- Таблица районов города
DROP TABLE IF EXISTS city_area;
CREATE TABLE city_area (
	id SERIAL PRIMARY KEY,
	city_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255),	
	FOREIGN KEY (city_id) REFERENCES city(id)	
);

-- Вставка нескольких районов города для примера
INSERT INTO city_area (city_id, name) VALUES
	(8, 'Железнодорожный'),
	(8, 'Октябрьский'),
	(8, 'Советский'),
	(5, 'Калининский'),
	(5, 'Кировский'),
	(5, 'Ленинский'),
	(5, 'Октябрьский'),
	(5, 'Ордожоникидзевский'),
	(5, 'Советский');

-- Таблица пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(50),
	lastname VARCHAR(50),
	email VARCHAR(120),
	phone BIGINT,
	region_id BIGINT UNSIGNED NOT NULL,
	city_id BIGINT UNSIGNED NOT NULL,
	city_area_id BIGINT UNSIGNED NOT NULL,
	is_active BIT DEFAULT 1,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	
	INDEX users_firstname_lastname(firstname, lastname),
	FOREIGN KEY (region_id) REFERENCES region(id),
	FOREIGN KEY (city_id) REFERENCES city(id),
	FOREIGN KEY (city_area_id) REFERENCES city_area(id)
);


INSERT INTO `users` (id, firstname , lastname , email , phone , region_id , city_id , city_area_id) 
VALUES  
	('1','Joannie','O\'Hara','princess.goldner@example.com','9374071116', 1, 2, 5),
	('2','Wellington','Kirlin','alang@example.com','9127498182', 1, 2, 5),
	('3','Janae','Durgan','millie03@example.com','9921090703', 1, 2, 5),
	('4','Lenna','Marquardt','corbin.parisian@example.org','9456642385', 1, 2, 5),
	('5','Rick','Lakin','ilehner@example.com','9191103792', 1, 2, 5),
	('6','Cydney','Wehner','watsica.mack@example.com','9881942174', 1, 2, 8),
	('7','Willis','Rutherford','wunsch.guadalupe@example.org','9410763172', 1, 2, 8),
	('8','Urban','Kulas','reilly76@example.org','9287811077', 1, 2, 8),
	('9','Nicholas','Runte','marquardt.roscoe@example.com','9163727209', 1, 2, 5),
	('10','Edison','Dickinson','fglover@example.net','9675063949', 1, 2, 5); 

-- Виды медиафайлов
DROP TABLE IF EXISTS ad_media_type;
CREATE TABLE ad_media_type(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO ad_media_type (id, name) VALUES 
	(1, 'Photo'),
	(2, 'Video');

-- Медиафайлы
DROP TABLE IF EXISTS ad_media;
CREATE TABLE ad_media (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60),
	extension VARCHAR(10),
	media_type_id BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (media_type_id) REFERENCES ad_media_type(id)
);

INSERT INTO ad_media VALUES
	(1, 'photo', 'jpg', 1),
	(2, 'clip', 'mp4', 2),
	(3, 'photo123', 'jpg', 1),
	(4, 'video11', 'avi', 2);

-- Предмет объявления, в самом объявлении можно указать другую контактную информацию, отличную от указанной при регистрации
DROP TABLE IF EXISTS ad_item;
CREATE TABLE ad_item (
	id SERIAL PRIMARY KEY,
	contact_name VARCHAR (100),
	contact_phone VARCHAR (45),
	user_id  BIGINT UNSIGNED NOT NULL,
	category_id BIGINT UNSIGNED NOT NULL,
	price FLOAT,
	ad_media_id BIGINT UNSIGNED,
	is_active BIT DEFAULT 1,
	is_premium BIT DEFAULT 0,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (category_id) REFERENCES ads_category(id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (ad_media_id) REFERENCES ad_media(id)
);

INSERT INTO ad_item (id, contact_name, contact_phone , user_id , category_id , price, ad_media_id)
VALUES
	('1', 'Joannie O\'Hara', '9374071116', 1, 2, 17000.00, 1),
	('2', 'Cydney Wehner', '9881942174', 6, 1, 5000.00, NULL),
	('3', 'Nicholas Runte', '9112457454', 9, 5, 7000.00, 2),
	('4', 'LennaMarquardt', '9312478454', 9, 5, 7000.00, 3);


-- Таблица с информацией о местонахождении предмета объявления
DROP TABLE IF EXISTS ad_item_location;
CREATE TABLE ad_item_location (
	item_id BIGINT UNSIGNED NOT NULL,
	region_id BIGINT UNSIGNED NOT NULL,
	region VARCHAR(100),
	city_id BIGINT UNSIGNED NOT NULL,
	city VARCHAR(100),
	city_area_id BIGINT UNSIGNED,
	city_area VARCHAR(100),
	
	FOREIGN KEY (item_id) REFERENCES ad_item(id),
	FOREIGN KEY (region_id) REFERENCES region(id),
	FOREIGN KEY (city_id) REFERENCES city(id),
	FOREIGN KEY (city_area_id) REFERENCES city_area(id)
);

INSERT INTO ad_item_location (item_id , region_id , city_id, city_area_id, region, city, city_area )
VALUES 
	('1', 1, 1, NULL, 'Республика Адыгея', 'Майкоп', NULL),
	('2', 2, 2, 8, 'Республика Башкортостан', 'Уфа', 'Калининский')
;

-- Текст объявления 
DROP TABLE IF EXISTS ad_item_comment;
CREATE TABLE ad_item_comment (
	id SERIAL PRIMARY KEY,
	item_id BIGINT UNSIGNED NOT NULL,
	pub_time DATETIME,
	title VARCHAR(200),
	body TEXT,
	is_active BIT DEFAULT 1,
	user_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (item_id) REFERENCES ad_item(id),
	FOREIGN KEY (user_id) REFERENCES users(id)

);

INSERT INTO ad_item_comment (item_id , title, body, user_id )
VALUES 
	(1, 'Заголовок', 'Текст объявления', 1);


-- Сообщения между пользователями
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    INDEX messages_from_user_id (from_user_id),
    INDEX messages_to_user_id (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)

);

INSERT INTO messages VALUES 
	(1, 1, 2, 'Текст сообщения', now()),
	(2, 2, 1, 'Текст сообщения', now());


/*
 *  ВЫБОРКИ
 */


SELECT 
