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

-- Таблица регионов РФ
DROP TABLE IF EXISTS region;
CREATE TABLE region (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60),
	
	index region_name(name)
);

-- Таблица городов РФ
DROP TABLE IF EXISTS city;
CREATE TABLE city (
	id SERIAL PRIMARY KEY,
	region_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(60),
	
	index city_name(name),
	FOREIGN KEY (region_id) REFERENCES region(id)	
);

-- Таблица районов города
DROP TABLE IF EXISTS city_area;
CREATE TABLE city_area (
	id SERIAL PRIMARY KEY,
	city_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255),
	
	index city_area_name(name),
	FOREIGN KEY (city_id) REFERENCES city(id)	
);

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


-- Виды медиафайлов
DROP TABLE IF EXISTS ad_media_type;
CREATE TABLE ad_media_type(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    
);

-- Медиафайлы
DROP TABLE IF EXISTS ad_media;
CREATE TABLE ad_media (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60),
	extension VARCHAR(10),
	media_type_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	
	index name_idx(name),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES ad_media_type(id)
);

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
	
	index name_idx(contact_name),
	index phone_idx(contact_phone),
	FOREIGN KEY (category_id) REFERENCES ads_category(id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (ad_media_id) REFERENCES ad_media(id)
);


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
	
	index region_idx(region),
	index city_idx(city),
	index city_area_idx(city_area),
	FOREIGN KEY (item_id) REFERENCES ad_item(id),
	FOREIGN KEY (region_id) REFERENCES region(id),
	FOREIGN KEY (city_id) REFERENCES city(id),
	FOREIGN KEY (city_area_id) REFERENCES city_area(id)
);


-- Текст объявления 
DROP TABLE IF EXISTS ad_item_comment;
CREATE TABLE ad_item_comment (
	id SERIAL PRIMARY KEY,
	item_id BIGINT UNSIGNED NOT NULL,
	pub_time DATETIME,
	title VARCHAR(200),
	body TEXT,
	is_active BIT DEFAULT 1,
	
	index title_idx(title),
	FOREIGN KEY (item_id) REFERENCES ad_item(id)

);


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



/*
 Выборки и представления
*/

-- Представление на выбор объявлений(заголовок, цена) одного пользователя
create or replace 
view user_ads 
as 
select ai.user_id, ai.id , aic.title, ai.price 
from ad_item as ai 
join ad_item_comment as aic 
on ai.user_id = 1 and ai.id = aic.item_id ; 


select * from user_ads;


-- Кол-во объвлений в отдельном регионе

select count(*) as number_of_ads, ail.region_id, r.name 
from ad_item_location as ail 
join region as r 
on ail.region_id = r.id  
group by region_id 
order by number_of_ads desc;


-- Объявления дороже определенной цены 


select ai.id, ai.contact_name, ai.user_id, aic.title, ai.price 
from ad_item as ai join ad_item_comment as aic 
where ai.id in (select id from ad_item where price > 5000) and ai.id = aic.item_id 
order by ai.price;


/*
 * хранимая процедура  
 */

-- Процедура для вставки нового пользователя 
drop procedure if exists create_new_user;
delimiter //
create procedure create_new_user 
(in firstname VARCHAR(50), in lastname VARCHAR(50), in email VARCHAR(120), in phone BIGINT, in region_id BIGINT, in city_id bigint, in city_area_id bigint) 
begin
	insert into users 
		(firstname , lastname , email , phone , region_id , city_id , city_area_id) 
	values
		(firstname , lastname , email , phone , region_id , city_id , city_area_id);
end//
delimiter ;

call create_new_user('John', 'Smith', '123@gmail.com', 79125894678, 1, 1, 1);


/*
 * Триггер
 */

-- Триггеры на внесение/изменение корректной цены объявления

delimiter //
drop trigger if exists correct_price_insert//
create trigger correct_price_insert
before insert on ad_item
for each row
begin
	if new.price <= 0 then 
		signal sqlstate '45000'
		set message_text = 'Введите корректную сумму';
	end if;
end //
delimiter ;

delimiter //
drop trigger if exists correct_price_update//
create trigger correct_price_update
before update on ad_item
for each row
begin
	if new.price <= 0 then 
		signal sqlstate '45000'
		set message_text = 'Введите корректную сумму';
	end if;
end //
delimiter ;
/*
-- Данные для проверки триггеров
insert into ad_item (contact_name , contact_phone , user_id , category_id , price , ad_media_id , is_active , is_premium ) values
	('Thora','1-862-919-8844','1','1','-100','1',1,0),
	('Thora','1-862-919-8844','1','1','0','1',1,0);
	
update ad_item 
set price = -100
where id = 1;

*/