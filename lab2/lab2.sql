-- Delete the tables if they exist.
-- Disable foreign key checks, so the tables can
-- be dropped in arbitrary order.
PRAGMA foreign_keys=OFF;

DROP TABLE IF EXISTS theaters;
DROP TABLE IF EXISTS performances;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;

PRAGMA foreign_keys=ON;

-- Create the tables.
CREATE TABLE theaters (
  theater_name TEXT,
  capacity INT,
  PRIMARY KEY (theater_name)
);

CREATE TABLE performances (
  start_time TEXT,
  title TEXT,
  production_year INT,
  IMDB_key TEXT,
  run_time INT,
  theater_name TEXT,
  FOREIGN KEY (theater_name) REFERENCES theaters(theater_name),
  PRIMARY KEY (theater_name, start_time, title, production_year)
);

CREATE TABLE tickets (
  id TEXT DEFAULT (lower(hex(randomblob(16)))),
 -- performance ???,
  user_name TEXT,
  FOREIGN KEY (user_name) REFERENCES customers(user_name),
  PRIMARY KEY (id)
);

CREATE TABLE customers (
  user_name TEXT,
  first_name TEXT,
  last_name TEXT,
  pass TEXT,
  PRIMARY KEY (user_name)
);

-- Insert data into the tables.

INSERT
INTO    theaters(theater_name, capacity)
VALUES  ('Kino', 100);

INSERT
INTO    performances(start_time, title, production_year, IMDB_key, run_time, theater_name)
VALUES  ('12.00', 'film1', '2022', 'randomimdbkey', 120, 'Kino');

INSERT
INTO    customers(user_name, first_name, last_name, pass)
VALUES  ('test12', 'Amy', 'Amyson', 'password12');


INSERT
INTO    tickets(user_name)
VALUES  ('test12');
