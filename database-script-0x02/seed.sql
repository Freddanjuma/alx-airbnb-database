-- seed.sql
-- Airbnb Database Sample Data
-- Populates the tables with realistic sample entries

-- Users
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
  ('uuid-001', 'John', 'Doe', 'john@example.com', 'hashed_password1', '1234567890', 'guest', NOW()),
  ('uuid-002', 'Mary', 'Smith', 'mary@example.com', 'hashed_password2', '0987654321', 'host', NOW()),
  ('uuid-003', 'Admin', 'User', 'admin@example.com', 'hashed_password3', '1112223333', 'admin', NOW());

-- Properties
INSERT INTO property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES
  ('prop-001', 'uuid-002', 'Ocean View Apartment', 'A cozy apartment with a sea view', 'Accra, Ghana', 120.00, NOW(), NOW()),
  ('prop-002', 'uuid-002', 'Mountain Retreat Cabin', 'Beautiful cabin in the mountains', 'Kumasi, Ghana', 200.00, NOW(), NOW());

-- Bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES
  ('book-001', 'prop-001', 'uuid-001', '2025-11-01', '2025-11-05', 480.00, 'confirmed', NOW()),
  ('book-002', 'prop-002', 'uuid-001', '2025-12-10', '2025-12-15', 1000.00, 'pending', NOW());

-- Payments
INSERT INTO payment (payment_id, booking_id, amount, payment_date, payment_method)
VALUES
  ('pay-001', 'book-001', 480.00, NOW(), 'credit_card'),
  ('pay-002', 'book-002', 1000.00, NOW(), 'paypal');

-- Reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at)
VALUES
  ('rev-001', 'prop-001', 'uuid-001', 5, 'Amazing experience, would stay again!', NOW()),
  ('rev-002', 'prop-002', 'uuid-001', 4, 'Very nice, but a bit cold at night.', NOW());

-- Messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES
  ('msg-001', 'uuid-001', 'uuid-002', 'Hi Mary, is your cabin available in December?', NOW()),
  ('msg-002', 'uuid-002', 'uuid-001', 'Yes, it is available. Would you like to book?', NOW());
