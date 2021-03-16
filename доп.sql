В данной таблице хранят информацию по изменению "статуса" для каждого типа поля (field ). 
То есть, есть поле pin, на 21.07.2017 было изменено значение, соответственно новое (new_value ) стало '' (пустая строка) и старое  (old_value), 
записалось как '300-L'.
Далее 26.07.2017 изменили значение с '' (пустая строка) на '10-AA'. И так по разным полям в разные даты были какие-то изменения значений.
Задача: составить запрос таким образом, что бы в новой результирующей таблице был календарь изменения значений для каждого поля. 
Всего три столбца: дата, поле, текущий статус.
То есть для каждого поля будет отображение каждого дня с отображением текущего статуса. К примеру, для поля pin на 21.07.2017 статус будет  '' 
(пустая строка), на 22.07.2017 -  '' (пустая строка). и т.д. до 26.07.2017, где статус станет '10-AA'
Решение должно быть универсальным для любого SQL, не только под PostgreSQL ;)

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
 	--стартовая часть рекурсии
 	 	select
 	     	min(t.date_event) as c_date
		   ,max(t.date_event) as max_date
	from test t
	union
	-- рекурсивная часть
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
select distinct min (t2.date_event) over () as date_event --первые стартовые даты
		,t2.field
		,null as new_value
		,null as old_value
from test t2) t
)
select r.c_date, t.field , t.new_value
from r
join t on r.c_date between t.date_event and t.next_date
order by t.field,r.c_date



Есть таблица.  В таблице есть юзеры, которые заходят на разные страницы page.
задача: выделить из таблицы тех юзеров, которые заходили подряд на страницы 1, 2, 3. именно в таком порядке. Сначала зашел несколько раз (или один раз) на 1 стр, потом 2, потом 3. Юзеры, которые заходили в других последовательностях, к примеру 2 2 2 1 3 2 нам не подходят.

drop table a 

create table a (
	user_id int,
	page int,
	time int
)

insert into a (user_id, page, time)
values 
(1,2,201),
(1,1,202),
(1,3,203),
(2,1,201),
(2,2,205),
(2,3,206),
(3,1,205),
(3,2,203),
(3,3,208),
(4,1,203),
(4,1,204),
(4,2,205),
(4,3,208),
(5,1,203),
(5,1,204),
(5,3,205),
(5,2,208),
(5,3,209)


explain analyze
with info as (
select user_id, array_agg( page order by min_time) as page_visits
from (
    select user_id, page, min(time) as min_time
    from a
    group by user_id, page 
) s
group by user_id)
select user_id from info where page_visits = (
	select array_agg(t.page)
	from (select distinct page from a order by page) t) 
	
-- 66

with a as 
(select user_id, page, 
case when page =  row_number() over(partition by user_id order by min(time))  then 1 else 0 end as is_true  
from a 
group by user_id, page 
order by user_id) 
select user_id from a 
group by user_id 
having sum(is_true)=3

explain analyze
select t.user_id
from (
	select distinct user_id, page, time
	from a
	order by time, user_id) t
group by t.user_id
having array_agg(t.page) = any(
	select array_agg(t.page)
	from (select distinct page from a order by page) t) 
-- 61 
	
explain analyze
select t.user_id
from (
	select distinct user_id, page, time
	from a
	order by time, user_id) t
group by t.user_id
having array_agg(t.page) = any(
	select array_agg(t.gs)
	from (select generate_series((select min(page) from a), (select max(page) from a)) gs) t) 
-- 61
	