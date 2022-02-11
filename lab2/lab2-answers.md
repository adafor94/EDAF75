4. Identify keys, both primary keys and foreign keys. Answer these questions (put your answer in lab2-answers.md):

a) Which relations have natural keys? - All. Except maybe ticket?

b) Is there a risk that any of the natural keys will ever change? - theater name, username, and performance time and date might change.

c) Are there any weak entity sets? - Not sure, but maybe Performance. Depending on the definition. It uses a foreign key as primary key.

d) In which relations do you want to use an invented key. Why? - Maybe in performances? To avoid having the time and date change.

6. Convert the E/R model to a relational model, use the method described during lecture 4.

Describe your model in your lab2-answers.md file – use the following conventions:

underscores for primary keys
slashes for foreign keys
underscores and slashes for attributes which are both (parts of) primary keys and foreign keys
For the college application example we had during lecture 2 we would end up with:

students(_s_id_, s*name, gpa, size_hs)
colleges(\_c_name*, state, enrollment)
applications(/_s_id_/, /_c_name_/, _major_, decision)

    theater(_name_, capacity)
    performance(_/theater_name/_, _time_, _date_, /title/, /production_year/)
    movies(_title_, _production_year_, IMDB_key, run_time)
    ticket(_id_, /theater_name/, /time/, /date/, /username/)
    customer(_username_, first_name, last_name, password)

7. There are at least two ways of keeping track of the number of seats available for each performance – describe them both, with their upsides and downsides (write your answer in lab2-answers.md).
   - Ackumulate or update?

For your own database, you can choose either method, but you should definitely be aware of both.
