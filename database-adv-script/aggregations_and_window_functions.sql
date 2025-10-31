-- aggregations_and_window_functions.sql
-- 1) Aggregation: total number of bookings made by each user
SELECT 
    u.id       AS user_id,
    u.name     AS user_name,
    COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC;

-- 2) Window function: rank properties using ROW_NUMBER() (unique rank per property)
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    COUNT(b.id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.id) DESC) AS row_number_rank
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY row_number_rank;

-- 3) Window function: rank properties using RANK() (ties share same rank)
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    COUNT(b.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.id) DESC) AS rank_rank
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY rank_rank;
