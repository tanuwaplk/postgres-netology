set search_path to world

select * from world.country

1. Получите атрибуты id фильма, название, описание, год релиза из таблицы фильмы.
Переименуйте поля так, чтобы все они начинались со слова Film (FilmTitle вместо title и тп)

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- as - для задания синонимов 

select film_id, title, description, release_year
from film

select film_id as FilmFilm_id, title as FilmTitle, description FilmDescription, release_year FilmRelease_year
from film

select film_id as "FilmFilm_id", title as "FilmTitle", description "FilmDescription", release_year "Год выпуска фильма"
from film

select "name"
from "language"

2. В одной из таблиц есть два атрибута:
rental_duration - длина периода аренды в днях  
rental_rate - стоимость аренды фильма на этот промежуток времени. 
Для каждого фильма из данной таблицы получите стоимость его аренды в день

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- стоимость аренды в день - отношение rental_rate к rental_duration

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

select round(1::numeric/2, 2)  --float число с плавающей точкой

select round(1::decimal/2, 2) 

Если работаете с деньгами, то используете тип данных decimal(10,2)


2* В полученной таблице задайте вычисленному столбцу псевдоним cost_per_day

- as - для задания синонимов 



3.1 Отсортировать список фильмов по убыванию стоимости за день аренды (п.2)

- используйте order by (по умолчанию сортирует по возрастанию)
- desc - сортировка по убыванию

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

3.1* Отсортируйте таблцу платежей по возрастанию суммы платежа (amount)

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- используйте order by 
- asc - сортировка по возрастанию 

select p.payment_id, p.amount
from payment p
order by p.amount

3.2 Вывести топ-10 самых дорогих фильмов по стоимости за день аренды

- используйте limit

select f.title, round(f.rental_rate/f.rental_duration, 2) as cost_per_day
from film f
order by cost_per_day desc
limit 10

3.3 Вывести топ-10 самых дорогих фильмов по стоимости аренды за день, начиная с 57-ой позиции

- воспользуйтесь Limit и offset

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
OFFSET 3 --(первые 3 позиции) 
LIMIT 5

3.3* Вывести топ-15 самых низких платежей, начиная с позиции 14000

- воспользуйтесь Limit и Offset

select p.payment_id, p.amount
from payment p
order by p.amount
offset 13999
limit 15

4. Вывести все уникальные годы выпуска фильмов

- воспользуйтесь distinct

select distinct release_year
from film

select distinct film_id, release_year 
from film

select distinct film_id
from film

select distinct release_year 
from film
order by release_year

4* Вывести уникальные имена покупателей

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- воспользуйтесь distinct

select distinct c.first_name
from customer c

==========

логический порядок

FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE или WITH ROLLUP
HAVING
SELECT <-- объявляем алиасы (псевдонимы)
DISTINCT
ORDER BY

название_схемы.название_таблицы --from
название_таблицы.название_столбца --select

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

5.1. Вывести весь список фильмов, имеющих рейтинг 'PG-13', в виде: "название - год выпуска"

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- "||" - оператор конкатенации 
- where - конструкция фильтрации
- "=" - оператор сравнения

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

5.2 Вывести весь список фильмов, имеющих рейтинг, начинающийся на 'PG'

- cast(название столбца as тип) - преобразование
- like - поиск по шаблону
- ilike - регистронезависимый поиск

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

5.2* Получить информацию по покупателям с именем содержашим подстроку'jam' (независимо от регистра написания), в виде: "имя фамилия" - одной строкой.

- "||" - оператор конкатенации
- where - конструкция фильтрации
- ilike - регистронезависимый поиск

select first_name
from customer c
where first_name ilike '%jam%'

select strpos('Hello world!', 'world')

select character_length('Hello world!')

select overlay('Hello world!' placing 'Max' from 7 for 5)

select position('world' in 'Hello world!')

select overlay('Hello world!' placing 'Max' from (select position('world' in 'Hello world!')) for (select character_length('world')))

select regexp_match()

6. Получить id покупателей, арендовавших фильмы в срок с 27-05-2005 по 28-05-2005 включительно

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- between - задает промежуток (аналог ... >= ... and ... <= ...)

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

6* Вывести платежи поступившие после 30-04-2007

- используйте ER - диаграмму, чтобы найти подходящую таблицу
- > - строгое больше (< - строгое меньше)

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
