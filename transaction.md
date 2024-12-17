## transactions
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