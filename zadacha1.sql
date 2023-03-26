DROP DATABASE IF EXISTS movies;
CREATE DATABASE movies;
USE movies;


CREATE TABLE producers(
	id INT AUTO_INCREMENT PRIMARY KEY,
    bullstat VARCHAR(9) NOT NULL UNIQUE,
	address VARCHAR(30) NOT NULL,
	name VARCHAR(30) NOT NULL

);

INSERT INTO producers(bullstat,address,name)
VALUES('123456789','Studentski grad,59ti blok','Ivan Ivanov'),
('987654321','Mladost,Sofia','Maria Dimitrova'),
('987651234','Varna','John Smith');

CREATE TABLE actors(
	id INT AUTO_INCREMENT PRIMARY KEY,
    sex ENUM('F','M','Other') NOT NULL,
	address VARCHAR(30) NOT NULL,
	name VARCHAR(30) NOT NULL,
    birthday DATE NULL DEFAULT NULL
);

INSERT INTO  actors(sex,address,name,birthday)
VALUES('M','Studentski grad,59ti blok','Ivan Ivanov','1985-05-09'),
('F','Mladost,Sofia','Maria Dimitrova','2000-06-15'),
('Other','Varna','John Smith','1998-04-15');

CREATE TABLE studios(
	id INT AUTO_INCREMENT PRIMARY KEY,
    bullstat VARCHAR(9) NOT NULL UNIQUE,
	address VARCHAR(30) NOT NULL
);

INSERT INTO studios(bullstat,address)
VALUES('123456789','Studentski grad'),
('987654321','Sofia'),
('987651234','Varna');

CREATE TABLE movies(
id INT AUTO_INCREMENT PRIMARY KEY,
lenght TIME NOT NULL,
title VARCHAR(50) NOT NULL,
year YEAR NOT NULL,
budget DOUBLE NOT NULL,
producer_id INT NOT NULL,
studio_id INT NOT NULL,
FOREIGN KEY (producer_id) REFERENCES producers(id),
FOREIGN KEY (studio_id) REFERENCES studios(id)

);

INSERT INTO  movies(lenght,title,year,budget,producer_id,studio_id)
VALUES('01:35:48','Titanic','1991',3.2,1,2),
('01:50:38','Wedding Day','1990','3.6',2,1),
('02:48:38','Home alone 3','1990',5.1,3,3),
('02:10:03','The Girl Boss','1999','2.5',3,1),
('01:25:38','The house','2021',7.2,2,2);

CREATE TABLE movie_actor(
movie_id INT REFERENCES movies(id),
actor_id int references actors(id),
CONSTRAINT FOREIGN KEY (movie_id) 
		REFERENCES movies(id) ,	
CONSTRAINT FOREIGN KEY (actor_id) 
		REFERENCES actors(id),
PRIMARY KEY(movie_id,actor_id)
);

INSERT INTO movie_actor(actor_id,movie_id)
VALUES (1,1),(2,3),(1,2);

#1.2
SELECT actors.name
FROM actors 
WHERE actors.address='Sofia' OR actors.sex='M';

#1.3
SELECT *
FROM movies
WHERE year BETWEEN 1990 AND 2000
ORDER BY budget desc
LIMIT 3;

#1.4
SELECT movies.title, actors.name
FROM movies JOIN actors ON actors.id IN(
			SELECT actor_id FROM movie_actor
            WHERE movie_actor.movie_id=movies.id)
            WHERE producer_id IN(
            SELECT id FROM producers
            WHERE name='John Smith');

#1.5
SELECT actors.name, AVG(movies.lenght) as avgLenght
FROM movies JOIN actors ON actors.id 
						IN(SELECT actor_id FROM movie_actor
                        WHERE movie_actor.movie_id=movies.id)
                        WHERE movies.lenght> (SELECT 
                        AVG(movies.lenght)
                        FROM movies
                        WHERE movies.year<2000)
                        GROUP BY actors.name;