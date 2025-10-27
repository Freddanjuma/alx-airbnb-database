# Airbnb Database Entity-Relationship Diagram (ERD)

This document describes the database design for the **Airbnb Clone Project**.  
It includes the key entities, their attributes, and how they are related.

---

## 🧩 ER Diagram

The diagram below illustrates how all entities are connected within the system.

> 📌 **Note:** Ensure you’ve exported your ERD image from Draw.io and saved it in this folder as `airbnb_ERD.png`.

![Airbnb ER Diagram](./airbnb_ERD.png)

---

## 🧱 Entities and Attributes

### 1. **User**
Represents the users of the platform, including guests, hosts, and admins.

| Field | Type | Description |
|-------|------|--------------|
| user_id | UUID (PK) | Unique identifier for each user |
| first_name | VARCHAR | User's first name |
| last_name | VARCHAR | User's last name |
| email | VARCHAR (unique) | User’s email address |
| password_hash | VARCHAR | Hashed password for authentication |
| phone_number | VARCHAR | Optional contact number |
| role | ENUM (guest, host, admin) | Defines user role |
| created_at | TIMESTAMP | Account creation date |

---

### 2. **Property**
Represents a rental property listed by a host.

| Field | Type | Description |
|-------|------|-------------|
| property_id | UUID (PK) | Unique property identifier |
| host_id | UUID (FK → User.user_id) | Host who owns the property |
| name | VARCHAR | Property name |
| description | TEXT | Description of the property |
| location | VARCHAR | Property address or area |
| price_per_night | DECIMAL | Cost per night |
| created_at | TIMESTAMP | Creation date |
| updated_at | TIMESTAMP | Last updated time |

---

### 3. **Booking**
Tracks reservations made by users for specific properties.

| Field | Type | Description |
|-------|------|-------------|
| booking_id | UUID (PK) | Unique booking ID |
| property_id | UUID (FK → Property.property_id) | Property being booked |
| user_id | UUID (FK → User.user_id) | User who made the booking |
| start_date | DATE | Booking start date |
| end_date | DATE | Booking end date |
| total_price | DECIMAL | Total cost for the stay |
| status | ENUM (pending, confirmed, canceled) | Booking status |
| created_at | TIMESTAMP | When booking was created |

---

### 4. **Payment**
Stores payment details related to bookings.

| Field | Type | Description |
|-------|------|-------------|
| payment_id | UUID (PK) | Unique payment ID |
| booking_id | UUID (FK → Booking.booking_id) | Associated booking |
| amount | DECIMAL | Amount paid |
| payment_date | TIMESTAMP | Date of payment |
| payment_method | ENUM (credit_card, paypal, stripe) | Method used for payment |

---

### 5. **Review**
Captures guest reviews and ratings for properties.

| Field | Type | Description |
|-------|------|-------------|
| review_id | UUID (PK) | Unique review ID |
| property_id | UUID (FK → Property.property_id) | Reviewed property |
| user_id | UUID (FK → User.user_id) | Reviewer (guest) |
| rating | INTEGER (1–5) | Rating value |
| comment | TEXT | Review text |
| created_at | TIMESTAMP | Review creation date |

---

### 6. **Message**
Stores communication between users (guest ↔ host).

| Field | Type | Description |
|-------|------|-------------|
| message_id | UUID (PK) | Unique message ID |
| sender_id | UUID (FK → User.user_id) | Message sender |
| recipient_id | UUID (FK → User.user_id) | Message receiver |
| message_body | TEXT | Content of the message |
| sent_at | TIMESTAMP | Time message was sent |

---

## 🔗 Relationships Summary

- A **User** (host) can list many **Properties**.  
- A **User** (guest) can make multiple **Bookings**.  
- Each **Booking** belongs to one **Property** and one **User**.  
- Each **Booking** has one **Payment**.  
- A **Property** can have multiple **Reviews**.  
- A **User** can send and receive multiple **Messages**.

---

## ✅ Conclusion

This ERD serves as the foundation for implementing the Airbnb clone’s database.  
It ensures data consistency, proper normalization, and efficient relationships among core entities.

