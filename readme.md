# the only T-SQL guide you'll ever need

- [About](#About)
- [Data Types](#Data-Types)
- [Creating SQL objects](#Creating-SQL-objects)
- [CRUD](#Selecting-data)
- [SQL Functions](#Aggregate-Functions)
- [Dynamic SQL](#Dynamic-SQL)
- [Transactions](#Transactions)

## Data Types
``` sql
- product_id int, bigint, smallint, tinyint -- whole number
- price decimal(10,2) -- decimal number with 10 digits and 2 of them are after the decimal point
- name nvarchar(50) -- string, maximum length of 50 characters
- release_date datetime, datetime2, date, time
- is_archived bit --  can be 0 or 1
- uuid uniqueidentifier -- (GUID) like 123e4567-e89b-12d3-a456-426614174000
- price money -- $123.45
- table
- cursor -- iterates through a result set
```

## Creating SQL objects
``` sql 
create database hatelovewear

use hatelovewear

create schema shop
```
``` sql 
create table shop.product (
    product_id int identity(1,1) primary key, -- auto increment by 1, starting from 1, unique and not null
    name nvarchar(50),
    price decimal(10,2),
    quantity int,
    size_id int -- foreign key

    foreign key (size_id) references size(size_id) -- foreign key `constraint`, `size_id` in `product` table must exist in `size` table
)
```

## Dropping SQL objects
``` sql
drop table shop.product
drop schema shop
drop database hatelovewear
```

## Altering SQL objects
``` sql
alter table shop.product
add [supplier_id] nvarchar(max)
drop column [supplier_id]
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
truncate table shop.product -- reset identity column
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

## Aggregate Functions
``` sql
select 
count(*)
max(price)
min(price)
avg(distinct price)
sum(price)
from shop.product -- each can be a window function
```

## Window Functions
``` sql
select 
row_number() over(order by price) as row_number, -- 1,2,3,4,5
rank() over(order by price) as rank, -- 1,2,2,4,5
dense_rank() over(order by price) as dense_rank -- 1,2,2,3,4

sum() over(order by price rows between 3 preceeding and current row) as rank -- 3 previous rows and current row
sum() over(order by price rows between 3 preceeding and 1 following) as rank -- 3 previous rows up to 1 next row

lead(price) over(order by price) as next_price, -- next row
lag(price) over(order by price) as previous_price -- previous row
first_value(price) over(order by price) as first_price, -- first row
last_value(price) over(order by price) as last_price -- last row

ntile(4) over(order by price) as quartile -- 1,2,3,4
percent_rank() over(order by price) as percentile -- 0.0, 0.25, 0.5, 0.75, 1.0
cume_dist() over(order by price) as cumulative_distribution -- 0.0, 0.25, 0.5...
from shop.product
```

## Merge
``` sql
merge shop.product as target -- target table
using stage.product as source -- source table 
on target.product_id = source.product_id -- join condition
when matched then -- update target row with source data 
update
set target.product_name = source.product_name
when not matched then -- insert source row into target table
insert (product_id, product_name)
values (source.product_id, source.product_name); 
```

## Dynamic SQL
``` sql
declare @table_name = 'product' -- no need for single quotes
declare @file_path = 'C:\Users\user\Documents\product.csv' -- need single quotes

declare @sql nvarchar(max)
set @sql = 'bulk insert etl.' + @table_name + ' from ''' + @file_path + ''''

-- result: bulk insert etl.product from 'C:\Users\user\Documents\product.csv'

-- for 'uri' in dynamic sql: ' ends string, '' single quote, variable, '' single quote, ' starts string
-- bulk means insert data from a file

exec sp_executesql @sql
```

## Transactions
- commit transaction: save changes
``` sql
begin transaction

update shop.product
set price = 100.00
where product_id = 1

select @@trancount -- 1
commit transaction
select @@trancount -- 0
```
- rollback transaction: undo changes
``` sql
begin transaction

update shop.product
set price = 100.00
where product_id = 1

select @@trancount -- 1
rollback transaction
select @@trancount -- 0
```
- savepoint: save a point in the transaction
``` sql
begin transaction

    update shop.product
    set price = 100.00
    where product_id = 1

save transaction savepoint1

    delete from shop.product
    where product_id = 1

rollback transaction savepoint1 -- rollback to savepoint1
```

- auto rollback: if an error occurs, the transaction will be rolled back
``` sql
begin transaction

insert into shop.product
values (20, 80.00, 50, 2)
select @@trancount -- 1

insert into shop.product
values ('sql', 80.00, 100, 1)
-- error: conversion failed when converting the nvarchar value 'sql' to data type int

select @@trancount -- 0

commit transaction -- will not be executed, transaction is rolled back
```

## Procedures
``` sql
AS
BEGIN

create procedure [dbo].[data_process]
@process_id bigint,
@process_date datetime2 = null -- default value null

insert into [dbo].[table]
	([process_id]
	,[process_date]
	,[log_date])
values
	(@process_id
	,@process_date
	,getdate())

print('data processed');

END
GO
```
