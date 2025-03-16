CREATE VIEW rental_summary AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE TEMPORARY TABLE payment_summary AS
SELECT c.customer_id, SUM(p.amount) AS total_paid
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

WITH customer_summary AS (
    SELECT rs.customer_id, rs.first_name, rs.last_name, rs.email, rs.rental_count, ps.total_paid
    FROM rental_summary rs
    LEFT JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)
SELECT customer_id, first_name, last_name, email, rental_count, total_paid,
       (total_paid / NULLIF(rental_count, 0)) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;
