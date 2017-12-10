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
  title VARCHAR(100) NOT NULL,
  previous_episode_id INT REFERENCES films(id) NULL
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
  date timestamp NOT NULL,
  nb_places_max INT2 NOT NULL,
  film_id INT REFERENCES films(id) NOT NULL,
  cinema_id INT REFERENCES cinemas(id) NOT NULL
);

-- Create the table tickets
-- A ticket is linked to 1 customer and 1 screening
CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  price FLOAT NOT NULL,
  customer_id INT REFERENCES customers(id) NOT NULL,
  screening_id INT REFERENCES screenings(id) NOT NULL
);
