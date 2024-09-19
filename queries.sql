create database [hatelovewear]

use [hatelovewear]

create schema [shop]

create table [shop].[product] (
    [product_id] int identity(1,1) primary key,
    [name] nvarchar(50),
    [price] decimal(10,2),
    [quantity] int,
    [size_id] int,
    -- foreign key ([size_id]) references [size]([size_id])
)

select * from shop.product