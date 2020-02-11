-- 1.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT * FROM users 
WHERE id in (SELECT user_id FROM orders);

-- 2.Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.*, c.name as catalog_name FROM products as p, catalogs as c WHERE c.id = p.catalog_id;

/* 
	3.(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
	  Поля from, to и label содержат английские названия городов, поле name — русское. 
	  Выведите список рейсов flights с русскими названиями городов.
*/

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	`from` VARCHAR(150),
	`to` VARCHAR(150)
);

INSERT INTO flights(id, `from`, `to`) VALUES
	(NULL, 'moscow', 'omsk'),
	(NULL, 'novgorod', 'kazan'),
	(NULL, 'irkutsk', 'moscow'),
	(NULL, 'omsk', 'irkutsk'),
	(NULL, 'moscow', 'kazan');
	
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	label VARCHAR(150),
	name VARCHAR(150)
);

INSERT INTO cities(label, name) VALUES
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'),
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');
SELECT 
	f.id,
	c.name as 'откуда',
	c1.name as 'куда'
FROM
	flights as f
JOIN
	cities as c
ON 
	f.from = c.label 
JOIN
	cities as c1
ON
	f.to = c1.label
ORDER BY
	id