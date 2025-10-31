-- database_index.sql
-- Objective: Create indexes to improve query performance for high-usage columns

-- 1. User Table: Index on email for faster authentication lookups
CREATE INDEX idx_users_email ON users(email);

-- 2. Booking Table: Index on user_id and property_id for frequent JOIN operations
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- 3. Property Table: Index on city and price for search filtering and sorting
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_price ON properties(price);

-- 4. Performance Measurement
-- Before adding indexes: run EXPLAIN or EXPLAIN ANALYZE to see query cost
-- Example:
-- EXPLAIN ANALYZE SELECT * FROM bookings WHERE user_id = 15;

-- After adding indexes: re-run EXPLAIN ANALYZE and compare execution time.
-- You should see a reduced cost or faster runtime.
