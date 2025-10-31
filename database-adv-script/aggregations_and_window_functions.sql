-- 1️⃣ Aggregation Query
-- Find the total number of bookings made by each user
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    COUNT(b.id) AS total_bookings
FROM users AS u
LEFT JOIN bookings AS b ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC;

-- Explanation:
-- COUNT(b.id) counts the number of bookings per user.
-- LEFT JOIN ensures users with no bookings are still shown (with 0 count).
-- GROUP BY groups data by user ID and name to calculate totals.


-- 2️⃣ Window Function Query
-- Rank properties based on the total number of bookings
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    COUNT(b.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.id) DESC) AS booking_rank
FROM properties AS p
LEFT JOIN bookings AS b ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY booking_rank;

-- Explanation:
-- COUNT(b.id) aggregates total bookings per property.
-- RANK() OVER() assigns a rank based on total bookings.
-- Properties with equal booking counts receive the same rank.
