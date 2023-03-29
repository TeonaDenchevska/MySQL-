DROP DATABASE IF EXISTS alpinist;
CREATE DATABASE alpinist;
use alpinist;

CREATE TABLE alpinist(
	id INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(30) NOT NULL,
    Last_Name VARCHAR(30) NOT NULL,
    speciality VARCHAR (30)NOT NULL
);

INSERT INTO alpinist(First_Name,Last_Name,speciality)
VALUES('Maria','Koleva','Geology'),('Ivan','Ivanov','Geography'),
		('Martin','Ivanov','Geology'),('Martin','Stoyanov','Climber'),
        ('Kaya','Stoyanova','Geology');

CREATE TABLE contry(
	code INT PRIMARY KEY,
     name VARCHAR(30) NOT NULL,
	 population DOUBLE NOT NULL ,
	 continent ENUM('Asia',' Africa', 'North America', 'South America', 'Antarctica', 'Europe', 'Australia'),
	 surfaceArea DOUBLE NOT NULL);

INSERT INTO contry(code,name,population,continent,surfaceArea)
VALUES(1,'China',1454477438 ,'Asia', 9.6),(2,'France',65667239 ,'Europe', 3.4);

CREATE TABLE mountain(
		id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL
        );

INSERT INTO mountain(name)
VALUES('Mon Blan'),('Himalayas');

CREATE TABLE peak(
		id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(30) NOT NULL,
        elevation DOUBLE NOT NULL ,
        mountain_id INT NOT NULL,
        FOREIGN KEY (mountain_id) REFERENCES mountain(id)
		);
INSERT INTO peak(name,elevation,mountain_id)
VALUES('Monte Bianco',4809,1),('Mount Everest',8849,2);

CREATE TABLE expedition(
		id INT AUTO_INCREMENT PRIMARY KEY,
        organizer VARCHAR(100) NOT NULL,
        begin_date DATE NOT NULL,
        end_date DATE NOT NULL,
        route VARCHAR(255),
        peak_id INT NOT NULL,
        FOREIGN KEY (peak_id) REFERENCES peak(id)
		);
INSERT INTO expedition(organizer,begin_date,end_date ,route ,peak_id)
	VALUES('Mon Blan','2012-03-12','2012-03-16','Mon Blan',1),
          ('Himalayas','2012-03-12','2012-03-16','Himalayas',2);

CREATE TABLE Participate(
		Leader_of_Expedition INT NOT NULL,
        expedition_id INT NOT NULL,
        FOREIGN KEY (Leader_of_Expedition) REFERENCES alpinist(id),
        FOREIGN KEY (expedition_id) REFERENCES expedition(id),
        PRIMARY KEY(Leader_of_Expedition,expedition_id)
        );
INSERT INTO Participate(Leader_of_Expedition,expedition_id)
VALUES(2,1),(3,2),(1,2),(4,2);
        
CREATE TABLE located(
		contry_id INT NOT NULL,
        mountain_id INT NOT NULL,
		FOREIGN KEY (contry_id ) REFERENCES contry(code),
        FOREIGN KEY (mountain_id) REFERENCES mountain(id),
        PRIMARY KEY (contry_id,mountain_id)
        );
INSERT INTO located(contry_id,mountain_id)
VALUES(2,1),(1,2);

#2 
SELECT alpinist.First_name,alpinist.Last_Name,alpinist.speciality,mountain.name
FROM alpinist JOIN Participate ON alpinist.id=Participate.Leader_of_Expedition
			   JOIN expedition ON Participate.expedition_id=expedition.id
               JOIN peak ON expedition.peak_id=peak.id
               JOIN mountain ON peak.mountain_id=mountain.id
               WHERE mountain.name='Himalayas' AND alpinist.speciality='Geology';
               
               
#3
SELECT alpinist.First_Name,alpinist.Last_Name,peak.name,mountain.name
FROM alpinist JOIN Participate ON alpinist.id=Participate.Leader_of_Expedition
			   JOIN expedition ON Participate.expedition_id=expedition.id
               JOIN peak ON expedition.peak_id=peak.id
			   JOIN mountain ON peak.mountain_id=mountain.id
               WHERE alpinist.Last_Name='Ivanov' AND mountain.name='Mon Blan';
         
#4 не е готово
SELECT mountain.name,contry.continent,AVG(COUNT(expedition))
FROM country JOIN mountain ON mountain.id IN(SELECT mountain_id FROM located 
											WHERE located.country_id=country.id)
							WHERE contry.continent='Asia'
                            