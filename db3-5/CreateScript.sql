CREATE DATABASE library_management;

-- 1. Сущность "Читатели"
CREATE TABLE readers (
    rid SERIAL PRIMARY KEY,
    reader_name VARCHAR(1000) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL
);

-- 2. Сущность "Книги"
CREATE TABLE books (
    isbn VARCHAR(13) PRIMARY KEY,
    book_title VARCHAR(1000) NOT NULL,
    pub_year INT CHECK (pub_year > 0 AND pub_year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

-- 3. Сущность "Авторы"
CREATE TABLE authors (
    aid SERIAL PRIMARY KEY,
    author_name VARCHAR(1000) NOT NULL
);

-- 4. Связующая таблица М2М между книгами и авторами
CREATE TABLE books_authors (
    isbn VARCHAR(13) REFERENCES books(isbn),
    aid INT REFERENCES authors(aid),
    PRIMARY KEY (isbn, aid)
);

-- 5. Cущность/связь "Выдачи"
CREATE TABLE loans (
    lid SERIAL PRIMARY KEY,
    rid INT NOT NULL REFERENCES readers(rid),
    isbn VARCHAR(13) NOT NULL REFERENCES books(isbn),
    loan_date DATE NOT NULL,
    return_date DATE NOT NULL CHECK (return_date >= loan_date),
    returned_date DATE CHECK (returned_date >= loan_date)
);