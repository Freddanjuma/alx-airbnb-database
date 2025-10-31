-- Retrieve all bookings with their respective users
SELECT 
    b.id AS booking_id,
    u.name AS user_name,
    u.email AS user_email,
    b.property_id,
    b.check_in_date,
    b.check_out_date
FROM bookings b
INNER JOIN users u 
    ON b.user_id = u.id;


-- Retrieve all properties with their reviews (if available)
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    r.id AS review_id,
    r.rating,
    r.comment
FROM properties p
LEFT JOIN reviews r 
    ON p.id = r.property_id;


-- Retrieve all users and all bookings (whether linked or not)
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    b.id AS booking_id,
    b.property_id,
    b.check_in_date
FROM users u
FULL OUTER JOIN bookings b 
    ON u.id = b.user_id;


-- Alternative for MySQL (no FULL OUTER JOIN)
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    b.id AS booking_id,
    b.property_id
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id

UNION

SELECT 
    u.id AS user_id,
    u.name AS user_name,
    b.id AS booking_id,
    b.property_id
FROM users u
RIGHT JOIN bookings b ON u.id = b.user_id;


-- Retrieve all properties with their reviews (if available)
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    r.id AS review_id,
    r.rating,
    r.comment
FROM properties p
LEFT JOIN reviews r 
    ON p.id = r.property_id;
