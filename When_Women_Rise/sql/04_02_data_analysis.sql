
-- Outliers -- 1371 outliers 
select COUNT(*)
from(
select 
		case 
        when type_id in (1,4) and  age_at_milestone >70 then 1
        when type_id in (5,6) and  (age_at_milestone >85 OR year(birth_date)< 1850 ) then 1
        when month(birth_date)='01' and day(birth_date)='01' and year(birth_date) in (1701,1801,1901,2001) then 1
        else 0
        end as is_outlier
        
from fact_table as f
join person_dim as p
on f.person_id=p.person_id) as view_table
where is_outlier =1;


-- Create a view table to flag outliers

CREATE VIEW v_fact_clean AS  

(select f.*, 
		l.leadership_type,
        p.person_name,
        p.gender, 
        p.is_woman, 
        p.birth_date,
		case 
        when f.type_id in (1,4) and  age_at_milestone >70 then 1
        when f.type_id in (5,6) and  (age_at_milestone >85 OR year(birth_date)< 1850 ) then 1
        when month(birth_date)='01' and day(birth_date)='01' and year(birth_date) in (1701,1801,1901,2001) then 1
        else 0
        end as is_outlier
        
from fact_table as f
join person_dim as p
on f.person_id=p.person_id
join leadership_dim as l
on f.type_id=l.type_id);
----------

-- type_id, leadership_type, total, flagged, pct_flagged)
SELECT
type_id, leadership_type,
count(*) as total,
sum(case when is_outlier =1 then 1 else 0 end)as total_flagged,
(sum(case when is_outlier =1 then 1 else 0 end)/count(*))*100 as pct_flagged
from v_fact_clean
group by type_id;

----------
-- Q2: What is the average age at milestone for women and men in each type?

select type_id, 
	   AVG(case when is_woman= 'TRUE' then age_at_milestone end) avg_female,
	   AVG(case when gender = 'male' then age_at_milestone end) avg_male,
       AVG(case when gender not in ('female', 'male') then age_at_milestone end) avg_else, 
       AVG(case when is_woman= 'TRUE' then age_at_milestone end) -  AVG(case when gender = 'male' then age_at_milestone end) as gap,
       COUNT(case when is_woman = 'TRUE' then 1 end) count_female,
       COUNT(case when gender = 'male' then 1 end) count_male,
       COUNT(case when gender not in ('female', 'male')  then 1 end) count_else
       
from v_fact_clean 
where is_outlier=0
GROUP BY type_id;
------------------------------------------------------------------------------------------------
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
        count(distinct f.person_id) as region_women_leaders, 
        round(avg(f.age_at_milestone),0) as region_avg
from v_fact_clean as f
join country_dim as c
on f.iso=c.iso
where f.is_woman= 'TRUE' AND un_region <> '' AND is_outlier=0
group by c.un_region
order by region_women_leaders) as firstt

JOIN 

(select  
        c.un_region,
        c.un_subregion,
        count(distinct f.person_id) as subregion_women_leaders, 
        round(avg(f.age_at_milestone),0) as sub_region_avg
from v_fact_clean as f
join country_dim as c
on f.iso=c.iso
where f.is_woman= 'TRUE' AND un_region <> '' AND is_outlier=0
group by c.un_region, c.un_subregion
order by subregion_women_leaders) as secondd
on firstt.un_region=secondd.un_region
order by firstt.region_women_leaders desc;
  

-------------------------------------------------------------------------------------------------

-- -- Q5: In each type, what share of women reached leadership at 40 to 49 and at 50 to 59? 

select *,`above_60%` + `under_40%` + `40-59%` as total
from 
(select   type_id,
		 count(*) total,
         round(avg(age_at_milestone),1) as avg_age,
         sum(case when age_at_milestone <40 then 1 else 0 end) as '<40',
         round((sum(case when age_at_milestone <40 then 1 else 0 end)/COUNT(*))*100,1) as 'under_40%',
         sum(case when age_at_milestone >=40 AND age_at_milestone <=59 then 1 else 0 end) as '40-59',
         round((sum(case when age_at_milestone >=40 AND age_at_milestone <=59 then 1 else 0 end)/COUNT(*))*100,1) as '40-59%',
         sum(case when age_at_milestone >59 then 1 else 0 end) as 'above_60',
         round((sum(case when age_at_milestone >59 then 1 else 0 end)/COUNT(*))*100,1) as 'above_60%'
from v_fact_clean
where is_woman='TRUE' and is_outlier=0
group by type_id) as total;

--------------------------------------------------------------------------------------------------------
-- Q7: For each region, show women's and men's average age side by side with the gap.
select   
c.un_region,
f.type_id,
SUM(CASE WHEN f.is_woman='TRUE' THEN 1 ELSE 0 END) women_count,
round(avg(case when f.is_woman='TRUE' then age_at_milestone end),1) as women_age_avg, 
round(avg(case when f.gender='male' then age_at_milestone end),1) as men_age_avg,
round(avg(case when f.is_woman='TRUE' then age_at_milestone end),1) - round(avg(case when f.gender='male' then age_at_milestone end),1)  as age_gap
from v_fact_clean as f
join country_dim as c
on c.iso=f.iso
where un_region <> '' and is_outlier = 0
group by c.un_region,f.type_id
order by un_region;

-------------------------------------------------------------------------------------------------------
-- Q8: What share of all leaders were women in each decade?
select * from year_dim;

select y.decade,
sum(case when is_woman='TRUE' then 1 else 0 end) total_women,
sum(case when gender='male' then 1 else 0 end) total_men,
count(*) as decade_leaders,
round((sum(case when is_woman='TRUE' then 1 else 0 end)/count(*)*100),2) as women_share
from v_fact_clean as f
join year_dim as y
on f.milestone_year=y.milestone_year
where is_outlier = 0
group by y.decade;
------------------------------------------------------------------------------------------------------
-- Q11: What is the median age at milestone for women in each type?


with ranked as (select 
type_id,
leadership_type,
age_at_milestone,
row_number() over(partition by type_id order by age_at_milestone) as ranking,
count(*) over (partition by type_id ) as n,
avg(age_at_milestone) over(partition by type_id) as avg_type
from v_fact_clean 
where is_woman='TRUE' and is_outlier=0 )

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


