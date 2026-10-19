use when_women_rise;

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

-- create the ceo stage tabel adn load data
create table ceos_stage(
	person_id varchar (10) primary key,
	person_name varchar (100),
	gender varchar (80),
	is_woman varchar(10),
	birth_date date,
	leadership_type varchar(100),
	first_organization varchar(200),
	milestone_date date,
	end_date date,
	age_at_milestone int,
	age_band varchar(50),
	milestone_year SMALLINT,
	milestone_decade int,
	roles_held_count int,
	country	varchar (20) ,
    iso_3 char (3),
	un_region varchar (20),
	un_subregion varchar(50)
	);
    
show create table ceos_stage;


ALTER TABLE ceos_stage
 MODIFY end_date VARCHAR(10),
 MODIFY country VARCHAR(60);



SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/kifah/Kifah Folders/BDAT2024/Portfolio/Portfolio_github/Portfolio_Public/When_Women_Rise/data/ceos.csv'
INTO TABLE when_women_rise.ceos_stage
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


select count(*) from ceos_stage;

---------------------------------------------------------------------------

-- Create the founder stage table and load data

create table founder_stage(
	person_id varchar (10) primary key,
	person_name varchar (100),
	gender varchar (80),
	is_woman varchar(10),
	birth_date date,
	leadership_type varchar(100),
	first_organization varchar(200),
	milestone_date date,
	-- end_date date,
	age_at_milestone int,
	age_band varchar(50),
	milestone_year SMALLINT,
	milestone_decade int,
	roles_held_count int,
	country	varchar (100) ,
    iso_3 char (3),
	un_region varchar (20),
	un_subregion varchar(50)
	);
    

show create table founder_stage;

SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/kifah/Kifah Folders/BDAT2024/Portfolio/Portfolio_github/Portfolio_Public/When_Women_Rise/data/founders.csv'
INTO TABLE when_women_rise.founder_stage
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


select count(*) from founder_stage;

--------------------------------------------------------------------
-- Create the Gov stage table and load data


create table gov_stage(
	person_id varchar (10) primary key,
	person_name varchar (100),
	gender varchar (80),
	is_woman varchar(10),
	birth_date date,
	leadership_type varchar(100),
	first_position varchar(200),
	milestone_date date,
	end_date varchar (50),
	age_at_milestone int,
	age_band varchar(50),
	milestone_year SMALLINT,
	milestone_decade int,
	roles_held_count int,
	country	varchar (100) ,
    iso_3 char (3),
	un_region varchar (20),
	un_subregion varchar(50)
	);
    
LOAD DATA LOCAL INFILE 'C:/Users/kifah/Kifah Folders/BDAT2024/Portfolio/Portfolio_github/Portfolio_Public/When_Women_Rise/data/heads_of_government.csv'
INTO TABLE when_women_rise.gov_stage
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select count(*) from gov_stage;

-----------------------------------------------------------------------

-- Create adn load data for the states leadership table

create table state_stage(
	person_id varchar (10) primary key,
	person_name varchar (100),
	gender varchar (80),
	is_woman varchar(10),
	birth_date date,
	leadership_type varchar(100),
	first_position varchar(200),
	milestone_date date,
	end_date varchar (50),
	age_at_milestone int,
	age_band varchar(50),
	milestone_year SMALLINT,
	milestone_decade int,
	roles_held_count int,
	country	varchar (100) ,
    iso_3 char (3),
	un_region varchar (20),
	un_subregion varchar(50)
	);
    
LOAD DATA LOCAL INFILE 'C:/Users/kifah/Kifah Folders/BDAT2024/Portfolio/Portfolio_github/Portfolio_Public/When_Women_Rise/data/heads_of_state.csv'
INTO TABLE when_women_rise.state_stage
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select count(*) from state_stage;

---------------------------------------------

-- create and load data into the regions stage table 

create table regions(
	iso3	char(3),
    un_region	varchar(80),
    un_subregion varchar(80)
);

LOAD DATA LOCAL INFILE 'C:/Users/kifah/Kifah Folders/BDAT2024/Portfolio/Portfolio_github/Portfolio_Public/When_Women_Rise/data/country_regions.csv'
INTO TABLE when_women_rise.regions
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * from regions;