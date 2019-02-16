SELECT ('ФИО: Мироненко Елена Борисовна');

--Лабораторная работа по модулю “SQL и получение данных”

--1. Используя редактор сайта https://www.db-fiddle.com создать схему базы данных (создать таблицы и заполнить их). Использовать синтаксис PostgreSQL 10.

CREATE TABLE Department
(
id int primary key,
name varchar(250)
);

CREATE TABLE Employee
(
id int primary key,
department_id int references Department(id),
chief_doc_id int,
name varchar(250),
num_public int
);

insert into Department values
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');

insert into Employee values
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);


--2. В том же редакторе https://www.db-fiddle.com создать следующие SQL-запросы:

--a) Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов

--2. Добавляем к таблице Department кол-во главных врачей, так как нам нужно вывести имя каждого департамента 
select d.name, a.count_chief_doc
from Department as d
left join
--1. Считаем кол-во главных врачей по каждому департаменту
(select e.department_id, count(distinct e.chief_doc_id) as count_chief_doc 
from Employee as e
group by e.department_id) as a
on a.department_id = d.id
order by d.name;

--b) Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)

--2. Добавляем название департаментов
select d.*, a.count_employee
from Department as d
inner join
--1. Находим департаменты, в которых работают больше трех сотрудников
(select e.department_id, count (distinct e.id) as count_employee
from Employee as e
group by e.department_id
having count (distinct e.id) >= 3 ) as a
on a.department_id = d.id;

--c) Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)

with temp_table 
as(
--2. Находим максимальное значение публикаций по каждому департаменту и сортируем по убыванию
select id, name, max(sum_num_public) as max_sum_num_public
from
(
--1. Выводим суммарное значение публикаций по каждому департаменту
select d.*, sum(num_public) as sum_num_public
from Employee as e
left join Department as d
on e.department_id = d.id
group by d.id) as a
group by id, name 
order by max_sum_num_public desc
)
--4. Сравниваем, чтобы максимальное кол-во публикаций соответствовало первому максимальному значению из темп таблицы, так как у нас может быть несколько департаментов с равным максимальным кол-вом публикаций
select * from temp_table
where max_sum_num_public in (
--3. Выбираем первое максимальное значение из темповой таблицы
select max_sum_num_public
from temp_table  
limit 1);

--d) Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)

with temp_table
as(
--2. Находим минимальное кол-во публикаций для каждого департамента
select department_id, min(sum_num_public) as min_num_public
from 
(
--1. Находим суммарное кол-во публикаций для каждого департамента и сотрудника. Так как теоретически могут быть дубли по одному департаменту и сотруднику
select e.department_id, e.name, sum(num_public) as sum_num_public
from Employee as e
group by e.department_id, e.name) as a
group by department_id
)
select id, name, name_employee, sum_num_public
from
(
--3. Находим суммарное кол-во публикаций для каждого департамента и сотрудника, так как теоретически могут быть дубли по одному департаменту и сотруднику
select d.*, e.name as name_employee, sum(e.num_public) as sum_num_public
from Employee as e
inner join Department as d
on d.id = e.department_id
group by d.id, e.name
) as h
--4. Оставляем только те записи, в которых суммарное значение публикаций по сотруднику и департаменту равно минимальному значению публикаций по департаменту
inner join temp_table as t
on h.id = t.department_id and h.sum_num_public=t.min_num_public
order by id, name;

--e) Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)

--2. Выводим департаменты и среднее кол-во публикаций, для тех департаментов которые удовлетворяют условию
select d.*, avg(num_public) as avg_num_public
from Employee as e
inner join Department as d
on e.department_id = d.id
where d.id in
(
--1. Находим департаменты, в которых работает больше одного главврача 
 select e.department_id
from Employee as e
group by e.department_id
having count(distinct e.chief_doc_id) > 1
)
group by d.id
order by avg_num_public desc;

--3. Полученные результаты из пункта 2 (набор запросов), сохранить в файл формата .sql и отправить координатору.

