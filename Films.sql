USE MASTER
GO
DROP DATABASE IF EXISTS Films
GO
CREATE DATABASE Films
GO
USE Films
GO

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL,
    JoinDate DATE,
    Age INT
) AS NODE;

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Year INT,
    Rating FLOAT
) AS NODE;

CREATE TABLE Genres (
    GenreID INT PRIMARY KEY,
    GenreName NVARCHAR(30) NOT NULL,
    Description NVARCHAR(200)
) AS NODE;

CREATE TABLE Watched (
    Rating INT,
    WatchDate DATE
)  AS EDGE;

CREATE TABLE BelongsTo AS EDGE;

CREATE TABLE FriendsWith (
    Since DATE,
    FriendshipLevel INT
) AS EDGE;

INSERT INTO Users VALUES
(1, 'Алексей Иванов', '2020-01-15', 28),
(2, 'Мария Петрова', '2019-05-22', 25),
(3, 'Дмитрий Сидоров', '2021-03-10', 32),
(4, 'Елена Кузнецова', '2020-11-05', 24),
(5, 'Сергей Смирнов', '2018-07-18', 40),
(6, 'Ольга Васильева', '2021-09-30', 27),
(7, 'Андрей Попов', '2019-12-25', 35),
(8, 'Анна Новикова', '2020-06-14', 29),
(9, 'Павел Федоров', '2021-01-08', 31),
(10, 'Наталья Морозова', '2018-03-03', 33);

INSERT INTO Movies VALUES
(1, 'Крестный отец', 1972, 9.2),
(2, 'Форрест Гамп', 1994, 8.8),
(3, 'Темный рыцарь', 2008, 9.0),
(4, 'Побег из Шоушенка', 1994, 9.3),
(5, 'Начало', 2010, 8.8),
(6, 'Матрица', 1999, 8.7),
(7, 'Список Шиндлера', 1993, 8.9),
(8, 'Криминальное чтиво', 1994, 8.9),
(9, 'Бойцовский клуб', 1999, 8.8),
(10, 'Зеленая миля', 1999, 9.1);

INSERT INTO Genres VALUES
(1, 'Криминал', 'Фильмы о преступности'),
(2, 'Драма', 'Фильмы с глубоким сюжетом'),
(3, 'Фантастика', 'Научная фантастика и фэнтези'),
(4, 'Боевик', 'Фильмы с динамичным действием'),
(5, 'Триллер', 'Напряженные фильмы с неожиданной развязкой'),
(6, 'Исторический', 'Фильмы на основе реальных событий'),
(7, 'Комедия', 'Юмористические фильмы'),
(8, 'Мелодрама', 'Фильмы о любовных отношениях'),
(9, 'Детектив', 'Фильмы с расследованием преступлений'),
(10, 'Приключения', 'Фильмы о захватывающих путешествиях');

INSERT INTO Watched ($from_id, $to_id, Rating, WatchDate)
VALUES
    ((SELECT $node_id FROM Users WHERE UserID = 1),
    (SELECT $node_id FROM Movies WHERE MovieID = 1),
    5, '2022-01-10'),
	((SELECT $node_id FROM Users WHERE UserID = 2),
    (SELECT $node_id FROM Movies WHERE MovieID = 2),
    4, '2021-11-15'),
	((SELECT $node_id FROM Users WHERE UserID = 3),
    (SELECT $node_id FROM Movies WHERE MovieID = 3),
    5, '2022-02-20'),
	((SELECT $node_id FROM Users WHERE UserID = 4),
    (SELECT $node_id FROM Movies WHERE MovieID = 4),
    5, '2021-10-05'),
	((SELECT $node_id FROM Users WHERE UserID = 5),
    (SELECT $node_id FROM Movies WHERE MovieID = 5),
    4, '2022-03-12'),
	((SELECT $node_id FROM Users WHERE UserID = 5),
    (SELECT $node_id FROM Movies WHERE MovieID = 6),
    5, '2022-03-12'),
	((SELECT $node_id FROM Users WHERE UserID = 6),
    (SELECT $node_id FROM Movies WHERE MovieID = 6),
    3, '2021-12-18'),
	((SELECT $node_id FROM Users WHERE UserID = 6),
    (SELECT $node_id FROM Movies WHERE MovieID = 3),
    2, '2021-12-18'),
	((SELECT $node_id FROM Users WHERE UserID = 7),
    (SELECT $node_id FROM Movies WHERE MovieID = 7),
    5, '2022-01-25'),
	((SELECT $node_id FROM Users WHERE UserID = 8),
    (SELECT $node_id FROM Movies WHERE MovieID = 8),
    4, '2021-11-30'),
	((SELECT $node_id FROM Users WHERE UserID = 9),
    (SELECT $node_id FROM Movies WHERE MovieID = 9),
    5, '2022-02-15'),
	((SELECT $node_id FROM Users WHERE UserID = 10),
    (SELECT $node_id FROM Movies WHERE MovieID = 10),
    4, '2021-10-22');

INSERT INTO BelongsTo ($from_id, $to_id)
SELECT 
    (SELECT $node_id FROM Movies WHERE MovieID = 1),
    (SELECT $node_id FROM Genres WHERE GenreID = 1)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 2),
       (SELECT $node_id FROM Genres WHERE GenreID = 2)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 3),
       (SELECT $node_id FROM Genres WHERE GenreID = 4)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 4),
       (SELECT $node_id FROM Genres WHERE GenreID = 2)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 5),
       (SELECT $node_id FROM Genres WHERE GenreID = 3)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 6),
       (SELECT $node_id FROM Genres WHERE GenreID = 3)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 7),
       (SELECT $node_id FROM Genres WHERE GenreID = 6)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 8),
       (SELECT $node_id FROM Genres WHERE GenreID = 1)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 9),
       (SELECT $node_id FROM Genres WHERE GenreID = 5)
UNION ALL
SELECT (SELECT $node_id FROM Movies WHERE MovieID = 10),
       (SELECT $node_id FROM Genres WHERE GenreID = 2);

INSERT INTO FriendsWith ($from_id, $to_id, Since, FriendshipLevel) VALUES
    ((SELECT $node_id FROM Users WHERE UserID = 1),
    (SELECT $node_id FROM Users WHERE UserID = 2),
    '2020-06-01', 3),
	((SELECT $node_id FROM Users WHERE UserID = 2),
    (SELECT $node_id FROM Users WHERE UserID = 1),
    '2020-06-01', 3),
	((SELECT $node_id FROM Users WHERE UserID = 1),
    (SELECT $node_id FROM Users WHERE UserID = 3),
    '2019-08-15', 2),
	((SELECT $node_id FROM Users WHERE UserID = 3),
    (SELECT $node_id FROM Users WHERE UserID = 1),
    '2019-08-15', 2),
	((SELECT $node_id FROM Users WHERE UserID = 2),
    (SELECT $node_id FROM Users WHERE UserID = 4),
    '2021-01-10', 1),
	((SELECT $node_id FROM Users WHERE UserID = 4),
    (SELECT $node_id FROM Users WHERE UserID = 2),
    '2021-01-10', 1),
	((SELECT $node_id FROM Users WHERE UserID = 3),
    (SELECT $node_id FROM Users WHERE UserID = 5),
    '2020-03-22', 3),
	((SELECT $node_id FROM Users WHERE UserID = 5),
    (SELECT $node_id FROM Users WHERE UserID = 3),
    '2020-03-22', 3),
	((SELECT $node_id FROM Users WHERE UserID = 4),
    (SELECT $node_id FROM Users WHERE UserID = 6),
    '2021-05-14', 2),
	((SELECT $node_id FROM Users WHERE UserID = 6),
    (SELECT $node_id FROM Users WHERE UserID = 4),
    '2021-05-14', 2),
	((SELECT $node_id FROM Users WHERE UserID = 5),
    (SELECT $node_id FROM Users WHERE UserID = 7),
    '2018-11-30', 3),
	((SELECT $node_id FROM Users WHERE UserID = 7),
    (SELECT $node_id FROM Users WHERE UserID = 5),
    '2018-11-30', 3),
	((SELECT $node_id FROM Users WHERE UserID = 6),
    (SELECT $node_id FROM Users WHERE UserID = 8),
    '2021-07-18', 1),
	((SELECT $node_id FROM Users WHERE UserID = 8),
    (SELECT $node_id FROM Users WHERE UserID = 6),
    '2021-07-18', 1),
	((SELECT $node_id FROM Users WHERE UserID = 7),
    (SELECT $node_id FROM Users WHERE UserID = 9),
    '2019-09-05', 2),
	((SELECT $node_id FROM Users WHERE UserID = 9),
    (SELECT $node_id FROM Users WHERE UserID = 7),
    '2019-09-05', 2),
	((SELECT $node_id FROM Users WHERE UserID = 8),
    (SELECT $node_id FROM Users WHERE UserID = 10),
    '2020-12-12', 3),
	((SELECT $node_id FROM Users WHERE UserID = 10),
    (SELECT $node_id FROM Users WHERE UserID = 8),
    '2020-12-12', 3),
	((SELECT $node_id FROM Users WHERE UserID = 9),
    (SELECT $node_id FROM Users WHERE UserID = 10),
    '2021-02-28', 2),
	((SELECT $node_id FROM Users WHERE UserID = 10),
    (SELECT $node_id FROM Users WHERE UserID = 9),
    '2021-02-28', 2);

-- 1) Какие фильмы смотрел пользователь
SELECT m.Title, w.Rating, w.WatchDate
FROM Users u, Movies m, Watched w
WHERE MATCH(u-(w)->m)
AND u.UserName = 'Елена Кузнецова';

-- 2) Какие жанры предпочитает пользователь
SELECT g.GenreName, COUNT(*) AS MovieCount
FROM Users u, Movies m, Genres g, Watched w, BelongsTo b
WHERE MATCH(u-(w)->m-(b)->g)
AND u.UserID = 1
GROUP BY g.GenreName
ORDER BY MovieCount DESC;

-- 3) Фильмы, которые смотрели друзья пользователя
SELECT DISTINCT m.Title, AVG(w.Rating) AS AvgRating
FROM Users u1, Users u2, Movies m, FriendsWith f, Watched w
WHERE MATCH(u1-(f)->u2-(w)->m)
AND u1.UserID = 1
GROUP BY m.Title
HAVING AVG(w.Rating) >= 4
ORDER BY AvgRating DESC;

-- 4) Наиболее популярные жанры среди друзей пользователя
SELECT g.GenreName, COUNT(*) AS MoviesCount, AVG(w.Rating) AS AvgRating
FROM Users me, Users friend, Movies m, Genres g, 
     FriendsWith f, Watched w, BelongsTo b
WHERE MATCH(me-(f)->friend-(w)->m-(b)->g)
  AND me.UserID = 5  -- ID пользователя
GROUP BY g.GenreName
ORDER BY MoviesCount DESC, AvgRating DESC;

-- 5) Общие друзья между двумя пользователями
SELECT u.UserName
FROM Users u, Users u1, Users u2, FriendsWith f1, FriendsWith f2
WHERE MATCH(u1-(f1)->u<-(f2)-u2)
AND u1.UserID = 1
AND u2.UserID = 5;

SELECT 
    u1.UserName AS PersonName,
    STRING_AGG(u2.UserName, '->') WITHIN GROUP (GRAPH PATH) AS FriendsPath
FROM 
    Users AS u1,
    FriendsWith FOR PATH AS f,
    Users FOR PATH AS u2
WHERE 
    MATCH(SHORTEST_PATH(u1(-(f)->u2){1,3}))
    AND u1.UserID = 1;

SELECT 
    u1.UserName AS PersonName,
    STRING_AGG(u2.UserName, '->') WITHIN GROUP (GRAPH PATH) AS MovieConnections
FROM 
    Users AS u1,
    Watched FOR PATH AS w1,
    Movies FOR PATH AS m,
    Watched FOR PATH AS w2,
    Users FOR PATH AS u2
WHERE 
    MATCH(SHORTEST_PATH(u1(-(w1)->m<-(w2)-u2)+))
    AND u1.UserID = 5;  

SELECT U1.UserId AS IdFirst
	, U1.username AS First
	, CONCAT(N'user (', U1.UserId, ')') AS [First image name]
	, U2.UserId AS IdSecond
	, U2.Username AS Second
	, CONCAT(N'user (', U2.UserId, ')') AS [Second image name]
FROM Users AS U1
	, FriendsWith AS fw
	, Users AS U2
WHERE MATCH(U1-(fw)->U2)

SELECT U.UserId AS IdFirst
	, U.Username AS First
	, CONCAT(N'user (', U.UserId, ')') AS [First image name]
	, M.MovieId AS IdSecond
	, M.title AS Second
	, CONCAT(N'movie (', M.MovieId, ')') AS [Second image name]
FROM Users AS U
	, Watched AS w
	, Movies AS M
WHERE MATCH(U-(w)->M)

SELECT M.MovieId AS IdFirst
	, M.title AS First
	, CONCAT(N'movie (', M.MovieId, ')') AS [First image name]
	, G.GenreId AS IdSecond
	, G.Genrename AS Second
	, CONCAT(N'genre (', G.GenreId, ')') AS [Second image name]
FROM Movies AS M
	, BelongsTo AS bt
	, Genres AS G
WHERE MATCH(M-(bt)->G)



