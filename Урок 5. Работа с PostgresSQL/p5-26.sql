select cast(���_����������� as ���_������)
select ���_�����������::���_������

FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE ��� WITH ROLLUP
HAVING
SELECT
DISTINCT
ORDER BY

============= ������� ������� =============

1. �������� ������� � 3-�� ������: �������� ������, ��� ������ � ���������� �������, � ������� �� ��������
* ����������� ������� film
* ��������� � film_actor
* ��������� � actor
* count - ���������� ������� �������� ��������
* ������� ���� � �������������� ����������� over � partition by

select f.title, a.last_name, count(fa.film_id) over (partition by a.actor_id)
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id

1.1. �������� �������, ���������� ����� �����������, ������������ ��� ������ � ������� ������ ������� ����������
* ����������� ������� customer
* ��������� � paymen
* ��������� � rental
* ��������� � inventory
* ��������� � film
* avg - �������, ����������� ������� ��������
* ������� ���� � �������������� ����������� over � partition by

select c.last_name, f.title, avg(p.amount) over (partition by c.customer_id)
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

select c.last_name, f.title, 
	avg(p.amount) over (partition by c.customer_id),
	sum(p.amount) over (partition by c.customer_id),
	max(p.amount) over (partition by c.customer_id),
	min(p.amount) over (partition by c.customer_id)
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

select *
from (
	select c.last_name, f.title, 
		avg(p.amount) over (partition by c.customer_id),
		sum(p.amount) over (partition by c.customer_id),
		max(p.amount) over (partition by c.customer_id),
		min(p.amount) over (partition by c.customer_id)
	from customer c
	join payment p on p.customer_id = c.customer_id
	join rental r on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id
	join film f on f.film_id = i.film_id) t
where t.avg > 4

select c.last_name, f.title, 
	last_value(p.amount) over (partition by c.customer_id order by date(p.payment_date) desc),
	p.amount, p.payment_date
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
order by c.customer_id, p.payment_date desc

select c.last_name, f.title, 
	last_value(p.amount) over (partition by c.customer_id),
	p.amount, p.payment_date
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
order by c.customer_id, p.payment_date desc

select c.last_name, f.title, p.payment_date, p.amount, 
	sum(p.amount) over (partition by c.customer_id order by p.payment_date desc),
	sum(p.amount) over (partition by c.customer_id order by date(p.payment_date) desc),
	max(p.amount) over (partition by c.customer_id order by date(p.payment_date) desc),
	avg(p.amount) over (partition by c.customer_id order by date(p.payment_date) desc)
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
order by c.customer_id, p.payment_date desc

select c.last_name, f.title, p.payment_date, 
	lag(p.amount) over (partition by c.customer_id),
	p.amount,
	lead(p.amount) over (partition by c.customer_id)
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

select t.last_name, t.title, t.payment_date,
	lag(t.amount) over (partition by t.customer_id),
	t.amount,
	lead(t.amount) over (partition by t.customer_id)
from (
	select c.last_name, f.title, p.payment_date, p.amount, c.customer_id
	from customer c
	join payment p on p.customer_id = c.customer_id
	join rental r on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id
	join film f on f.film_id = i.film_id
	order by c.customer_id) t
	
select t.last_name, t.title, t.payment_date,
	lag(t.amount, 5) over (),
	t.amount,
	lead(t.amount, 5) over ()
from (
	select c.last_name, f.title, p.payment_date, p.amount, c.customer_id
	from customer c
	join payment p on p.customer_id = c.customer_id
	join rental r on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id
	join film f on f.film_id = i.film_id
	order by c.customer_id) t

--����� �������� �������� �� ��� �������: � ����� �� ������� ����� � ������ ������� ������ �����? 
--�� ������� �� ��������� � ����������� ������ ���� ����� � ������ ������/������ �������.
with t1 as (
	select date_trunc('month', r.rental_date) m_d,
		count(r.rental_id) current_month,
		count(r.rental_id) - lag(count (r.rental_id)) over (order by date_trunc('month', r.rental_date)) diff_prev_month, 
		max(count (r.rental_id)) over () max_count
	from rental r
	group by date_trunc('month', r.rental_date))
select t1.m_d, t1.current_month, t1.diff_prev_month, (select m_d from t1 where current_month = max_count)
from t1

select *
from (
	select c.last_name, f.title, p.payment_date, p.amount,
		row_number() over (partition by c.customer_id order by p.payment_date desc) r
	from customer c
	join payment p on p.customer_id = c.customer_id
	join rental r on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id
	join film f on f.film_id = i.film_id) t
where t.r = 30 and t.amount = 4.99 

select c.last_name, f.title, p.payment_date, p.amount,
		row_number() over (partition by c.customer_id order by p.payment_date desc),
		rank() over (partition by c.customer_id order by p.amount),
		dense_rank() over (partition by c.customer_id order by p.amount)
	from customer c
	join payment p on p.customer_id = c.customer_id
	join rental r on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id
	join film f on f.film_id = i.film_id
	
select customer_id, staff_id, sum(amount)
from payment
where customer_id < 5
group by customer_id, staff_id
order by customer_id, staff_id

select customer_id, staff_id, date_part('month', payment_date), sum(amount)
from payment
where customer_id < 5
group by grouping sets(customer_id, staff_id, date_part('month', payment_date))
order by customer_id, staff_id, date_part('month', payment_date)

select customer_id, staff_id, date_part('month', payment_date), sum(amount)
from payment
where customer_id < 5
group by cube(customer_id, staff_id, date_part('month', payment_date))
order by customer_id, staff_id, date_part('month', payment_date)

select customer_id, staff_id, date_part('month', payment_date), sum(amount)
from payment
where customer_id < 5
group by rollup(customer_id, staff_id, date_part('month', payment_date))
order by customer_id, staff_id, date_part('month', payment_date)

============= ����� ��������� ��������� =============

2.  ��� ������ CTE �������� ������� �� ��������� �����������:
������� � ��� ���������� (staff) � ���������� �������� ��� (retal), ������� �� ������
* �������� CTE:
 - ����������� ������� staff
 - ��������� � rental
 - || - �������� ������������
 * �������� ������ � ���������� CTE:
 - ������������ �� fio
 - count - ���������� ������� �������� ��������
 - �������� �������� � ����: fio, ���������� ��������(rental_id)

with cte as (
	select s.last_name, r.rental_id, s.staff_id
	from staff s
	join rental r on r.staff_id = s.staff_id)
select last_name, count(rental_id)
from cte
group by staff_id, last_name

2.1. �������� ������, � ���������� ������������ � ����� "C"
* �������� CTE:
 - ����������� ������� category
 - ������������ ������ � ������� ��������� like 
* ��������� ���������� ��������� ��������� � �������� film_category
* ��������� � �������� film
* �������� ���������� � �������:
title, category."name"

with cte1 as (
	select "name", category_id
	from category 
	where name ilike 'c%'), 
cte2 as (
	select *
	from film_category),
cte3 as (
	select *
	from film)
select cte3.title
from cte3 
join cte2 on cte3.film_id = cte2.film_id
join cte1 on cte2.category_id = cte1.category_id

explain analyze
with cte1 as (
	select "name", category_id
	from category 
	where name ilike 'c%'), 
cte2 as (
	select *
	from film_category),
cte3 as (
	select *
	from film f
	join cte2 on cte2.film_id = f.film_id)
select *
from cte3 

explain analyze
with cte2 as (
	select *
	from film_category)
select *
from cte2 c1

explain analyze
with cte2 as (
	select *
	from film_category)
select *
from cte2 c1

 ============= ����� ��������� ��������� (�����������) =============
 
 3.��������� ���������
 + �������� CTE
 * ��������� ����� �������� (�.�. "anchor") ������ ��������� ��������� ��������� ��������
 *  ����������� ����� ��������� �� ������ � ���������� �������� � ����� ������� ��������
 + �������� ������ � CTE

with recursive r as (
	--��������� �����
	select 1 as i, 1 as factorial
	union 
	--����������� �����
	select i + 1 as i, factorial * (1 + i) as factorial
	from r
	where i < 10
)
select *
from r

create table geo ( 
	id int primary key, 
	parent_id int references geo(id), 
	name varchar(1000) );

insert into geo (id, parent_id, name)
values 
	(1, null, '������� �����'),
	(2, 1, '��������� �������'),
	(3, 1, '��������� �������� �������'),
	(4, 2, '������'),
	(5, 4, '������'),
	(6, 4, '��������'),
	(7, 5, '������'),
	(8, 5, '�����-���������'),
	(9, 6, '������');

select * from geo
order by id

with recursive r(a, b, c) as (
	select id, parent_id, name, 1 as level
	from geo
	where id = 5
	union
	select geo.id, geo.parent_id, geo."name", level + 1 as level
	from r
	join geo on geo.parent_id = r.a
)
select *
from r

with recursive r(a, b, c) as (
	select id, parent_id, name, 1 as level
	from geo
	where id = 5
	union
	select geo.id, geo.parent_id, geo."name", level + 1 as level
	from r
	join geo on geo.id = r.b
)
select *
from r

explain analyze
with recursive r as (
	select date('01.01.2021') as start_date
	union
	select date(start_date) + 1 as start_date
	from r
	where date(start_date) < date('01.02.2021')
)
select *
from r

explain analyze
select generate_series(date('01.01.2021'), date('01.02.2021'), interval '1 day')

select generate_series(1, 100, 5)

� ������ ������� ������ ���������� �� ��������� "�������" ��� ������� ���� ���� (field ). 
�� ����, ���� ���� pin, �� 21.07.2017 ���� �������� ��������, �������������� ����� (new_value ) ����� '' (������ ������) � ������  (old_value), 
���������� ��� '300-L'.
����� 26.07.2017 �������� �������� � '' (������ ������) �� '10-AA'. � ��� �� ������ ����� � ������ ���� ���� �����-�� ��������� ��������.

������: ��������� ������ ����� �������, ��� �� � ����� �������������� ������� ��� ��������� ��������� �������� ��� ������� ����. 
����� ��� �������: ����, ����, ������� ������.
�� ���� ��� ������� ���� ����� ����������� ������� ��� � ������������ �������� �������. � �������, ��� ���� pin �� 21.07.2017 ������ �����  '' 
(������ ������), �� 22.07.2017 -  '' (������ ������). � �.�. �� 26.07.2017, ��� ������ ������ '10-AA'

������� ������ ���� ������������� ��� ������ SQL, �� ������ ��� PostgreSQL ;)

create table test (
	date_event timestamp,
	field varchar(50),
	old_value varchar(50),
	new_value varchar(50)
)

insert into test (date_event, field, old_value, new_value)
values
('2017-08-05', 'val', 'ABC', '800'),
('2017-07-26', 'pin', '', '10-AA'),
('2017-07-21', 'pin', '300-L', ''),
('2017-07-26', 'con', 'CC800', 'null'),
('2017-08-11', 'pin', 'EKH', 'ABC-500'),
('2017-08-16', 'val', '990055', '100')

select * from test order by date(date_event)

explain analyze
select
	gs::date as change_date,
	fields.field as field_name,
	case 
		when (
			select new_value 
			from test t 
			where t.field = fields.field and t.date_event = gs::date) is not null 
			then (
				select new_value 
				from test t 
				where t.field = fields.field and t.date_event = gs::date)
		else (
			select new_value 
			from test t 
			where t.field = fields.field and t.date_event < gs::date 
			order by date_event desc 
			limit 1) 
	end as field_value
from 
	generate_series((select min(date(date_event)) from test), (select max(date(date_event)) from test), interval '1 day') as gs, 
	(select distinct field from test) as fields
order by 
	field_name, change_date
	--8 146 223

explain analyze
select
	distinct field, gs, first_value(new_value) over (partition by value_partition)
from
	(select
		t2.*,
		t3.new_value,
		sum(case when t3.new_value is null then 0 else 1 end) over (order by t2.field, t2.gs) as value_partition
	from
		(select
			field,
			generate_series((select min(date_event)::date from test), (select max(date_event)::date from test), interval '1 day')::date as gs
		from test) as t2
	left join test t3 on t2.field = t3.field and t2.gs = t3.date_event::date) t4
order by 
	field, gs
--92 709

explain analyze
with recursive r(a, b, c) as (
    select temp_t.i, temp_t.field, t.new_value
    from 
	    (select min(date(t.date_event)) as i, f.field
	    from test t, (select distinct field from test) as f
	    group by f.field) as temp_t
    left join test t on temp_t.i = t.date_event and temp_t.field = t.field
    union all
    select a + 1, b, 
    	case 
    		when t.new_value is null then c
    		else t.new_value
		end
    from r  
    left join test t on t.date_event = a + 1 and b = t.field
    where a < (select max(date(date_event)) from test)
)    
SELECT *
FROM r
order by b, a
--2616

explain analyze
with recursive r as (
 	--��������� ����� ��������
 	 	select
 	     	min(t.date_event) as c_date
		   ,max(t.date_event) as max_date
	from test t
	union
	-- ����������� �����
	select
	     r.c_date+ INTERVAL '1 day' as c_date
	    ,r.max_date
	from r
	where r.c_date < r.max_date
 ),
t as (select t.field
		, t.new_value
		, t.date_event
		, case when lead(t.date_event) over (partition by t.field order by t.date_event) is null
			   then max(t.date_event) over ()
			   else lead(t.date_event) over (partition by t.field order by t.date_event)- INTERVAL '1 day'
		  end	  
			   as next_date
		, min (t.date_event) over () as min_date
		, max(t.date_event) over () as max_date	  
from (
select t1.date_event
		,t1.field
		,t1.new_value
		,t1.old_value
from test t1
union all
select distinct min (t2.date_event) over () as date_event --������ ��������� ����
		,t2.field
		,null as new_value
		,null as old_value
from test t2) t
)
select r.c_date, t.field , t.new_value
from r
join t on r.c_date between t.date_event and t.next_date
order by t.field,r.c_date
--476

============= ������������� =============

4. �������� view � ��������� ������ (���; email) � title ������, ������� �� ���� � ������ ���������
+ �������� �������������:
* �������� CTE, 
- ���������� ������ �� ������� rental, 
- ��������� ����������� row_number() � ���� �� customer_id
- ����������� � ���� ���� �� rental_date �� �������� (desc)
* ���������� customer � ���������� cte 
* ��������� � inventory
* ��������� � film
* ������������ �� row_number = 1


create view task1 as
	with cte as (
		select r.*, row_number() over (partition by r.customer_id order by r.rental_date desc)
		from rental r)
	select c.last_name, c.email, f.title 
	from cte 
	join customer c on c.customer_id = cte.customer_id
	join inventory i on i.inventory_id = cte.inventory_id
	join film f on f.film_id = i.film_id
	where cte.row_number = 1
	
	explain analyze
select * from task1 t

4.1. �������� ������������� � 3-�� ������: �������� ������, ��� ������ � ���������� �������, � ������� �� ��������
+ �������� �������������:
* ����������� ������� film
* ��������� � film_actor
* ��������� � actor
* count - ���������� ������� �������� ��������
* ������� ���� � �������������� ����������� over � partition by

create view task2 as 
	select f.title, a.last_name, count(fa.film_id) over (partition by a.actor_id)
	from film f
	join film_actor fa on fa.film_id = f.film_id
	join actor a on a.actor_id = fa.actor_id
	
select * from task2 t

============= ����������������� ������������� =============

5. �������� ���������������� ������������� � ��������� ������ (���; email) � title ������, ������� �� ���� � ������ ���������
�������������� ���������� � �������� ������ � �������������.
+ �������� ����������������� ������������� ��� ���������� (with NO DATA):
* �������� CTE, 
- ���������� ������ �� ������� rental, 
- ��������� ����������� row_number() � ���� �� customer_id
- ����������� � ���� ���� �� rental_date �� �������� (desc)
* ���������� customer � ���������� cte 
* ��������� � inventory
* ��������� � film
* ������������ �� row_number = 1
+ �������� �������������
+ �������� ������

create materialized view task3 as
	with cte as (
		select r.*, row_number() over (partition by r.customer_id order by r.rental_date desc)
		from rental r)
	select c.last_name, c.email, f.title 
	from cte 
	join customer c on c.customer_id = cte.customer_id
	join inventory i on i.inventory_id = cte.inventory_id
	join film f on f.film_id = i.film_id
	where cte.row_number = 1
with no data

explain analyze
select * from task3

refresh materialized view task3

��������_������������� | ����+����� ����������

5.1. ������� ���������� ����������������� �������������, ����������:
������ ��������� �������, ������� ����������������� ������ ������� ����� 5 ����
+ �������� ����������������� ������������� � ����������� (with DATA)
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* ������������ ���������� ������� �� category.name
* ��� ������ ������ ���������� ������ ����������������� ������ �������
* �������������� ����������� �����, ��� ������ ��������� �� ������� ������������������ > 5 ����
 + �������� ������
 
create materialized view task4 as
	select c.name
	from film f
	join film_category fc using(film_id)
	join category c using(category_id)
	group by c.category_id
	having avg(f.rental_duration) > 5
with data

select * from task4

������ �� ������ �� ������� ����� ������� https://explain.depesz.com/
 
https://habr.com/ru/post/203320/

EXPLAIN [ ( �������� [, ...] ) ] ��������
EXPLAIN [ ANALYZE ] [ VERBOSE ] ��������

����� ����������� ��������:

    ANALYZE [ boolean ]
    VERBOSE [ boolean ]
    COSTS [ boolean ]
    BUFFERS [ boolean ]
    TIMING [ boolean ]
    FORMAT { TEXT | XML | JSON | YAML }
 
explain analyze
select c.name
from film f
join film_category fc using(film_id)
join category c using(category_id)
group by c.category_id
having avg(f.rental_duration) > 5

explain (format json, analyze)
select c.name
from film f
join film_category fc using(film_id)
join category c using(category_id)
group by c.category_id
having avg(f.rental_duration) > 5

explain (format json, analyze)
with cte as (
	select r.*, row_number() over (partition by r.customer_id order by r.rental_date desc)
	from rental r)
select c.last_name, c.email, f.title 
from cte 
join customer c on c.customer_id = cte.customer_id
join inventory i on i.inventory_id = cte.inventory_id
join film f on f.film_id = i.film_id
where cte.row_number = 1
order by f.title, c.last_name desc
