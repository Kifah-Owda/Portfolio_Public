-- Data Analysis
select * from fact_table;
-- Q1: How many leaders are in each leadership type, and how many of them are women?

select f.type_id, 
	   l.leadership_type,
	   count(*) AS total_leaders,
	   sum(case when is_woman= 'TRUE' THEN 1 ELSE 0 end) AS Women_Leaders,
       (sum(case when is_woman= 'TRUE' THEN 1 ELSE 0 end)/count(*))*100 AS 'percentage%'
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
JOIN leadership_dim as l
ON f.type_id=l.type_id
group by f.type_id;

-------------------------------------------------------------------------------------
-- Q2: What is the average age at milestone for women and men in each type?

select f.type_id, 
	   l.leadership_type,
	   AVG(case when is_woman= 'TRUE' then age_at_milestone end) avg_female,
	   AVG(case when gender = 'male' then age_at_milestone end) avg_male,
       AVG(case when gender not in ('female', 'male') then age_at_milestone end) avg_else, 
       AVG(case when is_woman= 'TRUE' then age_at_milestone end) -  AVG(case when gender = 'male' then age_at_milestone end) as gap,
       COUNT(case when is_woman = 'TRUE' then 1 end) count_female,
       COUNT(case when gender = 'male' then 1 end) count_male,
       COUNT(case when gender not in ('female', 'male')  then 1 end) count_else
       
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
JOIN leadership_dim as l
ON f.type_id=l.type_id
GROUP BY type_id;

-- Our data can be more accurate if we categorize every gender type as a woman or not, the else here might include someone identified as a woman but not female

-------------------------------------------------------------
-- Q3: Who is the youngest and who is the oldest woman in each type?

WITH Ranked as (
		   select 
           f.type_id, 
		   f.person_id,
           f.role_detail,
		   f.age_at_milestone, 
		   p.person_name,
		   l.leadership_type,
		   ROW_NUMBER() over(partition by type_id  order by age_at_milestone desc) as oldest,
		   ROW_NUMBER() over(partition by type_id  order by age_at_milestone asc) as youngest
			from fact_table as f
			join person_dim as p
			on f.person_id=p.person_id
			JOIN leadership_dim as l
			ON f.type_id=l.type_id
			where p.is_woman= 'TRUE')

select type_id, 
	   leadership_type,
	   (case when youngest =1 then 'youngest' else 'oldest' end) as extreme,
	   person_id, 
	   person_name,
       age_at_milestone, 
       role_detail
from ranked
where oldest = 1 or youngest= 1;

-------------

-- Q4: How many women leaders are there in each UN region and sub-region, and what is their average age at milestone?

select firstt.un_region, 
		firstt.region_women_leaders, 
        firstt.region_avg,
        secondd.un_subregion,
        secondd.subregion_women_leaders,
         secondd.sub_region_avg
from
(select  
        c.un_region,
        count(distinct p.person_id) as region_women_leaders, 
        round(avg(f.age_at_milestone),0) as region_avg
from fact_table as f
join country_dim as c
on f.iso=c.iso
join person_dim as p
on f.person_id=p.person_id
where p.is_woman= 'TRUE' AND un_region <> ''
group by c.un_region
order by region_women_leaders) as firstt

JOIN 

(select  
        c.un_region,
        c.un_subregion,
        count(distinct p.person_id) as subregion_women_leaders, 
        round(avg(f.age_at_milestone),0) as sub_region_avg
from fact_table as f
join country_dim as c
on f.iso=c.iso
join person_dim as p
on f.person_id=p.person_id
where p.is_woman= 'TRUE' AND un_region <> ''
group by c.un_region, c.un_subregion
order by subregion_women_leaders) as secondd
on firstt.un_region=secondd.un_region
order by firstt.region_women_leaders desc;
  

--------------------
-- Q5: In each type, what share of women reached leadership at 40 to 49 and at 50 to 59? 
select   f.type_id,
		 l.leadership_type,	
		 count(*) total,
         round(avg(age_at_milestone),1),
		 sum(case when age_band="30-39" then 1 else 0 end) as thirtes,
         round((sum(case when age_band="30-39" then 1 else 0 end)/COUNT(*))*100,1) as 'thirtes%',
		 sum(case when age_band="40-49" then 1 else 0 end) as forties,
         round((sum(case when age_band="40-49" then 1 else 0 end)/COUNT(*))*100,1) as 'forties%',
         sum(case when age_band="50-59" then 1 else 0 end) as fifties,
         round((sum(case when age_band="50-59" then 1 else 0 end)/COUNT(*))*100,1) as 'fifties%',
         sum(case when age_at_milestone <40 then 1 else 0 end) as '<40',
         round((sum(case when age_at_milestone <40 then 1 else 0 end)/COUNT(*))*100,1) as 'under_40%',
         sum(case when age_at_milestone >40 AND age_at_milestone <59 then 1 else 0 end) as '40-59',
         round((sum(case when age_at_milestone >40 AND age_at_milestone <49 then 1 else 0 end)/COUNT(*))*100,1) as '40-59%',
         sum(case when age_at_milestone >59 then 1 else 0 end) as 'above_60',
         round((sum(case when age_at_milestone >59 then 1 else 0 end)/COUNT(*))*100,1) as 'above_60%'
from fact_table as f
join leadership_dim as l
on f.type_id=l.type_id
join person_dim as p
on f.person_id=p.person_id
where p.is_woman='TRUE'
group by type_id;

--------------------
-- Q5.1 sahre of women in each sector

with all_lead as (select type_id, count(*) as all_leaders
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
group by type_id)


select   f.type_id,
		 l.leadership_type,	
		 count(*) women_type_total,
         a.all_leaders,
         round((count(*)/a.all_leaders)*100,1) as percentage
from fact_table as f
join leadership_dim as l
on f.type_id=l.type_id
join person_dim as p
on f.person_id=p.person_id
join all_lead as a
on a.type_id=f.type_id
where p.is_woman='TRUE'
group by type_id;

-----------------------
-- Q6: Which regions have the youngest and oldest women leaders?
with ranked as(
SELECT  c.un_region,
		f.age_at_milestone,
        c.country,
		rank() over(partition by c.un_region order by f.age_at_milestone) as youngest,
        rank() over(partition by c.un_region order by f.age_at_milestone desc) as oldest
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
join country_dim as c
on c.iso=f.iso
where p.is_woman='TRUE' and un_region <> ''),

ages as (
select max(age_at_milestone) as max_age, MIN(age_at_milestone) as min_age 
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
where p.is_woman='TRUE'
 
)

select un_region, 
age_at_milestone,
country,
case WHEN youngest=1 then 'youngest' else 'oldest' end as extreme
from ranked 
where (youngest=1 and age_at_milestone =(select min_age from ages)) OR
	 (oldest=1 and age_at_milestone =(select max_age from ages));
     
    ---------------------------------------
    
    -- Q7: For each region, show women's and men's average age side by side with the gap.
select   
c.un_region,
f.type_id,
SUM(CASE WHEN p.is_woman='TRUE' THEN 1 ELSE 0 END) women_count,
round(avg(case when p.is_woman='TRUE' then age_at_milestone end),1) as women_age_avg, 
round(avg(case when p.gender='male' then age_at_milestone end),1) as men_age_avg,
round(avg(case when p.is_woman='TRUE' then age_at_milestone end),1) - round(avg(case when p.gender='male' then age_at_milestone end),1)  as age_gap
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
join country_dim as c
on c.iso=f.iso
where un_region <> ''
group by c.un_region,f.type_id
order by un_region;

---------------
-- Q8: What share of all leaders were women in each decade?
select * from year_dim;

select y.decade,
sum(case when is_woman='TRUE' then 1 else 0 end) total_women,
sum(case when gender='male' then 1 else 0 end) total_men,
count(*) as decade_leaders,
round((sum(case when is_woman='TRUE' then 1 else 0 end)/count(*)*100),2) as women_share
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
join year_dim as y
on f.milestone_year=y.milestone_year
group by y.decade;

-----------------
-- Q9: Which women appear in more than one leadership type (for example CEO and founder)?

select f.person_id, 
	GROUP_CONCAT(leadership_type) as cat,
    case when p.person_name is null then 'Unkown Name' else p.person_name end as name
from fact_table as f	
join person_dim as p
on f.person_id=p.person_id
join leadership_dim as l
on l.type_id = f.type_id
where is_woman='TRUE'
group by f.person_id
having COUNT(distinct f.type_id)>1;

 -- some records have no name , where person name= perso id
 
select count(*)
from person_dim where person_id=person_name and is_woman='TRUE'; -- 74 women & 672 men

-- update the table , perosn name = null when person name is an id
update person_dim
set person_name=NULL
where person_id=person_name;

--------------------

-- Q10: Which countries have more women leaders than their region's average country?

with region_avg as 
( select 
	   c.un_region, 
	   COUNT(f.person_id) as total_women,
       COUNT(distinct country)  as num_countries,
       round(COUNT(f.person_id)/COUNT(distinct country),1) as region_average
       
from fact_table as f	
join person_dim as p
on f.person_id=p.person_id
join country_dim as c
on c.iso=f.iso
where is_woman='TRUE' and un_region <> ''
group by c.un_region
),

country_total as
(
select 
	c.un_region,	
	   c.country,
       COUNT(f.person_id) as country_total_women
       
from fact_table as f	
join person_dim as p
on f.person_id=p.person_id
join country_dim as c
on c.iso=f.iso
where is_woman='TRUE' and un_region <> ''
group by c.un_region,c.country
)

select
    co.country, co.country_total_women,
	av.un_region, av.region_average
from region_avg as av
join country_total as co
on av.un_region=co.un_region
where co.country_total_women> av.region_average
;


select 
	   c.un_region, 
	   COUNT(f.person_id) as total_women,
       COUNT(distinct country)  as num_countries,
       round(COUNT(f.person_id)/COUNT(distinct country),1) as region_average
       
from fact_table as f	
join person_dim as p
on f.person_id=p.person_id
join country_dim as c
on c.iso=f.iso
where is_woman='TRUE' and un_region <> '' and un_region='Americas'
group by c.un_region;

----------------
-- Q11: What is the median age at milestone for women in each type?

with ranked as (select 
f.type_id,
l.leadership_type,
f.age_at_milestone,
row_number() over(partition by f.type_id order by age_at_milestone) as ranking,
count(*) over (partition by f.type_id ) as n,
avg(age_at_milestone) over(partition by f.type_id) as avg_type
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
join leadership_dim as l
on f.type_id=l.type_id
where is_woman='TRUE' )

select type_id,leadership_type, group_avg, round(avg(age_at_milestone),1) as group_median
from(
select 
type_id,
leadership_type,
age_at_milestone,
ranking,
round(avg_type,1) as group_avg
from ranked 
where ranking IN (floor((n+1)/2) , ceil((n+1)/2))) as median
group by type_id,leadership_type,group_avg;

----
