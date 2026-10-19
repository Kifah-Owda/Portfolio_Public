/* 
Star Schema design, we will create a 4 dim tables (person, year, leadership, country) and one fact table
*/

-- Create leadership type dim table

-- Type id, Type_name and Sector  (Sector is the source table, like politics, business)

-- The solution will look like a table with the four values unique leadership type + ceo and founder, head of state and head of goveremnt  (inner joins bettwen the tables)

WITH union_all as ( 
			SELECT leadership_type FROM ceos_stage
			UNION ALL
			SELECT leadership_type FROM founder_stage
			UNION ALL
			SELECT leadership_type FROM gov_stage
			UNION ALL
			SELECT leadership_type FROM state_stage
		) 
        
SELECT  distinct leadership_type, sector
from union_all;

-----------------------------------------------
-- Step 1: Define the Table
CREATE TABLE leadership_dim
(
		type_id INT AUTO_INCREMENT PRIMARY KEY,
		leadership_type VARCHAR(50),
		sector VARCHAR(50)
);
--------------------------------
-- Step 2: Insert Values into leadership type
INSERT INTO leadership_dim (leadership_type)
	-- Persons with founder and ceo status -- new leadeship_type
With ceo_founder as (
			select f.person_id
			from founder_stage as f
			inner join ceos_stage as c
			on f.person_id=c.person_id) ,
	-- Persons with gov and state status -- new leadeship_type
       stae_gov as   ( 
			select f.person_id
			from gov_stage as f
			inner join state_stage as c
			on f.person_id=c.person_id ),
	   union_all as ( 
			SELECT person_id, leadership_type  FROM ceos_stage
			UNION ALL
			SELECT person_id, leadership_type sector FROM founder_stage
			UNION ALL
			SELECT person_id, leadership_type FROM gov_stage
			UNION ALL
			SELECT person_id, leadership_type FROM state_stage
		) 

SELECT DISTINCT leadership_type
from (
		select person_id, 
		CASE 
				when person_id IN (select person_id from ceo_founder) Then  'Founder & CEO'
				WHEN person_id IN (select person_id from stae_gov) Then 'Head of State & Goverenment'
				ELSE  leadership_type
				END AS leadership_type
		from union_all) as  person_id_leadership;
        
        
------------------------------------------
-- Step 3: Defien and Fill into the sector based on leadership type
        

Update leadership_dim        
SET sector=
CASE 
	WHEN leadership_type IN ('CEO','Founder & CEO', 'business founder') THEN  'Business'
	WHEN leadership_type IN ('head of government','head of state', 'Head of State & Goverenment') THEN  'Politics'
	END ;


---------------------------------------------------------------------

-- Step 4 : Fix typos and Title case 
Update leadership_dim        
SET leadership_type=
	Case 
	when  leadership_type='business founder' then 'Business Founder'
	when leadership_type ='head of state' then 'Head of State'
    when leadership_type ='Head of State & Goverenment' then 'Head of State & Government'
    Else leadership_type
	End;
    
-------------------------------------

-- Step 5:  View the dim table
select * 
from leadership_dim
order by sector;

------------------------------------------------------------------------------------------
 
-- Show the person dim table , person id, person name, dob, gender, and is_woman from all  tables
 

 -- Craete a union for the 4 tables, then svae them in person_dim table 
 
 -- Step 1, the union select statemnet
 
 with dim_stage as (
 
 select 
	person_id,
    person_name,
    birth_date,
    gender,
    is_woman
   
    
from ceos_stage

union 

 select 
	person_id,
    person_name,
    birth_date,
    gender,
    is_woman
    
    
from founder_stage

union 

 select 
	person_id,
    person_name,
    birth_date,
    gender,
    is_woman
    
from gov_stage

union 

 select 
	person_id,
    person_name,
    birth_date,
    gender,
    is_woman
    
from state_stage)

select count(*)
from dim_stage;

-- we noticed some person_id dups and we want to see where the duplicates come from

select *
from state_stage as s
inner join gov_stage as g
on s.person_id=g.person_id;

-- 1504 dups between gov and state

select * 
from founder_stage as s
inner join ceos_stage as g
on s.person_id=g.person_id;

-- 415 dups between founder and ceo

select count(*) 
from founder_stage as s
inner join gov_stage as g
on s.person_id=g.person_id;

-- 46 dups between founder and gov

select count(*) 
from ceos_stage as s
inner join gov_stage as g
on s.person_id=g.person_id;

-- 8 dups between ceos and gov
select count(*) 
from ceos_stage as s
inner join state_stage as g
on s.person_id=g.person_id;

-- 2 dups between ceos and state

select count(*) 
from founder_stage as s
inner join state_stage as g
on s.person_id=g.person_id;

-- 45 dups between founder and state

-- Query used to see what values caused the person id dup in the union table 
with dups_stage as(

		SELECT person_id,
			   COUNT(DISTINCT birth_date)  AS n_birth,
			   COUNT(DISTINCT person_name) AS n_name,
			   COUNT(DISTINCT gender)      AS n_gender
		FROM (
			SELECT person_id, person_name, birth_date, gender FROM ceos_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender FROM founder_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender FROM gov_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender FROM state_stage
		) AS all_people
		GROUP BY person_id
		HAVING n_birth > 1 OR n_name > 1 OR n_gender > 1)
	
    select *
    from (SELECT person_id, person_name, birth_date, gender FROM ceos_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender FROM founder_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender FROM gov_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender FROM state_stage
		) AS a
	inner join dups_stage as d
    on a.person_id=d.person_id
	order by a.person_id;
    


-- step 2: Craete the dim table

Create table person_dim(
	person_id varchar(10) primary key,
    person_name varchar(100),
    birth_date date,
    gender varchar (80),
    is_woman varchar(10)
) ;


-- Step 3: load the union select statment into the person_dim table

INSERT INTO person_dim ( union_all as 
		( 
			SELECT person_id, person_name, birth_date, gender, is_woman FROM ceos_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender, is_woman FROM founder_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender, is_woman FROM gov_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender, is_woman FROM state_stage
		) ,
		
with union_all as 
		( 
			SELECT person_id, person_name, birth_date, gender, is_woman FROM ceos_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender, is_woman FROM founder_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender, is_woman FROM gov_stage
			UNION ALL
			SELECT person_id, person_name, birth_date, gender, is_woman FROM state_stage
		) ,
        
		ordered as
        (
        SELECT *, 
		ROW_NUMBER () OVER(partition by person_id order by birth_date desc) as num
		FROM union_all
        ) 

SELECT person_id, person_name,birth_date, gender, is_woman
FROM ordered 
WHERE num=1

);

-- Before the dedup we had 22152 person table with the union and after the dedup 22102 unique persons 

select COUNT(*) from person_dim;


-------------------------------------------------------------------------------------------



CREATE TABLE year_dim 
(
milestone_year smallint primary key,
decade smallint
);

-- Check if we have any duplicated year with wrong decad
SELECT milestone_year, COUNT( milestone_year)
from (
SELECT milestone_year, milestone_decade FROM ceos_stage
UNION
SELECT milestone_year, milestone_decade FROM founder_stage
UNION
SELECT milestone_year, milestone_decade FROM state_stage
UNION
SELECT milestone_year, milestone_decade FROM gov_stage
ORDER BY 
milestone_YEAR) as union_all
GROUP BY milestone_year
HAVING COUNT( milestone_year)>1;

-- answer is zero so we are good to create the dim table

SELECT milestone_year, milestone_decade FROM ceos_stage
UNION
SELECT milestone_year, milestone_decade FROM founder_stage
UNION
SELECT milestone_year, milestone_decade FROM state_stage
UNION
SELECT milestone_year, milestone_decade FROM gov_stage
ORDER BY 
milestone_YEAR desc;
-- we found a record in 2029 which makes no sense
-----------------------

select *
from (
SELECT person_id, person_name, milestone_year, 'ceo' as source  FROM ceos_stage
UNION
SELECT person_id, person_name, milestone_year, 'founder' as source FROM founder_stage
UNION
SELECT person_id, person_name, milestone_year, 'state' as source FROM state_stage
UNION
SELECT person_id, person_name, milestone_year, 'gov' as source FROM gov_stage
) as union_all
where milestone_year=2029;

-- One peorson has milestone in 2029 which is wrong,
select *
from ceos_stage
where person_id='Q18687923';

--  we found it was  atypo and it will be manullay changed to 2019
UPDATE ceos_stage
set 
	milestone_date= '2019-10-01',
    milestone_year=2019,
	age_at_milestone= 60,
	age_band='60-69',
	milestone_decade=2010
where person_id='Q18687923';

-------------------------------------

-- Inset data into the dim table
INSERT INTO year_dim (milestone_year, decade)

SELECT milestone_year, milestone_decade FROM ceos_stage
UNION
SELECT milestone_year, milestone_decade FROM founder_stage
UNION
SELECT milestone_year, milestone_decade FROM state_stage
UNION
SELECT milestone_year, milestone_decade FROM gov_stage
ORDER BY 
milestone_YEAR desc;

--------------------------------------------

SELECT * FROM year_dim;


-----------------------------------------------------------------------------------------------------
show create table regions;

select * from regions;


-- first probelm how to deal with null iso_3 as a forigen key
-- second problem  same iso3 with more than one contry name

SELECT 
count(*) 
FROM(
	SELECT iso_3, country FROM ceos_stage
	UNION ALL
	SELECT iso_3, country FROM founder_stage
	UNION ALL
	SELECT iso_3, country FROM gov_stage
	UNION ALL
	SELECT iso_3, country FROM state_stage
	) as union_all
    
where iso_3 <>'' And country ='' ;    


-- 3022 rows with iso is empty
-- 2291 where iso and country is empty 
-- 731 iso empty and country has a value 
-- 0 roes with iso and empty country
-----------------------------------------------------
-- second problem  same iso3 with more than one contry name
SELECT 
iso_3, count(DISTINCT country) as n_country
FROM(
	SELECT iso_3, country FROM ceos_stage
	UNION ALL
	SELECT iso_3, country FROM founder_stage
	UNION ALL
	SELECT iso_3, country FROM gov_stage
	UNION ALL
	SELECT iso_3, country FROM state_stage
	) as union_all
    
group by iso_3  
having n_country >1
order by n_country desc;

-- no iso 3 had multiple country names, good news, only the empyty iso had multiple country names 45 

-- which countries exists in the data set but has no iso? and why?
select count(*)
from (
	SELECT iso_3, country FROM ceos_stage
	UNION ALL
	SELECT iso_3, country FROM founder_stage
	UNION ALL
	SELECT iso_3, country FROM gov_stage
	UNION ALL
	SELECT iso_3, country FROM state_stage
	) as union_all

where country IN (
	SELECT 
	distinct country
	FROM(
		SELECT iso_3, country FROM ceos_stage
		UNION ALL
		SELECT iso_3, country FROM founder_stage
		UNION ALL
		SELECT iso_3, country FROM gov_stage
		UNION ALL
		SELECT iso_3, country FROM state_stage
		) as union_all
	where iso_3 = '' and country <> ''
	order by country desc) ;
    
    
    SELECT count(DISTINCT country)
	FROM(
		SELECT iso_3, country FROM ceos_stage
		UNION ALL
		SELECT iso_3, country FROM founder_stage
		UNION ALL
		SELECT iso_3, country FROM gov_stage
		UNION ALL
		SELECT iso_3, country FROM state_stage
		) as union_all
	where iso_3 = '' and country <> ''
	order by country desc;
 -- answer: countries taht doesnt exist any more like east and west germany, ottoman Empire and so on
------------------------------------------

-- DEfine and create the table
 CREATE TABLE country_dim (
iso char (3) primary key,
country varchar(100),
un_region varchar(80) ,
un_subregion varchar(80) 
);
---------------------------------------------
-- Insert the values inside the table

insert into country_dim (iso, country, un_region, un_subregion)
SELECT 
	iso_3, country,  un_region, un_subregion
	FROM(
		SELECT iso_3, country, un_region, un_subregion FROM ceos_stage
		UNION 
		SELECT iso_3, country, un_region, un_subregion FROM founder_stage
		UNION 
		SELECT iso_3, country, un_region, un_subregion FROM gov_stage
		UNION 
		SELECT iso_3, country, un_region, un_subregion FROM state_stage
		) as union_all
	where iso_3 <> '' 
 GROUP BY iso_3, country, un_region, un_subregion
 ORDER BY iso_3 ;
 
 -- note no iso has diff data values in the whole dataset
 
 -------------------------------------------
 
 select *
 from country_dim;

 -----------------------------------------------------------------------------------------
 
 -- FACT TABLE


-- CREATE Statment

CREATE TABLE fact_table 
(		id INT Auto_increment primary key,
		person_id VARCHAR(10) NOT NULL,
        type_id INT NOT NULL,
        iso CHAR(3) ,
        milestone_date DATE NOT NULL, 
		end_date DATE,
        milestone_year SMALLINT NOT NULL,
        age_at_milestone SMALLINT ,
        age_band VARCHAR(10),
        roles_held_count TINYINT,
        role_detail VARCHAR (100),
        
        CONSTRAINT FK_PERSON_ID
        FOREIGN KEY (person_id)
        REFERENCES person_dim(person_id),
        
        CONSTRAINT FK_TYPE_ID
        FOREIGN KEY (type_id)
        REFERENCES leadership_dim(type_id),
        
        CONSTRAINT FK_ISO
        FOREIGN KEY (iso)
        REFERENCES country_dim(iso) ,
        
        CONSTRAINT FK_MILE_YEAR
        FOREIGN KEY (milestone_year)
        REFERENCES year_dim(milestone_year)
        
        
);

SELECT * FROM leadership_dim;
-- show create table year_dim;


-- Select statment for the fact table - 
-- end date missing in founder so we create a new one and filled it with nulls
-- type id doesnt exist in the satging table so we CREATE a join 
-- now we want to replace all empty fields with ifnull 





insert into fact_table (
				person_id,
				type_id,
				iso,
				milestone_date,
				end_date,
				milestone_year,
				age_at_milestone,
				age_band,
				roles_held_count,
				role_detail
				)
                
WITH union_all AS(
		SELECT person_id, 
				leadership_type, 
				NULLIF(iso_3,'') AS iso_3, 
				milestone_date, 
				NULLIF(end_date, '') AS end_date,
				milestone_year,
				NULLIF(age_at_milestone,'') As age_at_milestone,
				NULLIF(age_band,'') AS age_band,
				NULLIF(roles_held_count,'') AS roles_held,
				NULLIF(first_organization,'') AS role_detail
				FROM ceos_stage 
		UNION ALL
		SELECT
		person_id, 
				leadership_type, 
				NULLIF(iso_3,'') AS iso_3, 
				milestone_date, 
				null as end_date,
				milestone_year,
				NULLIF(age_at_milestone,'') As age_at_milestone,
				NULLIF(age_band,'') AS age_band,
				NULLIF(roles_held_count,'') AS roles_held,
				NULLIF(first_organization,'') AS role_detail

		FROM founder_stage 
		UNION ALL
		SELECT
				person_id, 
				leadership_type, 
				NULLIF(iso_3,'') AS iso_3, 
				milestone_date, 
				NULLIF(end_date, '') AS end_date,
				milestone_year,
				NULLIF(age_at_milestone,'') As age_at_milestone,
				NULLIF(age_band,'') AS age_band,
				NULLIF(roles_held_count,'') AS roles_held,
				NULLIF(first_position,'') AS role_detail
		FROM state_stage 
		UNION ALL
		SELECT
				person_id, 
				leadership_type, 
				NULLIF(iso_3,'') AS iso_3, 
				milestone_date, 
				NULLIF(end_date, '') AS end_date,
				milestone_year,
				NULLIF(age_at_milestone,'') As age_at_milestone,
				NULLIF(age_band,'') AS age_band,
				NULLIF(roles_held_count,'') AS roles_held,
				NULLIF(first_position,'') AS role_detail
		FROM gov_stage 
		)                
SELECT
			u.person_id,
			l.type_id,
			u.iso_3,
			u.milestone_date,
			u.end_date,
			u.milestone_year,
			u.age_at_milestone,
			u.age_band,
			u.roles_held,
			u.role_detail
from union_all as u
inner join leadership_dim  as l
on u. leadership_type=l.leadership_type;


select * from fact_table;

