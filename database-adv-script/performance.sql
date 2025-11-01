
-- Initial query: Retrieve all bookings along with user, property, and payment details
SELECT 
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location AS property_location,
    pay.id AS payment_id,
    pay.amount AS payment_amount,
    pay.status AS payment_status
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.payment_id = pay.id
WHERE b.total_amount > 0 AND pay.status = 'completed';





-- This file contains an initial complex query and its refactored,
-- optimized version to demonstrate performance improvement.

-- =====================================================================
-- 1. INITIAL "SLOW" QUERY
-- =====================================================================
--
-- Objective: Retrieve all bookings along with user, property, and payment
--            details.
--
-- Problem: This query joins 4 large tables (Bookings, Users, Properties,
-- Payments) *without any filter*. It selects all columns (`*`) and
-- reads all rows from all tables, creating a massive, inefficient
-- result set. This is a "worst-case" query that would
-- likely crash a production server.
--
-- ANALYSIS: The "EXPLAIN ANALYZE" command is used below to show the
-- inefficient query plan.
--
EXPLAIN ANALYZE
SELECT
    *
FROM
    Bookings b
JOIN
    Users u ON b.guest_id = u.user_id
JOIN
    Properties p ON b.property_id = p.property_id
JOIN
    Payments pm ON b.booking_id = pm.booking_id;


-- =====================================================================
-- 2. REFACTORED "FAST" QUERY
-- =====================================================================
--
-- Objective: Get the *same type* of data, but optimized for a
--            specific, common use case (e.g., finding bookings
--            for a specific property).
--
-- ANALYSIS: The "EXPLAIN ANALYZE" command is used again to show the
-- new, faster plan after refactoring.
--
EXPLAIN ANALYZE
WITH FilteredBookings AS (
    -- Step 1: Find the exact bookings we need. We add a filter
    -- (WHERE) here. This query is small and fast.
    SELECT
        b.booking_id,
        b.guest_id,
        b.property_id
    FROM
        Bookings b
    JOIN
        Properties p ON b.property_id = p.property_id
    WHERE
        p.title = 'Cozy Beachfront Studio'
)
-- Step 2: Now, join the other large tables (Users, Payments)
-- against *only* the few IDs we found in the CTE.
SELECT
    fb.booking_id,
    u.first_name,
    u.email,
    p.title AS property_title,
    p.location,
    pm.amount,
    pm.status AS payment_status
FROM
    FilteredBookings fb
JOIN
    Users u ON fb.guest_id = u.user_id
JOIN
    Properties p ON fb.property_id = p.property_id
JOIN
