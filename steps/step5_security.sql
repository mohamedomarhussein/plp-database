-- ============================================================
-- Step 5: Apply Least-Privilege Security
-- ============================================================

-- 1. Create read-only and read-write roles
CREATE ROLE app_read;
CREATE ROLE app_write;

-- 2. Grant connection and schema usage
GRANT CONNECT ON DATABASE bootcamp TO app_read, app_write;
GRANT USAGE ON SCHEMA public TO app_read, app_write;

-- 3. Read-only role: SELECT only
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;

-- 4. Read-write role: SELECT, INSERT, UPDATE, DELETE
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public TO app_write;

-- 5. Create the API user (uses app_write role)
CREATE USER api
LOGIN PASSWORD 'strong-secret'
IN ROLE app_write;

-- ============================================================
-- Verification: prove least-privilege is enforced
-- ============================================================

-- Should SUCCEED (app_read can SELECT)
SET ROLE app_read;
SELECT * FROM students LIMIT 1;

-- Should FAIL (app_read cannot INSERT)
INSERT INTO students (name) VALUES ('Test');

-- Reset back to superuser
RESET ROLE;
