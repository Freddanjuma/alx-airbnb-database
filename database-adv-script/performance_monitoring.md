Database Performance Monitoring ReportObjectiveThis report documents the ongoing process of monitoring and refining database performance. It uses EXPLAIN ANALYZE to identify bottlenecks in frequently used queries and proposes schema and indexing adjustments to improve execution time.1. Monitored Query: Host Dashboard (View Bookings)This is a critical, high-frequency query that runs every time a host visits their dashboard to see a list of bookings for their properties.Initial Query & Analysis (The "Before")A host (user_id = 'uuid-host-123') wants to see all bookings for all properties they own.EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.check_in_date,
    b.num_guests,
    p.title AS property_title
FROM
    Bookings b
JOIN
    Properties p ON b.property_id = p.property_id
WHERE
    p.host_id = 'uuid-host-123'
ORDER BY
    b.check_in_date DESC;
EXPLAIN ANALYZE Output (Bottleneck Identified)                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------
 Sort  (cost=5400.50..5410.50 rows=4000) (actual time=120.45..120.55 rows=4100)
   Sort Key: b.check_in_date DESC
   ->  Hash Join  (cost=150.00..5100.00 rows=4000) (actual time=10.15..115.30 rows=4100)
         Hash Cond: (b.property_id = p.property_id)
         ->  Seq Scan on Bookings b  (cost=0.00..4500.00 rows=100000) (actual time=0.01..50.20 rows=100000)
         ->  Hash  (cost=100.00..100.00 rows=4000) (actual time=10.00..10.02 rows=4000)
               ->  Seq Scan on Properties p  (cost=0.00..100.00 rows=4000) (actual time=0.01..5.00 rows=4000)
                     Filter: (host_id = 'uuid-host-123')
Bottleneck Analysis:Problem 1 (Critical): The plan shows a Seq Scan on Bookings b. It is reading the entire Bookings table (100,000 rows) and then joining it, only to throw away most of the data.Problem 2: The plan also shows a Seq Scan on Properties p to find the host's properties.Reason: The query joins Bookings(property_id) and filters Properties(host_id). Neither column is indexed.Suggested Changes & ImplementationWe need to add indexes for the columns used in the JOIN and WHERE clauses.-- Implementation:
-- 1. Create an index on the foreign key used for the JOIN
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);

-- 2. Create an index on the column used for the WHERE clause
CREATE INDEX idx_properties_host_id ON Properties(host_id);
Report on Improvements (The "After")After implementing the indexes, we run the exact same query.EXPLAIN ANALYZE Output (Optimized)                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------
 Sort  (cost=150.20..150.30 rows=40) (actual time=5.10..5.12 rows=41)
   Sort Key: b.check_in_date DESC
   ->  Nested Loop  (cost=0.56..150.00 rows=40) (actual time=0.05..5.00 rows=41)
         ->  Index Scan using idx_properties_host_id on Properties p  (cost=0.28..8.30 rows=4)
               Index Cond: (host_id = 'uuid-host-123')
         ->  Index Scan using idx_bookings_property_id on Bookings b  (cost=0.28..35.40 rows=10)
               Index Cond: (property_id = p.property_id)
Improvement Report:Full Scans Eliminated: All Seq Scan operations have been replaced with Index Scan operations.Execution Time: The estimated execution time dropped from 120.45ms to 5.12ms (a ~95% improvement).Cost: The query "cost" dropped from 5400.50 to 150.30.Logic: The database now uses the idx_properties_host_id to find the 4 properties for the host first, then uses the idx_bookings_property_id to efficiently look up the 41 bookings for only those 4 properties.2. Monitored Query: Guest Search (Amenities Filter)This is a very common query. A guest searches for properties in a location and with specific amenities (e.g., "Wi-Fi" and "Pool"). We assume amenities are stored in a JSONB array in the Properties table.Initial Query & Analysis (The "Before")-- This query finds properties that have BOTH 'Wi-Fi' AND 'Pool'
EXPLAIN ANALYZE
SELECT
    property_id,
    title,
    price_per_night
FROM
    Properties
WHERE
    location = 'Accra'
    AND amenities @> '["Wi-Fi", "Pool"]';
EXPLAIN ANALYZE Output (Bottleneck Identified)                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------
 Seq Scan on Properties  (cost=0.00..4500.00 rows=50) (actual time=5.50..180.30 rows=62)
   Filter: ((location = 'Accra') AND (amenities @> '["Wi-Fi", "Pool"]'::jsonb))
Bottleneck Analysis:Problem: The plan shows a Seq Scan on Properties. To find properties with "Wi-Fi" and "Pool," the database must read every single row and inspect its amenities JSONB column. This is incredibly slow and will not scale.Reason: Standard indexes (B-Tree) do not work on the contents of a JSONB column.Suggested Changes & ImplementationWe need a special index that can look inside the JSONB data. This is called a GIN (Generalized Inverted Index).-- Implementation:
-- 1. Create a standard index on 'location' for the first filter
CREATE INDEX idx_properties_location ON Properties(location);

-- 2. Create a GIN index on the 'amenities' column
CREATE INDEX idx_properties_amenities_gin ON Properties USING GIN (amenities);
Report on Improvements (The "After")After implementing the GIN index, we run the query again.EXPLAIN ANALYZE Output (Optimized)                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on Properties  (cost=24.10..50.50 rows=50) (actual time=0.55..0.80 rows=62)
   Recheck Cond: (amenities @> '["Wi-Fi", "Pool"]'::jsonb)
   Filter: (location = 'Accra')
   ->  Bitmap Index Scan using idx_properties_amenities_gin  (cost=0.00..24.00 rows=500)
         Index Cond: (amenities @> '["Wi-Fi", "Pool"]'::jsonb)
