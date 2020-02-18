/*
В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/
DELIMITER \\
DROP TRIGGER IF EXISTS not_null \\
CREATE TRIGGER not_null BEFORE UPDATE ON products
FOR EACH ROW 
BEGIN
	IF new.name IS NULL THEN
		SET NEW.name = COALESCE(NEW.name, OLD.name);		
	END IF;
	IF new.description IS NULL THEN
		SET NEW.description = COALESCE(NEW.description, OLD.description);
	END IF;
END\\

