
-- таблицы, первичные ключи, тип данных
SELECT col.table_name, col.column_name, c.data_type 
FROM information_schema.table_constraints tc 
JOIN information_schema.constraint_column_usage col
  ON col.constraint_name = tc.constraint_name
 AND col.table_name = tc.table_name
 AND tc.constraint_type = 'PRIMARY KEY'
 JOIN information_schema.columns c
 ON c.column_name = col.column_name and c.table_name = col.table_name;
 
-- неактивные пользователи
SELECT email FROM customer WHERE active = 0;

-- фильмы выпущенные в 2006
SELECT * FROM film WHERE release_year = 2006;

-- последние 10 платежей
SELECT * FROM payment where amount != 0 order by payment_date desc limit 10; 