## procedures
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

## dynamic SQL
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