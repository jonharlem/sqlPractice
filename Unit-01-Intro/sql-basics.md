# Learn SQL: Structured Query Language
In this example we will be working with: PostgreSQL [Postgres Documentation](http://www.postgresql.org/docs/9.4/interactive/index.html). For a list of relational database management systems (RDBMS) see: [RDBMS List](https://en.wikipedia.org/wiki/Comparison_of_relational_database_management_systems)

Further reading on SQL: [SQL Wikipedia](https://en.wikipedia.org/wiki/SQL)

Great Resources:
  - [PostgreSQL Commands](http://www.postgresql.org/docs/9.4/interactive/sql-commands.html)
  - [PostgreSQL Coding Conventions](http://www.postgresql.org/docs/9.4/interactive/source.html)


Introduce Concepts
------------------
  - Setup Postgres
  - Run Postgres
    - `psql` in the terminal
  - Intro to SQL
    - Data Definition Language (DDL): _The schema of a database._
      - Create a database
      - Create a table
      - Drop a table
      - Introduce Datatypes
        - serial [Numeric types](http://www.postgresql.org/docs/9.0/static/datatype-numeric.html)
        - varchar [Character types](http://www.postgresql.org/docs/9.2/static/datatype-character.html)
        - point [Geometric types](http://www.postgresql.org/docs/9.2/static/datatype-geometric.html)
        - int [Numeric types](http://www.postgresql.org/docs/9.0/static/datatype-numeric.html)
        - real [Numeric types](http://www.postgresql.org/docs/9.0/static/datatype-numeric.html)
        - date [Data/time types](http://www.postgresql.org/docs/9.2/static/datatype-datetime.html)
      - Introduce Constraints
        - [foreign keys](http://www.postgresql.org/docs/9.3/static/ddl-constraints.html#DDL-CONSTRAINTS-FK)
        - [primary keys](http://www.postgresql.org/docs/9.3/static/ddl-constraints.html#DDL-CONSTRAINTS-PRIMARY-KEYS)
        - Schema Constraints
    - Data Manipulation Language (DML): _Interacting with the database and tables._
      - Select
      - Update
      - Delete
      - Insert
      - Join



Postgres Installation & Startup
-------------------------------
If you have `homebrew` installed, you can run `brew install postgresql`. If not, you can download it here: [PostgreSQL](http://www.postgresql.org/download/)

Before you can connect to `postgres` you must startup the server. An easy way to start the server is to download and use this free app: [PostgresApp](http://postgresapp.com/). You can also start it manually, feel free to google for instructions. (For simplicity, I recommend you use the app.)



Database Setup
--------------

- Create the database

```
$ psql
$ CREATE DATABASE weatherapp;
```

- Load the schema

```
$ psql "weatherapp" < db/schema.sql
```

- Load the seed data

```
$ psql "weatherapp" < db/seed.sql
```


Query
-----
To be able to run queries on our database. You must first `\connect` or `\c` to the `weatherapp` database. Type `\dt` to list all _database tables_.

```
$ psql
$ \connect weatherapp
```
List all of the `weatherapp` database tables:
```
$ \dt

  List of relations
   Schema |  Name   | Type  | Owner
  --------+---------+-------+-------
   public | cities  | table | <your-name>
   public | weather | table | <your-name>
```
Describe the table using `\d+ <table-name>`

```
$ \d+ cities

  Table "public.cities"
    Column  |         Type          |                      Modifiers                      | Storage  | Stats target | Description
  ----------+-----------------------+-----------------------------------------------------+----------+--------------+-------------
   id       | integer               | not null default nextval('cities_id_seq'::regclass) | plain    |              |
   city     | character varying(80) |                                                     | extended |              |
   location | point                 |                                                     | plain    |              |

  Indexes:
  "cities_pkey" PRIMARY KEY, btree (id)

  Referenced by:
  TABLE "weather" CONSTRAINT "weather_city_id_fkey" FOREIGN KEY (city_id) REFERENCES cities(id)
```
Resources on [Index types](http://www.postgresql.org/docs/9.2/static/indexes-types.html)

- `SELECT` all records from a table
```
$ SELECT * FROM cities;
$ SELECT * FROM weather;
```

- `SELECT` a specific record from a table
```
$ SELECT * FROM cities WHERE city = 'Boulder';

   id |  city   | location
  ----+---------+----------
    1 | Boulder | (2,5)
```

- Updating records with `UPDATE`:
```
$ UPDATE
    weather
  SET
    temp_lo = temp_lo+1, temp_hi = temp_lo+15, prcp = DEFAULT
  WHERE
    city_id = 1;


$ SELECT * FROM weather WHERE city_id = 1;

 id | city_id | temp_lo | temp_hi | prcp |    date
----+---------+---------+---------+------+------------
  1 |       1 |      76 |      90 |      | 2015-11-10
  4 |       1 |      72 |      86 |      | 2015-11-09
  7 |       1 |      82 |      96 |      | 2015-11-08

```

- Create a record with `INSERT`:
```
$ INSERT INTO
    cities
  VALUES
    (default, 'Queens', point(10,27));

$ SELECT * FROM cities;
   id |   city   | location
  ----+----------+----------
    1 | Boulder  | (2,5)
    2 | Denver   | (7,2)
    3 | Brooklyn | (9,1)
    4 | Queens   | (10,27)

```

- Create a record with `INSERT` and return it's `id`:
```
INSERT INTO cities VALUES (default, 'New York', point(32,78)) RETURNING id;

  id
  ----
   4
  (1 row)
```

- Delete a record and all of it's `foreign key` relationships. This works because the schema is created as `city_id int references cities(id) on delete cascade`:
```
$ DELETE FROM cities WHERE city = 'Boulder';
```

- Example of a simple `join`. Queries can access multiple tables at once, or access the same table in such a way that multiple rows of the table are being processed at the same time. A query that accesses multiple rows of the same or different tables at one time is called a join query[...](http://www.postgresql.org/docs/8.3/static/tutorial-join.html)

```
$ SELECT * FROM cities, weather WHERE cities.id = weather.city_id;

   id |   city   | location | id | city_id | temp_lo | temp_hi |  prcp  |    date
  ----+----------+----------+----+---------+---------+---------+--------+------------
    1 | Boulder  | (2,5)    |  1 |       1 |      75 |      42 | 210000 | 2015-11-10
    2 | Denver   | (7,2)    |  2 |       2 |      65 |      55 | 300030 | 2015-11-10
    3 | Brooklyn | (9,1)    |  3 |       3 |      55 |      39 | 120000 | 2015-11-10
    1 | Boulder  | (2,5)    |  4 |       1 |      71 |      55 | 103000 | 2015-11-09
    2 | Denver   | (7,2)    |  5 |       2 |      74 |      51 | 300040 | 2015-11-09
    3 | Brooklyn | (9,1)    |  6 |       3 |      72 |      66 | 203000 | 2015-11-09
    1 | Boulder  | (2,5)    |  7 |       1 |      81 |      65 | 104000 | 2015-11-08
    2 | Denver   | (7,2)    |  8 |       2 |      64 |      55 | 300300 | 2015-11-08
    3 | Brooklyn | (9,1)    |  9 |       3 |      42 |      36 | 202000 | 2015-11-08
```

Another way to write an `INNER JOIN`:
```
SELECT * FROM cities INNER JOIN weather ON (cities.id = weather.city_id);
```

- Attempt to `INSERT` an invalid record:
```
INSERT INTO weather VALUES (default, 1, 44, 88, 243433, now());
  ERROR:  new row for relation "weather" violates check constraint "weather_check"
  DETAIL:  Failing row contains (10, 1, 44, 88, 243433, 2015-11-10).
```

- `DROP` an entire table
```
$ DROP TABLE cities CASCADE;

$ \dt
  List of relations
   Schema |  Name   | Type  | Owner
  --------+---------+-------+-------
   public | weather | table | fa
  (1 row)
```

- [SQL pPrepared Statements](http://www.postgresql.org/docs/9.2/static/sql-prepare.html)
```
PREPARE
  city ( varchar, point )
AS INSERT INTO
  cities ( id, city, location )
VALUES
  ( default, $1, $2 );

EXECUTE city ( 10, 'Bronx', point(13,34) );
```
