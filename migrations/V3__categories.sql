-- Self-referencing category tree
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name TEXT,
    parent_id INT REFERENCES categories(id)
);

INSERT INTO categories (name, parent_id) VALUES
('Electronics', NULL),
('Computers', 1),
('Laptops', 2),
('Phones', 1)
ON CONFLICT DO NOTHING;