# Query Optimization Report

## Objective
To analyze and optimize a SQL query that retrieves all bookings along with user, property, and payment details. The goal is to reduce execution time and improve database performance.

---

## Step 1: Initial Query Analysis
**Command used:**
```sql
EXPLAIN SELECT b.id, u.name, u.email, p.name, pay.amount
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.payment_id = pay.id;
