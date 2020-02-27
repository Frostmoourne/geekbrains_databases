/*
 * описание сайта, функций, аннотация к таблицам, выборки, тригеры, представления
 */




DROP DATABASE IF EXISTS advertising_site;
CREATE DATABASE advertising_site;
use advertising_site;

DROP TABLE IF EXISTS ads_category;
CREATE TABLE ads_category (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS region;
CREATE TABLE region (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60)
);

DROP TABLE IF EXISTS city;
CREATE TABLE city (
	id SERIAL PRIMARY KEY,
	region_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(60),	
	FOREIGN KEY (region_id) REFERENCES region(id)	
);

DROP TABLE IF EXISTS city_area;
CREATE TABLE city_area (
	id SERIAL PRIMARY KEY,
	city_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255),	
	FOREIGN KEY (city_id) REFERENCES city(id)	
);

DROP TABLE IF EXISTS ad_item_location;
CREATE TABLE ad_item_location (
	item_id BIGINT UNSIGNED NOT NULL,
	region_id BIGINT UNSIGNED NOT NULL,
	region VARCHAR(100),
	city_id BIGINT UNSIGNED NOT NULL,
	city VARCHAR(100),
	city_area_id BIGINT UNSIGNED NOT NULL,
	city_area VARCHAR(100),
	
	FOREIGN KEY (region_id) REFERENCES region(id),
	FOREIGN KEY (city_id) REFERENCES city(id),
	FOREIGN KEY (city_area_id) REFERENCES city_area(id)

);


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(50),
	lastname VARCHAR(50),
	email VARCHAR(120),
	phone BIGINT,
	region VARCHAR(100),
	region_id BIGINT UNSIGNED NOT NULL,
	city VARCHAR(100),
	city_id BIGINT UNSIGNED NOT NULL,
	is_active BIT DEFAULT 1,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	
	INDEX users_firstname_lastname(firstname, lastname),
	FOREIGN KEY (region_id) REFERENCES region(id),
	FOREIGN KEY (city_id) REFERENCES city(id)
);

DROP TABLE IF EXISTS ad_item;
CREATE TABLE ad_item (
	id SERIAL PRIMARY KEY,
	contact_name VARCHAR (100),
	contact_phone VARCHAR (45),
	user_id  BIGINT UNSIGNED NOT NULL,
	category_id BIGINT UNSIGNED NOT NULL,
	price FLOAT,
	is_active BIT DEFAULT 1,
	is_premium BIT DEFAULT 0,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (category_id) REFERENCES ads_category(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS ad_media;
CREATE TABLE ad_media (
	id SERIAL PRIMARY KEY,
	ad_item_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(60),
	extension VARCHAR(10),
	content_type VARCHAR(40),
	
	FOREIGN KEY (ad_item_id) REFERENCES ad_item(id)
);


DROP TABLE IF EXISTS ad_item_comment;
CREATE TABLE ad_item_comment (
	id SERIAL PRIMARY KEY,
	item_id BIGINT UNSIGNED NOT NULL,
	pub_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	title VARCHAR(200),
	body TEXT,
	is_active BIT DEFAULT 1,
	user_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (item_id) REFERENCES ad_item(id),
	FOREIGN KEY (user_id) REFERENCES users(id)

);


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




