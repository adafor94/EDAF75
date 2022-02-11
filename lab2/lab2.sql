-- Delete the tables if they exist.
-- Disable foreign key checks, so the tables can
-- be dropped in arbitrary order.
PRAGMA foreign_keys=OFF;

DROP TABLE IF EXISTS theaters;
DROP TABLE IF EXISTS performances;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS movies;

PRAGMA foreign_keys=ON;

-- Create the tables.
CREATE TABLE theaters (
  theater_name TEXT,
  capacity INT,
  PRIMARY KEY (theater_name)
);

CREATE TABLE performances (
  time TIME,
  date DATE,
  title TEXT,
  production_year TEXT,
  theater_name TEXT,
  FOREIGN KEY (theater_name) REFERENCES theaters(theater_name),
  FOREIGN KEY (title, production_year) REFERENCES movies(title, production_year)
  PRIMARY KEY (theater_name, time, date)
);

CREATE TABLE movies (
  title TEXT,
  production_year INT,
  IMDB_key TEXT,
  run_time INT,
  PRIMARY KEY (title, production_year)
);

CREATE TABLE tickets (
  id TEXT DEFAULT (lower(hex(randomblob(16)))),
  theater_name TEXT,
  time TIME,
  date DATE,
  username TEXT,
  FOREIGN KEY (username) REFERENCES customers(username),
  FOREIGN KEY (theater_name, time, date) REFERENCES performances(theater_name, time, date)
  PRIMARY KEY (id)
);

CREATE TABLE customers (
  username TEXT,
  first_name TEXT,
  last_name TEXT,
  pass TEXT,
  PRIMARY KEY (username)
);

-- Insert data into the tables.

INSERT
INTO    theaters(theater_name, capacity)
VALUES  ('Kino', 100),
        ('SF Lund', 200),
        ('SF Malmö', 150);

INSERT
INTO    movies(title, production_year, IMDB_key, run_time)
VALUES  ('Licorice Pizza', 2021, 'tt11271038', 133),
        ('Killers of the Flower Moon', 2022, 'tt5537002', 120),
        ('The French Dispatch', 2021, 'tt8847712', 107);

INSERT 
INTO    performances(time, date, title, production_year, theater_name)
VALUES  ('19:00', '2022-03-01', 'Licorice Pizza', 2021, 'Kino'),
        ('19:00', '2022-03-02', 'Licorice Pizza', 2021, 'Kino'), 
        ('19:00', '2022-03-03', 'Licorice Pizza', 2021, 'Kino'),
        ('18:00', '2022-03-01', 'Killers of the Flower Moon', 2022, 'SF Lund'),
        ('20:00', '2022-03-05', 'The French Dispatch', 2021, 'SF Lund'),
        ('21:00', '2022-03-08', 'Killers of the Flower Moon', 2022, 'SF Malmö');

INSERT
INTO    customers(username, first_name, last_name, pass)
VALUES  ('alice123', 'Alice', 'Aliceson', 'password12'),
        ('bob123', 'Bob', 'Bobson', 'password12');

