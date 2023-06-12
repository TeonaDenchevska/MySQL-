DROP DATABASE IF EXISTS kontrolno_2;
CREATE DATABASE kontrolno_2;
USE kontrolno_2;

CREATE TABLE employees(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
    position VARCHAR(30) NOT NULL
);
CREATE TABLE salaryPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	salaryAmount DOUBLE NOT NULL,
    monthlyBonus DOUBLE NOT NULL,
	yearOfPayment year NOT NULL,
    monthOfPayment INT NOT NULL,
    dateOfPayment date NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE actions(
	id INT AUTO_INCREMENT PRIMARY KEY,
	actionType ENUM('buy','sales','rent') NOT NULL
);

CREATE TABLE customers(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
    phone VARCHAR(10) NOT NULL,
    email VARCHAR(50) NOT NULL
);
CREATE TABLE types(
	id INT AUTO_INCREMENT PRIMARY KEY,
	actionType ENUM('land','building','apartment','house','maisonette') NOT NULL
);
CREATE TABLE properties(
	id INT AUTO_INCREMENT PRIMARY KEY,
	area DOUBLE NOT NULL,
    price DOUBLE NOT NULL,
    location VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    type_id INT NOT NULL,
    FOREIGN KEY (type_id) REFERENCES types(id)
);

CREATE TABLE ads(
	id INT AUTO_INCREMENT PRIMARY KEY,
	isActual ENUM('Yes','No'),
    publicationDate date NOT NULL,
	action_id INT NOT NULL,
    FOREIGN KEY (action_id) REFERENCES actions(id),
    property_id INT NOT NULL,
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

CREATE TABLE deals(
	id INT AUTO_INCREMENT PRIMARY KEY,
    dealDate date NOT NULL,
    paymentType VARCHAR(30) NOT NULL,
	ad_id INT NOT NULL,
    FOREIGN KEY (ad_id) REFERENCES ads(id),
	employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
    );

INSERT INTO employees (name, position)
VALUES ('John Doe', 'Manager'),
       ('Jane Smith', 'Broker'),
       ('Mike Johnson', 'Accountant');


INSERT INTO salaryPayments (salaryAmount, monthlyBonus, yearOfPayment, monthOfPayment, dateOfPayment, employee_id)
VALUES (5000, 1000, 2023, 6, '2023-06-01', 1),
       (4000, 800, 2023, 6, '2023-06-01', 2),
       (3000, 600, 2023, 6, '2023-06-01', 3);


INSERT INTO actions (actionType)
VALUES ('buy'),
       ('sales'),
       ('rent');


INSERT INTO customers (name, phone, email)
VALUES ('Alice Johnson', '1234567890', 'alice@example.com'),
       ('Bob Smith', '9876543210', 'bob@example.com'),
       ('Eve Davis', '5555555555', 'eve@example.com');


INSERT INTO types (actionType)
VALUES ('land'),
       ('building'),
       ('apartment'),
       ('house'),
       ('maisonette');


INSERT INTO properties (area, price, location, description, customer_id, type_id)
VALUES (100.5, 200000, '123 Main St', 'Beautiful land for sale', 1, 1),
       (2000, 500000, '456 Elm St', 'Spacious house for sale', 2, 4),
       (100, 100000, '789 Oak St', 'Cozy apartment for sale', 3, 3),
	(100, 100000, '789 Oak St', 'Cozy apartment for sale', 3, 3),
(100, 100000, '789 Oak St', 'Cozy apartment for sale', 3, 3);

#zadacha3
DELIMITER //

CREATE TRIGGER after_insert_listing_for_sale
AFTER INSERT ON ads
FOR EACH ROW
BEGIN
    DECLARE sales_count INT;
    DECLARE discount DECIMAL(4,2);
    
    SELECT COUNT(*) INTO sales_count
    FROM deals d
    JOIN ads a ON d.ad_id = a.id
	JOIN properties p ON a.property_id = p.id
    WHERE p.customer_id = NEW.customer_id
    AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales');
    

    IF sales_count <= 5 THEN
        SET discount = 0.005;
    ELSE
        SET discount = 0.01;
    END IF;
    

    IF sales_count > 0 THEN
        CALL SendEmailToCustomer(NEW.property_id, NEW.id, discount); 
    END IF;
END //

DELIMITER ;


#zadacha4
DELIMITER //

CREATE TRIGGER before_insert_rental_listing
BEFORE INSERT ON ads
FOR EACH ROW
BEGIN
    DECLARE owner_listing_count INT;
    

    SELECT COUNT(*) INTO owner_listing_count
    FROM ads a
    JOIN properties p ON a.property_id = p.id
    WHERE p.customer_id = NEW.customer_id
    AND a.action_id = (SELECT id FROM actions WHERE actionType = 'rent')
    AND a.isActual = 'Yes';
    

    IF owner_listing_count >= 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Listing aborted. Property owner has exceeded the limit of two active rental listings.';
    END IF;
END //

DELIMITER ;
INSERT INTO ads (isActual, publicationDate, action_id, property_id)
VALUES ('Yes', '2023-06-01', 1,1),
       ('No', '2023-06-02', 2,2),
       ('Yes', '2023-06-03', 3,3),
       ('Yes', '2023-06-01', 2, 3),
       ('No', '2023-06-02', 2, 3),
       ('Yes', '2023-06-03', 2, 3);


INSERT INTO deals (dealDate, paymentType, ad_id, employee_id)
VALUES ('2023-06-05', 'Cash', 1, 1),
       ('2023-06-06', 'Credit Card', 2, 2),
       ('2023-06-07', 'Bank Transfer', 3, 3);

#zadacha1
CREATE VIEW monthlyDeals AS
SELECT c.name AS owner_name, c.phone AS owner_phone, p.location AS property_address, p.area AS property_area, p.price AS property_price, e.name AS broker_name
FROM deals d
JOIN ads a ON d.ad_id = a.id
JOIN properties p ON a.property_id = p.id
JOIN customers c ON p.customer_id = c.id
JOIN employees e ON d.employee_id = e.id
WHERE YEAR(d.dealDate) = YEAR(CURDATE()) AND MONTH(d.dealDate) = MONTH(CURDATE()) AND p.area > 100 AND p.type_id = (SELECT id FROM types WHERE actionType = 'house') AND e.position='broker'
ORDER BY p.price;

#zadacha2
DELIMITER //

CREATE PROCEDURE commissionPayment(IN p_month INT, IN p_year INT)
BEGIN
    DECLARE total_commission DECIMAL(10,2);
    DECLARE avg_commission DECIMAL(10,2);
    DECLARE bonus_15 DECIMAL(10,2);
    DECLARE bonus_10 DECIMAL(10,2);
    DECLARE bonus_5 DECIMAL(10,2);
    
    -- Start a transaction
    START TRANSACTION;
    
    -- Calculate total commission for the specified month and year
    SELECT SUM((CASE WHEN p.price <= 100000 THEN p.price * 0.02 ELSE p.price * 0.03 END))
    INTO total_commission
    FROM deals d
    JOIN ads a ON d.ad_id = a.id
    JOIN properties p ON a.property_id = p.id
    WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
    AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales');
    
    -- Calculate average commission for the specified month and year
    SELECT AVG((CASE WHEN p.price <= 100000 THEN p.price * 0.02 ELSE p.price * 0.03 END))
    INTO avg_commission
    FROM deals d
    JOIN ads a ON d.ad_id = a.id
    JOIN properties p ON a.property_id = p.id
    WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
    AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales');
    
    -- Calculate additional bonuses for the top three employees
    SET bonus_15 = avg_commission * 0.15;
    SET bonus_10 = avg_commission * 0.1;
    SET bonus_5 = avg_commission * 0.05;
    
    -- Update the monthlyBonus field in the salaryPayments table for each broker
    UPDATE salaryPayments sp
    JOIN employees e ON sp.employee_id = e.id
    JOIN (
        SELECT d.employee_id, COUNT(*) AS sales_count
        FROM deals d
        JOIN ads a ON d.ad_id = a.id
        JOIN properties p ON a.property_id = p.id
        WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
        AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales')
        GROUP BY d.employee_id
    ) sales ON sp.employee_id = sales.employee_id
    SET sp.monthlyBonus = 
        CASE
            WHEN e.position = 'Broker' AND e.id IN (
                SELECT employee_id
                FROM deals d
                JOIN ads a ON d.ad_id = a.id
                JOIN properties p ON a.property_id = p.id
                WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
                AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales')
            ) THEN
                CASE
                    WHEN e.id = (
                        SELECT employee_id
                        FROM deals d
                        JOIN ads a ON d.ad_id = a.id
                        JOIN properties p ON a.property_id = p.id
                        WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
                        AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales')
                        GROUP BY employee_id
                        ORDER BY COUNT(*) DESC
                        LIMIT 0,1
                    ) THEN (total_commission / sales.sales_count) + bonus_15
                    WHEN e.id = (
                        SELECT employee_id
                        FROM deals d
                        JOIN ads a ON d.ad_id = a.id
                        JOIN properties p ON a.property_id = p.id
                        WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
                        AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales')
                        GROUP BY employee_id
                        ORDER BY COUNT(*) DESC
                        LIMIT 1,1
                    ) THEN (total_commission / sales.sales_count) + bonus_10
                    WHEN e.id = (
                        SELECT employee_id
                        FROM deals d
                        JOIN ads a ON d.ad_id = a.id
                        JOIN properties p ON a.property_id = p.id
                        WHERE YEAR(d.dealDate) = p_year AND MONTH(d.dealDate) = p_month
                        AND a.action_id = (SELECT id FROM actions WHERE actionType = 'sales')
                        GROUP BY employee_id
                        ORDER BY COUNT(*) DESC
                        LIMIT 2,1
                    ) THEN (total_commission / sales.sales_count) + bonus_5
                    ELSE (total_commission / sales.sales_count)
                END
            ELSE 0
        END;
    
    -- Commit the transaction
    COMMIT;
    
END //

DELIMITER ;

CALL commissionPayment(6, 2023);