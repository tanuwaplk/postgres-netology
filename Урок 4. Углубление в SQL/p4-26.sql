create database ��������_����;

create schema lecture_4;

set search_path to lecture_4

======================== �������� ������ ========================
1. �������� ������� "�����" � ������:
- id 
- ���
- ��������� (����� �� ����)
- ���� ��������
* ����������� 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* ��� id �������� serial, ����������� primary key
* ��� � ���� �������� - not null
* ��������� - ����������� ���

create table author (
	id serial primary key,
	author_name varchar(50) not null, -- unique
	nick_name varchar(50),
	born_date date not null,
	create_date timestamp default now(),
	deleted int2 default 0
)

select * from author

1*  �������� ������� "������������" � ������: id ������������, ���, ��������, id ������
* ��� id ������������ �������� serial, ����������� primary key
* �������� - not null
* ��� > 0 CHECK (��� > 0)
* id ������ ���� �������� ��� �����������

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

======================== ���������� ������� ========================

2. �������� ������ �� 3-� ����� ��������� � ������� �������:
���� �������� ����, 08.02.1828
������ ������� ���������, ��. ���������, 03.10.1814
������ ��������, 12.01.1949
* ����� ��������� ��������� ����� ������������:
    INSERT INTO table (column1, column2, �)
    VALUES
     (value1, value2, �),
     (value1, value2, �) ,...;

insert into author (author_name, nick_name, born_date)
values ('���� �������� ����', null, '08.02.1828'),
	('������ ������� ���������', '��. ���������', '03.10.1814'),
	('������ ��������', null, '12.01.1949')
	
insert into author (author_name, born_date)
values ('���� �������� ����', '08.02.1828'),
	('������ ������� ���������', '03.10.1814'),
	('������ ��������', '12.01.1949')
	
select * from author
	
2. �������� ������ �� 5-� ����� �������������, id ������ - ��������� NULL:
�������� ����� ��� ��� �����, 1916
��������, 1837
����� ������ �������, 1840
���������� ���, 1980
������� �������� �����, 1994

insert into books (book_name, book_year)
select unnest(array['�������� ����� ��� ��� �����', '��������', '����� ������ �������', 
	'���������� ���', '������� �������� �����']),
	unnest(array[1916, 1837, 1840, 1980, 1994])
	
select * from books b

insert into books (book_name, book_year)
values ('�����_2', 2030)

delete from books

======================== ����������� ������� ========================

3. �������� ���� "����� ��������" � ������� � ��������
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;
 
alter table author add column born_place varchar(50) default 1

alter table author drop column born_place

alter table author alter column born_place drop not null

select * from author a

alter table books alter column book_name type text using book_name::text

select pg_typeof(book_name) from books
 
 3* � ������� ������������ �������� ������� id ������ - ������� ���� - ������ �� �������
 * ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition
 
alter table books add constraint books_author_fkey foreign key (author_id) references author(id) --ON DELETE CASCADE

alter table books drop constraint books_author_id_fkey

 ======================== ����������� ������ ========================

4. �������� ������, ��������� ���������� ����� ��������
��������:
���� �������� ���� - �������
������ ������� ��������� - ���������� �������
������ �������� - ������
* UPDATE table
  SET column1 = value1,
   column2 = value2 ,...
  WHERE
   condition;
  
select * from author a

update author
set born_place = '�������'
where id = 1

update author
set born_place = '������'
where id = 2

update author
set born_place = '������'
where id = 3

4*. � ������� ������������ ���������� id �������:

���� �������� ����: 
    �������� ����� ��� ��� �����
������ ������� ���������: 
    ��������
    ����� ������ �������
������ ��������:
    ���������� ���
    ������� �������� �����

select * from books b   
    
update books
set author_id = 1, book_year = 2006
where id = 1

update books
set author_id = 2
where id in (2,3)

update books
set author_id = (select id from author where author_name = '������ ��������')
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
 
 ======================== �������� ������ ========================
 
 5. ������� ������������ " �������� ����� ��� ��� �����"

select * from books b   

delete from books 
where id = 1

5.1 ������� ������ 

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

 ======================================================= ������� ���� ������ =======================================================
 
 ======================== json ========================
 �������� ������� orders
 
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
 
|{��������_������: quantity, product_id: quantity, product_id: quantity}|����� ����� ������|


6. �������� ����� ���������� �������:
* CAST ( data AS type) �������������� �����
* SUM - ���������� ������� �����
* -> ���������� JSON
*->> ���������� �����

select pg_typeof(info) from orders

select pg_typeof(info -> 'customer')
from orders

select pg_typeof(info ->> 'customer')
from orders

select sum((info -> 'items' ->> 'qty')::int)
from orders

6*  �������� ������� ���������� �������, ��������� ������������ �� "Toy"

select avg((info -> 'items' ->> 'qty')::int)
from orders
where info -> 'items' ->> 'product' like 'Toy%'

======================== array ========================
7. �������� ������� ��� ����������� ����������� ������� (special_features) �
������ -- ������� ��������� �������� ������� special_features
* array_length(anyarray, int) - ���������� ����� ��������� ����������� �������

select pg_typeof(special_features)
from film

select pg_typeof(array['1',2,3, 'a']::varchar[])

select array_length(special_features, 1), special_features
from film

select array_length('{{1,2,3,4,5},{1,2,3,4,5},{1,2,3,4,5}}'::text[], 1)

select array_length('{{1,2,3,4,5},{1,2,3,4,5},{1,2,3,4,5}}'::text[], 2)

select array_length(array['asdasd', 'asdasdasd'], 2)

select '''';

7* �������� ��� ������ ���������� ����������� ��������: 'Trailers','Commentaries'
* ����������� ���������:
@> - ��������
<@ - ���������� �
*  ARRAY[��������] - ��� �������� �������

https://postgrespro.ru/docs/postgresql/12/functions-subquery
https://postgrespro.ru/docs/postgrespro/12/functions-array

-- ������ �������� --
select title, special_features
from film 
where special_features::text ilike '%Trailers%' or special_features::text ilike '%Commentaries%'

select title, special_features
from film 
where special_features[1] = 'Trailers' or special_features[1] = 'Commentaries' or
	special_features[2] = 'Trailers' or special_features[2] = 'Commentaries' or
	special_features[3] = 'Trailers' or special_features[3] = 'Commentaries' or
	special_features[4] = 'Trailers' or special_features[4] = 'Commentaries' 

-- ���-�� ������� �������� --

select title, string_agg(t.unnest, ', ') 
from (select title, unnest(special_features), film_id 
	from film) as t
where t.unnest = 'Trailers' or t.unnest = 'Commentaries'
group by film_id, title

select count(*) from film

-- ������� �������� --

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