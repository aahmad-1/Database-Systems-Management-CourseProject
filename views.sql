-- first req

-- view 1: employee overview w/ department, job title, and location
-- useful for management to see all info of an employee at once
CREATE OR REPLACE VIEW view_employee_info AS
SELECT
    e.e_id,
    e.emp_name,
    e.email,
    e.contract_type,
    e.salary,
    j.title AS job_title,
    j.base_salary,
    d.dep_name AS department,
    hq.hq_name AS headquarters,
    gl.city AS city,
    gl.country AS country
FROM employee e
LEFT JOIN job_title j ON e.j_id = j.j_id
LEFT JOIN department d ON e.d_id = d.d_id
LEFT JOIN headquarters hq ON d.hid = hq.h_id
LEFT JOIN geo_location gl ON hq.l_id = gl.l_id;


-- view 2: project overview w/ customer and location info
-- useful for management to keep track of all active projects & their clients
CREATE OR REPLACE VIEW view_project_overview AS
SELECT
    p.p_id,
    p.project_name,
    p.budget,
    p.commission_percentage,
    p.p_start_date,
    p.p_end_date,
    c.c_name AS customer_name,
    c.c_type AS customer_type,
    gl.city AS customer_city,
    gl.country AS customer_country
FROM project p
LEFT JOIN customer c ON p.c_id = c.c_id
LEFT JOIN geo_location gl ON c.l_id = gl.l_id;


-- view 3: employee skills w/ their salary benefits
-- useful for management to see the skills of employees and if certain skills correlate to salary benefit
CREATE OR REPLACE VIEW view_employee_skills AS
SELECT
    e.e_id,
    e.emp_name,
    e.salary,
    s.skill,
    s.salary_benefit,
    s.salary_benefit_value
FROM employee e
INNER JOIN employee_skills es ON e.e_id = es.e_id
INNER JOIN skills s ON es.s_id = s.s_id;


-- view 4: shows which employees work on which projects
-- useful for management to see a project team assignments
CREATE OR REPLACE VIEW view_project_staffing AS
SELECT
    p.p_id,
    p.project_name,
    p.budget,
    e.e_id,
    e.emp_name,
    e.email,
    j.title AS job_title,
    pr.prole_start_date
FROM project_role pr
INNER JOIN project p ON pr.p_id = p.p_id
INNER JOIN employee e ON pr.e_id = e.e_id
LEFT JOIN job_title j ON e.j_id = j.j_id;
