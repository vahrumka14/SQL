SELECT ('ФИО: Мироненко Елена Борисовна');


--Домашнее задание №2

--1. Простые выборки

--1.1 SELECT , LIMIT - выбрать 10 записей из таблицы rating (Для всех дальнейших запросов выбирать по 10 записей, если не указано иное)

Select *
from ratings 
limit 10;

--1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42", а поле movieid между 100 и 1000

select *
from links
where imdbid like '%42' and movieid between 100 and 1000
limit 10;

--или без включения границ интервала в выборку

select *
from links
where imdbid like '%42' and (movieid > 100 and movieid < 1000)
limit 10;

--2. Сложные выборки: JOIN

--2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5

select distinct imdbId
from links as l
inner join ratings as r
on l.movieid = r.movieid
where rating = 5
limit 10;


--3. Аггрегация данных: базовые статистики

--3.1 COUNT() Посчитать число фильмов без оценок

select count (distinct l.movieid)
from links as l
left join ratings as r
on l.movieid = r.movieid
where r.movieid is null;


--3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5

select userid, avg(rating)
from ratings
group by userid
having avg(rating) > 3.5
order by avg(rating) desc
limit 10;


--4. Иерархические запросы

--4.1 Подзапросы: достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.

select distinct imdbid
from links
where movieid in
(
select movieid
from ratings
group by movieid
having avg(rating) > 3.5
)
limit 10;


--4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок. Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.


with tmp_table
as 
(
select userid
from ratings
group by userid
having count(rating)>10
)
select avg(r.rating)
from tmp_table as t
inner join ratings as r
on t.userid = r.userid;







