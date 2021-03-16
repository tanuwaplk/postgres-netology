
-- магазинны с более 300 покупателями
select s.store_id from store s
join customer c 
on c.store_id = s.store_id 
group by s.store_id 
having count(c.customer_id )>300;

-- города покупателей
select customer_id, city.city from customer c 
join address a 
on c.address_id = a.address_id 
join city 
on a.city_id = city.city_id;

-- ФИО сотрудников и города магазинов, имеющих больше 300-от покупателей
select s.store_id, st.first_name, st.last_name, city.city from store s 
join staff st
	on s.manager_staff_id = st.staff_id and s.store_id =st.store_id 
join address a 
	on a.address_id = s.address_id 
join city 
	on a.city_id = city.city_id 
where s.store_id in 
	(select s.store_id from store s
	join customer c 
	on c.store_id = s.store_id 
	group by s.store_id 
	having count(c.customer_id )>300);


-- количество актеров, которые снимаются в фильмах, которые сдаются в аренду за 2,99
select count( distinct fa.actor_id) as cnt from film f 
join film_actor fa
on fa.film_id =f.film_id 
where f.rental_rate = 2.99





	