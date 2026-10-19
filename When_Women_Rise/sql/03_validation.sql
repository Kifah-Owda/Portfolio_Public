-- Data Validation after star schema

-- Do we have the data from the four tables? coutn each type 

SELECT type_id, count(*) as count_table 
FROM fact_table
GROUP  BY (type_id); 

-- Results type id 1,4,5,6 acceptable as tpe 2, and 3 are made up of persons record existing in 2 tables example ceo & founder

-- Null Values 

select count(*)
from fact_table
where iso is null; -- 3022 records with geo data - missing iso

select count(*)
from fact_table
where end_date is null;  -- 15622 records with null end date

select * from fact_table;

-- number of countries
select COUNT(DISTINCT iso) from fact_table WHERE iso IS NOT NULL ;  -- 209 UNIQUE COUNTRIES 

-- AGE RANGE

SELECT max_age, Min_age, max_age-Min_age as Age_Range
FROM
(
SELECT maX(age_at_milestone) as max_age, MIN(age_at_milestone) as Min_age
FROM fact_table) as max_min;     -- max age 100, min age 15 and age range 85. we need to check the max age record

select count(distinct person_id) from fact_table where age_at_milestone >70;   -- 579 , 511 after removing dups persons achived milestone over the age of 70
 
 -- People whoc achived milestone at age 70+
select f.*, p.*
from fact_table as f
inner join person_dim as p
on f.person_id=p.person_id
where f.age_at_milestone >70;  -- in all types of leadership, ceo, founder, head of gov and state

----------------------------------------------

-- We know that the fact tabel have overlap where smae person appeared in 2 or more different tables aka different roles, investigate

SELECT person_id, COUNT(*) 
FROM fact_table
GROUP BY person_id
having count(*)>1
order by COUNT(*)  desc;  -- we have person id duplicated 3 and 2 times no 4 times. max bettwen 3 tables

SELECT person_id,type_id
FROM fact_table
GROUP BY person_id
having count(*)>1;   -- returns zero meaning, all dup person id belong to 3 different types 

-- just shwo the duplicated person id and the type
select d.person_id, f.type_id 
from(
select person_id
from fact_table 
group by person_id
having count(*)>1) as d
inner join fact_table as f
on d.person_id= f.person_id
order by d.person_id, f.type_id