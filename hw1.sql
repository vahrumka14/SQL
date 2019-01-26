SELECT ('ФИО: Мироненко Елена Борисовна');

--su - postgres
--psql


-- создание таблицы films


--Табличка films:

--title - название (текст)
--id (число) соответствует film_id в табличке persons2content
--country страна (тест)
--box_office сборы в долларах (число)
--release_year год выпуска (timestamp)


CREATE TABLE films 
(
title varchar(250),
id serial,
country varchar(100),
box_office bigint,
release_year timestamp
);

-- заполнение таблицы films данными

INSERT INTO films VALUES ('Игры разума', 1, 'США', 313542341, '2001-1-1');
INSERT INTO films VALUES ('Умница Уилл Хантинг', 2, 'США', 225933435, '1997-1-1');
INSERT INTO films VALUES ('Жизнь прекрасна', 3, 'Италия', 229163264, '1997-1-1');
INSERT INTO films VALUES ('Матч Поинт', 4, 'США, Великобритания', 78265575, '2005-1-1');
INSERT INTO films VALUES ('Он и Она', 5, 'Франция, Бельгия', 264275, '2017-1-1');

-- создание таблицы persons

--Табличка persons

--id (число) - соответствует person_id в табличке persons2content
--fio (текст) фамилия, имя

CREATE TABLE persons
(
id serial,
fio varchar(200)
);

-- заполнение таблицы persons данными

INSERT INTO persons VALUES (1, 'Рассел Кроу');
INSERT INTO persons VALUES (2, 'Рон Ховард');
INSERT INTO persons VALUES (3, 'Мэтт Дэймон');
INSERT INTO persons VALUES (4, 'Гас Ван Сент');
INSERT INTO persons VALUES (5, 'Роберто Бениньи');
INSERT INTO persons VALUES (6, 'Вуди Аллен');
INSERT INTO persons VALUES (7, 'Скарлетт Йоханссон');
INSERT INTO persons VALUES (8, 'Николя Бедос');

-- создание таблицы persons2content

--Табличка persons2content
--- person_id (число) - id персоны
--- film_id (число) - id контента
--- person_type (текст) тип персоны (актёр, режиссёр и т.д.)

CREATE TABLE persons2content
(
person_id serial,
film_id serial,
person_type varchar(50)
);

-- заполнение таблицы persons2content данными

INSERT INTO persons2content VALUES ( 1, 1, 'актер');
INSERT INTO persons2content VALUES ( 2, 1, 'режиссер');
INSERT INTO persons2content VALUES ( 3, 2, 'актер');
INSERT INTO persons2content VALUES ( 4, 2, 'режиссер');
INSERT INTO persons2content VALUES ( 5, 3, 'актер');
INSERT INTO persons2content VALUES ( 5, 3, 'режиссер');
INSERT INTO persons2content VALUES ( 6, 4, 'режиссер');
INSERT INTO persons2content VALUES ( 7, 4, 'актер');
INSERT INTO persons2content VALUES ( 8, 5, 'режиссер');
INSERT INTO persons2content VALUES ( 8, 5, 'актер');


-- проверка полученных данных

select * from films
left join persons2content as pc
on films.id = pc.film_id
left join persons as p
on p.id = pc.person_id;



