# Company Database – DSM Project

Final course project for Database Systems Management

---

## Project Overview

This project extends an existing PostgreSQL company database with new database features.

The database contains data for a company and covers:

- Employees, departments, job titles
- Customers and projects
- Skills and user groups
- Geographic locations and headquarters

---

## Files Included

```
views.sql          - Four management views
triggers.sql       - Three automated triggers
procedures.sql     - Three stored procedures
roles.sql          - Three access roles (admin, employee, trainee)
db_changes.sql     - Structural changes (new column, NOT NULL and CHECK constraints)
projectdb_final.backup  - PostgreSQL backup of the completed database
Database Systems Management Project Report.pdf     - Project documentation
```

---

## What Was Added

- **Views** – four views combining multiple tables for management use
- **Triggers** – duplicate skill check, auto project staffing, contract date automation
- **Procedures** – set base salaries, extend temporary contracts, percentage salary raise
- **Roles** – admin (superuser), employee (read all), trainee (limited read)
- **Changes** – zip_code column, NOT NULL on email and start date, salary CHECK constraint

---

## How to Use

1. Open pgAdmin and create a new database named `dbsm_projectdb`
2. Restore `projectdb_final.backup` into it (right-click database → Restore)
3. All changes are already included in the backup

To apply changes manually from scratch:
1. Open pgAdmin and create a new database named `dbsm_projectdb`
2. Restore the original course-provided backup
3. Run SQL files in this EXACT order (VERY IMPORTANT):
   - `db_changes.sql`
   - `views.sql`
   - `triggers.sql`
   - `procedures.sql`
   - `roles.sql`

---

## Concepts Applied

- Views with multi-table JOINs
- Triggers (BEFORE INSERT, AFTER INSERT, BEFORE UPDATE)
- Stored procedures with plpgsql
- Role-based access control (GRANT, REVOKE)
- ALTER TABLE (ADD COLUMN, SET NOT NULL, ADD CONSTRAINT)