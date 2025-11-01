-- =========================================
-- STEP 1: Create a new partitioned table
-- =========================================

-- Drop existing partitioned table if any (for testing)
DROP TABLE IF EXISTS bookings_partitioned CASCADE;

-- Create partitioned table (PostgreSQL syntax)
CREATE TABLE bookings_partitioned (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id INT,
    created_at TIMESTAMP DEFAULT NOW()
)
PARTITION BY RANGE (start_date);

-- =========================================
-- STEP 2: Create partitions (monthly basis)
-- =========================================

CREATE TABLE bookings_2025_jan PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE bookings_2025_feb PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

CREATE TABLE bookings_2025_mar PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-03-01') TO ('2025-04-01');

-- You can keep adding partitions dynamically (e.g., each quarter or month)

-- =========================================
-- STEP 3: Test performance before partitioning
-- =========================================

EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE start_date BETWEEN '2025-01-01' AND '2025-02-01';

-- =========================================
-- STEP 4: Test performance after partitioning
-- =========================================

EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE start_date BETWEEN '2025-01-01' AND '2025-02-01';

-- =========================================
-- STEP 5: Verify data insertion to the correct partition
-- =========================================

INSERT INTO bookings_partitioned (user_id, property_id, start_date, end_date, payment_id)
VALUES (1, 10, '2025-01-15', '2025-01-20', 5);

SELECT tableoid::regclass AS partition, *
FROM bookings_partitioned
WHERE user_id = 1;
