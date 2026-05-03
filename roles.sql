-- fifth req

-- admin w/ administrative rights (superuser)
DO $$ BEGIN
    CREATE ROLE admin WITH SUPERUSER LOGIN PASSWORD 'admin_password';
    EXCEPTION WHEN duplicate_object THEN
        RAISE NOTICE 'Role "admin" already exists, skipping.';
END $$;


-- employee rights to read info, no write access
DO $$ BEGIN
    CREATE ROLE employee WITH LOGIN PASSWORD 'employee_password';
    EXCEPTION WHEN duplicate_object THEN
        RAISE NOTICE 'Role "employee" already exists, skipping.';
END $$;

GRANT CONNECT ON DATABASE dbsm_projectdb TO employee;
GRANT USAGE ON SCHEMA public TO employee;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO employee;


-- trainee read access only to specific tables,
-- and limited access to employee table (only e_id, emp_name, email)
DO $$ BEGIN
    CREATE ROLE trainee WITH LOGIN PASSWORD 'trainee_password';
    EXCEPTION WHEN duplicate_object THEN
        RAISE NOTICE 'Role "trainee" already exists, skipping.';
END $$;

GRANT CONNECT ON DATABASE dbsm_projectdb TO trainee;
GRANT USAGE ON SCHEMA public TO trainee;

GRANT SELECT ON project TO trainee;
GRANT SELECT ON customer TO trainee;
GRANT SELECT ON geo_location TO trainee;
GRANT SELECT ON project_role TO trainee;
GRANT SELECT (e_id, emp_name, email) ON employee TO trainee;