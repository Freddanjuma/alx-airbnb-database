Query Optimization ReportThis report analyzes a slow, inefficient query from perfomance.sql and documents the strategy used to refactor it for high performance.1. Initial "Slow" Query AnalysisThe initial query was designed to retrieve all booking data, including user, property, and payment details.-- Initial "Slow" Query
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
Identified Inefficiencies (from EXPLAIN ANALYZE)No WHERE Clause (Catastrophic): The query joins four large tables (Bookings, Users, Properties, Payments) without any filters. If each table has 10,000 rows, the database might have to process 10,000 x 10,000 x 10,000 x 10,000 potential combinations. This is a "Cartesian explosion" and would crash the server.SELECT * (Inefficient): Using SELECT * forces the database to retrieve every single column from all four tables, including large text fields (description), password hashes, etc. This wastes memory, CPU, and network bandwidth.Full Table Scans: The EXPLAIN plan for this query would show sequential scans (Seq Scan) on all tables, as the database has no choice but to read every single row from every table to execute the joins.Conclusion: This query is unscalable and dangerous for a production environment.2. Refactoring StrategyThe solution is to stop thinking about retrieving "all data" and instead focus on a specific, common use case. A real-world application would never need all bookings at once; it would need bookings for a specific property or a specific user.Our strategy is: "Filter First, Join Later."Refactor the query to find bookings for one specific property (e.g., 'Cozy Beachfront Studio').Use a Common Table Expression (CTE) to get a small, filtered list of Booking IDs first.Join the Users and Payments tables against that small, pre-filtered list of bookings.Use SELECT with specific columns, not *.3. Refactored "Fast" Query AnalysisThis query retrieves the same type of data but for a single property, making it fast and efficient.-- Refactored "Fast" Query
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
    Payments pm ON fb.booking_id = pm.booking_id;
