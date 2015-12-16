-- Create a new database called 'url_shortener_(your_first_name)_(your_last_name)'id
CREATE DATABASE url_shortener_jon_harlem;
-- Create a new table called 'urls'. This table should have the columns that you need to store a shortened URL (id, original_url and count)
CREATE TABLE urls 
(
	id serial primary key,
	original_url varchar(80),
	count int
);
-- Insert 5 rows of data into the 'urls' table.
INSERT INTO urls VALUES (default, 'https://coursework.galvanize.com', 3);
INSERT INTO urls VALUES (default, 'https://github.com/jonharlem', 4);
INSERT INTO urls VALUES (default, 'https://github.com/equinusocio/material-theme', 1);
INSERT INTO urls VALUES (default, 'http://explainshell.com/', 6);
INSERT INTO urls VALUES (default, 'https://members.galvanize.com/', 1);
-- Display all of the rows in the urls table with all of the columns
SELECT * FROM urls;
-- Display all of the rows in the urls table with only the original_url column
SELECT original_url FROM urls;
-- Display one row from the urls table with a specific id
SELECT * FROM urls WHERE id=2;

