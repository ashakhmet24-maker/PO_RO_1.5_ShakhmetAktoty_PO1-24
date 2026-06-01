create schema if not exists online_shop;

set search_path to online_shop;

drop table if exists order_items cascade;
drop table if exists orders cascade;
drop table if exists products cascade;
drop table if exists categories cascade;
drop table if exists customers cascade;

create table if not exists customers(

customer_id serial primary key,

full_name varchar(100) not null,

email varchar(100) unique,

phone varchar(20)

);

create table if not exists categories(

category_id serial primary key,

category_name varchar(50) unique not null

);

create table if not exists products(

product_id serial primary key,

product_name varchar(100) not null,

price numeric(10,2) check(price>=0),

stock int check(stock>=0),

category_id int references categories(category_id)

);

create table if not exists orders(

order_id serial primary key,

customer_id int references customers(customer_id),

order_date date check(order_date > date '2026-01-01'),

status varchar(20) default 'active'

);

create table if not exists order_items(

order_item_id serial primary key,

order_id int references orders(order_id),

product_id int references products(product_id),

quantity int check(quantity>=0),

unit_price numeric(10,2),

total_price numeric(10,2)
generated always as (quantity*unit_price) stored

);

-- add customer address for delivery information
alter table customers
add column address varchar(150);

-- international numbers may be longer
alter table customers
alter column phone type varchar(30);

-- clearer naming for available stock
alter table products
rename column stock to stock_quantity;

-- product price must stay realistic
alter table products
add constraint price_limit
check(price<=100000);
alter table products
drop constraint price_limit;

-- new orders should be pending by default
alter table orders
alter column status
set default 'pending';

truncate table order_items restart identity cascade;
truncate table orders restart identity cascade;
truncate table products restart identity cascade;
truncate table categories restart identity cascade;
truncate table customers restart identity cascade;

insert into customers(full_name,email,phone,address)
values
('Aruzhan Bekova','aruzhan@gmail.com','87011111111','Atyrau'),
('Dias Nur','dias@gmail.com','87022222222','Almaty'),
('Aliya Omar','aliya@gmail.com','87033333333','Astana'),
('Timur Askar','timur@gmail.com','87044444444','Aktau'),
('Dana Sapar','dana@gmail.com','87055555555','Shymkent');

insert into categories(category_name)
values
('Electronics'),
('Clothes'),
('Books'),
('Beauty'),
('Sports');

insert into products
(product_name,price,stock_quantity,category_id)
values

('Laptop',350000,10,
(SELECT category_id FROM categories WHERE category_name='Electronics')),

('Phone',250000,20,
(SELECT category_id FROM categories WHERE category_name='Electronics')),

('T-shirt',7000,40,
(SELECT category_id FROM categories WHERE category_name='Clothes')),

('Perfume',15000,15,
(SELECT category_id FROM categories WHERE category_name='Beauty')),

('Football',9000,30,
(SELECT category_id FROM categories WHERE category_name='Sports'));

insert into orders
(customer_id,order_date,status)

values

(
(SELECT customer_id
FROM customers
WHERE email='aruzhan@gmail.com'),

'2026-06-10',

'pending'
),

(
(SELECT customer_id
FROM customers
WHERE email='dias@gmail.com'),

'2026-06-11',

'completed'
),

(
(SELECT customer_id
FROM customers
WHERE email='aliya@gmail.com'),

'2026-06-12',

'pending'
),

(
(SELECT customer_id
FROM customers
WHERE email='timur@gmail.com'),

'2026-06-13',

'cancelled'
),

(
(SELECT customer_id
FROM customers
WHERE email='dana@gmail.com'),

'2026-06-14',

'pending'
);

insert into order_items
(order_id,product_id,quantity,unit_price)

values

(
(SELECT order_id
FROM orders
WHERE order_date='2026-06-10'),

(SELECT product_id
FROM products
WHERE product_name='Laptop'),

1,

350000
),

(
(SELECT order_id
FROM orders
WHERE order_date='2026-06-11'),

(SELECT product_id
FROM products
WHERE product_name='Phone'),

2,

250000
),

(
(SELECT order_id
FROM orders
WHERE order_date='2026-06-12'),

(SELECT product_id
FROM products
WHERE product_name='T-shirt'),

3,

7000
);

-- customer changed order status after payment

update orders

set status='completed'

where status='pending';

-- reduce stock after orders were placed

update products

set stock_quantity =
stock_quantity - 1

where product_id in

(
select product_id
from order_items
);

-- remove cancelled orders but keep data for defense

begin;

delete from orders

where status='cancelled'

returning order_id;

rollback;

revoke all privileges
on all tables in schema online_shop
from online_shop_readonly;

revoke all privileges
on all tables in schema online_shop
from online_shop_writer;

drop role if exists online_shop_readonly;
drop role if exists online_shop_writer;

create role online_shop_readonly;

create role online_shop_writer;

grant select

on all tables in schema online_shop

to online_shop_readonly;
grant insert, update

on orders

to online_shop_writer;

-- writers may add orders but cannot edit them later

revoke update

on orders

from online_shop_writer;