create table if not exists products (
product_id integer primary key,
product_name varchar(50) not null 
);

create table if not exists customers (
customer_id integer primary key,
customer_name varchar(100),
city varchar(100),
country varchar(100)
);

create table if not exists regions (
region_id  integer primary key,
country varchar(100),
region varchar(100),
subregion varchar(100),
continent varchar(100)
);

create table if not exists time (
time_id integer primary key,
order_date date,
year integer,
month integer,
month_name varchar(20),
quarter integer,
day integer
);


DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales;


create table if not exists sales (
order_number integer,
time_id integer references time(time_id),
product_id integer references products(product_id),
customer_id integer references customers(customer_id),
region_id integer references regions(region_id),
quantity integer,
price_each numeric(10,2),
sales numeric(10,2)
);

TRUNCATE TABLE sales CASCADE;
TRUNCATE TABLE time CASCADE;
TRUNCATE TABLE regions CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE products CASCADE;

SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM regions;
SELECT COUNT(*) FROM time;
51





