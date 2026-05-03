-- third req


-- set all employees salary to the base salary of their job title
CREATE OR REPLACE PROCEDURE set_salary_to_baselvl()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employee SET salary = job_title.base_salary
    FROM job_title
    WHERE employee.j_id = job_title.j_id;
END;
$$;

/**
--Test call:
CALL set_salary_to_baselvl();
SELECT e_id, emp_name, salary FROM employee LIMIT 10;
**/


-- add 3 months to all temporary contracts (increase their contract_end date)
CREATE OR REPLACE PROCEDURE increase_contracts()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employee
    SET contract_end = contract_end + INTERVAL '3 months'
    WHERE contract_type = 'Temporary' AND contract_end IS NOT NULL;
END;
$$;

/**
-- Test call:
CALL increase_contracts();
SELECT e_id, emp_name, contract_type, contract_eznd FROM employee 
WHERE contract_type = 'Temporary' 
LIMIT 10;
**/

-- increase salaries by a given percentage
-- p_percentage: 10 = 10% increase, 5.5 = 5.5% increase
-- p_salary_limit: only raise the salaries below this value. 0 or NULL means no limit
CREATE OR REPLACE PROCEDURE increase_salaries(
    p_percentage  NUMERIC,
    p_salary_limit INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employee
    SET salary = ROUND(salary + (salary * p_percentage / 100))
    WHERE (p_salary_limit IS NULL OR p_salary_limit = 0) OR salary < p_salary_limit;
END;
$$;

/**
-- test call to increase all salaries by 10%
CALL increase_salaries(10);
SELECT e_id, emp_name, salary FROM employee LIMIT 10;
**/

/**
-- test call to increase salaries by 5% ONLY for employees earning <4000
CALL increase_salaries(5, 4000);
SELECT e_id, emp_name, salary FROM employee WHERE salary < 4000 LIMIT 10;
**/
