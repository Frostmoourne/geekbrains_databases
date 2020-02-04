-- Подсчитайте средний возраст пользователей в таблице users

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;

-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT 
	COUNT(*) AS TOTAL, 
	DAYNAME(concat(substring(NOW(), 1, 5), SUBSTRING(birthday_at, 6, 5))) as `dayname` 
FROM 
	users
GROUP BY 
	`dayname`;

-- Подсчитайте произведение чисел в столбце таблицы

SELECT EXP(SUM(LOG(value))) as multiplication 