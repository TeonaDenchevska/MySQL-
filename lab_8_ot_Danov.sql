use school_sport_clubs;

#1
drop view if exists  CoachView;
create view CoachView
as
SELECT coaches.name as CoachName,sports.name,concat(sg.id,'-',sg.location) as groupInfo,salarypayments.year,salarypayments.month,salarypayments.salaryAmount
from coaches JOIN sportgroups as sg ON coaches.id=sg.coach_id
			 JOIN sports ON sg.sport_id=sports.id
             JOIN salarypayments ON coaches.id=salarypayments.coach_id
			 WHERE salarypayments.month=3 AND salarypayments.year=2023;


select * from CoachView;

#2
DROP PROCEDURE IF EXISTS GetStudentsInMultipleGroups;
DELIMITER //
CREATE PROCEDURE GetStudentsInMultipleGroups()
BEGIN
    SELECT s.name
    FROM students s
    INNER JOIN student_sport ss ON s.id = ss.student_id
    GROUP BY s.id, s.name
    HAVING COUNT(ss.student_id) > 1;
END //
DELIMITER ;

CALL GetStudentsInMultipleGroups();

#3
DROP PROCEDURE IF EXISTS GetCoachesWithoutGroups;
DELIMITER //
CREATE PROCEDURE GetCoachesWithoutGroups()
BEGIN
    SELECT c.name
    FROM coaches c
    LEFT JOIN sportgroups sg ON c.id = sg.coach_id
    WHERE sg.id IS NULL;
END //
DELIMITER ; 

CALL GetCoachesWithoutGroups();


#4
use transaction_test;
DROP PROCEDURE IF EXISTS convert_currency;
DELIMITER //
CREATE PROCEDURE convert_currency(IN amount DOUBLE, IN currency_from VARCHAR(10), IN currency_to VARCHAR(10), OUT result DOUBLE)
BEGIN
    DECLARE rate_eur DOUBLE;
    DECLARE rate_bgn DOUBLE;
 
    IF currency_from = 'BGN' THEN
        SET result = amount / 0.51;
    ELSEIF currency_from = 'EUR' THEN
        SET result = amount * 1.96;
    END IF;
 
    IF currency_to = 'BGN' THEN
        SET result = result * 1.96;
    ELSEIF currency_to = 'EUR' THEN
        SET result = result / 0.51;
    END IF;
END//
 
DELIMITER ;

#5
 
drop procedure if exists transfer_money;
DELIMITER //
CREATE PROCEDURE transfer_money(IN sender_id INT, IN recipient_id INT, IN amountSent DECIMAL(10,2))
BEGIN
    DECLARE sender_currency VARCHAR(10);
    DECLARE recipient_currency VARCHAR(10);
    DECLARE exchange_rate DECIMAL(10,2);
    DECLARE MESSAGE_TEXT VARCHAR(256);
    SELECT currency INTO sender_currency FROM customer_accounts WHERE id = sender_id;
    IF sender_currency IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sender account not found';
    END IF;
 
    SELECT currency INTO recipient_currency FROM customer_accounts WHERE id = recipient_id;
    IF recipient_currency IS NULL THEN
        SET MESSAGE_TEXT = 'Recipient account not found';
    END IF;
 
    IF sender_currency = recipient_currency THEN
        SET exchange_rate = 1;
    ELSEIF sender_currency = 'BGN' AND recipient_currency = 'EUR' THEN
        SET exchange_rate = 1/1.96;
    ELSEIF sender_currency = 'EUR' AND recipient_currency = 'BGN' THEN
        SET exchange_rate = 1.96;
    ELSE
        SET MESSAGE_TEXT = 'Invalid currency exchange';
    END IF;
 
    UPDATE customer_accounts SET amount = amount - ( amountSent*exchange_rate) WHERE id = sender_id AND amount >= amountSent*exchange_rate;
    IF ROW_COUNT() = 0 THEN
        SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;
 
    UPDATE customer_accounts SET amount =amount + ( amountSent*exchange_rate) WHERE id = recipient_id;
    IF ROW_COUNT() = 0 THEN
       SET MESSAGE_TEXT = 'Transaction failed';
    END IF;
 
 
    SELECT 'Transaction successful' AS result;
    
END//
DELIMITER ;

call transfer_money(2,3,100);


