-- создание базы данных, если БД с таким именем не существует
CREATE DATABASE IF NOT EXISTS example;

-- выбор созданой БД
USE example;

-- создание таблицы
CREATE TABLE IF NOT EXISTS users (
 id INT,
 name CHAR
);
 