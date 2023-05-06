DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE doctors(
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
middle_name VARCHAR(50),
last_name VARCHAR(50) NOT NULL,
cabinet INT NOT NULL,
specialization VARCHAR(255) NOT NULL,
health_fund ENUM ("Yes","No"),
phone_number VARCHAR(25) NOT NULL,
mail VARCHAR(50) NOT NULL
);

CREATE TABLE patients(
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
middle_name VARCHAR(50),
last_name VARCHAR(50) NOT NULL,
address VARCHAR(50) NOT NULL,
egn VARCHAR(40) NOT NULL,
diagnosis  VARCHAR(80) NOT NULL,
treatment VARCHAR(40) NOT NULL,
medicaments VARCHAR(80) NOT NULL,
healing_time VARCHAR(80) NOT NULL
);

CREATE TABLE doctor_patient(
patient_id INT REFERENCES patients(id),
doctor_id INT REFERENCES doctors(id),
   CONSTRAINT FOREIGN KEY (patient_id) 
		REFERENCES patients(id) ,	
    CONSTRAINT FOREIGN KEY (doctor_id) 
		REFERENCES doctors(id),
PRIMARY KEY(patient_id,doctor_id)
);

INSERT INTO doctors (first_name, middle_name, last_name, cabinet, specialization, health_fund, phone_number, mail)
VALUES ('John', 'Smith', 'Doe', 101, 'Cardiologist', 'Yes', '555-1234', 'john.doe@example.com'),
('Jane', NULL, 'Doe', 102, 'Neurologist', 'No', '555-4321', 'jane.doe@example.com'),
('Bob', 'Johnson', 'Smith', 103, 'Pediatrician', 'Yes', '555-5678', 'bob.johnson@example.com'),
('Mary', NULL, 'Williams', 104, 'Dermatologist', 'No', '555-8765', 'mary.williams@example.com'),
('David', 'Lee', 'Chung', 105, 'Ophthalmologist', 'Yes', '555-2345', 'david.chung@example.com'),
('Samantha', 'Park', 'Kim', 106, 'Oncologist', 'Yes', '555-7890', 'samantha.kim@example.com'),
('Michael', NULL, 'Brown', 107, 'Psychiatrist', 'No', '555-3456', 'michael.brown@example.com'),
('Jennifer', 'Taylor', 'Smith', 108, 'Gynecologist', 'Yes', '555-6789', 'jennifer.smith@example.com'),
('William', NULL, 'Davis', 109, 'Orthopedist', 'No', '555-9012', 'william.davis@example.com'),
('Olivia', 'Lee', 'Jones', 110, 'Urologist', 'Yes', '555-4567', 'olivia.jones@example.com');

INSERT INTO patients (first_name, middle_name, last_name, address, egn, diagnosis, treatment, medicaments, healing_time)
VALUES ('Alice', NULL, 'Johnson', '123 Main St', '1234567890', 'Heart Disease', 'Medication', 'Lisinopril', '2 weeks'),
('Robert', 'Lee', 'Smith', '456 Oak St', '2345678901', 'Migraine', 'Therapy', 'Counseling', '1 month'),
('Sarah', 'Park', 'Chung', '789 Maple Ave', '3456789012', 'Eczema', 'Cream', 'Cortisone', '1 week'),
('James', NULL, 'Williams', '111 Elm St', '4567890123', 'Conjunctivitis', 'Drops', 'Tobramycin', '3 days'),
('Ava', NULL, 'Davis', '222 Pine St', '5678901234', 'Fractured Arm', 'Casting', 'Fiberglass', '6 weeks'),
('Ethan', 'Kim', 'Miller', '333 Spruce St', '6789012345', 'Leukemia', 'Chemotherapy', 'Methotrexate', '6 months'),
('Emma', NULL, 'Garcia', '444 Cedar St', '7890123456', 'Anxiety', 'Medication', 'Lexapro', '1 year'),
('Noah', NULL, 'Rodriguez', '555 Oak St', '8901234567', 'Urinary Tract Infection', 'Antibiotics', 'Ciprofloxacin', '10 days'),
('Sophia', NULL, 'Lopez', '666 Maple Ave', '9012345678', 'Asthma', 'Inhaler', 'Albuterol', 'Indefinitely');


INSERT INTO  doctor_patient (patient_id,doctor_id) VALUES
(1,2),
(2,3),
(2,2),
(3,4),
(4,6),
(5,7),
(6,10),
(7,8),
(9,9);


#2
SELECT *
FROM doctors
WHERE health_fund='Yes';

#3
SELECT diagnosis, COUNT(*) as patient_count
FROM patients
GROUP BY  diagnosis ;

#4
SELECT doctors.first_name as doctor_name, doctors.last_name as doctor_last_name, patients.first_name as patient_name, patients.last_name as patient_last_name
FROM doctors JOIN doctor_patient ON doctors.id = doctor_patient.doctor_id
			 JOIN patients ON patients.id = doctor_patient.patient_id;
             
#5
SELECT doctors.first_name as doctor_name, doctors.last_name as doctor_last_name, patients.first_name as patient_name, patients.last_name as patient_last_name
FROM doctors LEFT OUTER JOIN doctor_patient ON doctors.id = doctor_patient.doctor_id
			LEFT OUTER JOIN patients ON doctor_patient.patient_id = patients.id;
            
#6
SELECT first_name as Doctor_Name, last_name as Doctor_last_name
FROM doctors
WHERE id IN (
    SELECT doctor_id
    FROM doctor_patient
    WHERE patient_id IN (
        SELECT id
        FROM patients
        WHERE diagnosis = 'Heart Disease'
    )
);

#7
SELECT doctors.specialization, COUNT(patients.id) AS num_patients
FROM doctors
LEFT JOIN doctor_patient ON doctors.id = doctor_patient.doctor_id
LEFT JOIN patients ON patients.id = doctor_patient.patient_id
GROUP BY doctors.specialization;


DELIMITER //

CREATE TRIGGER validate_egn
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
  IF NEW.egn REGEXP '[^0-9]' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'EGN can only contain digits';
  END IF;
END //

DELIMITER ;

INSERT INTO patients (first_name, middle_name, last_name, address, egn, diagnosis, treatment, medicaments, healing_time)
VALUES ('Alice', NULL, 'Johnson', '123 Main St', '123A567890', 'Heart Disease', 'Medication', 'Lisinopril', '2 weeks');

#8_2 update information

DELIMITER //

CREATE TRIGGER validate_egn_update
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
  IF NEW.egn REGEXP '[^0-9]' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'EGN can only contain digits';
  END IF;
END //

DELIMITER ;

#9
drop procedure if exists  CursorTest;
delimiter |
create procedure CursorTest()
begin
declare finished int;
declare tempName varchar(100);
declare tempMiddleName varchar(100);
declare tempLastName varchar(100);
declare doctorCursor CURSOR for
SELECT first_name,middle_name,last_name
from doctors
where health_fund='No';
declare continue handler FOR NOT FOUND set finished = 1;
set finished = 0;
OPEN doctorCursor;
doctor_loop: while( finished = 0)
DO
FETCH doctorCursor INTO tempName,tempMiddleName,tempLastName;
       IF(finished = 1)
       THEN 
       LEAVE doctor_loop;
       END IF;	
       SELECT tempName,tempMiddleName,tempLastName; # or do something with these variables...
end while;
CLOSE doctorCursor;
SET finished = 0;
end;
|
delimiter ;

call  CursorTest();


