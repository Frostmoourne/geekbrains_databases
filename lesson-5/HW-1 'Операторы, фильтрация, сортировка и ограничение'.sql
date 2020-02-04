-- заполнение текущими датой и временем поля created_at и updated_at
UPDATE users SET created_at = NOW(), updated_at = NOW();

-- преобразование VARCHAR к DATETIME
UPDATE users 
	SET created_at = STR_TO_DATE(created_at, '%e.%m.%Y %H:%i'),
		updated_at = STR_TO_DATE(updated_at, '%e.%m.%Y %H:%i');

ALTER TABLE users MODIFY COLUMN created_at DATETIME;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME;


-- группировка по значению value, нулевые запасы в конце

SELECT * FROM storehouses_products ORDER BY value < 1 ASC, value;


-- извлечь пользователей, родившихся в мае и августе

SELECT * FROM users WHERE birthday_at RLIKE 'may|august';


-- Сортировка записей в заданном порядке
SELECT * FROM catalogs WHERE id IN (5,1,2) ORDER BY FIELD(id, 5, 1, 2)
