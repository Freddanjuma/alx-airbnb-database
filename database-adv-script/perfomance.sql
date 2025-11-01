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
