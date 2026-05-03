-- sixth req


-- add zip_code column to Geo_location (no data population required)
ALTER TABLE geo_location ADD COLUMN zip_code CHARACTER VARYING;


-- add NOT NULL constraint to customer email & project start date
-- take into account NULL emails and dates with placeholders  & current date
UPDATE customer SET email = 'placeholder@domain.com'
WHERE email IS NULL;

ALTER TABLE customer ALTER COLUMN email SET NOT NULL;


UPDATE project SET p_start_date = CURRENT_DATE
WHERE p_start_date IS NULL;

ALTER TABLE project ALTER COLUMN p_start_date SET NOT NULL;


-- add check constraint to employee salary & make sure  more than 1000
--    must first update any salaries that are 1000 or below
UPDATE employee SET salary = 1001
WHERE salary <= 1000;

ALTER TABLE employee
    ADD CONSTRAINT salary_check CHECK (salary > 1000);
