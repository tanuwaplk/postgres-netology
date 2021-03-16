-- порядковый номер аренды для каждого пользователя
select *, 
row_number() over (partition by customer_id order by rental_date) as rent_order
from rental;

-- сколько пользователи брали в арнеду фильмов с аттрибутом Behind the Scenes
create materialized view customer_bts_amount as 
(select r.customer_id, count(distinct f.film_id ) from rental r
join inventory i 
on r.inventory_id = i.inventory_id 
join film f 
on f.film_id = i.film_id 
where 'Behind the Scenes' = any(f.special_features )
group by r.customer_id);

-- обновление материализованного представления
refresh materialized view customer_bts_amount;

-- первый вариант поиска по Behind the Scenes
select film_id, special_features from film 
where 'Behind the Scenes' = any(special_features );

-- второй вариант поиска по Behind the Scenes
select film_id, feature 
from (
	select film_id, unnest(special_features) as feature from film) t
where feature = 'Behind the Scenes';

-- третий вариант поиска по Behind the Scenes (еще можно перевести array в текст и искать через like)
select film_id, special_features from film 
where special_features @> '{"Behind the Scenes"}';



-- медленный запрос 
explain analyze 
select distinct cu.first_name  || ' ' || cu.last_name as name, 
	count(ren.iid) over (partition by cu.customer_id)
from customer cu
full outer join 
	(select *, r.inventory_id as iid, inv.sf_string as sfs, r.customer_id as cid
	from rental r 
	full outer join 
		(select *, unnest(f.special_features) as sf_string
		from inventory i
		full outer join film f on f.film_id = i.film_id) as inv 
		on r.inventory_id = inv.inventory_id) as ren 
	on ren.cid = cu.customer_id 
where ren.sfs like '%Behind the Scenes%'
order by count desc;
/* 
1. оконная функция count работает медленнее, чем если бы мы сгрупировали по пользователю и подсчитали то же самое
условие 
2. фильтр по Behind the Scenes применяется после того, как джойнятся таблицы с подзапросами. Проделывается много лишней работы
3. подзапросы не нужны, можно было обойтисть просто join'ами 
4. unnest(f.special_features) увеличивает кол-во строк в таблице, для проверки условия можно было обойтись ANY 
 */

-- мой запрос (не всегда в 15 секунд, но не знаю, как еще оптимизировать)
explain analyze 
select r.customer_id, count(distinct f.film_id ) from rental r
join inventory i 
on r.inventory_id = i.inventory_id 
join film f 
on f.film_id = i.film_id 
where 'Behind the Scenes' = any(f.special_features )
group by r.customer_id;

/* в порядке исполнения: 
1. Сканирование строк таблицы Film, фильтрация по 'Behind the Scenes', убирается 462 строки
2. Результат сканирования подаётся на вход узлу Hash, который конструирует хеш-таблицу
3. Сканирование таблицы inventory
4. Передача результатов узлу Hash Join, проверка по условию f.film_id = i.film_id 
5. Сохренение результатов в виде хеш-таблицы
6. Передача узлу Hash Join, который читает строки из таблицы rental и проверяет их по этой хеш-таблице
по условию r.inventory_id = i.inventory_id
7. Сортировка по ключу группировки r.customer_id
8. Группировка 
9. Аггрегирование результатов 
 */
