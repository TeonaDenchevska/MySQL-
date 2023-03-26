DROP DATABASE IF EXISTS medical_treatments;
CREATE DATABASE medical_treatments;
use medical_treatments;

CREATE TABLE patients(
	EGN VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
    );

INSERT INTO patients(EGN,name)
VALUES('0219102547','Teona'),
('0217035874','Frosina'),
('0317035874','Borislav');

    
CREATE TABLE treatments(
	id INT AUTO_INCREMENT PRIMARY KEY,
    price DOUBLE NOT NULL
    );
    
INSERT INTO treatments(price)
VALUES(100),(150),(300),(120),(180),(340),(190),(50),(320),(500),(50);



CREATE TABLE doctors(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO doctors(name)
VALUES('Martin Kostadinov'),('Yoana Dimitrova'),('Kaya Zdravkova'),('Ivan Ivanov'),('Ivan Ivanov');



CREATE TABLE procedures(
	time DATETIME NOT NULL,
    room INT NOT NULL,
    patient_egn VARCHAR(10) NOT NULL,
    treatment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    FOREIGN KEY (patient_egn) REFERENCES patients(egn),
    FOREIGN KEY (treatment_id) REFERENCES treatments(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
	CONSTRAINT `time_patient_treatment_unique`
	UNIQUE(time, patient_egn, treatment_id),
	CONSTRAINT PRIMARY KEY (time, patient_egn, treatment_id),
    CONSTRAINT `time_patient_doctor_unique`
    UNIQUE(time, patient_egn, doctor_id)

    );
    
INSERT INTO procedures(time,room,patient_egn,treatment_id,doctor_id)
VALUES('2022-05-17',3,'0217035874',3,1),('2022-05-19',1,'0219102547',2,5),('2022-05-19',3,'0317035874',1,1),('2022-05-20',2,'0217035874',10,5),('2022-05-18',3,'0317035874',10,4);

#2.1
SELECT patients.name,doctors.id,procedures.room,procedures.time
FROM procedures JOIN patients ON procedures.patient_egn=patients.egn
				JOIN doctors  ON procedures.doctor_id=doctors.id
                JOIN treatments ON procedures.treatment_id=treatments.id
                WHERE treatments.id=10
                AND doctors.name="Ivan Ivanov";


#2.2
SELECT patients.name,SUM(treatments.price)
FROM procedures JOIN patients ON procedures.patient_egn=patients.egn
				JOIN treatments ON procedures.treatment_id=treatments.id
                WHERE procedures.room=3 AND procedures.doctor_id=1
                GROUP BY patients.egn;