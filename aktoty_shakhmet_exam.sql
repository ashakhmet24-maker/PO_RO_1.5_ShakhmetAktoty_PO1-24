-- Easy 1
SELECT
    c.first_name,
    c.last_name,
    ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.city = 'Aurora'
ORDER BY c.last_name ASC;

-- Easy 2
SELECT
    l.name AS language_name,
    COUNT(f.film_id) AS film_count
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY film_count DESC;

-- Easy 3
SELECT
    f.title,
    f.length,
    c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY f.length DESC, f.title
LIMIT 10;

-- Easy 4
SELECT
    store_id,
    COUNT(customer_id) AS customer_count
FROM customer
WHERE activebool = TRUE
GROUP BY store_id
ORDER BY store_id;

-- Medium 1
SELECT
    s.store_id,
    c.city,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
GROUP BY s.store_id, c.city
ORDER BY total_revenue DESC;

-- Medium 2
SELECT
    f.title,
    c.name AS category,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY f.title, c.name
ORDER BY rental_count DESC, f.title
LIMIT 5;

-- Medium 3
SELECT
    ci.city,
    COUNT(p.payment_id) AS payment_count,
    ROUND(AVG(p.amount),2) AS average_amount
FROM payment p
JOIN customer cu ON p.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
HAVING COUNT(p.payment_id) > 50
ORDER BY average_amount DESC;

-- Medium 4
SELECT
    a.first_name || ' ' || a.last_name AS actor_name,
    c.name AS category,
    COUNT(f.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY actor_name, c.name
ORDER BY film_count DESC
LIMIT 10;

-- Medium 5
SELECT
    c.name AS category,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 3;