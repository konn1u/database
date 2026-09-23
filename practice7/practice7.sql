INSERT INTO Readers (reader_name, reader_phone) VALUES
('Анна Петрова', '+7-900-111-22-33'),
('Иван Соколов', '+7-900-222-33-44'),
('Мария Ким', '+7-900-333-44-55'),
('Олег Васильев', '+7-900-444-55-66'),
('Тестовый Читатель', '+7-900-555-66-77');

INSERT INTO Books (isbn, book_title, pub_year) VALUES
('978-5-17-118366-8', 'Мастер и Маргарита', 1967),
('978-5-389-06256-6', 'Преступление и наказание', 1866),
('978-5-04-116716-3', 'Война и мир', 1869),
('978-5-699-12014-7', 'Золотой теленок', 1931),
('978-5-389-03713-7', 'Пикник на обочине', 1972);

INSERT INTO Authors (author_name) VALUES
('Михаил Булгаков'),
('Федор Достоевский'),
('Лев Толстой'),
('Илья Ильф'),
('Евгений Петров'),
('Аркадий Стругацкий'),
('Борис Стругацкий');

INSERT INTO books_authors (isbn, aid) VALUES
('978-5-17-118366-8', (SELECT aid FROM Authors WHERE author_name = 'Михаил Булгаков')),
('978-5-389-06256-6', (SELECT aid FROM Authors WHERE author_name = 'Федор Достоевский')),
('978-5-04-116716-3', (SELECT aid FROM Authors WHERE author_name = 'Лев Толстой')),
('978-5-699-12014-7', (SELECT aid FROM Authors WHERE author_name = 'Илья Ильф')),
('978-5-699-12014-7', (SELECT aid FROM Authors WHERE author_name = 'Евгений Петров')),
('978-5-389-03713-7', (SELECT aid FROM Authors WHERE author_name = 'Аркадий Стругацкий')),
('978-5-389-03713-7', (SELECT aid FROM Authors WHERE author_name = 'Борис Стругацкий'));

INSERT INTO Loans (rid, isbn, loan_date, return_date, returned_date) VALUES
((SELECT rid FROM Readers WHERE reader_name = 'Анна Петрова'), '978-5-17-118366-8', '2026-09-01', '2026-09-15', '2026-09-10'),
((SELECT rid FROM Readers WHERE reader_name = 'Иван Соколов'), '978-5-389-06256-6', '2026-09-03', '2026-09-17', NULL),
((SELECT rid FROM Readers WHERE reader_name = 'Мария Ким'), '978-5-04-116716-3', '2026-09-05', '2026-09-19', '2026-09-18'),
((SELECT rid FROM Readers WHERE reader_name = 'Олег Васильев'), '978-5-699-12014-7', '2026-09-07', '2026-09-21', NULL),
((SELECT rid FROM Readers WHERE reader_name = 'Анна Петрова'), '978-5-389-03713-7', '2026-09-09', '2026-09-23', NULL),
((SELECT rid FROM Readers WHERE reader_name = 'Мария Ким'), '978-5-699-12014-7', '2026-08-20', '2026-09-03', '2026-09-01');

-- Задание 1
SELECT *
FROM readers;

-- Задание 2
SELECT book_title, pub_year
FROM books;

-- Задание 3
SELECT book_title, pub_year
FROM books
WHERE pub_year > 1800 AND pub_year < 1900;

-- Задание 4
SELECT book_title, pub_year
FROM books
WHERE pub_year BETWEEN 1917 AND 1991;

-- Задание 5
SELECT *
FROM readers
WHERE phone_number = '+7-900-333-44-55';

-- Задание 6
SELECT *
FROM readers
WHERE reader_name LIKE '%Ким';

-- Задание 7
SELECT *
FROM loans
WHERE returned_date IS NULL;

-- Задание 8
SELECT book_title, pub_year
FROM books
ORDER BY book_title;

-- Задание 9
SELECT *
FROM loans
WHERE returned_date IS NULL
ORDER BY return_date;

-- Задание 10
SELECT *
FROM books
ORDER BY pub_year DESC
LIMIT 3;