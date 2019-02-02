SELECT ('ФИО: Мироненко Елена Борисовна');


--Домашнее задание №3

--Оконные функции.

--Вывести список пользователей в формате userId, movieId, normed_rating, avg_rating где
--userId, movieId - без изменения
--для каждого пользователя преобразовать рейтинг r в нормированный - normed_rating=(r - r_min)/(r_max - r_min), где r_min и r_max соответственно минимально и максимальное значение рейтинга у данного пользователя
--avg_rating - среднее значение рейтинга у данного пользователя
--Вывести первые 30 таких записей

select userid, movieid, rating,
avg(rating) over (partition by userid) as avg_rating,
case 
when (max(rating) over (partition by userid) - min(rating) over (partition by userid)) = 0 then '0'
else (rating - min(rating) over (partition by userid))/(max(rating) over (partition by userid) - min(rating) over (partition by userid))
end as normed_rating
from ratings
order by userid, rating desc
limit 30;

--ETL

--Extract

--Напишите команду создания таблички keywords у неё должно быть 2 поля - id(числовой) и tags (текстовое).
--psql -U postgres -c "ВАША КОМАНДА"

psql -U postgres -c \
    "DROP TABLE IF EXISTS keywords_5"         

psql -U postgres -c '                         
Create table keywords_5 
(
id bigint,
tags text
);'


--Напишите команду копирования данных из файла в созданную вами таблицу
--psql -U postgres -c "ВАША КОМАНДА"

psql -U postgres -c \
    "\\copy keywords_5 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER"

psql -U postgres
SELECT  COUNT(*) FROM keywords_5;

--Transform

--Сформируйте запрос (назовём его ЗАПРОС1) к таблице ratings, в котором будут 2 поля -- movieId -- avg_rating - средний рейтинг, который ставят этому контенту пользователи В выборку должны попасть те фильмы, которым поставили оценки более чем 50 пользователей Список должен быть отсортирован по убыванию по полю avg_rating и по возрастанию по полю movieId Из этой выборки оставить первое 150 элементов
--Теперь мы хотим добавить к выборке хороших фильмов с высоким рейтингов информацию о тегах. Воспользуемся Common Table Expressions. Для этого нужно написать ЗАПРОС2, который присоединяет к выборке таблицу keywords
--WITH top_rated as ( ЗАПРОС1 ) ЗАПРОС2;


With top_rated as
(
select movieid, avg(rating) as avg_rating
from ratings
group by movieid
having count(distinct userid) > 50
order by avg_rating desc, movieid asc
limit 150
)
select t.*, k.tags
from top_rated as t
left join keywords_5 as k
on t.movieid = k.id;

--Load

--Сохраним нашу выборку в новую таблицу top_rated_tags. Для этого мы модифицируем ЗАПРОС2 - вместо простого SELECT сделаем SELECT INTO.


psql -U postgres -c \
    "DROP TABLE IF EXISTS top_rated_tags"

psql -U postgres

WITH top_rated as 
( 
select movieid, avg(rating) as avg_rating
from ratings
group by movieid
having count(distinct userid) > 50
order by avg_rating desc, movieid asc
limit 150
)  
SELECT t.movieid, k.tags as top_rated_tags 
INTO top_rated_tags
FROM top_rated as t
left join keywords_5 as k
on t.movieid = k.id;

--Теперь можно выгрузить таблицу в текстовый файл - пример см. в лекции. Внимание: Поля в текстовом файле нужно разделить при помощи табуляции ( символ E\t).

sudo chmod 777 '/usr/local/share/netology/raw_data'
su - postgres

psql -U postgres -c \
	"\copy (SELECT * FROM top_rated_tags) TO '/usr/local/share/netology/raw_data/top_rated_tags.csv' WITH CSV HEADER DELIMITER as E'\t'"


