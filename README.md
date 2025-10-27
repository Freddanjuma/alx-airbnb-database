# alx-airbnb-database# Database Schema - Airbnb Clone

## Overview
This directory contains the SQL scripts defining the schema for the Airbnb Clone project.  
It includes table definitions, constraints, and indexes to ensure efficient data storage and retrieval.

## Files
- **schema.sql** – Contains the SQL `CREATE TABLE` statements for all entities.

## Tables
1. **Users** – Stores information about guests, hosts, and admins.
2. **Properties** – Stores property listings created by hosts.
3. **Bookings** – Handles reservations made by users.
4. **Payments** – Records all payment transactions.
5. **Reviews** – Stores user reviews and ratings for properties.
6. **Messages** – Manages direct communication between users.

## Constraints
- Foreign key constraints maintain data integrity.
- `CHECK` constraints validate field values.
- Indexes are added for faster queries.

## How to Use
To initialize the database schema, run the following command inside your SQL environment:
```sql
SOURCE database-script-0x01/schema.sql;


# Database Script 0x02 — Seed Data

This script populates the Airbnb database with realistic sample data for testing.

## Files
- **seed.sql** — Contains SQL `INSERT` statements for all entities (Users, Properties, Bookings, Payments, Reviews, and Messages).

## Description
The sample data simulates real-world usage:
- Multiple users (guests, hosts, admin)
- Properties listed by hosts
- Bookings made by guests
- Payments processed
- Reviews left by guests
- Messages exchanged between users
