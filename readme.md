# the only T-SQL guide you'll ever need

- [About](#About)
- [Data Types](#Data-Types)
- [Creating SQL objects](#Creating-SQL-objects)
- [Inserting data](#Inserting-data)

## Data Types
``` sql
- product_id int
- price decimal(10,2)
- name nvarchar(50)
- release_date datetime, datetime2, date, time
- is_archived bit
- uuid uniqueidentifier
- price money 
- table
- cursor
```
- `product_id` is a whole number
- `price` is a decimal number with 10 digits and 2 of them are after the decimal point
- `name` is a unicode string, with a maximum length of 50 characters
- `release_date` is a date and time value
- `is_archived` is a bit, which can be 0 or 1
- `uuid` is a unique identifier (GUID) like 123e4567-e89b-12d3-a456-426614174000
- `price` is a money data type, which is a currency value like $123.45
- `cursor` iterates through a result set

## Creating SQL objects
``` sql 
create database hatelovewear
```
``` sql 
use hatelovewear
```
``` sql
create schema shop
```
``` sql 
create table shop.product (
    product_id int identity(1,1) primary key,
    name nvarchar(50),
    price decimal(10,2),
    quantity int,
    size_id int

    foreign key (size_id) references size(size_id)
)
```
- `identity` will auto increment by 1, starting from 1 when a new row is inserted
- `primary key` means unique and not null
- `size_id` is a `foreign key`
- the last statement is the foreign key `constraint`, which means `size_id` in `product` table must exist in `size` table

<br> the objects selection chain is `database.schema.object`
``` sql
hatelovewear.shop.product
```

## Dropping SQL objects
``` sql
drop table shop.product
```
``` sql
drop schema shop
```
``` sql
drop database hatelovewear
```


## Selecting data
``` sql
select distinct product_id from shop.product
```

## Inserting data

- Insert multiple rows
``` sql
insert into shop.product 
(name, price, quantity, size_id)
values 
('sql', 80.00, 100, 1),
('sql', 80.00, 50, 2),
```

- Backup table (if backup table exists)
``` sql
insert into shop.product_archive 
select * from shop.product
where is_archived = 1
```

- Backup table (if backup table doesnt exists)
``` sql
select * into shop.product_backup 
from shop.product
```

## Updating data
``` sql
update shop.product
set price = 100.00
where product_id = 1
```

## Deleting data
``` sql
delete from shop.product
where product_id = 1
```
``` sql
truncate table shop.product
```

## Variables
``` sql
declare @product_id int
set @product_id = 1

declare @last_order = (select max(order_id) from shop.order)
declare @tmp_table table (product_id int, price decimal(10,2))
```

## Case statement
```sql
case when @insert = 1 and @delete = 0 then 'insert'
    when @insert = 0 and @delete = 1 then 'delete'
    when @insert = 1 and @delete = 1 then 'update'
else 'none' end as event
```

## CTE
``` sql
with cte as (
    select product_id,
    size_id, 
    sum(price) over(partition by size_id order by price) as total_price
    from shop.product
)

select * from cte
where total_price > 100
```

## Functions
``` sql
select 
count(*)
max(price)
min(price)
avg(distinct price)
sum(price)
from shop.product

select 
row_number() over(order by price) as row_number, -- 1,2,3,4,5
rank() over(order by price) as rank, -- 1,2,2,4,5
dense_rank() over(order by price) as dense_rank -- 1,2,2,3,4
    to do: rank() over(order by price preceeding 1 following 4) as rank

lead(price) over(order by price) as next_price, -- next row
lag(price) over(order by price) as previous_price -- previous row
first_value(price) over(order by price) as first_price, -- first row
last_value(price) over(order by price) as last_price -- last row

ntile(4) over(order by price) as quartile -- 1,2,3,4
percent_rank() over(order by price) as percentile -- 0.0, 0.25, 0.5, 0.75, 1.0
cume_dist() over(order by price) as cumulative_distribution -- 0.0, 0.25, 0.5, 0.75, 1.0
from shop.product
```







