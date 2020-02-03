-- возвращение имен в алфавитном порядке без повторений
select distinct firstname from users order by firstname 

-- отметка о неактивности пользователя, если он несовершеннолетний
update profiles SET is_active=0 WHERE TIMESTAMPDIFF(year, birthday, NOW()) < 18;

-- скрипт удаления сообщений из "будущего"
delete from messages where created_at > now();  
