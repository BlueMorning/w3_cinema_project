DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS cinemas;

-- Create the customers table
-- A customer can buy * tickets
CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  funds FLOAT NOT NULL
);

-- Create the films table
-- A film can be proposed through * screenings
CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(100) NOT NULL
);

-- Create the table cinemas
-- A cinema can propose * screenings
CREATE TABLE cinemas (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL
);

-- Create the table screenings
-- A screening is linked to 1 cinema and 1 movie
CREATE TABLE screenings (
  id SERIAL4 PRIMARY KEY,
  date DATE,
  time TIME,
  nb_places_max INT2,
  film_id INT REFERENCES films(id),
  cinema_id INT REFERENCES cinemas(id)
);

-- Create the table tickets
-- A ticket is linked to 1 customer and 1 screening
CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  price FLOAT,
  customer_id INT REFERENCES customers(id),
  screening_id INT REFERENCES screenings(id)
);
