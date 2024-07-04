--Ερώτημα a
select insurance.contract_code,drivers.fullname as drivers_fullname,clients.fullname,contract_start_date from clients inner join insurance on clients.contract_code=insurance.contract_code inner join drivers on  clients.contract_code=drivers.contract_code WHERE contract_start_date >= date_trunc('month', current_date ) and contract_start_date < date_trunc('month', current_date + interval '1' month);
--η συνάρτηση date_trunc() που χρησιμοποιείται και στο ερώτημα α και στο β επιστρέφει την πρώτη μέρα του μήνα που περιέχεται στην ημερομηνία που δίνεται ως όρισμα 
--Ερώτημα b
select phonenumber1,phonenumber2,fullname,insurance.contract_code,contract_end_date from clients inner join insurance on clients.contract_code=insurance.contract_code where insurance.contract_end_date > date_trunc('month', current_date + interval '1' month) and insurance.contract_end_date < date_trunc('month', current_date + interval '2' month)
--
--Ερώτημα c
select count (contract_code),insurance_group, case when DATE_PART('year', contract_start_date::date)=2020  then '2020' when  DATE_PART('year', contract_start_date::date)=2019 then '2019' when  DATE_PART('year', contract_start_date::date)=2018 then '2018'  when DATE_PART('year', contract_start_date::date)=2017  then '2017'  when DATE_PART('year', contract_start_date::date)=2016  then '2016' end as contract_start_year from insurance inner join vehicle_category on insurance.categoryid=vehicle_category.categoryid where valid_con=FALSE and DATE_PART('year', contract_start_date::date) >= 2016 group by contract_start_year,insurance_group order by contract_start_year desc;
--
--Ερώτημα d
--1η παραλλαγή
select sum (TO_NUMBER(con_cost,'L9G999g999.99')),vehicle_category.insurance_group, count (contract_code) from insurance inner join vehicle_category on insurance.categoryid=vehicle_category.categoryid group by vehicle_category.insurance_group ORDER BY COUNT(TO_NUMBER(con_cost,'L9G999g999.99')) DESC
--
--2η παραλλαγή 
select count(contract_code),avg(TO_NUMBER(con_cost,'L9G999g999.99')) as avg_con_cost,vehicle_category.insurance_group, avg(TO_NUMBER(con_cost,'L9G999g999.99'))*count(contract_code) as total_profit from insurance inner join vehicle_category on insurance.categoryid=vehicle_category.categoryid group by vehicle_category.insurance_group
-- η συνάρτηση To_Number χρησιμοποιείται επειδή η στήλη με τα κόστη περιέχει και το σύμβολο του ευρώ οπότε δεν μας επιτρέπεται να τα προσθέσουμε αν πρώτα δεν τα μετατρέψουμε απο varchar σε αριθμό 
--Ερώτημα e 1η λύση με μέσο όρο 
Select avg(con_count) AS con_count from 
(Select count(contract_code) as con_count
from vehicles where release_year>=2017 group by release_year) Z 
--(0-4 χρονια)
Select avg(con_count) AS con_count from 
(Select count(contract_code) as con_count
from vehicles where release_year>=2012 and release_year<=2016 group by release_year) Z
--(5-9 χρόνια)
Select avg(con_count) AS con_count from 
(Select count(contract_code) as con_count
from vehicles where release_year>=2002 and release_year<=2011 group by release_year) Z
--(10-19 χρόνια)
Select avg(con_count) AS con_count from 
(Select count(contract_code) as con_count
from vehicles where release_year<=2001 group by release_year) Z 
--(20+ χρόνια)
--2η λύση με ποσοστά 
select count(contract_code), case when 2021-release_year<=4 then '0-4' when 2021-release_year>=5 and 2021-release_year<=9 then '5-9' when 2021-release_year>=10 and 2021-release_year<=19 then '10-19' else '20+' end as car_age  from vehicles group by car_age ; 
--
--Ερώτημα f 1η λύση με μέσο όρο
select avg(viol_count) AS viol_count from 
(Select count(violations.violation_id) as viol_count,DATE_PART('year', drivers.birthdate::date) 
from caused_by inner join violations on violations.violation_id=caused_by.violation_id inner join drivers on caused_by.driver=drivers.drivers_license_number where DATE_PART('year', drivers.birthdate::date) >=1997 and DATE_PART('year', drivers.birthdate::date) <=2003  group by DATE_PART('year', drivers.birthdate::date) ) Z 
--(18-24 χρονών)
Select avg(viol_count) AS viol_count from 
(Select count(violations.violation_id) as viol_count,DATE_PART('year', drivers.birthdate::date) 
from caused_by inner join violations on violations.violation_id=caused_by.violation_id inner join drivers on caused_by.driver=drivers.drivers_license_number where DATE_PART('year', drivers.birthdate::date) >=1972 and DATE_PART('year', drivers.birthdate::date) <=1996  group by DATE_PART('year', drivers.birthdate::date) ) Z 
--(25-49 χρονών)
Select avg(viol_count) AS viol_count from 
(Select count(violations.violation_id) as viol_count,DATE_PART('year', drivers.birthdate::date) 
from caused_by inner join violations on violations.violation_id=caused_by.violation_id inner join drivers on caused_by.driver=drivers.drivers_license_number  where DATE_PART('year', drivers.birthdate::date) >=1952 and DATE_PART('year', drivers.birthdate::date) <=1971  group by DATE_PART('year', drivers.birthdate::date) ) Z  
--(50-69 χρονών)
Select avg(viol_count) AS viol_count from 
(Select count(violations.violation_id) as viol_count,DATE_PART('year', drivers.birthdate::date) 
from caused_by inner join violations on violations.violation_id=caused_by.violation_id inner join drivers on caused_by.driver=drivers.drivers_license_number  where DATE_PART('year', drivers.birthdate::date) <=1951  group by DATE_PART('year', drivers.birthdate::date) ) Z 
--(70+ χρόνων) 
--2η λύση με ποσοστά αντι για μέσο όρο 
select count(violation_id)*2, case when DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)>=18 and  DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)<=24 then '18-24' when DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)>=25 and  DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)<=49 then '25-49' when DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)>=50 and  DATE_PART('year', CURRENT_DATE)-DATE_PART('year',drivers.birthdate::date)<=69 then '50-69' else '70+' end as driver_age from caused_by inner join drivers on caused_by.driver=drivers.drivers_license_number group by driver_age ; 

--

