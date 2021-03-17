create table table_one (
	name_one varchar(255) not null
);

create table table_two (
	name_two varchar(255) not null
);

insert into table_one (name_one)
values ('one'), ('two'), ('three'), ('four'), ('five')

insert into table_two (name_two)
values ('four'), ('five'), ('six'), ('seven'), ('eight')

select * from table_one

select * from table_two

--left, right, inner, full outer, cross

select t1.name_one, t2.name_two
from table_one t1
inner join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

select count(*)
from customer

select count(*)
from customer c 
left join address a on a.address_id = c.address_id

select count(*)
from customer c 
inner join address a on a.address_id = c.address_id

select t1.name_one, t2.name_two
from table_one t1
right join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1
cross join table_two t2

select t1.name_one, t2.name_two
from table_one t1, table_two t2

-- ��� �� �����
select t1.name_one, t2.name_two
from table_one t1, table_two t2
where t1.name_one = t2.name_two
--

t1.name_one != null -- ������ �� ������
t1.name_one is null / t1.name_one is not null

delete from table_one;
delete from table_two;

insert into table_one (name_one)
select unnest(array[1,1,2])

insert into table_two (name_two)
select unnest(array[1,1,3])

select * from table_one

select * from table_two

select t1.name_one, t2.name_two
from table_one t1
inner join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
right join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1
cross join table_two t2

1a 1b
1c 1d
2  3

1a 1b, 1a 1d, 1c 1b, 1c 1d

select t1.name_one, t2.name_two
from table_one t1, table_two t2
where t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

-- 5 ���������� �����

============= ���������� =============

1. �������� ������ �������� ���� ������� � �� ������ (������� language)
* ����������� ������� film
* ��������� � language
* �������� ���������� � �������:
title, language."name"

select f.title, l.name
from film f
left join language l on f.language_id = l.language_id

1.1 �������� ��� ������ � �� ���������:
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* �������� ���������� � �������:
title, category."name"
--using

select f.title, c."name"
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id

select f.title, c."name"
from film f
join film_category fc using(film_id)
join category c using(category_id)

select f.title, c."name"
from category c
join film_category fc using(category_id)
join film f using(film_id)

select "select"
from "table"

2. �������� ������ ���� �������, ����������� � ������ Lambs Cincinatti (film_id = 508). 
* ����������� ������� film
* ��������� � film_actor
* ��������� � actor
* ������������, ��������� where � "title like" (��� ��������) ��� "film_id =" (��� id)

select f.title, a.last_name, a.first_name
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 508

2.1 �������� ��� �������� �� ������ Woodridge (city_id = 576)
* ����������� ������� store
* ��������� ������� � address 
* ��������� ������� � city 
* ��������� ������� � country 
* ������������ , ��������� where � "city like" (��� �������� ������) ��� "city_id ="  (��� id)
* �������� ������ ����� ������� ��������� � �� id:
store_id, postal_code, country, city, district, address, address2, phone

select s.store_id
from city c
left join country c2 on c.country_id = c2.country_id
left join address a on a.city_id = c.city_id
left join store s on s.address_id = a.address_id
where c.city_id = 576

select s.store_id
from city c
join country c2 on c.country_id = c2.country_id
join address a on a.city_id = c.city_id
join store s on s.address_id = a.address_id
where c.city_id = 576

select s.store_id
from city c
right join country c2 on c.country_id = c2.country_id
right join address a on a.city_id = c.city_id
right join store s on s.address_id = a.address_id
where c.city_id = 576

select 1 as x, 1 as y
union
select 1 as a, 1 as b

select 1 as x, 2 as y
union
select 1 as a, 1 as b

select 1 as x, 1 as y
union all
select 1 as a, 1 as b

select 1 as x, 2 as y
except
select 1 as a, 1 as b

select 1 as x, 1 as y
union all
select 1 as a, 1 as b
except
select 1 as a, 1 as b

select concat(t1.name_one, t2.name_two)
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select 
	case
		when t1.name_one is null then t2.name_two
		else '���-�� ����� �� ���'
	end
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

============= ���������� ������� =============

3. ����������� ���������� ������� � ������ Grosse Wonderful (id - 384)
* ����������� ������� film
* ��������� � film_actor
* ������������, ��������� where � "title like" (��� ��������) ��� "film_id =" (��� id) 
* ��� �������� ����������� ������� count, ����������� actor_id � �������� ��������� ������ �������
--��, ������� ���������� 

select count(fa.actor_id)
from film f
left join film_actor fa on f.film_id = fa.film_id
where f.film_id = 384

select count(fa.actor_id)
from film f
left join film_actor fa on f.film_id = fa.film_id

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
left join film_actor fa on f.film_id = fa.film_id
group by f.film_id


select *
from film_actor fa

FROM
ON
JOIN
WHERE
GROUP by --�����, �� �� � ������ ���� ��� �����������
WITH CUBE ��� WITH ROLLUP
HAVING
select --������ 
DISTINCT
ORDER by

select f.title as a, count(fa.actor_id), f.description as b, f.release_year as c
from film f
left join film_actor fa on f.film_id = fa.film_id
group by a,b,c

select f.title as a, count(fa.actor_id), f.description as b, f.release_year as c
from film f
left join film_actor fa on f.film_id = fa.film_id
group by 1,3,4

select f.title as a, count(fa.actor_id), f.description as b, f.release_year as c
from film f
left join film_actor fa on f.film_id = fa.film_id
group by 1,3,4
order by 2,1


3.1 ���������� ������� ��������� ������ �� ���� �� ���� �������
* ����������� ������� film
* ��������� ������ �� ���� rental_rate/rental_duration
* avg - �������, ����������� ������� ��������
--4 ���������

select avg(rental_rate/rental_duration),
	max(rental_rate/rental_duration),
	min(rental_rate/rental_duration),
	sum(rental_rate/rental_duration)
from film 

select string_agg(s.last_name, ', ')
from staff s

select array_agg(s.last_name)
from staff s

select *
from staff s

============= ����������� =============

4. �������� ������ �������, � ������� ��������� ������ 10 �������

* ����������� ������� film
* ��������� � film_actor
* ������������ �������� ������� �� film_id
* ��� ������ ������ ���������� ����������� �������
* �������������� ����������� �����, ��� ������ ������� � ������������ > 10
--having, numeric, alias

select f.title
from film f
join film_actor fa using(film_id)
group by f.film_id
having count(fa.actor_id) > 10


4.1 �������� ������ ��������� �������, ������� ����������������� ������ ������� ����� 5 ����
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* ������������ ���������� ������� �� category.name
* ��� ������ ������ ���������� ������ ����������������� ������ �������
* �������������� ����������� �����, ��� ������ ��������� �� ������� ������������������ > 5 ����

select c."name"
from film f
join film_category fc using(film_id)
join category c using(category_id)
group by c.category_id
having avg(f.rental_duration) > 5

select *
from payment p
where customer_id < 10

select customer_id, sum(amount)
from payment p
where customer_id < 10
group by customer_id
union
select staff_id, sum(amount)
from payment p
where customer_id < 10
group by staff_id

select customer_id, staff_id, sum(amount)
from payment
where customer_id < 10
group by customer_id, staff_id

select customer_id, staff_id, sum(amount)
from payment
where customer_id < 10
group by grouping sets(customer_id, staff_id)
order by customer_id, staff_id

select customer_id, staff_id, sum(amount)
from payment
where customer_id < 10
group by cube(customer_id, staff_id)
order by customer_id, staff_id

select customer_id, staff_id, sum(amount)
from payment
where customer_id < 10
group by rollup(customer_id, staff_id)
order by customer_id, staff_id

============= ���������� =============

5. �������� ���������� �������, �� ���������� ������ �� ���� ������, ��� ������� �������� �� ���� �������
* �������� ���������, ������� ����� ��������� ������� �������� ��������� ������ �� ���� (������� 3.1)
* ����������� ������� film
* ������������ ������ � �������������� �������, ��������� �������� > (���������)
* count - ���������� ������� �������� ��������

select avg(rental_rate/rental_duration) from film

select count(f.film_id)
from film f
where f.rental_rate/f.rental_duration > (select avg(rental_rate/rental_duration) from film)

6. �������� ������, � ���������� ������������ � ����� "C"
* �������� ���������:
 - ����������� ������� category
 - ������������ ������ � ������� ��������� like 
* ��������� � �������� film_category
* ��������� � �������� film
* �������� ���������� � �������:
title, category."name"
--position and time

select category_id, "name"
from category 
where "name" like 'C%'

explain analyse
select f.title, t.name
from (
	select category_id, "name"
	from category 
	where "name" like 'C%') t 
join film_category fc on fc.category_id = t.category_id
join film f on f.film_id = fc.film_id --175 / 53.29 / 0.47

explain analyse
select f.title, t.name
from film f
join film_category fc on fc.film_id = f.film_id
join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.29 / 0.47

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id and 
	fc.category_id in (select category_id
	from category 
	where "name" like 'C%')
join category c on c.category_id = fc.category_id --175 / 47.11 / 0.45

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c.category_id in (
	select category_id
	from category 
	where "name" like 'C%') --175 / 46.96 / 0.43

explain analyze
select f.title, t.name
from film f
right join film_category fc on fc.film_id = f.film_id
right join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.29 / 0.43

6.1. �������� ������, � ���������� ������������ � ����� "C", �� ����������� ������ ���������� � ������� ����������
* ����������� ������� film
* ��������� � �������� film_category
* �������� ���������:
 - ����������� ������� category
 - ������������ ������ � ������� ��������� like 
* ����������� ��������� ������ ���������� � ���������� � ������� ��������� in


-- ������ 2 ��� kcu

select tc.table_name, tc.constraint_name, c.column_name, c.data_type
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu on 
	tc.constraint_schema = kcu.constraint_schema and
	tc.table_name = kcu.table_name and
	tc.constraint_name = kcu.constraint_name
join information_schema.columns c on
	kcu.constraint_schema = c.table_schema and
	kcu.table_name = c.table_name and
	kcu.column_name = c.column_name
where tc.constraint_schema = 'dvd-rental' and tc.constraint_type = 'PRIMARY KEY'

select tc.table_name, kc.column_name, c.data_type
from 
	information_schema.table_constraints tc,
	information_schema.key_column_usage kc,
	information_schema.columns c
where tc.constraint_type = 'PRIMARY KEY'
	and kc.table_name = tc.table_name 
	and kc.table_schema = tc.table_schema 
	and kc.constraint_name = tc.constraint_name 
	and tc.table_name = c.table_name 
	and kc.column_name = c.column_name
	and tc.constraint_schema = 'dvd-rental'
	and kc.constraint_schema = c.table_schema

