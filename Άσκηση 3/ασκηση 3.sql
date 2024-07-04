--ερωτημα α
create or replace function update_contract ()
returns trigger as
$BODY$
begin
update insurance set contract_end_date = contract_end_date + interval '1 year' where  contract_end_date =CURRENT_DATE and categoryid in (select categoryid from vehicle_category where vehicle_category.insurance_group='professional') ;-- αν η ημερομηνία κάποια εγγραφής είναι ίση με την τρέχουσα ημερομηνία και αν η ασφαλιστική κατηργορία είναι επαγγελματική τότε κάνω update τον ζητούμενο πίνακα και αλλάζω την ημερομηνία λήξης του συμβολαίου
return new;
end;
$BODY$
language plpgsql;

create trigger update_contract 
after update on insurance 
for each row execute procedure update_contract();
update insurance set contract_start_date=contract_start_date ;--επειδή δεν θέλω να αλλάξω κάτι άλλο απο τον πίνακα θέτω μια μεταβλητή ίση με τον εαυτό της
select * from insurance;
delete from  insurance;
COPY insurance (insuranceID,contract_code,car,contract_start_date,contract_end_date,valid_con,con_cost,categoryid) FROM 'C:\Users\Public\Insurance.csv' DELIMITER ',' CSV HEADER;

--ερωτημα β
CREATE TYPE my_type AS (contract_code varchar, driver varchar, client varchar,contract_start_date date); --φτιάχνω τον τύπο με βάση τον οποίο θέλω να επιστρεφεται το αποτέλεσμα της συνάρτησης στον οποίο υλοποιούμε τον cursor. Εφόσον έχω επιλέξει να εκτελέσω το 1ο query της άσκησης 2 όπως θα φανεί παρακάτω βάζω με τη σειρά τις απαραίτητες μεταβλητές ωστέ να έχω οργανωμένα τα δεδομένα που θα πάρω 

CREATE FUNCTION getQuery() RETURNS SETOF my_type AS $$ --το αποτέλεσμα της συνάρτησης θα επιστραφει με βάση τον τύπο που έχω δημιουργήσει (βλ. σκρινσοτ)
DECLARE 
  my_cursor CURSOR FOR select insurance.contract_code,drivers.fullname as drivers_fullname,clients.fullname,contract_start_date from clients inner join insurance on clients.contract_code=insurance.contract_code inner join drivers on  clients.contract_code=drivers.contract_code WHERE contract_start_date >= date_trunc('month', current_date ) and contract_start_date < date_trunc('month', current_date + interval '1' month);
 --υλοποιώ το query μέσω του cursor που έχω δημιουργήσει
  rec my_type;--δηλώνω μεταβλητή του τύπου που έχω δημιουργήσει
BEGIN
  OPEN my_cursor;
  FETCH my_cursor INTO rec.contract_code, rec.driver,rec.client,rec.contract_start_date;    -- Διαβάζω πρώτη γραμμή απο τον cursor 
  WHILE FOUND LOOP
    RETURN NEXT rec;                                 -- Return the data to the caller
    FETCH my_cursor INTO rec.contract_code, rec.driver,rec.client,rec.contract_start_date;  -- Διαβάζω γραμμες μέσα στο loop
  END LOOP;
  CLOSE my_cursor;
  RETURN;
END;
$$ LANGUAGE plpgsql;
select getQuery(); --καλώ την συνάρτηση 