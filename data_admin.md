use [master] 
go
create login reporting_user with password = '';

use [db]
go
create user reporting_user for login reporting_user

alter role db_datareader add member reporting_user
or
grant select on invoice.corr_recpt_val_rprt_vw to reporting_user