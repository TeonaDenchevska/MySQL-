DROP DATABASE IF exists dating_site;
CREATE DATABASE dating_site;
USE dating_site;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50),
  last_name VARCHAR(50) NOT NULL,
  sex ENUM('M', 'F','Other') NOT NULL,
  status ENUM('single','taken') NOT NULL,
  eye_color VARCHAR(50),
  hair_color VARCHAR(50),
  skin_color VARCHAR(50),
  height INT,
  weight DECIMAL(5,2),
  education VARCHAR(50),
  profession VARCHAR(50),
  interests VARCHAR(255)
);

CREATE TABLE dating_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date_location VARCHAR(255),
  date_duration INT,
  met_again ENUM('Yes', 'No')
);
  CREATE TABLE dates(
  first_person INT REFERENCES users(id),
  second_person INT REFERENCES users(id),
  date_id INT REFERENCES dating_history(id),
   CONSTRAINT FOREIGN KEY (first_person) 
		REFERENCES users(id) ,	
    CONSTRAINT FOREIGN KEY (second_person) 
		REFERENCES users(id),
	CONSTRAINT FOREIGN KEY (date_id) 
		REFERENCES dating_history(id) ,	
PRIMARY KEY(date_id,first_person,second_person)
);


CREATE TABLE couple (
  couple_id INT PRIMARY KEY AUTO_INCREMENT,
  first_person INT NOT NULL,
  second_person INT NOT NULL,
  day DATE NOT NULL,
  FOREIGN KEY (first_person) REFERENCES users(id),
  FOREIGN KEY (second_person) REFERENCES users(id)
);


INSERT INTO users (first_name, middle_name, last_name, sex, status, eye_color, hair_color, skin_color, height, weight, education, profession, interests) VALUES
('John', 'M', 'Smith', 'M', 'single', 'brown', 'black', 'fair', 175, 70.5, 'Bachelor in Computer Science', 'Software Engineer', 'Playing guitar, Swimming, Reading'),
('Jane', NULL, 'Doe', 'F', 'single', 'blue', 'blonde', 'pale', 160, 55.2, 'Bachelor in Marketing', 'Marketing Manager', 'Traveling, Cooking, Dancing'),
('Mark', 'A', 'Johnson', 'M', 'single', 'green', 'brown', 'olive', 180, 80.0, 'Bachelor in Business Administration', 'Business Analyst', 'Golf, Watching Movies, Football'),
('Samantha', 'L', 'Davis', 'F', 'single', 'brown', 'red', 'fair', 165, 62.1, 'Bachelor in Psychology', 'Psychologist', 'Playing piano, Hiking, Yoga'),
('Alex', 'M', 'Wilson', 'Other', 'single', 'grey', 'blonde', 'pale', 170, 65.0, 'Bachelor in Fine Arts', 'Artist', 'Painting, Sketching, Travelling'),
('Emily', NULL, 'Brown', 'F', 'single', 'hazel', 'brown', 'fair', 170, 58.0, 'Bachelor in Communications', NULL, 'Reading, Yoga, Cooking'),
('Michael', 'B', 'Johnson', 'M', 'single', 'blue', 'blonde', 'fair', 185, 85.5, 'Master in Finance', 'Financial Analyst', 'Gym, Traveling, Watching Sports'),
('Sarah', 'J', 'Lee', 'F', 'single', 'green', 'black', 'olive', 162, 53.7, 'Bachelor in Economics', 'Economist', 'Hiking, Photography, Cooking'),
('David', 'K', 'Wong', 'M', 'single', 'brown', 'black', 'pale', 178, 72.3, 'Bachelor in Architecture', 'Architect', 'Drawing, Traveling, Playing guitar'),
('Melissa', NULL, 'Taylor', 'F', 'single', 'brown', 'blonde', 'fair', 175, 68.9, 'Bachelor in Fashion Design', 'Fashion Designer', 'Shopping, Dancing, Watching Movies'),
('Maya', NULL, 'Taylor', 'F', 'single', 'brown', 'blonde', 'fair', 178, 68.9, 'Bachelor in Fashion Design', 'Fashion Designer', 'Singing, Dancing, Watching Movies'),
('Tom', NULL, 'Taylor', 'M', 'single', 'brown', 'blonde', 'fair', 178, 68.9, 'Bachelor in Fashion Design', 'Fashion Designer', 'Drawing, Traveling, Playing guitar');

INSERT INTO dating_history (date_location, date_duration, met_again) VALUES
('Cafe Del Mar', 2, 'Yes'),
('Central Park', 3, 'Yes'),
('Empire State Building', 1, 'No'),
('The Met Museum', 4, 'Yes'),
('Brooklyn Bridge', 2, 'No'),
('Times Square', 1, 'No'),
('Yankee Stadium', 5, 'Yes'),
('Coney Island', 3, 'Yes'),
('The High Line', 2, 'No'),
('Statue of Liberty', 6, 'Yes');

INSERT INTO dates (first_person, second_person, date_id) VALUES
(1, 2, 1),
(1, 3, 2),
(2, 3, 3),
(3, 4, 4),
(4, 5, 5),
(3, 6, 6),
(6, 7, 7),
(7, 8, 8),
(8, 9, 9),
(9, 10, 10);

INSERT INTO couple (first_person, second_person, day) VALUES
(1, 2, '2022-03-15'),
(3, 6, '2022-04-20'),
(7, 8, '2022-06-30'),
(9, 10, '2022-07-05');

 
SET SQL_SAFE_UPDATES=0; #за да може да се update базата 

# задача 0
 UPDATE users
SET status = 'taken'
WHERE id IN (
  SELECT first_person FROM couple
  UNION
  SELECT second_person FROM couple
);


 # задача 2
 
 SELECT * FROM users
WHERE sex LIKE '%F%';

 #3
 SELECT sex, COUNT(*) as number_of_users
FROM users
GROUP BY  sex;

#4
SELECT users.first_name, users.last_name, dating_history.date_location,dating_history.date_duration
FROM users  INNER JOIN dates ON users.id = dates.first_person OR users.id = dates.second_person
			INNER JOIN dating_history ON dates.date_id = dating_history.id
			WHERE users.sex='F' AND dating_history.date_duration>1
            ORDER BY dating_history.date_duration DESC;


#5

SELECT users.first_name,users.middle_name,users.last_name, dating_history.date_location,dating_history.date_duration
FROM dating_history RIGHT OUTER JOIN dates ON dating_history.id = dates.date_id
					RIGHT OUTER JOIN users ON dates.first_person=users.id OR dates.second_person=users.id
                    WHERE users.sex='M';
#6 
SELECT *
FROM users
WHERE id IN (
  SELECT first_person
  FROM dates
  WHERE date_id IN (
    SELECT id
    FROM dating_history
    WHERE date_location = 'Central Park'
  )
)
OR id IN (
  SELECT second_person
  FROM dates
  WHERE date_id IN (
    SELECT id
    FROM dating_history
    WHERE date_location = 'Central Park'
  )
);
#7
SELECT u.first_name, u.last_name, dh.date_location, dh.date_duration
FROM users u
JOIN dates d ON u.id = d.first_person OR u.id = d.second_person
JOIN dating_history dh ON d.date_id = dh.id
WHERE dh.date_duration < (SELECT AVG(date_duration) FROM dating_history)
ORDER BY dh.date_duration DESC;

#8
delimiter |
CREATE TRIGGER prevent_same_id
BEFORE INSERT ON dates
FOR EACH ROW
BEGIN
  IF NEW.first_person = NEW.second_person THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Error: first_person and second_person cannot be the same';
  END IF;
END;
|
Delimiter ;

INSERT INTO dates (first_person, second_person, date_id) VALUES
(1, 1, 1);

delimiter |
CREATE TRIGGER prevent_same_id_couple
BEFORE INSERT ON couple
FOR EACH ROW
BEGIN
  IF NEW.first_person = NEW.second_person THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Error: first_person and second_person cannot be the same';
  END IF;
END;
|
Delimiter ;

INSERT INTO couple (first_person, second_person, day) VALUES
(1, 1, '2022-03-15');

#9
drop procedure if exists  CursorTest;
delimiter |
create procedure CursorTest()
begin
declare finished int;
declare tempName varchar(100);
declare tempMiddleName varchar(100);
declare tempLastName varchar(100);
declare userCursor CURSOR for
SELECT first_name,middle_name,last_name
from users
where status='taken';
declare continue handler FOR NOT FOUND set finished = 1;
set finished = 0;
OPEN userCursor;
user_loop: while( finished = 0)
DO
FETCH userCursor INTO tempName,tempMiddleName,tempLastName;
       IF(finished = 1)
       THEN 
       LEAVE user_loop;
       END IF;	
       SELECT tempName,tempMiddleName,tempLastName; # or do something with these variables...
end while;
CLOSE userCursor;
SET finished = 0;
SELECT 'Finished!';
end;
|
delimiter ;

call CursorTest ();


