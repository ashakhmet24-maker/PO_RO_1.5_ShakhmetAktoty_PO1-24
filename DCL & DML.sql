-- Task 1

-- 1. create role
CREATE ROLE student_role;

-- 2. give SELECT rights
GRANT SELECT ON film TO student_role;
GRANT SELECT ON actor TO student_role;

-- 3. create user
CREATE USER student1 WITH PASSWORD 'pass123';

-- 4. assign role to user
GRANT student_role TO student1;

-- Task 2
SELECT *
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
AND f.rental_rate < 3.00;
-- Update
UPDATE film
SET rental_rate = 3.99
WHERE film_id IN (
    SELECT f.film_id
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
    AND f.rental_rate < 3.00
);

-- Task 3
INSERT INTO film (
    title,
    language_id,
    rental_duration,
    rental_rate,
    replacement_cost,
    rating
)
VALUES (
    'The Matrix Reloaded',
    1,
    7,
    4.99,
    19.99,
    'R'
)
RETURNING film_id, title;

-- Task 4
-- Task 4 (safe delete in one script)

-- 1. Preview
SELECT *
FROM payment
WHERE amount = 0.00;

-- 2. Delete
DELETE FROM payment
WHERE amount = 0.00;

-- 3. Verify
SELECT COUNT(*) AS remaining_zero_payments
FROM payment
WHERE amount = 0.00;