DROP TABLE tickets;
DROP TABLE customers;
DROP TABLE screenings;
DROP TABLE films;

CREATE TABLE films(
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255),
  price INT
);

CREATE TABLE screenings(
  id SERIAL4 PRIMARY KEY,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  screening_time TIMESTAMP,
  seats INT
);

CREATE TABLE customers(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT
);

CREATE TABLE tickets(
  id SERIAL4 PRIMARY KEY,
  screening_id INT REFERENCES screenings(id) ON DELETE CASCADE,
  customer_id INT REFERENCES customers(id) ON DELETE CASCADE
);
