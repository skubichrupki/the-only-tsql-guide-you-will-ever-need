## data types
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

## variables
``` sql
declare @product_id int
set @product_id = 1

declare @last_order = (select max(order_id) from shop.order)
declare @tmp_table table (product_id int, price decimal(10,2))
```

## case statement
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