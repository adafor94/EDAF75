-- Delete the tables if they exist.
-- Disable foreign key checks, so the tables can
-- be dropped in arbitrary order.
PRAGMA foreign_keys=OFF;

DROP TABLE IF EXISTS theaters;
DROP TABLE IF EXISTS performances;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS movies;

PRAGMA foreign_keys=ON;

-- Create the tables.
CREATE TABLE theaters (
  theater_name TEXT,
  capacity INT,
  PRIMARY KEY (theater_name)
);

CREATE TABLE performances (
  performance_id INT DEFAULT (lower(hex(randomblob(16)))),
  time TIME,
  date DATE,
  imdbKey TEXT,
  theater_name TEXT,
  FOREIGN KEY (theater_name) REFERENCES theaters(theater_name),
  FOREIGN KEY (imdbKey) REFERENCES movies(imdbKey)
  PRIMARY KEY (performance_id)
);

CREATE TABLE movies (
  title TEXT,
  year INT,
  imdbKey TEXT,
  PRIMARY KEY (imdbKey)
);

CREATE TABLE tickets (
  ticket_id TEXT DEFAULT (lower(hex(randomblob(16)))),
  performance_id INT,
  username TEXT,
  FOREIGN KEY (username) REFERENCES users(username),
  FOREIGN KEY (performance_id) REFERENCES performances(performance_id)
  PRIMARY KEY (ticket_id)
);

CREATE TABLE users (
  username TEXT,
  fullName TEXT,
  pwd TEXT,
  PRIMARY KEY (username)
);

-- Insert data into the tables.

INSERT
INTO    theaters(theater_name, capacity)
VALUES  ('Kino', 100),
        ('SF Lund', 200),
        ('SF Malmö', 150);

INSERT
INTO    movies(title, year, imdbKey)
VALUES  ('Licorice Pizza', 2021, 'tt11271038'),
        ('Killers of the Flower Moon', 2022, 'tt5537002'),
        ('The French Dispatch', 2021, 'tt8847712');

-- INSERT 
-- INTO    performances(time, date, title, production_year, theater_name)
-- VALUES  ('19:00', '2022-03-01', 'Licorice Pizza', 2021, 'Kino'),
--         ('19:00', '2022-03-02', 'Licorice Pizza', 2021, 'Kino'), 
--         ('19:00', '2022-03-03', 'Licorice Pizza', 2021, 'Kino'),
--         ('18:00', '2022-03-01', 'Killers of the Flower Moon', 2022, 'SF Lund'),
--         ('20:00', '2022-03-05', 'The French Dispatch', 2021, 'SF Lund'),
--         ('21:00', '2022-03-08', 'Killers of the Flower Moon', 2022, 'SF Malmö');

INSERT
INTO    users(username, fullName, pwd)
VALUES  ('alice123', 'Alice Aliceson', 'password12'),
        ('bob123', 'Bob Bobson', 'password12');
