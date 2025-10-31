-- This file contains queries demonstrating different types of SQL JOINs
-- for the alx-airbnb-database project.

-- Note: Table names (Users, Bookings, Properties, Reviews) and column names
-- (user_id, property_id, etc.) are assumed based on standard practice.

--
-- 1. INNER JOIN
--
-- Objective: Retrieve all bookings and the respective users who made them.
--
-- This query selects only the rows where a booking has a matching user.
-- If a booking had no user_id (orphaned data), it would not be included.
--
SELECT
    b.booking_id,
    b.check_in_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM
    Bookings b
INNER JOIN
    Users u ON b.user_id = u.user_id;


--
-- 2. LEFT JOIN
--
-- Objective: Retrieve all properties and their reviews,
-- including properties that have no reviews.
--
-- This query lists EVERY property from the 'Properties' table (the LEFT table).
-- If a property has reviews, the review details (rating, comment) will be shown.
-- If a property has NO reviews, it will still be listed, but the
-- review columns (r.rating, r.comment) will be NULL.
--
SELECT
    p.property_id,
    p.title,
    p.location,
    r.rating,
    r.comment
FROM
    Properties p
LEFT JOIN
    Reviews r ON p.property_id = r.property_id
ORDER BY
    p.title, r.rating DESC;


--
-- 3. FULL OUTER JOIN
--
-- Objective: Retrieve all users and all bookings, even if the user has
-- no booking or a booking is not linked to a user.
--
-- This query is useful for data auditing. It returns:
--   1. Users who have made bookings (all columns filled).
--   2. Users who have NOT made any bookings (booking columns will be NULL).
--   3. Bookings that are NOT linked to any user (user columns will be NULL).
--
-- Note: MySQL does not support FULL OUTER JOIN. You would emulate it using:
-- (SELECT ... FROM Users LEFT JOIN Bookings ...)
-- UNION
-- (SELECT ... FROM Users RIGHT JOIN Bookings ...)
--
-- This query is written in standard SQL (PostgreSQL/SQL Server).
--
SELECT
    u.user_id,
    u.first_name,
    u.email,
    b.booking_id,
    b.check_in_date,
    b.total_price
FROM
    Users u
FULL OUTER JOIN
    Bookings b ON u.user_id = b.user_id;


