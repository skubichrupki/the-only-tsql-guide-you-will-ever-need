# the only T-SQL guide you'll ever need

## creating SQL objects
``` sql 
create database allegro

use allegro
create schema stg
```

## creating table
``` sql 
create table stg.orders (
    order_id int identity(1,1) primary key,
    name nvarchar(50),
    price decimal(10,2),
    quantity int,
    buyer_id int -- foreign key
)
```

## deleting objects 
``` sql
drop table stg.orders
drop schema stg
drop database allegro
```

## altering objects
``` sql
alter table stg.orders
add [supplier_name] nvarchar(max) -- add column

drop column [supplier_name] -- delete column

alter column supplier_name nvarchar(50); -- change column data type 
```