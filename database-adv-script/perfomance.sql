-- =========================================
-- Original Query (Before Optimization)
-- =========================================
-- Retrieves all bookings along with user, property, and payment details
-- This query is functional but not performance-optimized
EXPLAIN
SELECT 
    b.id AS booking_id,
    u.name AS user_name,
    u.email AS user_email,
    p.name AS property_name,
    p.location AS property_location,
    pay.amount AS payment_amount,
    pay.status AS payment_status,
    b.created_at AS booking_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.payment_id = pay.id;

-- =========================================
-- Optimized Query (After Analysis)
-- =========================================
-- Optimizations:
-- 1. Selected only necessary columns
-- 2. Used INNER JOINs only where needed
-- 3. Applied indexing on user_id, property_id, and payment_id
-- 4. Ensured filters for recent data retrieval using WHERE clause
EXPLAIN
SELECT 
    b.id AS booking_id,
    u.name AS user_name,
    p.name AS property_name,
    pay.amount,
    pay.status
FROM bookings b
INNER JOIN users u ON b.user_id = u.id
INNER JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.payment_id = pay.id
WHERE b.created_at >= NOW() - INTERVAL '6 months';
