
-- =========================================
-- INITIAL QUERY: Retrieve all bookings with user, property, and payment details
-- =========================================

SELECT 
    bookings.id AS booking_id,
    users.name AS user_name,
    users.email AS user_email,
    properties.name AS property_name,
    properties.location AS property_location,
    payments.amount AS payment_amount,
    payments.status AS payment_status,
    bookings.created_at AS booking_date
FROM bookings
JOIN users ON bookings.user_id = users.id
JOIN properties ON bookings.property_id = properties.id
JOIN payments ON bookings.payment_id = payments.id;

-- =========================================
-- EXPLAIN ANALYSIS OF INITIAL QUERY
-- =========================================
EXPLAIN
SELECT 
    bookings.id AS booking_id,
    users.name,
    properties.name,
    payments.amount
FROM bookings
JOIN users ON bookings.user_id = users.id
JOIN properties ON bookings.property_id = properties.id
JOIN payments ON bookings.payment_id = payments.id;

-- =========================================
-- OPTIMIZED QUERY (After performance analysis)
-- =========================================

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
