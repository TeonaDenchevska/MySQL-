DROP DATABASE IF EXISTS `cableCompany`;
CREATE DATABASE `cableCompany`;
USE `cableCompany`;

CREATE TABLE `cableCompany`.`customers` (
	`customerID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`firstName` VARCHAR( 55 ) NOT NULL ,
	`middleName` VARCHAR( 55 ) NOT NULL ,
	`lastName` VARCHAR( 55 ) NOT NULL ,
	`email` VARCHAR( 55 ) NULL , 
	`phone` VARCHAR( 20 ) NOT NULL , 
	`address` VARCHAR( 255 ) NOT NULL ,
	PRIMARY KEY ( `customerID` )
) ENGINE = InnoDB;

/*INSERT INTO customers
VALUES(1,'Moni','Dimova','Mihova','smihova@tu-sofia.bg','0887471458','59 blok');*/

CREATE TABLE `cableCompany`.`accounts` (
	`accountID` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
	`amount` DOUBLE NOT NULL ,
	`customer_id` INT UNSIGNED NOT NULL ,
	CONSTRAINT FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers` ( `customerID` )
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

INSERT INTO accounts
VALUES(1,500,1);

CREATE TABLE `cableCompany`.`plans` (
	`planID` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(32) NOT NULL,
	`monthly_fee` DOUBLE NOT NULL
) ENGINE = InnoDB;

DROP TRIGGER IF EXISTS zad5;
DELIMITER $
CREATE TRIGGER zad5 BEFORE INSERT ON plans
FOR EACH ROW
BEGIN
IF(new.monthly_fee<10)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The monthly fee must be bigger than 10';
END IF;
END;
$
DELIMITER ;

/*INSERT INTO plans(name, monthly_fee)
VALUES('medium',5);*/

CREATE TABLE `cableCompany`.`payments`(
	`paymentID` INT AUTO_INCREMENT PRIMARY KEY ,
	`paymentAmount` DOUBLE NOT NULL ,
	`month` TINYINT NOT NULL ,
	`year` YEAR NOT NULL ,
	`dateOfPayment` DATETIME NOT NULL ,
	`customer_id` INT UNSIGNED NOT NULL ,
	`plan_id` INT UNSIGNED NOT NULL ,		
	CONSTRAINT FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers`( `customerID` ) ,
	CONSTRAINT FOREIGN KEY ( `plan_id` ) 
		REFERENCES `cableCompany`.`plans` ( `planID` ) ,
	UNIQUE KEY ( `customer_id`, `plan_id`,`month`,`year` )
)ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`debtors`(
	`customer_id` INT UNSIGNED NOT NULL ,
	`plan_id` INT UNSIGNED NOT NULL ,
	`debt_amount` DOUBLE NOT NULL ,
	FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers`( `customerID` ) ,
	FOREIGN KEY ( `plan_id` )
		REFERENCES `cableCompany`.`plans`( `planID` ) ,
	PRIMARY KEY ( `customer_id`, `plan_id` )
) ENGINE = InnoDB;

INSERT INTO customers (firstName, middleName, lastName, email, phone, address)
VALUES ('John', 'A', 'Doe', 'johndoe@example.com', '1234567890', '123 Main St');

INSERT INTO accounts (amount, customer_id)
VALUES (100.00, 1);

INSERT INTO plans (name, monthly_fee)
VALUES ('Basic', 29.99);

INSERT INTO payments (paymentAmount, month, year, dateOfPayment, customer_id, plan_id)
VALUES (29.99, 5, 2023, '2023-05-01 10:00:00', 1, 1);

INSERT INTO debtors (customer_id, plan_id, debt_amount)
VALUES (1, 1, 10.00);

#1
drop procedure if exists ex1;
delimiter \\
create procedure ex1(in customerId int, in sum double, out result bit)
	begin
		declare curSum double;
        
		start transaction;
		
			select amount into curSum 
			from accounts
			where customer_id = customerId;
			
			if curSum < sum then 
			set result = 0;
			rollback;
            else 
            update accounts
            set amount = amount - sum
            where customer_id = customerId;
            set result = 1;
			end if;
    commit;
end \\
delimiter ;


call ex1(1, 100, @res);
select @res;

select * from customers;
select * from accounts;

#2
drop procedure if exists ex2;
delimiter \\
create procedure ex2(in customerId int, in plan_id int)
	begin
		declare fee double;
        declare isThere bool default false;
		declare finished int;
        declare currCus, currPlan int;
        declare curDebts cursor for select customer_id, plan_id from debtors;
        declare continue handler for not found set finished = 1;
        set finished = 0;
		start transaction;
        
			select monthly_fee into fee from plans where planID = plan_id;
			
			if (select amount from accounts where customer_id = customerId) >= fee then
            update accounts
            set amount = amount - fee
            where customer_id = customerId;
            else
				open curDebts;
				getRecords: loop
					fetch curDebts into currCus, CurrPlan;
                    if finished = 1 then leave getRecords;
                    end if;
                    if currCus = customerId and currPlan = plan_id then set isThere = true;
                    update debtors
                    set debt_amount = debt_amount + fee
                    where currCus = customer_id and currPlan = plan_id;
                    end if;
                end loop getRecords;
                
                if isThere = false then 
                insert into debtors(customer_id, plan_id, debt_amount)
                values(customerId, plan_id, fee);
                end if;
			end if;
		commit;
end \\
delimiter ;
# 3. Създайте event, който се изпълнява на 28-я ден от всеки месец и извиква втората процедура.

/*
DELIMITER |
CREATE EVENT payment_event
ON SCHEDULE EVERY 1 MONTH
STARTS '2023-05-28 03:00:00'
DO
BEGIN
	CALL user_payments();
END
|
DELIMITER ;
*/

#4
DROP VIEW IF EXISTS zad4;
CREATE VIEW zad4
AS
SELECT customers.firstName,customers.middleName,customers.lastName,payments.dateOfPayment,plans.name,debtors.debt_amount
FROM customers JOIN payments ON customers.customerID=payments.customer_id
				JOIN plans ON payments.plan_id=plans.planID
                JOIN debtors ON plans.planID=debtors.plan_id;

#5
DROP TRIGGER IF EXISTS zad5;
DELIMITER $
CREATE TRIGGER zad5 BEFORE INSERT ON plans
FOR EACH ROW
BEGIN
IF(plans.monthly_fee<10)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The monthly fee must be bigger than 10';
END IF;
END;
$
DELIMITER ;

#6
DROP TRIGGER IF EXISTS zad5;
DELIMITER $
CREATE TRIGGER zad5 BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
IF((SELECT debt_amount FROM debtors WHERE debtors.customer_id=new.customer_id)>new.amount-old.amount)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The amount must be bigger that debt amount';
END IF;
END;
$
DELIMITER ;


update accounts 
set amount = amount + 5
where customer_id = 1;

#7
DROP PROCEDURE IF EXISTS zad7;
DELIMITER $
CREATE PROCEDURE zad7(IN firstName VARCHAR(255),IN middleName VARCHAR(255),IN lastName VARCHAR(255))

BEGIN
SELECT * 
FROM customers RIGHT OUTER JOIN payments ON customers.customerID=payments.customer_id;

END;
$
DELIMITER ;

call zad7('John', 'A', 'Doe');