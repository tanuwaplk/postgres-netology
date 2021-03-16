-- 1. В каких городах больше одного аэропорта?
select city from airports
group by city
having count(airport_code)>1

/* airport_code - уникальный идентификатор аэропорта, поэтому его можно использовать, 
чтобы посчитать кол-во аэропортов. having как раз позволяет фильтровать значения с помощью агрегирующих
функций */

-- 2. В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
select distinct arrival_airport from flights f 
join aircrafts o 
on f.aircraft_code= o.aircraft_code 
where range = (select max(range) from aircrafts)

/* два подзапроса или join и подзапрос дают одинаковую производителность, 
остановилась на втором варианте */

-- 3. Вывести 10 рейсов с максимальным временем задержки вылета

select flight_no from flights f2 
where actual_departure notnull
group by flight_no
order by avg(actual_departure-scheduled_departure)::time desc limit 10

/* получается немного производительнее, если сразу отсеять бесполезные строчки, в которых нет 
 информации о фактическом времени вылета */

-- 4. Были ли брони, по которым не были получены посадочные талоны?

select t.book_ref from tickets t 
join ticket_flights tf on t.ticket_no = tf.ticket_no 
left join boarding_passes bp on tf.ticket_no = bp.ticket_no and tf.flight_id = bp.flight_id 
join flights f on f.flight_id  = tf.flight_id 
where boarding_no is null and status!= 'Scheduled'

/* эксперементировала с подзапросами, роста производительности не получила. 
условие boarding_no is null отвечает за то, чтобы найти бронирования,  в которых 
посадочный не полулось смапить по рейсу в конкретном билете.
условие status!= 'Scheduled' ограничивыет выборку, отрезает те рейсы в бронировании, 
на которые невозможно было еще зарегистрироваться */


/* 5. Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого аэропорта 
на каждый день. Т.е. в этом столбце должна отражаться накопительная сумма - сколько человек уже вылетело 
из данного аэропорта на этом или более ранних рейсах за день.
*/

select f.flight_id, departure_airport, actual_departure, 
(select count( seat_no) from seats where seats.aircraft_code = f.aircraft_code group by aircraft_code )- count(distinct bp.seat_no) as free_seats,
round(
	(count(distinct bp.seat_no)*1.0/(select count( seat_no) from seats where seats.aircraft_code = f.aircraft_code group by aircraft_code ) -1)*-100
	,2) as percentage_free,
sum(count(distinct bp.seat_no)) over (partition by departure_airport, date(actual_arrival) order by actual_arrival ) as passanger_running_total
from flights f 
join boarding_passes bp on bp.flight_id = f.flight_id 
where actual_departure is not null
group by f.flight_id 

/* наверняка можно оптимизировать, но не получилось. Свободные места считала 
как разница между общей вместительностью самолета и кол-вом мест согласно посадочным. В подзапрос убрала подсчет кол-ва мест
в самолете, чтобы не раздувать таблицу джойнами. От второго джойна не придумала как избавиться, чтобы работало окно*/


-- 6. Найдите процентное соотношение перелетов по типам самолетов от общего количества.
select distinct model, 
ROUND((select count(flight_id) from flights f where f.aircraft_code = a.aircraft_code)*1.0 / (select count(*) from flights),4) * 100 as percantage_total
from aircrafts a


-- 7. Были ли города, в которые можно добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?
with economy as 
(select flight_id, min(amount) as ec from ticket_flights tf
where fare_conditions = 'Economy'
group by flight_id),
business as 
(select flight_id, min(amount) as bus from ticket_flights tf
where fare_conditions = 'Business'
group by flight_id)
select city from airports where airport_code in (select arrival_airport from flights where flight_id in (select e.flight_id from economy e
join business b on e.flight_id=b.flight_id
where bus < ec))

-- 8. Между какими городами нет прямых рейсов?drop view airport_flights
create view cities_flights as
select distinct  a.city as city_from, a2.city as city_to
from flights f
join airports a ON a.airport_code =f.departure_airport
join airports a2 on a2.airport_code = f.arrival_airport
where  a.city>a2.city

select distinct a1.city as city1,  a2.city as city2
from airports a1, airports a2
where a1.city<>a2.city and a1.city>a2.city
except
select * from cities_flights

/* Дублирование направлений как Моска-Питер и Питер-Москва исключила с помощью условия a.city>a2.city. 
 */

/* 9. Вычислите расстояние между аэропортами, связанными прямыми рейсами, 
 сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы */


create view airport_flights as
select distinct aircraft_code, a.airport_code as from_airport, a.latitude as from_latitude, a.longitude as from_longitude, 
 a2.airport_code as to_airport, a2.latitude as to_latitude, a2.longitude as to_longitude
from flights f
join airports a ON a.airport_code =f.departure_airport
join airports a2 on a2.airport_code = f.arrival_airport
where  a.airport_code>a2.airport_code

select from_airport, to_airport, 
(6371* acos(sind(from_latitude)* sind(to_latitude) + cosd(from_latitude)* cosd(to_latitude)* cosd(from_longitude - to_longitude)))::int as airports_distance,
range, 
range - (6371* acos(sind(from_latitude)* sind(to_latitude) + cosd(from_latitude)* cosd(to_latitude)* cosd(from_longitude - to_longitude)))::int  as extra_range
from airport_flights af
join aircrafts a on a.aircraft_code = af.aircraft_code
order by from_longitude

/* Создала CTE, чтобы было удобнее работать.  Под сравнением расстояния с дальностью перелетом поняла 
 подсчет разности как показатель избыточной дальности перелта (сверху расстояния)
 */

