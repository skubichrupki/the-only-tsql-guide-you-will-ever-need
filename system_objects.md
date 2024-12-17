
## view definition check

``` sql
select v.name
,v.object_id
from sys.views as v
join sys.sql_modules as m on v.object_id = m.object_id
where m.definition like '%over%'
```