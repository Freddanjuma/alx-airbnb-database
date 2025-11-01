Query Optimization ReportThis report analyzes an initial, highly inefficient query and details the refactoring process to optimize it for a real-world use case.1. Initial "Slow" QueryThe QueryThe initial query fulfills the instruction "retrieves all bookings along with the user details, property details, and payment details" in the most literal and inefficient way possible.EXPLAIN ANALYZE
SELECT *
FROM Bookings b
JOIN Users u ON b.guest_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
JOIN Payments pm ON b.booking_id = pm.booking_id;
Performance Analysis (Inefficiencies)The EXPLAIN ANALYZE plan for this query would reveal it is the worst possible query for a database.No Filters: The query has no WHERE clause, forcing the database to join every single row from Bookings with every matching row in Users, Properties, and Payments.Full Table Scans: The database will perform a Sequential Scan (Full Table Scan) on all four tables.Massive Data Generation: The intermediate dataset created by the joins would be enormous, consuming huge amounts of memory and CPU. This is known as a "Cartesian product" problem in its worst form.Use of SELECT *: Selecting all columns (*) forces the database to retrieve every single piece of data (including large description fields, password hashes, etc.), which is slow and wasteful.This query would never be used in a real application as it would time out or crash the database.2. Refactoring StrategyThe goal is to refactor this "get everything" query into a "get something specific" query that is highly optimized. No application ever needs "all bookings and all details" at once. A real use case is "get details for bookings for a specific property."The strategy is to filter first, then join.Isolate the Filter: Create a fast, small query to find only the booking_ids that match our filter (e.g., p.title = 'Cozy Beachfront Studio'). This is done in a Common Table Expression (CTE).Defer Joins: Use the small list of booking_ids from the CTE as the driver for the other joins. This way, we are only joining against the 10-20 rows we actually need.Be Specific: Replace SELECT * with the exact columns required for the application.3. Refactored "Fast" QueryThe QueryThis query is refactored from the "get all" query into a fast, efficient query for a real-world use case.EXPLAIN ANALYZE
WITH FilteredBookings AS (
    -- Step 1: Find the exact bookings we need by ADDING A FILTER.
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
-- Step 2: Now, join against *only* the few IDs we found.
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
    Payments pm ON fb.booking_id = pm.booking_id;
