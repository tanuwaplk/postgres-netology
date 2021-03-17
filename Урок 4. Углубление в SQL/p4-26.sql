create database название_базы;

create schema lecture_4;

set search_path to lecture_4

======================== Создание таблиц ========================
1. Создайте таблицу "автор" с полями:
- id 
- имя
- псевдоним (может не быть)
- дата рождения
* Используйте 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* для id подойдет serial, ограничение primary key
* Имя и дата рождения - not null
* псевдоним - ограничений нет

create table author (
	id serial primary key,
	author_name varchar(50) not null, -- unique
	nick_name varchar(50),
	born_date date not null,
	create_date timestamp default now(),
	deleted int2 default 0
)

select * from author

1*  Создайте таблицу "Произведения" с полями: id произведения, год, название, id автора
* для id произведения подойдет serial, ограничение primary key
* название - not null
* год > 0 CHECK (год > 0)
* id автора пока оставьте без ограничений

create table books (
	id serial primary key,
	book_name varchar(150) not null,
	book_year int2 not null check(book_year > 1600 and book_year < 2100),
	author_id int2 references author(id)
	--primary key (col1, col2...)
)

select * from books

drop table books

select tc.constraint_name
from information_schema.table_constraints tc
where tc.constraint_schema = 'lecture_4' and tc.constraint_type = 'FOREIGN KEY'

======================== Заполнение таблицы ========================

2. Вставьте данные по 3-м любым писателям в таблицу авторов:
Жюль Габриэль Верн, 08.02.1828
Михаил Юрьевич Лермонтов, Гр. Диарбекир, 03.10.1814
Харуки Мураками, 12.01.1949
* Можно вставлять несколько строк одновременно:
    INSERT INTO table (column1, column2, …)
    VALUES
     (value1, value2, …),
     (value1, value2, …) ,...;

insert into author (author_name, nick_name, born_date)
values ('Жюль Габриэль Верн', null, '08.02.1828'),
	('Михаил Юрьевич Лермонтов', 'Гр. Диарбекир', '03.10.1814'),
	('Харуки Мураками', null, '12.01.1949')
	
insert into author (author_name, born_date)
values ('Жюль Габриэль Верн', '08.02.1828'),
	('Михаил Юрьевич Лермонтов', '03.10.1814'),
	('Харуки Мураками', '12.01.1949')
	
select * from author
	
2. Вставьте данные по 5-м любым произведениям, id автора - заполните NULL:
Двадцать тысяч льё под водой, 1916
Бородино, 1837
Герой нашего времени, 1840
Норвежский лес, 1980
Хроники заводной птицы, 1994

insert into books (book_name, book_year)
select unnest(array['Двадцать тысяч льё под водой', 'Бородино', 'Герой нашего времени', 
	'Норвежский лес', 'Хроники заводной птицы']),
	unnest(array[1916, 1837, 1840, 1980, 1994])
	
select * from books b

insert into books (book_name, book_year)
values ('книга_2', 2030)

delete from books

======================== Модификация таблицы ========================

3. Добавьте поле "место рождения" в таблицу с авторами
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;
 
alter table author add column born_place varchar(50) default 1

alter table author drop column born_place

alter table author alter column born_place drop not null

select * from author a

alter table books alter column book_name type text using book_name::text

select pg_typeof(book_name) from books
 
 3* В таблице произведений измените колонку id автора - внешний ключ - ссылка на авторов
 * ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition
 
alter table books add constraint books_author_fkey foreign key (author_id) references author(id) --ON DELETE CASCADE

alter table books drop constraint books_author_id_fkey

 ======================== Модификация данных ========================

4. Обновите данные, проставив корректное место рождения
писателю:
Жюль Габриэль Верн - Франция
Михаил Юрьевич Лермонтов - Российская Империя
Харуки Мураками - Япония
* UPDATE table
  SET column1 = value1,
   column2 = value2 ,...
  WHERE
   condition;
  
select * from author a

update author
set born_place = 'Франция'
where id = 1

update author
set born_place = 'Россия'
where id = 2

update author
set born_place = 'Япония'
where id = 3

4*. В таблице произведений проставьте id авторов:

Жюль Габриэль Верн: 
    Двадцать тысяч льё под водой
Михаил Юрьевич Лермонтов: 
    Бородино
    Герой нашего времени
Харуки Мураками:
    Норвежский лес
    Хроники заводной птицы

select * from books b   
    
update books
set author_id = 1, book_year = 2006
where id = 1

update books
set author_id = 2
where id in (2,3)

update books
set author_id = (select id from author where author_name = 'Харуки Мураками')
where id in (4,5)

select * from a

create table a (
	col1 int,
	col2 int,
	unique (col1, col2)
)

insert into a
values (null, null)

primary key = unique + not null + index
 
 ======================== Удаление данных ========================
 
 5. Удалите произведение " Двадцать тысяч льё под водой"

select * from books b   

delete from books 
where id = 1

5.1 Удалить автора 

delete from author 
where id = 2

truncate author cascade

select * from author   

drop table author

drop table books

update author 
set deleted = 1
where id = 2

select * 
from author a
where deleted = 0

 ======================================================= Сложные типы данных =======================================================
 
 ======================== json ========================
 Создайте таблицу orders
 
CREATE TABLE orders (
     ID serial PRIMARY KEY,
     info json NOT NULL
);

INSERT INTO orders (info)
VALUES
 (
'{ "customer": "John Doe", "items": {"product": "Beer","qty": 6}}'
 ),
 (
'{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24}}'
 ),
 (
'{ "customer": "Josh William", "items": {"product": "Toy Car","qty": 1}}'
 ),
 (
'{ "customer": "Mary /"ttt Clark", "items": {"product": "Toy Train","qty": 2}}'
 );
 
select * from orders

INSERT INTO orders (info)
VALUES
 (
'{ "a": { "a": { "a": { "a": { "a": { "c": "b"}}}}}}'
 )
 
|{название_товара: quantity, product_id: quantity, product_id: quantity}|общая сумма заказа|


6. Выведите общее количество заказов:
* CAST ( data AS type) преобразование типов
* SUM - агрегатная функция суммы
* -> возвращает JSON
*->> возвращает текст

select pg_typeof(info) from orders

select pg_typeof(info -> 'customer')
from orders

select pg_typeof(info ->> 'customer')
from orders

select sum((info -> 'items' ->> 'qty')::int)
from orders

6*  Выведите среднее количество заказов, продуктов начинающихся на "Toy"

select avg((info -> 'items' ->> 'qty')::int)
from orders
where info -> 'items' ->> 'product' like 'Toy%'

======================== array ========================
7. Выведите сколько раз встречается специальный атрибут (special_features) у
фильма -- сколько элементов содержит атрибут special_features
* array_length(anyarray, int) - возвращает длину указанной размерности массива

select pg_typeof(special_features)
from film

select pg_typeof(array['1',2,3, 'a']::varchar[])

select array_length(special_features, 1), special_features
from film

select array_length('{{1,2,3,4,5},{1,2,3,4,5},{1,2,3,4,5}}'::text[], 1)

select array_length('{{1,2,3,4,5},{1,2,3,4,5},{1,2,3,4,5}}'::text[], 2)

select array_length(array['asdasd', 'asdasdasd'], 2)

select '''';

7* Выведите все фильмы содержащие специальные атрибуты: 'Trailers','Commentaries'
* Используйте операторы:
@> - содержит
<@ - содержится в
*  ARRAY[элементы] - для описания массива

https://postgrespro.ru/docs/postgresql/12/functions-subquery
https://postgrespro.ru/docs/postgrespro/12/functions-array

-- ПЛОХАЯ ПРАКТИКА --
select title, special_features
from film 
where special_features::text ilike '%Trailers%' or special_features::text ilike '%Commentaries%'

select title, special_features
from film 
where special_features[1] = 'Trailers' or special_features[1] = 'Commentaries' or
	special_features[2] = 'Trailers' or special_features[2] = 'Commentaries' or
	special_features[3] = 'Trailers' or special_features[3] = 'Commentaries' or
	special_features[4] = 'Trailers' or special_features[4] = 'Commentaries' 

-- ЧТО-ТО СРЕДНЕЕ ПРАКТИКА --

select title, string_agg(t.unnest, ', ') 
from (select title, unnest(special_features), film_id 
	from film) as t
where t.unnest = 'Trailers' or t.unnest = 'Commentaries'
group by film_id, title

select count(*) from film

-- ХОРОШАЯ ПРАКТИКА --

select title, special_features, array_position(special_features, 'Trailers')
from film 
where array_position(special_features, 'Trailers') is not null or
	array_position(special_features, 'Commentaries') is not null
	
select title, special_features, array_position(special_features, 'Trailers')
from film 
where array_position(special_features, 'Trailers') > 0 or
	array_position(special_features, 'Commentaries') > 0

select array_positions(array[1,2,1,3,1,5], 5)

select title, special_features
from film 
where 'Trailers' = any(special_features) or	'Commentaries' = any(special_features)

any = some 

select title, special_features
from film 
where 'Trailers' = all(special_features) or	'Commentaries' = all(special_features)

select title, special_features
from film 
where special_features @> array['Trailers'] or special_features	@> array['Commentaries']

select title, special_features
from film 
where special_features @> array['Trailers', 'Commentaries']

select title, special_features
from film 
where special_features <@ array['Trailers'] or special_features	<@ array['Commentaries'] or
	special_features <@ array['Trailers', 'Commentaries']
	
select title, special_features
from film 
where special_features && array['Trailers'] or special_features	&& array['Commentaries']