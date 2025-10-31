-- This file documents the identification and creation of indexes
-- to optimize query performance for the Airbnb database.
--
-- We will follow a three-step process:
-- 1. Analyze slow queries ("BEFORE").
-- 2. Create indexes for high-usage columns.
-- 3. Analyze the same queries to verify the improvement ("AFTER").
--
-- Note: "EXPLAIN ANALYZE" runs the query and shows the *actual* execution plan
-- and time. "EXPLAIN" just shows the *planned* execution.

-- =====================================================================
-- PART 1: "BEFORE" - ANALYZE SLOW QUERIES
-- =====================================================================
-- Run these commands *before* you create any indexes to see the
-- (presumably) high cost and "Full Table Scan" or "Seq Scan" plans.
--

-- SLOW QUERY 1: Searching for properties by location and price.
-- This is a very common query for users.
EXPLAIN ANALYZE
SELECT
    property_id,
    title,
    location,
    price_per_night
FROM
    Properties
WHERE
    location = 'Accra'
    AND price_per_night < 200
ORDER BY
    price_per_night ASC;

-- EXPECTED "BEFORE" RESULT FOR QUERY 1:
-- The database will likely perform a "Full Table Scan" (or "Seq Scan")
-- on the `Properties` table. It must read *every single row*
-- to find the ones matching 'Accra' and then sort them.
-- This is very slow.


-- SLOW QUERY 2: Finding all bookings for a specific user.
-- This is used in the user's "My Trips" page.
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.check_in_date,
    p.title
FROM
    Bookings b
JOIN
    Properties p ON b.property_id = p.property_id
WHERE
    b.guest_id = 'some-uuid-of-a-guest';

-- EXPECTED "BEFORE" RESULT FOR QUERY 2:
-- The database will perform a "Full Table Scan" on the `Bookings` table,
-- looking for 'some-uuid-of-a-guest' row by row. This is a classic
-- bottleneck in applications.


-- =====================================================================
-- PART 2: CREATE INDEXES
-- =====================================================================
-- Based on our analysis, we identify these high-usage columns.

--
-- On the `Users` table
--
-- Reason: `email` is used in `WHERE` clauses for login.
-- It must be unique, so we add a UNIQUE INDEX.
CREATE UNIQUE INDEX idx_users_email ON Users(email);

--
-- On the `Properties` table
--
-- Reason: `host_id` is a Foreign Key, used in `JOIN`s (to find a
-- host's properties) and `WHERE` clauses.
CREATE INDEX idx_properties_host_id ON Properties(host_id);

-- Reason: `location` and `price_per_night` are the most heavily
-- used columns for searching (`WHERE`) and sorting (`ORDER BY`).
-- We index them separately.
CREATE INDEX idx_properties_location ON Properties(location);
CREATE INDEX idx_properties_price_per_night ON Properties(price_per_night);


--
-- On the `Bookings` table
--
-- Reason: `guest_id` and `property_id` are Foreign Keys used constantly
-- in `JOIN`s and `WHERE` clauses (like our "Slow Query 2").
CREATE INDEX idx_bookings_guest_id ON Bookings(guest_id);
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);

-- Reason (Advanced): For checking availability, we often search by
-- `property_id`, `check_in_date`, and `check_out_date` all at once.
-- A composite index covers this specific, high-usage query.
CREATE INDEX idx_bookings_availability ON Bookings(property_id, check_in_date, check_out_date);


-- =====================================================================
-- PART 3: "AFTER" - VERIFY THE IMPROVEMENT
-- =====================================================================
-- Now, run the *exact same queries* as in Part 1.
-- You will see the query plan has changed dramatically.
--

-- "AFTER" QUERY 1: Searching for properties
EXPLAIN ANALYZE
SELECT
    property_id,
    title,
    location,
    price_per_night
FROM
    Properties
WHERE
    location = 'Accra'
    AND price_per_night < 200
ORDER BY
    price_per_night ASC;

-- EXPECTED "AFTER" RESULT FOR QUERY 1:
-- The database will now use an "Index Scan" (or "Bitmap Scan")
-- using `idx_properties_location` and/or `idx_properties_price_per_night`.
-- The "cost" and execution time should be significantly lower.


-- "AFTER" QUERY 2: Finding all bookings for a specific user.
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.check_in_date,
    p.title
FROM
    Bookings b
JOIN
    Properties p ON b.property_id = p.property_id
WHERE
    b.guest_id = 'some-uuid-of-a-guest';

-- EXPECTED "AFTER" RESULT FOR QUERY 2:
-- The database will now use an "Index Scan" on `idx_bookings_guest_id`
-- to instantly find the user's bookings. The query will be
-- extremely fast, even with millions of bookings.
