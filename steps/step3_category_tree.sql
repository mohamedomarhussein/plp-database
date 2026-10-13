-- ============================================================
-- Step 3: Model a Category Tree
-- ============================================================

-- 1. Create the self-referencing categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT,
    parent_id INT REFERENCES categories(id)
);

-- 2. Insert sample data (tree structure)
INSERT INTO categories (name, parent_id) VALUES
('Electronics', NULL),
('Computers', 1),
('Laptops', 2),
('Phones', 1);

-- 3. Walk the tree with a recursive CTE
WITH RECURSIVE tree AS (
    -- Anchor: root nodes (no parent)
    SELECT id, name, parent_id, 0 AS depth
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive: children of nodes already in the tree
    SELECT c.id, c.name, c.parent_id, t.depth + 1
    FROM categories c
    JOIN tree t ON c.parent_id = t.id
)
SELECT repeat('  ', depth) || name AS tree
FROM tree
ORDER BY depth, name;
