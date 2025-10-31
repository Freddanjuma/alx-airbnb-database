# SQL Joins — Airbnb Database

This task demonstrates the use of SQL joins to combine data across multiple related tables.

## 1️⃣ INNER JOIN
**Query:** Retrieves all bookings and the respective users who made them.  
**Use Case:** Display all user bookings on a dashboard.

## 2️⃣ LEFT JOIN
**Query:** Retrieves all properties and their reviews, including those without reviews.  
**Use Case:** Show all Airbnb listings, even those not reviewed yet.

## 3️⃣ FULL OUTER JOIN
**Query:** Retrieves all users and all bookings, even if there’s no relationship between them.  
**Use Case:** Data audits and consistency checks.

### Example Tables
- **users** → id, name, email  
- **bookings** → id, user_id, property_id, check_in_date, check_out_date  
- **properties** → id, name, location  
- **reviews** → id, property_id, rating, comment

### 💡 Notes
- Use `FULL OUTER JOIN` only if your SQL engine supports it.  
  If using MySQL, replace it with a `UNION` of `LEFT JOIN` and `RIGHT JOIN`.


# Aggregations and Window Functions

This directory contains SQL examples that demonstrate aggregations and window functions used to analyze bookings and properties.

## Files
- `aggregations_and_window_functions.sql` — SQL queries:
  1. Aggregation: total number of bookings per user using `COUNT()` and `GROUP BY`.
  2. Window function using `ROW_NUMBER()` to assign a unique rank to properties ordered by number of bookings.
  3. Window function using `RANK()` to assign a rank to properties; properties with equal booking counts share the same rank.

## Purpose
- **Aggregation** (COUNT / GROUP BY) is used to summarize data (e.g., total bookings per user).
- **ROW_NUMBER()** gives a deterministic unique ordering (1,2,3...) useful when you need a strict ordinal position.
- **RANK()** gives tied ranks for equal values (e.g., two properties both with 10 bookings will share rank 1, the next gets rank 3).

## Example usage
- Use the aggregation query to build user analytics (e.g., most active users).
- Use `ROW_NUMBER()` when assigning unique positions (e.g., leaderboard).
- Use `RANK()` when ties should have equal standing (e.g., top properties by bookings).


# Aggregations and Window Functions

This directory contains SQL examples that demonstrate aggregations and window functions used to analyze bookings and properties.

## Files
- `aggregations_and_window_functions.sql` — SQL queries:
  1. Aggregation: total number of bookings per user using `COUNT()` and `GROUP BY`.
  2. Window function using `ROW_NUMBER()` to assign a unique rank to properties ordered by number of bookings.
  3. Window function using `RANK()` to assign a rank to properties; properties with equal booking counts share the same rank.

## Purpose
- **Aggregation** (COUNT / GROUP BY) is used to summarize data (e.g., total bookings per user).
- **ROW_NUMBER()** gives a deterministic unique ordering (1,2,3...) useful when you need a strict ordinal position.
- **RANK()** gives tied ranks for equal values (e.g., two properties both with 10 bookings will share rank 1, the next gets rank 3).

## Example usage
- Use the aggregation query to build user analytics (e.g., most active users).
- Use `ROW_NUMBER()` when assigning unique positions (e.g., leaderboard).
- Use `RANK()` when ties should have equal standing (e.g  top properties by bookings).

### ✅ Author
Fred Danjuma — Backend Developer in Training
