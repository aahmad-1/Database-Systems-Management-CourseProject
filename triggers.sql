-- second req

-- before inesrting a new skill, make sure the same skill does not already exist
CREATE OR REPLACE FUNCTION check_duplicate_skill()
RETURNS TRIGGER AS $$
DECLARE
    existing_skill VARCHAR;
BEGIN
    SELECT skill INTO existing_skill FROM skills
    WHERE LOWER(skill) = LOWER(NEW.skill);

    IF existing_skill IS NOT NULL THEN
        RAISE EXCEPTION 'Skill "%" already exists.', NEW.skill;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_duplicate_skill BEFORE INSERT ON skills
FOR EACH ROW EXECUTE FUNCTION check_duplicate_skill();


-- after inserting a new project, check the customer country and
-- select three employees from that country to start working w/ the project
CREATE OR REPLACE FUNCTION assign_employees_to_project()
RETURNS TRIGGER AS $$
DECLARE
    customer_country VARCHAR;
    emp RECORD;
    assigned INT := 0;
BEGIN
    SELECT gl.country INTO customer_country FROM customer c
    INNER JOIN geo_location gl ON c.l_id = gl.l_id
    WHERE c.c_id = NEW.c_id;

    --  pick max 3 employees from that country who are not already on the project
    FOR emp IN
        SELECT e.e_id
        FROM employee e
        INNER JOIN department d ON e.d_id = d.d_id
        INNER JOIN headquarters hq ON d.hid = hq.h_id
        INNER JOIN geo_location gl ON hq.l_id = gl.l_id
        WHERE gl.country = customer_country
          AND e.e_id NOT IN (
              SELECT e_id FROM project_role WHERE p_id = NEW.p_id
          )
        LIMIT 3
    LOOP
        INSERT INTO project_role (e_id, p_id, prole_start_date)
        VALUES (emp.e_id, NEW.p_id, CURRENT_DATE);

        assigned := assigned + 1;
    END LOOP;

    IF assigned = 0 THEN
        RAISE NOTICE 'No employees found in country "%" for project %.', customer_country, NEW.p_id;
    ELSE
        RAISE NOTICE '% employee(s) assigned to project % from country "%".', assigned, NEW.p_id, customer_country;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER assign_employees_to_project AFTER INSERT ON project
FOR EACH ROW EXECUTE FUNCTION assign_employees_to_project();


-- before updating employee contract_type, make sure contract_start is set
-- to current date, and contract_end is 2 years after if Temporary, NULL otherwise
CREATE OR REPLACE FUNCTION update_contract_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.contract_type IS DISTINCT FROM OLD.contract_type THEN
        NEW.contract_start := CURRENT_DATE;

        IF NEW.contract_type = 'Temporary' THEN
            NEW.contract_end := CURRENT_DATE + INTERVAL '2 years';
        ELSE
            NEW.contract_end := NULL;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_contract_dates BEFORE UPDATE ON employee
FOR EACH ROW EXECUTE FUNCTION update_contract_dates();
