DROP SCHEMA IF EXISTS library_schema CASCADE;
CREATE SCHEMA library_schema;
SET search_path TO library_schema;


CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender CHAR(1) DEFAULT 'M',
    created_at DATE DEFAULT CURRENT_DATE,

    CONSTRAINT chk_gender CHECK (gender IN ('M','F')),
    CONSTRAINT chk_email CHECK (email LIKE '%@%'),
    CONSTRAINT chk_customer_date CHECK (created_at > DATE '2026-01-01')
);


CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL UNIQUE
);


CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,

    category_id INT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT DEFAULT 0,
    created_at DATE DEFAULT CURRENT_DATE,

    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_stock CHECK (stock >= 0),
    CONSTRAINT chk_book_date CHECK (created_at > DATE '2026-01-01'),

    CONSTRAINT fk_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE RESTRICT
);


CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,

    PRIMARY KEY (book_id, author_id),

    CONSTRAINT fk_book FOREIGN KEY (book_id)
        REFERENCES books(book_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_author FOREIGN KEY (author_id)
        REFERENCES authors(author_id)
        ON DELETE CASCADE
);


CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL,
    book_id INT NOT NULL,

    quantity INT DEFAULT 1,
    loan_date DATE DEFAULT CURRENT_DATE,

    return_date DATE,

    total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity * 10) STORED,

    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_loan_date CHECK (loan_date > DATE '2026-01-01'),

    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_book FOREIGN KEY (book_id)
        REFERENCES books(book_id)
        ON DELETE CASCADE
);