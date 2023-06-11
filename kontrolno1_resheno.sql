DROP DATABASE IF EXISTS libary;
CREATE DATABASE libary;
USE libary;


CREATE TABLE userRole(
	id INT AUTO_INCREMENT PRIMARY KEY,
    roleName ENUM('administrator','librarian','student','profesor') NOT NULL
);
INSERT INTO userRole (roleName) VALUES ('administrator');
INSERT INTO userRole (roleName) VALUES ('librarian');
INSERT INTO userRole (roleName) VALUES ('student');
INSERT INTO userRole (roleName) VALUES ('profesor');

CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
    egn VARCHAR(9) NOT NULL UNIQUE,
    pass VARCHAR(30) NOT NULL,
	phone VARCHAR(10) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL,
    userRole_id INT NOT NULL,
    FOREIGN KEY (userRole_id) REFERENCES userRole(id)
);
INSERT INTO users (name, egn, pass, phone, email, userRole_id)
VALUES ('John Doe', '123456789', 'password', '1234567890', 'john@example.com', 1),
('Jane Smith', '987654321', 'password', '9876543210', 'jane@example.com', 3),
('John A', '123456775', 'password', '1234567790', 'john@example.com', 3);





CREATE TABLE publishers(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30),
	address VARCHAR(50) NOT NULL
);
INSERT INTO publishers (name, address)
VALUES ('TU-SOFIA', '123 Main Street'),
('Publisher B', '456 Elm Street'),
('Publisher C', '457 Elm Street'),
('Publisher D', '457 Right Street');


CREATE TABLE authors(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30),
	info VARCHAR(50) NOT NULL
);

INSERT INTO authors (name, info)
VALUES ('Author X', 'Info about Author X'),('Author Y', 'Info about Author Y'),('Author Z', 'Info about Author z');

CREATE TABLE genres(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30)
);
INSERT INTO genres (name) VALUES
('Horor'),
('Crime'),
('Comedy');

CREATE TABLE books(
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(30) NOT NULL,
    description VARCHAR(50) NOT NULL,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);
INSERT INTO books (title, description,publisher_id) VALUES
('Book 1', 'Book 1 Description', 1),
('Book 2', 'Book 2 Description', 2),
('Book 3', 'Book 3 Description', 3),
('Book 9', 'Book 1 Description', 1),
('Book 4', 'Book 1 Description', 1),
('Book 5', 'Book 1 Description', 1),
('Book 6', 'Book 1 Description', 1),
('Book 7', 'Book 1 Description', 1),
('Book 8', 'Book 1 Description', 1);
INSERT INTO books (title, description) VALUES
('Book 1', 'Book 1 Description');

CREATE TABLE loanBooks(
	id INT AUTO_INCREMENT PRIMARY KEY,
	date DATE NOT NULL,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (book_id) REFERENCES books(id)
);
INSERT INTO loanBooks (date, user_id,book_id)
VALUES ('2023-06-01', 2,1),('2023-06-05', 2,2),('2023-06-05', 2,3),('2023-05-05', 2,3),('2023-06-01', 2,4),('2023-06-01', 2,5),('2023-06-01', 2,6),('2023-06-01', 2,7),('2023-06-01', 2,8),('2023-06-01',3,9);

CREATE TABLE authors_books(
author_id INT REFERENCES authors(id),
book_id INT REFERENCES books(id),
CONSTRAINT FOREIGN KEY (author_id) 
		REFERENCES authors(id) ,	
CONSTRAINT FOREIGN KEY (book_id) 
		REFERENCES books(id),
PRIMARY KEY(author_id, book_id));

INSERT INTO authors_books (author_id, book_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(2, 2),
(3, 2),
(3, 3);

CREATE TABLE genres_books(
genre_id INT REFERENCES genres(id),
book_id INT REFERENCES books(id),
CONSTRAINT FOREIGN KEY (genre_id) 
		REFERENCES genres(id) ,	
CONSTRAINT FOREIGN KEY (book_id) 
		REFERENCES books(id),
PRIMARY KEY(genre_id, book_id));

INSERT INTO genres_books (genre_id, book_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 3);






CREATE VIEW zadacha2
AS
SELECT books.title,books.description,authors.name as Author, genres.name as Genre ,publishers.name as Publisher
FROM books JOIN authors_books ON authors_books.book_id=books.id
			JOIN authors ON authors_books.author_id=authors.id
            JOIN genres_books ON genres_books.book_id=books.id
			JOIN genres ON genres_books.genre_id=genres.id
            JOIN publishers ON books.publisher_id=publishers.id;
      
#zadacha 3
SELECT b.title, p.name AS publisher_name
FROM books b
LEFT JOIN publishers p ON b.publisher_id = p.id
UNION
SELECT b.title, NULL AS publisher_name
FROM books b
WHERE b.publisher_id IS NULL
UNION
SELECT NULL AS title, p.name AS publisher_name
FROM publishers p
LEFT JOIN books b ON p.id = b.publisher_id
WHERE b.publisher_id IS NULL;   

#zadacha 4
SELECT a1.name AS author1_name, a2.name AS author2_name, b.title
FROM books b
JOIN authors_books ab1 ON b.id = ab1.book_id
JOIN authors a1 ON ab1.author_id = a1.id
JOIN authors_books ab2 ON b.id = ab2.book_id
JOIN authors a2 ON ab2.author_id = a2.id
WHERE ab1.author_id < ab2.author_id
GROUP BY b.id, a1.name, a2.name, b.title
HAVING COUNT(*) = 2
ORDER BY b.title;

#zadacha5
#първ начин само с джоинове
SELECT u.name, u.phone, u.email, COUNT(*) AS loan_books_count
FROM users u
JOIN loanBooks lb ON u.id = lb.user_id
JOIN books b ON lb.book_id = b.id
JOIN publishers p ON b.publisher_id = p.id
JOIN userRole ur ON u.userRole_id=ur.id
WHERE ur.roleName = 'student' AND p.name='TU-SOFIA'
GROUP BY u.id
HAVING loan_books_count > 5;


#втор начин с мал селект кай ролята на users
SELECT u.name, u.phone, u.email, COUNT(*) AS loan_books_count
FROM users u
JOIN loanBooks lb ON u.id = lb.user_id
JOIN books b ON lb.book_id = b.id
JOIN publishers p ON b.publisher_id = p.id
WHERE u.userRole_id = (SELECT id FROM userRole WHERE roleName = 'student')
  AND p.name = 'TU-SOFIA'
GROUP BY u.id
HAVING loan_books_count > 5;