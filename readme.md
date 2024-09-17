# the only T-SQL guide you'll ever need

- [About](#About)
- [Data Types](#Data-Types)
- [Creating SQL objects](#Creating-SQL-objects)
- [Inserting data](#Inserting-data)

## About
- this is a collection of T-SQL queries and functions that I have found useful in my work
- you can practice along with this guide, but you need 2 things running on your pc
    - [SQL Server Instance](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
    - software to run T-SQL queries, like [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) or [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)

## Data Types
``` sql
- [product_id] int
- [price] decimal(10,2)
- [name] nvarchar(50)
- [release_date] datetime, datetime2, date, time
- [is_archived] bit
- [uuid] uniqueidentifier
- [price] money 
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
- `table` is a table type
- `cursor` is a cursor type, which is used to iterate through a result set

btw, the square brackets like in `[product_id]` are used to avoid errors when the object name is a reserved keyword, like  `name`, `time` or to avoid spaces in the object name, generally its a good practice to use them

## Creating SQL objects
in this chapter i'll create a database for clothing store called `hatelovewear`, with a schema `shop` and a table `product` with some columns

- Create new Database
``` sql 
create database [hatelovewear]
```
-  To use the already created database, just use 
``` sql 
use [hatelovewear]
```

- Create new Schema
``` sql
create schema [shop]
```
schema is a container for objects, like tables, views, procedures, etc. it is a way to organize the database, you can have multiple schemas in your database.

- Create new Table <br>
``` sql 
create table [shop].[product] (
    [product_id] int identity(1,1) primary key,
    [name] nvarchar(50),
    [price] decimal(10,2),
    [quantity] int,
    [size_id] int,
    (tbd) foreign key ([size_id]) references [size]([size_id])
)
```
- `product_id` is an integer
- `identity` means `product_id` will auto increment by 1, starting from 1 when a new row is inserted
- `primary key` means `product_id` is unique and not null
- `size_id` is a `foreign key`, referencing to another table, in this case `[size]` table, and its `[size_id]` column (this table doesnt exist yet)
- (tbd) the last statement is the foreign key `constraint`, which means `size_id` in `product` table must exist in `[size]` table

<br> the objects selection chain is `[database].[schema].[object]` which in our case would be:
``` sql
[hatelovewear].[shop].[product]
```

## Inserting data
new hoodie 'hatelove sql' has been released in size 'S' (x100) and 'L' (x50) 
<br> its price is 80.00
<br> lets insert it into the `product` table

- Insert multiple rows
``` sql
insert into [shop].[product] 
([name], [price], [quantity], [size_id])
values 
('sql', 80.00, 100, 1),
('sql', 80.00, 50, 2),
```


