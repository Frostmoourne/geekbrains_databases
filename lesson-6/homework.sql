-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
select 
count(*) as number_of_msg, 
from_user_id 
from messages
where to_user_id = 1 and (from_user_id in 
	(select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
		union
	 select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'))
group by from_user_id
order by number_of_msg DESC

-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
	
select 
	count(*) as number_of_likes
from likes
where user_id in (select user_id from profiles where timestampdiff(year, birthday, now()) < 10)


-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

select 
	'female' as gender,	
	count(*) as likes	
from likes
where user_id in (select user_id from profiles where gender = 'f')
union 
select 
	'male' as gender,	
	count(*) as likes
from likes
where user_id in (select user_id from profiles where gender = 'm')