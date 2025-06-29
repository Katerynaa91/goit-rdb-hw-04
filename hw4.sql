-- -- Task 1: Create DB / Schema LibraryManagement

-- CREATE SCHEMA IF NOT EXISTS LibraryManagement;
USE `librarymanagement`;

-- create tables:
-- 		"authors" (author_id (INT, автоматично зростаючий PRIMARY KEY), author_name (VARCHAR))
--      "genres" (genre_id (INT, автоматично зростаючий PRIMARY KEY), genre_name (VARCHAR))
-- 		"users" (user_id (INT, автоматично зростаючий PRIMARY KEY), username (VARCHAR), email (VARCHAR))
--      (F) "books" (book_id (INT, автоматично зростаючий PRIMARY KEY), title (VARCHAR), publication_year (YEAR),
-- 				 		  author_id (INT, FOREIGN KEY зв'язок з "Authors"),
--               		  genre_id (INT, FOREIGN KEY зв'язок з "Genres"))
--      (F) "borrowed_books" (borrow_id (INT, автоматично зростаючий PRIMARY KEY), borrow_date (DATE), return_date (DATE),
-- 					      book_id (INT, FOREIGN KEY зв'язок з "Books"),
--                        user_id (INT, FOREIGN KEY зв'язок з "Users"))

CREATE TABLE IF NOT EXISTS authors
			 (author_id INT AUTO_INCREMENT PRIMARY KEY, 
			  author_name VARCHAR(100));
  
CREATE TABLE IF NOT EXISTS genres
			 (genre_id INT AUTO_INCREMENT PRIMARY KEY, 
			 genre_name VARCHAR(50));
  
CREATE TABLE IF NOT EXISTS users
			 (user_id INT AUTO_INCREMENT PRIMARY KEY, 
             username VARCHAR(50), 
             email VARCHAR(50));

CREATE TABLE IF NOT EXISTS books
				(book_id INT AUTO_INCREMENT PRIMARY KEY,
                title VARCHAR(80), 
                publication_year YEAR,
				author_id INT,
				genre_id INT,
				FOREIGN KEY(author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
                FOREIGN KEY(genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS borrowed_books
			   (borrow_id INT AUTO_INCREMENT PRIMARY KEY, 
               borrow_date DATE, 
               return_date DATE DEFAULT NULL,          -- in case the book hasn't been returned yet
               book_id INT,
               user_id INT,
               FOREIGN KEY(book_id) REFERENCES books(book_id) ON DELETE CASCADE,
               FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE);

INSERT INTO users (username, email)
VALUES 	('petargreat',	'petarmelnik@outlook.com'),
		('vasylinagennadievna', 'info12345@yahoo.com'),
		('urbanpulse2004', 'urbanpulse360@gmail.com');

INSERT INTO authors (author_name)
VALUES 	('George Orwell'),
		('Chuck Palahniuk'),
        ('Francis Scott Key Fitzgerald');
        
INSERT INTO genres (genre_name)
VALUES 	('Dystopian'),
		('Postmodernism'),
        ('Tragedy');

INSERT INTO books (title, publication_year, author_id, genre_id)
VALUES	('1984', 1949, 1, 1),
        ('The Great Gatsby', 1925, 3, 3),
        ('Fight Club', 1996, 2, 2)
;

INSERT INTO borrowed_books (borrow_date, return_date, book_id, user_id)
VALUES	('2025-01-25', '2025-02-10', 2, 1),
		('2025-05-03', '2025-05-24', 1, 3),
        ('2025-04-04', '2025-04-14', 2, 2),
        ('2025-03-01', '2025-03-28', 1, 1),
        ('2025-05-22', NULL, 3, 1),
        ('2025-06-10', '2025-06-20', 3, 2)

;
use `hw3db`;

select * from categories; -- (only primaries, no FK)
select * from customers;
select * from employees;
select * from order_details;
select * from orders;
select * from shippers;
select * from suppliers;
select * from products;

select 	o.id as order_id, o.date,
		c.id as customer_id,
        c.name as customer_name,
        c.contact as customer_contact,
        c.address as customer_address, 
        c.city as customer_city, 
        c.postal_code as customer_postal_code, 
        c.country as customer_country,
        e.employee_id, 
        e.last_name as employee_last_name,
        e.first_name as employee_first_name,
        e.birthdate as employee_birthdate, 
        e.photo as employee_photo, 
        e.notes as employee_notes,
        s.name, s.phone, 
        s.id as shipper_id,
        od.quantity,
        p.name, p.unit, p.price,
        ct.id as category_id, 
        ct.name, ct.description,
        sp.id as supplier_id, 
        sp.name as supplier_name, 
        sp.contact as supplier_contact, 
        sp.address as supplier_address, 
        sp.city as supplier_city, 
        sp.postal_code as supplier_postal_code, 
        sp.country as supplier_country, 
        sp.phone as supplier_phone
        
from orders o 
join customers c on o.customer_id = c.id
join employees e on o.employee_id = e.employee_id
join shippers s on o.shipper_id = s.id
join order_details od on o.id = od.order_id
join products p on od.product_id = p.id
join categories ct on p.category_id = ct.id
join suppliers sp on p.supplier_id = sp.id;

-- 4. Виконайте запити, перелічені нижче.
-- •	Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).
-- однаковий результат, напевне, немає NULL значень, тобто всі товари співвідносяться із замовленнями або
-- всі клієнти мають замовлення і т.п.
select 	COUNT(1) as total_count
from  products p 
left join order_details od on od.product_id = p.id;

-- •	На основі запита з пункта 3 виконайте наступне: оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.

SELECT e.*
FROM employees e
WHERE e.employee_id > 3 AND e.employee_id <= 10;

-- •	Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, 
-- середню кількість товару (кількість товару знаходиться в order_details.quantity)
SELECT 
    c.name,
    AVG(od.quantity) AS average_quantity,
    COUNT(1) AS category_count
FROM order_details od
JOIN products p ON od.product_id = p.id
JOIN categories c ON p.category_id = c.id
GROUP BY 1
;
-- •	Відфільтруйте рядки, де середня кількість товару більша за 21.
-- •	Відсортуйте рядки за спаданням кількості рядків.
SELECT 
    c.name,
    AVG(od.quantity) AS average_quantity,
    COUNT(1) AS category_count
FROM order_details od
JOIN products p ON od.product_id = p.id
JOIN categories c ON p.category_id = c.id
GROUP BY 1
HAVING AVG(od.quantity) > 21
ORDER BY 3 DESC
;

-- •	Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком. - Таких в мене немає




