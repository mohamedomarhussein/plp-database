-- ============================================================
-- Step 1: Build a Reusable Audit Log
-- ============================================================

-- 1. Create the audit_log table
CREATE TABLE audit_log (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tbl TEXT,
    op TEXT,
    old_row JSONB,
    new_row JSONB,
    changed_by TEXT DEFAULT current_user,
    at TIMESTAMPTZ DEFAULT now()
);

-- 2. Create the trigger function that records changes as JSON
CREATE OR REPLACE FUNCTION audit() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log(tbl, op, old_row, new_row)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- 3. Attach the trigger to the students table
CREATE TRIGGER trg_audit
AFTER INSERT OR UPDATE OR DELETE
ON students
FOR EACH ROW
EXECUTE FUNCTION audit();

-- 4. Sanity check: the trigger should now be registered
SELECT tgname, tgrelid::regclass AS table_name, tgenabled
FROM pg_trigger
WHERE tgname = 'trg_audit';
