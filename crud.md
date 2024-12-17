## selecting data
``` sql
select distinct product_id from shop.product
```

## inserting data

- insert multiple rows
``` sql
insert into shop.product 
(name, price, quantity, size_id)
values 
('sql', 80.00, 100, 1),
('sql', 80.00, 50, 2),
```

- backup table (if backup table exists)
``` sql
insert into shop.product_archive 
select * from shop.product
where is_archived = 1
```

- backup table (if backup table doesnt exists)
``` sql
select * into shop.product_backup 
from shop.product
```

## updating data
``` sql
update shop.product
set price = 100.00
where product_id = 1
```

## deleting data
``` sql
delete from shop.product
where product_id = 1
```
``` sql
truncate table shop.product -- reset identity column
```
## merge
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