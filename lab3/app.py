from bottle import get, post, run, request, response
import sqlite3
from urllib.parse import unquote


file = "filename"
db = sqlite3.connect("movies.sqlite")

@get('/ping')
def pong():
    response.status = 200
    return "pong"

@post('/reset')
def resetDatabase():
    c = db.cursor()
    c.executescript(
        """
        DELETE FROM theaters;
        DELETE FROM performances;
        DELETE FROM movies;
        DELETE FROM movies;
        DELETE from tickets;
        DELETE from users;

        INSERT
        INTO    theaters(theater_name, capacity)
        VALUES  ('Kino', 10),
                ('Regal', 16),
                ('Skandia', 100);
        """
    )
    db.commit()

@post('/users')
def post_user():
    user = request.json
    c = db.cursor()
    print([user['username'], user['fullName'], user['pwd']])
    c.execute(
        """
        INSERT
        INTO    users(username, fullName, pwd)
        VALUES  (?, ?, ?)
        RETURNING username
        """,
        [user['username'], user['fullName'], user['pwd']]
    )
    found = c.fetchone()
    if not found:
        response.status = 400
        return ""
    else:
        db.commit()
        response.status = 201
        username, = found
        return "/users/" + username

@post('/movies')
def post_movie():
    movie = request.json
    c = db.cursor()
    c.execute(
        """
        INSERT
        INTO    movies(title, year, imdbKey)
        VALUES  (?, ?, ?)
        RETURNING imdbKey
        """,
        [movie['title'], movie['year'], movie['imdbKey']]
    )
    found = c.fetchone()
    if not found:
        response.status = 400
        return ""
    else:
        db.commit()
        response.status = 201
        imdbKey, = found
        return "/movies/" + imdbKey

@post('/performances')
def post_performance():
    performance = request.json
    c = db.cursor()
    c.execute(
        """
        INSERT
        INTO    performances(time, date, imdbKey, theater_name)
        VALUES  (?, ?, ?, ?)
        RETURNING performance_id
        """,
        [performance['time'], performance['date'], performance['imdbKey'], performance['theater']]
    )
    found = c.fetchone()
    if not found:
        response.status = 400
        return "No such movie or theater"
    else:
        db.commit()
        response.status = 201
        performance_id, = found
        return "/performances/" + performance_id

@get('/movies')
def get_movies():
    query = """
        SELECT   *
        FROM     movies
        WHERE 1 = 1
        """
    params = []
    if request.query.title:
        query += " AND title = ?"
        params.append(unquote(request.query.title))
    if request.query.year:
        query += " AND year == ?"
        params.append(request.query.year)

    c = db.cursor()
    c.execute(query)

    found = [{"imdbKey": imdbKey, "title": title, "year": year}
             for title, year, imdbKey in c]
    response.status = 201
    return {"data": found}


@get('/movies/<imdbKey>')
def get_moviesByimdbKey(imdbKey):
    query = """
        SELECT   *
        FROM     movies
        WHERE imdbKey == ?
        """

    c = db.cursor()
    c.execute(query, [imdbKey])

    found = [{"imdbKey": imdbKey, "title": title, "year": year}
             for title, year, imdbKey in c]
    response.status = 201
    return {"data": found}

@get('/performances')
def get_movies():
    c = db.cursor()
    c.execute(
        """
        WITH t(performance_id, total) AS (
            SELECT performance_id, count()
            FROM tickets
            GROUP BY performance_id
        )

        SELECT performance_id, date, time, title, year, theater_name, capacity - coalesce(total, 0) AS remainingSeats
        FROM performances
        JOIN movies
        USING (imdbKey)
        JOIN theaters
        USING (theater_name)
        LEFT OUTER JOIN t
        USING (performance_id)
        """
    )

    found = [{"performanceId": performance_id, "date": date, "startTime": time, "title": title, "year": year, "theater": theater_name, "remainingSeats": remainingSeats}
             for performance_id, date, time, title, year, theater_name, remainingSeats in c]
    
    response.status = 201
    return {"data" : found}


@post('/tickets')
def post_ticket():
    ticket = request.json
    c = db.cursor()
    c.execute(
        """
        WITH t(performance_id, total) AS (
            SELECT performance_id, count()
            FROM tickets
            GROUP BY performance_id
        )

        SELECT capacity - coalesce(total, 0) AS remainingSeats
        FROM performances
        JOIN theaters
        USING (theater_name)
        LEFT OUTER JOIN t
        USING (performance_id)
        WHERE performance_id == ?
        """, [ticket["performanceId"]]
    )
    remainingSeats, = c.fetchone()
    if remainingSeats == 0:
        response.status = 400
        return "No tickets left"
    
    c.execute(
       """
        SELECT username
        FROM users
        WHERE username == ? AND pwd = ?
        """, [ticket["username"], ticket["pwd"]]
    )

    found = c.fetchone()
    if not found:
        response.status = 401
        return "Wrong user credentials"
    
    c.execute(
        """
        INSERT
        INTO tickets(username, performance_id)
        VALUES (?, ?)
        RETURNING ticket_id
        """, [ticket["username"], ticket["performanceId"]]
    )

    found, = c.fetchone()
    if not found:
        response.status = 400
        return "Error"
    else:
        db.commit()
        response.status = 201
        return "/tickets/{found}"

run(host='localhost', port=7007)

