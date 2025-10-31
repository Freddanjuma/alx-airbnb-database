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

### ✅ Author
Fred Danjuma — Backend Developer in Training
