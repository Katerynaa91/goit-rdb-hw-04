-- -- TASK 1 
-- -- Створити базу даних LibraryManagement
-- -- Створити таблиці:
-- -- "authors" 
-- -- 		(author_id (INT, автоматично зростаючий PRIMARY KEY), author_name (VARCHAR))
-- -- "genres" 
-- -- 		(genre_id (INT, автоматично зростаючий PRIMARY KEY), genre_name (VARCHAR))
-- -- "users" 
-- -- 		(user_id (INT, автоматично зростаючий PRIMARY KEY), username (VARCHAR), email (VARCHAR))
-- -- "books" -> (Table with FK)
-- -- 		(book_id (INT, автоматично зростаючий PRIMARY KEY), title (VARCHAR), publication_year (YEAR),
-- -- 		author_id (INT, FOREIGN KEY зв'язок з "Authors"),
-- -- 		genre_id (INT, FOREIGN KEY зв'язок з "Genres")) 
-- -- "borrowed_books" -> (Table with FK) 
-- -- 		(borrow_id (INT, автоматично зростаючий PRIMARY KEY), borrow_date (DATE), return_date (DATE),
-- -- 		book_id (INT, FOREIGN KEY зв'язок з "Books"),
-- -- 		user_id (INT, FOREIGN KEY зв'язок з "Users"))
-- ===================================================================================
CREATE SCHEMA IF NOT EXISTS LibraryManagement;

USE `librarymanagement`;

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
               	return_date DATE DEFAULT NULL,          -- DEFAULT NULL in case the book hasn't been returned yet
               	book_id INT,
               	user_id INT,
               	FOREIGN KEY(book_id) REFERENCES books(book_id) ON DELETE CASCADE,
               	FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE);

-- ================================================================================
-- -- TASK 2. Заповніть таблиці простими видуманими тестовими даними. 
-- ================================================================================
INSERT INTO 	users (username, email)
VALUES 		('petargreat',	'petarmelnik@outlook.com'),
		('vasylinagennadievna', 'info12345@yahoo.com'),
		('urbanpulse2004', 'urbanpulse360@gmail.com');

INSERT INTO 	authors (author_name)
VALUES 		('George Orwell'),
		('Chuck Palahniuk'),
        	('Francis Scott Key Fitzgerald');
        
INSERT INTO 	genres (genre_name)
VALUES 		('Dystopian'),
		('Postmodernism'),
        	('Tragedy');

INSERT INTO 	books (title, publication_year, author_id, genre_id)
VALUES		('1984', 1949, 1, 1),
        	('The Great Gatsby', 1925, 3, 3),
        	('Fight Club', 1996, 2, 2);

INSERT INTO 	borrowed_books (borrow_date, return_date, book_id, user_id)
VALUES		('2025-01-25', '2025-02-10', 2, 1),
		('2025-05-03', '2025-05-24', 1, 3),
	        ('2025-04-04', '2025-04-14', 2, 2),
	        ('2025-03-01', '2025-03-28', 1, 1),
	        ('2025-05-22', NULL, 3, 1),
	        ('2025-06-10', '2025-06-20', 3, 2);

-- ================================================================================
-- -- TASK 3. 
-- -- 	Перейдіть до бази даних, з якою працювали у темі 3. Напишіть запит за допомогою операторів FROM та INNER JOIN, 
-- -- 	що об’єднує всі таблиці даних, які ми завантажили з файлів: order_details, orders, customers, products, categories, employees, shippers, suppliers.
-- ================================================================================
use `hw3db`;

select * from categories; 
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

-- ================================================================================
-- -- TASK 4. Виконайте запити, перелічені нижче.
-- ================================================================================
-- -- Змініть декілька операторів INNER на LEFT чи RIGHT. Визначте, що відбувається з кількістю рядків. Чому? Напишіть відповідь у текстовому файлі.
-- -- Спочатку виводило однакову кількість записів, оскільки всі записи з усіх таблиць мали відповідники в інших таблицях. 
-- -- Тому, додала новий продукт, щоб показати, що LEFT JOIN виведе іншу кількість через продукти, для яких немає замовлень (буде NULL)

INSERT INTO products (name, supplier_id, category_id, unit, price)
VALUES 	('Ikura-Test', '4', '8', '2 - 200 ml jars', '10');

SELECT 	
	COUNT(1) AS total_count_inner_join
FROM  products p 
JOIN order_details od ON od.product_id = p.id;

-- Output: count 518

SELECT 	
	COUNT(1) AS total_count_left_join
FROM  products p 
LEFT JOIN order_details od ON od.product_id = p.id;

-- Output: count 519

-- -- Оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.

SELECT e.*
FROM employees e
WHERE e.employee_id > 3 AND e.employee_id <= 10;

-- -- Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, середню кількість товару (кількість товару знаходиться в order_details.quantity)
SELECT 
    	c.name,
    	AVG(od.quantity) AS average_quantity,
    	COUNT(1) AS category_count
FROM order_details od
JOIN products p ON od.product_id = p.id
JOIN categories c ON p.category_id = c.id
GROUP BY 1
;

-- -- Відфільтруйте рядки, де середня кількість товару більша за 21.
-- -- Відсортуйте рядки за спаданням кількості рядків.
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

Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.
SELECT 	p.name,
	p.price,
	p.category_id,
	od.id,
        od.order_id,
        od.quantity
FROM  products p 
LEFT JOIN order_details od ON od.product_id = p.id
ORDER BY od.quantity ASC
