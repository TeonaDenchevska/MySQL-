DROP DATABASE IF EXISTS school_sport_clubs;
CREATE DATABASE school_sport_clubs;
USE school_sport_clubs;

CREATE TABLE school_sport_clubs.sports(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL
)Engine = Innodb;

CREATE TABLE school_sport_clubs.coaches(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL ,
	egn VARCHAR(10) NOT NULL UNIQUE CONSTRAINT EGN CHECK(CHAR_LENGTH(egn) = 10),
	month_salary DECIMAL , 
	hour_salary DECIMAL
)Engine = Innodb;

CREATE TABLE school_sport_clubs.students(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL ,
	egn VARCHAR(10) NOT NULL UNIQUE ,
	address VARCHAR(255) NOT NULL ,
	phone VARCHAR(20) NULL DEFAULT NULL ,
	class VARCHAR(10) NULL DEFAULT NULL   
)Engine = Innodb;

CREATE TABLE school_sport_clubs.sportGroups(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	location VARCHAR(255) NOT NULL ,
	dayOfWeek ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') ,
	hourOfTraining TIME NOT NULL ,
	sport_id INT NOT NULL ,
	coach_id INT NOT NULL ,
	UNIQUE KEY(location,dayOfWeek,hourOfTraining)  ,
	CONSTRAINT FOREIGN KEY(sport_id) 
		REFERENCES sports(id) ,
	CONSTRAINT FOREIGN KEY (coach_id) 
		REFERENCES coaches(id)
)Engine = Innodb;

CREATE TABLE school_sport_clubs.student_sport(
	student_id INT NOT NULL , 
	sportGroup_id INT NOT NULL ,  
	CONSTRAINT FOREIGN KEY (student_id) 
		REFERENCES students(id) ,	
	CONSTRAINT FOREIGN KEY (sportGroup_id) 
		REFERENCES sportGroups(id) ,
	PRIMARY KEY(student_id,sportGroup_id)
)Engine = Innodb;

CREATE TABLE taxesPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	student_id INT NOT NULL,
	group_id INT NOT NULL,
	paymentAmount DOUBLE NOT NULL,
	month TINYINT,
	year YEAR,
	dateOfPayment DATETIME NOT NULL ,
	CONSTRAINT FOREIGN KEY (student_id) 
		REFERENCES students(id),
	CONSTRAINT FOREIGN KEY (group_id) 
		REFERENCES sportgroups(id)
)Engine = Innodb;

CREATE TABLE salaryPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	coach_id INT NOT NULL,
	month TINYINT,
	year YEAR,
	salaryAmount DOUBLE CONSTRAINT salaryCantBeNegative CHECK(salaryAmount >= 0),
	dateOfPayment DATETIME not null,
	CONSTRAINT FOREIGN KEY (coach_id) 
		REFERENCES coaches(id),
	UNIQUE KEY(`coach_id`,`month`,`year`)    
)Engine = Innodb;
		
create table coach_work(
	id INT auto_increment primary key,
    coach_id INT not null,
    group_id INT not null,
    number_of_hours INT not null default 1,
	date DATETIME not null,
	isPayed BOOLEAN NOT NULL DEFAULT 0,
    foreign key (coach_id) references coaches(id),
    foreign key (group_id) references sportgroups(id)
)Engine = Innodb;

create table salarypayments_log(
id INT auto_increment primary key,
operation ENUM('INSERT','UPDATE','DELETE') not null,
old_coach_id INT,
new_coach_id INT,
old_month INT,
new_month INT,
old_year INT,
new_year INT,
old_salaryAmount DECIMAL,
new_salaryAmount DECIMAL,
old_dateOfPayment DATETIME,
new_dateOfPayment DATETIME,
dateOfLog DATETIME
)Engine = Innodb;

INSERT INTO sports
VALUES 	(NULL, 'Football') ,
		(NULL, 'Volleyball'),
		(NULL, 'Tennis');
		
INSERT INTO coaches  (name, egn)
VALUES 	('Ivan Todorov Petkov', '7509041245') ,
		('georgi Ivanov Todorov', '8010091245') ,
		('Ilian Todorov Georgiev', '8407106352') ,
		('Petar Slavkov Yordanov', '7010102045') ,
		('Todor Ivanov Ivanov', '8302160980') , 
		('Slavi Petkov Petkov', '7106041278');
		
INSERT INTO students (name, egn, address, phone, class) 
VALUES 	('Iliyan Ivanov', '9401150045', 'Sofia-Mladost 1', '0893452120', '10') ,
		('Ivan Iliev Georgiev', '9510104512', 'Sofia-Liylin', '0894123456', '11') ,
		('Elena Petrova Petrova', '9505052154', 'Sofia-Mladost 3', '0897852412', '11') ,
		('Ivan Iliev Iliev', '9510104542', 'Sofia-Mladost 3', '0894123457', '11') ,
		('Maria Hristova Dimova', '9510104547', 'Sofia-Mladost 4', '0894123442', '11') ,
		('Antoaneta Ivanova Georgieva', '9411104547', 'Sofia-Krasno selo', '0874526235', '10');
		
INSERT INTO sportGroups
VALUES 	(NULL, 'Sofia-Mladost 1', 'Monday', '08:00:00', 1, 1 ) ,
		(NULL, 'Sofia-Mladost 1', 'Monday', '09:30:00', 1, 2 ) ,
		(NULL, 'Sofia-Liylin 7', 'Sunday', '08:00:00', 2, 1) ,
		(NULL, 'Sofia-Liylin 7', 'Sunday', '09:30:00', 2, 2) ,		
		(NULL, 'Plovdiv', 'Monday', '12:00:00', '1', '1');
		
INSERT INTO student_sport 
VALUES 	(1, 1),
		(2, 1),
		(3, 1),
		(4, 2),
		(5, 2),
		(6, 2),
		(1, 3),
		(2, 3),
		(3, 3);
		
INSERT INTO `school_sport_clubs`.`taxespayments` 
VALUES	(NULL, '1', '1', '200', '1', 2023, now()),
		(NULL, '1', '1', '200', '2', 2023, now()),
		(NULL, '1', '1', '200', '3', 2023, now()),
		(NULL, '1', '1', '200', '4', 2023, now()),
		(NULL, '1', '1', '200', '5', 2023, now()),
		(NULL, '1', '1', '200', '6', 2023, now()),
		(NULL, '1', '1', '200', '7', 2023, now()),
		(NULL, '1', '1', '200', '8', 2023, now()),
		(NULL, '1', '1', '200', '9', 2023, now()),
		(NULL, '1', '1', '200', '10', 2023, now()),
		(NULL, '1', '1', '200', '11', 2023, now()),
		(NULL, '1', '1', '200', '12', 2023, now()),
		(NULL, '2', '1', '250', '1', 2023, now()),
		(NULL, '2', '1', '250', '2', 2023, now()),
		(NULL, '2', '1', '250', '3', 2023, now()),
		(NULL, '2', '1', '250', '4', 2023, now()),
		(NULL, '2', '1', '250', '5', 2023, now()),
		(NULL, '2', '1', '250', '6', 2023, now()),
		(NULL, '2', '1', '250', '7', 2023, now()),
		(NULL, '2', '1', '250', '8', 2023, now()),
		(NULL, '2', '1', '250', '9', 2023, now()),
		(NULL, '2', '1', '250', '10', 2023, now()),
		(NULL, '2', '1', '250', '11', 2023, now()),
		(NULL, '2', '1', '250', '12', 2023, now()),
		(NULL, '3', '1', '250', '1', 2023, now()),
		(NULL, '3', '1', '250', '2', 2023, now()),
		(NULL, '3', '1', '250', '3', 2023, now()),
		(NULL, '3', '1', '250', '4', 2023, now()),
		(NULL, '3', '1', '250', '5', 2023, now()),
		(NULL, '3', '1', '250', '6', 2023, now()),
		(NULL, '3', '1', '250', '7', 2023, now()),
		(NULL, '3', '1', '250', '8', 2023, now()),
		(NULL, '3', '1', '250', '9', 2023, now()),
		(NULL, '3', '1', '250', '10', 2023, now()),
		(NULL, '3', '1', '250', '11', 2023, now()),
		(NULL, '3', '1', '250', '12', 2023, now()),
		(NULL, '1', '2', '200', '1', 2023, now()),
		(NULL, '1', '2', '200', '2', 2023, now()),
		(NULL, '1', '2', '200', '3', 2023, now()),
		(NULL, '1', '2', '200', '4', 2023, now()),
		(NULL, '1', '2', '200', '5', 2023, now()),
		(NULL, '1', '2', '200', '6', 2023, now()),
		(NULL, '1', '2', '200', '7', 2023, now()),
		(NULL, '1', '2', '200', '8', 2023, now()),
		(NULL, '1', '2', '200', '9', 2023, now()),
		(NULL, '1', '2', '200', '10', 2023, now()),
		(NULL, '1', '2', '200', '11', 2023, now()),
		(NULL, '1', '2', '200', '12', 2023, now()),
		(NULL, '4', '2', '200', '1', 2023, now()),
		(NULL, '4', '2', '200', '2', 2023, now()),
		(NULL, '4', '2', '200', '3', 2023, now()),
		(NULL, '4', '2', '200', '4', 2023, now()),
		(NULL, '4', '2', '200', '5', 2023, now()),
		(NULL, '4', '2', '200', '6', 2023, now()),
		(NULL, '4', '2', '200', '7', 2023, now()),
		(NULL, '4', '2', '200', '8', 2023, now()),
		(NULL, '4', '2', '200', '9', 2023, now()),
		(NULL, '4', '2', '200', '10', 2023, now()),
		(NULL, '4', '2', '200', '11', 2023, now()),
		(NULL, '4', '2', '200', '12', 2023, now()),
		/**2022**/
		(NULL, '1', '1', '200', '1', 2022, now()),
		(NULL, '1', '1', '200', '2', 2022, now()),
		(NULL, '1', '1', '200', '3', 2022, now()),
		(NULL, '1', '1', '200', '4', 2022, now()),
		(NULL, '1', '1', '200', '5', 2022, now()),
		(NULL, '1', '1', '200', '6', 2022, now()),
		(NULL, '1', '1', '200', '7', 2022, now()),
		(NULL, '1', '1', '200', '8', 2022, now()),
		(NULL, '1', '1', '200', '9', 2022, now()),
		(NULL, '1', '1', '200', '10', 2022, now()),
		(NULL, '1', '1', '200', '11', 2022, now()),
		(NULL, '1', '1', '200', '12', 2022, now()),
		(NULL, '2', '1', '250', '1', 2022, now()),
		(NULL, '2', '1', '250', '2', 2022, now()),
		(NULL, '2', '1', '250', '3', 2022, now()),
		(NULL, '2', '1', '250', '4', 2022, now()),
		(NULL, '2', '1', '250', '5', 2022, now()),
		(NULL, '2', '1', '250', '6', 2022, now()),
		(NULL, '2', '1', '250', '7', 2022, now()),
		(NULL, '2', '1', '250', '8', 2022, now()),
		(NULL, '2', '1', '250', '9', 2022, now()),
		(NULL, '2', '1', '250', '10', 2022, now()),
		(NULL, '2', '1', '250', '11', 2022, now()),
		(NULL, '2', '1', '250', '12', 2022, now()),
		(NULL, '3', '1', '250', '1', 2022, now()),
		(NULL, '3', '1', '250', '2', 2022, now()),
		(NULL, '3', '1', '250', '3', 2022, now()),
		(NULL, '3', '1', '250', '4', 2022, now()),
		(NULL, '3', '1', '250', '5', 2022, now()),
		(NULL, '3', '1', '250', '6', 2022, now()),
		(NULL, '3', '1', '250', '7', 2022, now()),
		(NULL, '3', '1', '250', '8', 2022, now()),
		(NULL, '3', '1', '250', '9', 2022, now()),
		(NULL, '3', '1', '250', '10', 2022, now()),
		(NULL, '3', '1', '250', '11', 2022, now()),
		(NULL, '3', '1', '250', '12', 2022, now()),
		(NULL, '1', '2', '200', '1', 2022, now()),
		(NULL, '1', '2', '200', '2', 2022, now()),
		(NULL, '1', '2', '200', '3', 2022, now()),
		(NULL, '1', '2', '200', '4', 2022, now()),
		(NULL, '1', '2', '200', '5', 2022, now()),
		(NULL, '1', '2', '200', '6', 2022, now()),
		(NULL, '1', '2', '200', '7', 2022, now()),
		(NULL, '1', '2', '200', '8', 2022, now()),
		(NULL, '1', '2', '200', '9', 2022, now()),
		(NULL, '1', '2', '200', '10', 2022, now()),
		(NULL, '1', '2', '200', '11', 2022, now()),
		(NULL, '1', '2', '200', '12', 2022, now()),
		(NULL, '4', '2', '200', '1', 2022, now()),
		(NULL, '4', '2', '200', '2', 2022, now()),
		(NULL, '4', '2', '200', '3', 2022, now()),
		(NULL, '4', '2', '200', '4', 2022, now()),
		(NULL, '4', '2', '200', '5', 2022, now()),
		(NULL, '4', '2', '200', '6', 2022, now()),
		(NULL, '4', '2', '200', '7', 2022, now()),
		(NULL, '4', '2', '200', '8', 2022, now()),
		(NULL, '4', '2', '200', '9', 2022, now()),
		(NULL, '4', '2', '200', '10', 2022, now()),
		(NULL, '4', '2', '200', '11', 2022, now()),
		(NULL, '4', '2', '200', '12', 2022, now()),
		/**2021**/
		(NULL, '1', '1', '200', '1', 2021, now()),
		(NULL, '1', '1', '200', '2', 2021, now()),
		(NULL, '1', '1', '200', '3', 2021, now()),
		(NULL, '2', '1', '250', '1', 2021, now()),
		(NULL, '3', '1', '250', '1', 2021, now()),
		(NULL, '3', '1', '250', '2', 2021, now()),
		(NULL, '1', '2', '200', '1', 2021, now()),
		(NULL, '1', '2', '200', '2', 2021, now()),
		(NULL, '1', '2', '200', '3', 2021, now()),
		(NULL, '4', '2', '200', '1', 2021, now()),
		(NULL, '4', '2', '200', '2', 2021, now());
		
INSERT INTO `school_sport_clubs`.`salaryPayments` 
VALUES	(NULL, '1', 1, 2023, 2500, now()),
		(NULL, '1', 2, 2023, 2500, now()),
		(NULL, '1', 3, 2023, 2500, now()),
		(NULL, '1', 4, 2023, 2500, now()),
		(NULL, '2', 1, 2023, 3600, now()),
		(NULL, '2', 2, 2023, 3600, now()),
		(NULL, '2', 3, 2023, 3600, now()),
		(NULL, '2', 4, 2023, 3600, now()),
		(NULL, '3', 1, 2023, 1500, now()),
		(NULL, '3', 2, 2023, 1500, now()),
		(NULL, '3', 3, 2023, 1500, now()),
		(NULL, '3', 4, 2023, 1500, now()),
		(NULL, '4', 1, 2023, 900, now()),
		(NULL, '4', 2, 2023, 900, now()),
		(NULL, '4', 3, 2023, 900, now()),
		(NULL, '4', 4, 2023, 900, now()),
		(NULL, '5', 1, 2023, 1200, now()),
		(NULL, '5', 2, 2023, 1200, now()),
		(NULL, '5', 3, 2023, 1200, now()),
		(NULL, '5', 4, 2023, 1200, now()),
		(NULL, '6', 1, 2023, 5500, now()),
		(NULL, '6', 2, 2023, 5500, now()),
		(NULL, '6', 3, 2023, 5500, now()),
		(NULL, '6', 4, 2023, 5500, now());

UPDATE `school_sport_clubs`.`coaches` SET `month_salary`='2200', `hour_salary`='24' WHERE `id`='1';
UPDATE `school_sport_clubs`.`coaches` SET `month_salary`='2300', `hour_salary`='25' WHERE `id`='2';
UPDATE `school_sport_clubs`.`coaches` SET `month_salary`='2800', `hour_salary`='28' WHERE `id`='3';
UPDATE `school_sport_clubs`.`coaches` SET `month_salary`='3000', `hour_salary`='30' WHERE `id`='4';
UPDATE `school_sport_clubs`.`coaches` SET `month_salary`='2450', `hour_salary`='26' WHERE `id`='5';

INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('1', '1', '2', '2023-03-07 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('1', '1', '2', '2023-03-14 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('1', '1', '2', '2023-03-21 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('1', '1', '2', '2023-03-28 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('1', '1', '2', '2023-04-04 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('1', '1', '2', '2023-04-11 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '2', '2', '2023-03-07 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '2', '2', '2023-03-14 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '2', '2', '2023-03-21 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '2', '2', '2023-03-28 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '2', '2', '2023-04-04 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '2', '2', '2023-04-11 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '3', '2', '2023-04-02 08:45:55');
INSERT INTO `school_sport_clubs`.`coach_work` (`coach_id`, `group_id`, `number_of_hours`, `date`) VALUES ('2', '3', '2', '2023-04-09 08:45:55');
drop procedure if exists CoachName;
#1
delimiter |
create procedure CoachName(IN nameParam VARCHAR(255))
begin
SET @coachName = nameParam;
SELECT sports.name,sportgroups.location,sportgroups.dayOfWeek,sportgroups.hourOfTraining,students.name,students.phone
from coaches JOIN sportgroups ON coaches.id=sportgroups.coach_id
			 JOIN sports ON sportgroups.sport_id=sports.id
             JOIN student_sport ON sportgroups.id=student_sport.sportGroup_id
             JOIN students ON student_sport.student_id=students.id
WHERE coaches.name = @coachName;
end;
|
delimiter ;

call CoachName('Petar Slavkov Yordanov');
call CoachName('Ivan Todorov Petkov');
drop procedure if exists IdSport;


#2
DELIMITER |
CREATE PROCEDURE IdSport(IN idParam INT)
BEGIN 
SET @sport_id=idParam;
SELECT sports.name,students.name,coaches.name
from sports  JOIN sportgroups ON sports.id=sportgroups.sport_id
             JOIN student_sport ON sportgroups.id=student_sport.sportGroup_id
             JOIN students ON student_sport.student_id=students.id
             JOIN coaches ON sportgroups.coach_id=coaches.id
WHERE sports.id = @sport_id;
END;
|
DELIMITER ;

call IdSport(2);

drop procedure if exists AvgTaxPayment;
#3
DELIMITER |
CREATE PROCEDURE AvgTaxPayment(IN StudentNameParam VARCHAR(255))
BEGIN 
SET @StudentName=StudentNameParam;
SELECT AVG(taxespayments.paymentAmount) as AvgTaxPayment
from students  JOIN taxespayments ON students.id=taxespayments.student_id
WHERE students.name = @StudentName;
END;
|
DELIMITER ;

call AvgTaxPayment('Maria Hristova Dimova');
call AvgTaxPayment('Iliyan Ivanov');
call AvgTaxPayment('Elena Petrova Petrova');



drop procedure if exists CountGroups;
#4
DELIMITER |
CREATE PROCEDURE CountGroups(IN CoachNameParam VARCHAR(255))
BEGIN 
DECLARE result VARCHAR(255);
SET @CoachName=CoachNameParam;
SET result="";
IF((
SELECT COUNT(sportgroups.id) as NumberOfGroups
from sports  JOIN sportgroups ON sports.id=sportgroups.sport_id
             JOIN coaches ON sportgroups.coach_id=coaches.id
WHERE  @CoachName=coaches.name ) >0)
THEN 
SET result=(SELECT COUNT(sportgroups.id) as NumberOfGroups
from sports  JOIN sportgroups ON sports.id=sportgroups.sport_id
             JOIN coaches ON sportgroups.coach_id=coaches.id
WHERE @CoachName=coaches.name);
ELSE 
SET result="This coach has zero number of groups";
END IF;
SELECT result;
END
|
DELIMITER ;

call CountGroups("Ivan Todorov Petkov");
call CountGroups("Petar Slavkov Yordanov");

