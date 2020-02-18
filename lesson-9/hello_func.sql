/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE hour int;
	SET hour = hour(now());
	IF hour between 6 and 11 THEN
  		RETURN "Доброе утро!"; 
	ELSEIF hour between 12 and 17 THEN
  		RETURN "Добрый день!"; 
  	ELSEIF hour between 18 and 23 THEN
  		RETURN "Добрый вечер!"; 
  	ELSEIF hour between 0 and 5 THEN
  		RETURN "Доброй ночи!"; 
	END IF;
END//

SELECT hello()//



