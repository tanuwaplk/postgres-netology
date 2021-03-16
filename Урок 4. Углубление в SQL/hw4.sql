CREATE SCHEMA myschema;


CREATE TABLE myschema.nationality(
id serial primary key,
fullname varchar(255) unique not null
);

CREATE TABLE myschema.languages(
id serial primary key,
fullname varchar(255) unique not null
);

CREATE TABLE myschema.countries(
id serial primary key,
fullname varchar(255) unique not null
);


CREATE TABLE myschema.lang_nat(
id_language integer references myschema.languages(id),
id_nationality integer references myschema.nationality(id),
primary key(id_language,id_nationality)
);

CREATE TABLE myschema.country_nat(
id_country integer,
id_nationality integer references myschema.nationality(id),
primary key(id_country,id_nationality)
);

ALTER TABLE  myschema.country_nat
ADD 
FOREIGN KEY (id_country) REFERENCES myschema.countries (id);

INSERT INTO myschema.nationality(fullname)
VALUES 
('славяне'),
('англосаксы'),
('хань'),
('башкиры'),
('испанцы');


INSERT INTO myschema.languages(fullname)
VALUES 
('русский'),
('английский'),
('французский'),
('испанский'),
('башкирский');

INSERT INTO myschema.countries(fullname)
VALUES 
('Россия'),
('Великобритания'),
('Франция'),
('Китай'),
('Испания');

INSERT INTO myschema.country_nat
VALUES 
(1,1),
(1,4),
(2,2),
(4,3),
(5,5);

INSERT INTO myschema.lang_nat
VALUES 
(1,1),
(2,2),
(5,4);


ALTER table myschema.nationality
ADD COLUMN updated_at timestamp,
ADD COLUMN is_minority boolean default false,
ADD COLUMN aliases text[];


UPDATE myschema.nationality 
SET aliases = '{"ханьжэнь","ханьцы"}',
	updated_at = current_timestamp
WHERE id=3;


SELECT * FROM myschema.nationality;