set search_path to world

select * from world.country

1. �������� �������� id ������, ��������, ��������, ��� ������ �� ������� ������.
������������ ���� ���, ����� ��� ��� ���������� �� ����� Film (FilmTitle ������ title � ��)

- ����������� ER - ���������, ����� ����� ���������� �������
- as - ��� ������� ��������� 

select film_id, title, description, release_year
from film

select film_id as FilmFilm_id, title as FilmTitle, description FilmDescription, release_year FilmRelease_year
from film

select film_id as "FilmFilm_id", title as "FilmTitle", description "FilmDescription", release_year "��� ������� ������"
from film

select "name"
from "language"

2. � ����� �� ������ ���� ��� ��������:
rental_duration - ����� ������� ������ � ����  
rental_rate - ��������� ������ ������ �� ���� ���������� �������. 
��� ������� ������ �� ������ ������� �������� ��������� ��� ������ � ����

- ����������� ER - ���������, ����� ����� ���������� �������
- ��������� ������ � ���� - ��������� rental_rate � rental_duration

select f.title, f.rental_rate/f.rental_duration
from film f

select f.title, f.rental_rate/f.rental_duration as cost_per_day
from film f

select f.title, f.rental_rate/f.rental_duration as cost_per_day,
	f.rental_rate * f.rental_duration,
	f.rental_rate + f.rental_duration,
	f.rental_rate - f.rental_duration
from film f

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f

select round(1::numeric/2, 2)  --float ����� � ��������� ������

select round(1::decimal/2, 2) 

���� ��������� � ��������, �� ����������� ��� ������ decimal(10,2)


2* � ���������� ������� ������� ������������ ������� ��������� cost_per_day

- as - ��� ������� ��������� 



3.1 ������������� ������ ������� �� �������� ��������� �� ���� ������ (�.2)

- ����������� order by (�� ��������� ��������� �� �����������)
- desc - ���������� �� ��������

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day desc

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day asc

select f.title, round(f.rental_rate/f.rental_duration, 2)
from film f
order by round(f.rental_rate/f.rental_duration, 2) desc

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day desc, f.title

select f.title, concat(round(f.rental_rate/f.rental_duration, 2), '%') as cost_per_day
from film f
order by cost_per_day desc, f.title

3.1* ������������ ������ �������� �� ����������� ����� ������� (amount)

- ����������� ER - ���������, ����� ����� ���������� �������
- ����������� order by 
- asc - ���������� �� ����������� 

select p.payment_id, p.amount
from payment p
order by p.amount

3.2 ������� ���-10 ����� ������� ������� �� ��������� �� ���� ������

- ����������� limit

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day desc
limit 10

3.3 ������� ���-10 ����� ������� ������� �� ��������� ������ �� ����, ������� � 57-�� �������

- �������������� Limit � offset

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day desc
limit 10
offset 57

explain analyze
select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day desc
offset 59
limit 8

SELECT title, rental_rate/rental_duration AS cost_per_day 
FROM film 
ORDER by cost_per_day desc 
OFFSET 3 --(������ 3 �������) 
LIMIT 5

3.3* ������� ���-15 ����� ������ ��������, ������� � ������� 14000

- �������������� Limit � Offset

select p.payment_id, p.amount
from payment p
order by p.amount
offset 13999
limit 15

4. ������� ��� ���������� ���� ������� �������

- �������������� distinct

select distinct release_year
from film

select distinct film_id, release_year 
from film

select distinct film_id
from film

select distinct release_year 
from film
order by release_year

4* ������� ���������� ����� �����������

- ����������� ER - ���������, ����� ����� ���������� �������
- �������������� distinct

select distinct c.first_name
from customer c

==========

���������� �������

FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE ��� WITH ROLLUP
HAVING
SELECT <-- ��������� ������ (����������)
DISTINCT
ORDER BY

��������_�����.��������_������� --from
��������_�������.��������_������� --select

select f.title, a.last_name, f.film_id
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id

select f.title, a.last_name, f.film_id
from film f
join (select fa.film_id as f_id, fa.actor_id from film_actor fa order by f_id) fff on fff.f_id = f.film_id
join actor a on a.actor_id = fff.actor_id

select *
from fff

select film.title, actor.last_name
from film 
join film_actor fa on film_actor.film_id = film.film_id
join actor on actor.actor_id = film_actor.actor_id

==========

5.1. ������� ���� ������ �������, ������� ������� 'PG-13', � ����: "�������� - ��� �������"

- ����������� ER - ���������, ����� ����� ���������� �������
- "||" - �������� ������������ 
- where - ����������� ����������
- "=" - �������� ���������

select *
from (
	select concat(c.last_name, ' ', c.first_name) as n
	from actor c
	order by actor_id) t
where t.n is not null

select *
from (
	select c.last_name || ' ' || c.first_name as n
	from actor c
	order by actor_id) t
where t.n is not null

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating = 'PG-13'

select f.title || ' - ' || f.release_year, f.rating
from film f

select concat('Hello', null, ' ', 'world!')

select 'Hello' || null || ' ' || 'world!'

5.2 ������� ���� ������ �������, ������� �������, ������������ �� 'PG'

- cast(�������� ������� as ���) - ��������������
- like - ����� �� �������
- ilike - ������������������� �����

select concat(f.title, ' - ', f.release_year), pg_typeof(f.rating)
from film f

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating = 'PG-13' or f.rating = 'PG'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where cast(f.rating as text) like 'PG%'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating::text like 'PG%'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating::text like '%13'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating::text like '__'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where length(f.rating::text) = 5

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating::text like '%-__'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating::text like 'pg%'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where f.rating::text ilike 'pg%'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where lower(f.rating::text) like 'pg%'

select concat(f.title, ' - ', f.release_year), f.rating
from film f
where upper(f.rating::text) like 'PG%'

--enum

5.2* �������� ���������� �� ����������� � ������ ���������� ���������'jam' (���������� �� �������� ���������), � ����: "��� �������" - ����� �������.

- "||" - �������� ������������
- where - ����������� ����������
- ilike - ������������������� �����

select first_name
from customer c
where first_name ilike '%jam%'

select strpos('Hello world!', 'world')

select character_length('Hello world!')

select overlay('Hello world!' placing 'Max' from 7 for 5)

select position('world' in 'Hello world!')

select overlay('Hello world!' placing 'Max' from (select position('world' in 'Hello world!')) for (select character_length('world')))

select regexp_match()

6. �������� id �����������, ������������ ������ � ���� � 27-05-2005 �� 28-05-2005 ������������

- ����������� ER - ���������, ����� ����� ���������� �������
- between - ������ ���������� (������ ... >= ... and ... <= ...)

select r.customer_id, r.rental_id, r.rental_date
from rental r
where r.rental_date between '27-05-2005 00:00:00' and '28-05-2005 00:00:00'
order by r.rental_date desc

select r.customer_id, r.rental_id, r.rental_date
from rental r
where r.rental_date >= '27-05-2005' and r.rental_date <= '28-05-2005'

select r.customer_id, r.rental_id, r.rental_date
from rental r
where r.rental_date between '27-05-2005'::date and '28-05-2005'::date + interval '1 day'
order by r.rental_date desc

select r.customer_id, r.rental_id, r.rental_date
from rental r
where r.rental_date between '27-05-2005' and '28-05-2005 23:59:59'
order by r.rental_date desc

select r.customer_id, r.rental_id, r.rental_date
from rental r
where r.rental_date between '2005-05-27' and '2005-05-28 23:59:59'
order by r.rental_date desc

select r.customer_id, r.rental_id, r.rental_date
from rental r
where r.rental_date between '27/05/2005' and '2005-05-28 23:59:59'
order by r.rental_date desc

6* ������� ������� ����������� ����� 30-04-2007

- ����������� ER - ���������, ����� ����� ���������� �������
- > - ������� ������ (< - ������� ������)

select p.payment_id, p.payment_date
from payment p
where p.payment_date::date > '30-04-2007'

select '28.02.2020'::date - interval '3 weeks' + interval '1 year'

select extract(year from '28.02.2020'::date)

select extract(month from '28.02.2020'::date)

select extract(week from '28.02.2020'::date)

select extract(day from '28.02.2020'::date)

select date_part('month', '28.02.2020'::date)

select date_trunc('day', '28.02.2020'::date)

select extract(epoch from '28.02.2020'::date)

select now()

date
timestamp 
timestamptz

select pg_typeof((('28.02.2020'::date)::timestamp)::timestamptz)

select pg_typeof((('28.02.2020'::timestamptz)::timestamp)::date)

select pg_typeof(('01:02:03'::time)::date)
