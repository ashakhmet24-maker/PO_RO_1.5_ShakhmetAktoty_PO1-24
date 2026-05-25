-- CLEANUP (re-runnable script)

DROP USER IF EXISTS db_admin_user;
DROP USER IF EXISTS db_reader_user;

DROP ROLE IF EXISTS schoolapp_admin;
DROP ROLE IF EXISTS schoolapp_readonly;

-- A1 roles

CREATE ROLE schoolapp_admin;
CREATE ROLE schoolapp_readonly;

GRANT USAGE ON SCHEMA public TO schoolapp_admin;
GRANT USAGE ON SCHEMA public TO schoolapp_readonly;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO schoolapp_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO schoolapp_readonly;

-- A2 users

CREATE USER db_admin_user WITH PASSWORD 'admin123';
CREATE USER db_reader_user WITH PASSWORD 'reader123';

GRANT schoolapp_admin TO db_admin_user;
GRANT schoolapp_readonly TO db_reader_user;

-- A3 revoke safety

REVOKE UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM schoolapp_readonly;

-- verify admin
SET ROLE db_admin_user;

SELECT current_user;

SELECT COUNT(*) FROM your_main_table;

-- пример UPDATE
UPDATE your_main_table SET id = id;

RESET ROLE;

-- verify reader
SET ROLE db_reader_user;

SELECT current_user;

SELECT COUNT(*) FROM your_main_table;

-- these should fail (leave as is)
BEGIN;
INSERT INTO your_main_table VALUES (1);
ROLLBACK;

BEGIN;
UPDATE your_main_table SET id = id;
ROLLBACK;

BEGIN;
DELETE FROM your_main_table WHERE id = 1;
ROLLBACK;

RESET ROLE;

-- B5 truncate (order: children → parents)

TRUNCATE TABLE your_child_table CASCADE;
TRUNCATE TABLE your_main_table CASCADE;

-- B6 inserts

INSERT INTO your_main_table (name)
VALUES ('Example 1');

INSERT INTO your_main_table (name)
VALUES ('Example 2');

INSERT INTO your_main_table (name)
VALUES ('Example 3');

INSERT INTO your_main_table (name)
VALUES ('Example 4');

INSERT INTO your_main_table (name)
VALUES ('Example 5');

-- C7 update 1 preview
SELECT * FROM your_main_table WHERE id = 1;

-- business update
UPDATE your_main_table
SET name = 'Updated value'
WHERE id = 1;

-- C7 update 2 preview
SELECT * FROM your_main_table WHERE status = 'old';

UPDATE your_main_table
SET status = 'new'
WHERE status = 'old';

-- C8 preview
SELECT * FROM table1 t
JOIN table2 t2 ON t.id = t2.id;

UPDATE table1 t
SET value = t2.value
FROM table2 t2
WHERE t.id = t2.id;

-- D9 business reason:
-- removing cancelled or obsolete records to keep database clean

BEGIN;

DELETE FROM your_main_table
WHERE status = 'cancelled';

SELECT COUNT(*) FROM your_main_table; -- paste result as comment

ROLLBACK;