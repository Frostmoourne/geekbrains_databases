/*
 * Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
 * catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
 * идентификатор первичного ключа и содержимое поля name. 
 */


DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	tbl_name VARCHAR(255),
	pk_id BIGINT NOT NULL,
	name_field VARCHAR(255)
) ENGINE=ARCHIVE;


DROP TRIGGER IF EXISTS archive_users;
DELIMITER \\
CREATE TRIGGER archive_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs 
		(tbl_name, pk_id, name_field)
	VALUES 
		('users', new.id, new.name);
END\\
DELIMITER ;

DROP TRIGGER IF EXISTS archive_products;
DELIMITER \\
CREATE TRIGGER archive_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs 
		(tbl_name, pk_id, name_field)
	VALUES 
		('products', new.id, new.name);
END\\
DELIMITER ;

DROP TRIGGER IF EXISTS archive_catalogs;
DELIMITER \\
CREATE TRIGGER archive_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs 
		(tbl_name, pk_id, name_field)
	VALUES 
		('users', new.id, new.name);
END\\
DELIMITER ;

/*
 * Создайте SQL-запрос, который помещает в таблицу users миллион записей. 
 */

DROP PROCEDURE IF EXISTS add_users;
DELIMITER //
CREATE PROCEDURE add_users()
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i < 1000000 DO
		INSERT INTO users (name, birthday_at) VALUES
	    ('NAME', (CURRENT_TIMESTAMP - INTERVAL FLOOR(RAND() * 80) YEAR));
	    SET i = i + 1;
	END WHILE;
END//
DELIMITER ;

CALL add_users();
