DROP DATABASE IF EXISTS usersarticles;
CREATE DATABASE usersarticles;
use usersarticles;

CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY ,
    name VARCHAR(30) UNIQUE NOT NULL
    );

INSERT INTO users(name)
VALUES('Teona'),('Antonia'),('Simona'),('Martin'),('Ivan');

CREATE TABLE articles(
	id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(160) NOT NULL,
    contents TEXT NOT NULL,
    date DATE NOT NULL,
    author_id INT NOT NULL,
    moderator_id INT ,
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (moderator_id) REFERENCES users(id)
    );
    

INSERT INTO articles(title, contents, date, author_id, moderator_id)
VALUES ("Article 1", "Content of article 1...", "2012-03-12", 2, NULL),
       ("Article 2", "Content of article 2...", "2012-03-28", 5, NULL),
       ("Article 3", "Content of article 3...", "2012-04-04", 3, NULL),
       ("Article 4", "Content of article 4...", "2012-02-27", 2, NULL),
       ("Article 5", "Content of article 5...", "2012-03-28", 5, 1),
       ("Article 6", "Content of article 6...", "2012-04-04", 4, 2),
       ("Article 7", "Content of article 7...", "2012-02-27", 2, 1),
       ("Article 8", "Content of article 8...", "2012-02-27", 1, 2),
       ("Article 9", "Content of article 9...", "2012-02-27", 1, NULL);

#3.2
SELECT articles.title
FROM articles JOIN users ON articles.author_id=users.id
			WHERE users.name="Ivan" AND articles.moderator_id is NULL;

#3.3.1
SELECT users.id as id,users.name as Name,COUNT(articles.id) as approvedArticles
FROM users JOIN articles ON users.id=articles.author_id
WHERE articles.moderator_id IS NOT NULL
GROUP BY users.id;

#3.3.2
SELECT users.id as id,users.name as Name,COUNT(articles.id) as onWaitingdArticles
FROM users JOIN articles ON users.id=articles.author_id
WHERE articles.moderator_id IS NULL
GROUP BY users.id;


#3.3 в една заявка 
SELECT users.id,
       users.name,
       SUM(IF(articles.moderator_id IS NOT NULL, 1, 0))
	        AS moderatedcount,
       SUM(IF(articles.moderator_id IS NULL, 1, 0))
	        AS unmoderatedcount
FROM users JOIN articles ON users.id = articles.author_id
GROUP BY users.id;


