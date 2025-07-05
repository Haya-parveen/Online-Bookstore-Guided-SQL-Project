--Create database named OnlineBookstore
CREATE DATABASE OnlineBookstore;

--Switch to the Database
\c OnlineBookstore;

--Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
	Customer_ID SERIAL PRIMARY KEY,
	customer_name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


--Import data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Haya\SQL\Practice\Online Book Store-Guided Project\Books.csv'
CSV HEADER;

--Import data into Customers Table
COPY Customers(Customer_ID, Customer_name, Email, Phone, City, Country)
FROM 'C:\Haya\SQL\Practice\Online Book Store-Guided Project\Customers.csv'
CSV HEADER;

--Import data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_date, Quantity, Total_Amount)
FROM 'C:\Haya\SQL\Practice\Online Book Store-Guided Project\Orders.csv'
CSV HEADER;

--BASIC QUERIES

--1. Retrieve all books in the fiction genre
SELECT * FROM Books
WHERE genre='Fiction';

--2.Find books published after year 1950
SELECT * FROM Books
WHERE published_year > 1950;

--3.  List all customers from canada
SELECT * FROM Customers
WHERE country='Canada';

--4. Show orders placed in nov 2023
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5. Retrieve the total stock of books avaialable
SELECT SUM(Stock) AS Total_stock
FROM Books;

--6. Find the details of most expensive book
SELECT *
FROM Books
ORDER BY price DESC
LIMIT 1;


--7. Show all customers who ordered more than 1 quantity of book
SELECT * 
FROM Orders
WHERE Quantity > 1;


--8. Retrieve all orders where the total amount exceeds $20
SELECT * 
FROM Orders
WHERE Total_Amount > 20;

--9. List all genres available in books stock.
SELECT DISTINCT genre
FROM Books;

--10. Find the book with lowest stock
SELECT * 
FROM Books
ORDER BY stock 
LIMIT 1;

--11. Calculate total revenue generated from all orders.
SELECT SUM(total_amount) AS Total_revenue
FROM Orders;


--ADVANCE QUERIES
--1. Retrieve total number of books sold for each genre.
SELECT b.Genre, SUM(o.Quantity) Total_books_sold
FROM Orders o
JOIN Books b ON o.book_id=b.Book_id
GROUP BY b.Genre;

--2. Find average price of books in the "fantasy" genre.
SELECT AVG(price) Average_price
FROM Books
WHERE genre='Fantasy';

--3. List customers who have placed at least 2 orders;
SELECT o.customer_id, c.customer_name, COUNT(Order_id) Order_count
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY o.customer_id, c.customer_name
HAVING COUNT(Order_id) >=2;

--4. Find the most frequently ordered book
SELECT o.book_id, b.title, COUNT(o.Order_id) Order_count
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY order_count DESC LIMIT 1;

--5. Show the top 3 most expensive books of fantasy genre.
SELECT * 
FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--6. Retrieve the total quantity of books sold by each author
SELECT b.author,SUM(o.quantity) Total_quantity_books
FROM Orders o
JOIN Books b on o.book_id=b.book_id
GROUP BY b.author;

--7. List the cities where customers who spent over $ 30 are located.
SELECT  DISTINCT c.city,o.total_amount
FROM customers c
JOIN orders o on c.customer_id=o.customer_id
WHERE o.total_amount > 30;

--8. Find the customer who spent the most on orders
SELECT c.customer_id,c.customer_name,SUM(o.total_amount) Total_spent
FROM orders o
JOIN customers c on o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY Total_spent DESC LIMIT 1;

--9. Calculate the stock remaining after fulfilling all orders
SELECT b.book_id,b.title,b.stock, 
	COALESCE(SUM(o.quantity),0) order_quantity,
	b.stock-COALESCE(SUM(o.quantity),0) remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id= o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;
































