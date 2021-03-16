
--1. Сколько оплатил каждый пользователь за прокат фильмов за каждый месяц
select customer_id , date_trunc('month', payment_date )  as month_payment, sum(amount ) from payment
group by customer_id, month_payment 
order by customer_id;

-- 2. На какую сумму продал каждый сотрудник магазина
select r.staff_id, sum(f.rental_rate) from rental r 
join inventory i 
on i.inventory_id = r.inventory_id 
join film f 
on f.film_id = i.film_id 
group by r.staff_id

--3. Сколько каждый пользователь взял фильмов в аренду
select customer_id, count(film_id) from rental r
join inventory i
on r.inventory_id = i.inventory_id 
group by customer_id;

-- 4. Сколько раз брали в прокат фильмы, в которых снимались актрисы с именем Julia
select film_id, count(distinct r.rental_id ) from rental r
right join inventory i 
on i.inventory_id = r.inventory_id and i.film_id in (
	select film_id from film_actor fa where actor_id in
		(select actor_id from actor where first_name like 'Julia'))
where r.rental_id is not null 
group by film_id

-- 5. Сколько актеров снимались в фильмах, в названии которых встречается подстрока bed
select film_id, count(actor_id) from film_actor 
where film_id in (select film_id from film where lower(title) like '%bed%' )
group by film_id;


-- 6. Вывести пользователей, у которых указано два адреса
select customer_id from customer where address_id in 
	(select address_id from address where address2 similar to '%[a-z]%')
	
-- 7. Сформировать массив из категорий фильмов и для каждого фильма вывести индекс массива соответствующей категории

select film_id, new_index, name from 
(select distinct name, c.category_id, ROW_NUMBER() OVER(ORDER BY name desc ) as new_index from category c) as cat
join film_category fc
on fc.category_id = cat.category_id;  

-- 8. Вывести массив с идентификаторами пользователей в фамилиях которых есть подстрока 'ah'
select customer_id from customer where lower(last_name) like '%ah%';

--- 9. Вывести фильмы, у которых в названии третья буква 'b'
select film_id from film 
where title like '__b%';

-- 10. Найти последнюю запись по пользователю в таблице аренда без учета last_update

select *, (row_number() over (partition by customer_id order by return_date desc)) as numb from rental ;

-- 11. Вывести ФИО пользователя и название третьего фильма, который он брал в аренду.
select first_name, last_name , title from (select customer_id, rental_date, f.title, row_number() over (partition by customer_id order by rental_date) from rental r 
join inventory i 
on i.inventory_id = r.inventory_id 
join film f 
on f.film_id = i.film_id) as t1
join customer c 
on t1.customer_id = c.customer_id 
where row_number = 3;

-- 12. Вывести пользователей, которые брали один и тот же фильм больше одного раза.

select customer_id from rental r 
join inventory i 
on r.inventory_id = i.inventory_id 
group by customer_id, film_id 
having count(i.inventory_id )>2 

-- 13. Какой из месяцев оказался наиболее доходным

select  date_part('month', payment_date ) as month, sum(amount) from payment p 
group by month 
order by sum desc 
limit 1 ;

-- 14. Одним запросом ответить на два вопроса: в какой из месяцев взяли в аренду фильмов больше всего? На сколько по отношению к предыдущему месяцу было сдано в аренду больше/меньше фильмов.

with new_f as (
select date_trunc('month',rental_date) as month, count(i.inventory_id), (date_trunc('month',rental_date) - interval '1 month') as m2 from rental r 
join inventory i 
on r.inventory_id = i.inventory_id 
group by month)
select f1.month, f1.count, (f1.count - f2.count)  as d from new_f f1
join new_f f2
on f1.m2 = f2.month
order by f1.count desc 
limit 1 ;