-- 1️⃣ Non-Correlated Subquery
-- Find all properties where the average rating is greater than 4.0
SELECT p.id, p.name, p.location
FROM properties AS p
WHERE p.id IN (
    SELECT property_id
    FROM reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
);

-- Explanation:
-- The inner subquery calculates the average rating per property.
-- The outer query selects properties whose IDs match those with an average rating > 4.0.


-- 2️⃣ Correlated Subquery
-- Find users who have made more than 3 bookings
SELECT u.id, u.name, u.email
FROM users AS u
WHERE (
    SELECT COUNT(*)
    FROM bookings AS b
    WHERE b.user_id = u.id
) > 3;

-- Explanation:
-- The inner query is executed for each user (correlated with u.id).
-- It counts how many bookings that user made.
-- Only users with more than 3 bookings are returned.
