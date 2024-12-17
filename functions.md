## aggregate functions
``` sql
select 
count(*)
max(price)
min(price)
avg(distinct price)
sum(price)
from shop.product -- each can be a window function
```

## window Functions
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

## dates and times
```
CAST(GETDATE() AS nvarchar(50)) AS string_date
,CAST('420,69' AS DECIMAL(3,2)) AS string_to_decimal 
,CONVERT(VARCHAR(20), birthdate, 11)
,TRY_CONVERT(VARCHAR(20), birthdate, 11) -- nulls the values that didnt work in convert
,CONVERT(DECIMAL(3,2), '420.69') AS string_to_decimal -- only IN SQL server
,PARSE(birthdate AS DATE USING de-de)

,GETDATE()
,GETUTCDATE(), CURRENT_TIMESTAMP
,SYSDATETIME(), SYSUTCDATETIME()
,YEAR(@Date), MONTH(@Date), DAY(@Date) 
,DATEPART(DAYOFYEAR, @Date)
,DATENAME(WEEKDAY, @Date)
,DATEADD(DAY, 14, @Date)
,DATEDIFF(HOUR, @ins_date, GETDATE())

,FORMAT(@Date, 'd', 'pl-PL'), FORMAT(@Date, 'dd-MM-YYYY'), FORMAT(123456, '-')
,FORMAT(CAST('2018-01-01 14:00' AS datetime2), N'HH:mm') -- 14:00
```

## strings
``` sql
,LEN(@string)
,LOWER(@mystring) -- lowercase 
,UPPER(@mystring) -- uppercase
,LEFT(@mystring, 3) -- last 3 characters
,RIGHT(@mystring, 3) -- first 3 characters
,LTRIM(@string) -- trim from left
,RTRIM(@string) -- trim from right
,TRIM() -- trimming blanks
,REPLACE('I LIKE pizza', 'pizza', 'burgir') -- i LIKE burgir
,SUBSTRING('I LIKE pizza', 7, 5) -- pizza (position, numer of letters)
,CONCAT('string1', 'string2'), CONCAT_WS(' ', 'string1', 'string2') -- IN ws you SELECT a separator
,STRING_AGG(first_name, ',' ) WITHIN GROUP (ORDER BY first_name ASC) -- list of strings - useful WITH GROUP BY (YEAR for example)
,STRING_AGG(CONCAT(first_name, CHAR(13))) -- carriage RETURN
,CHARINDEX('pizza', 'i LIKE pizza AND burgir', 5) -- third parameter IS optional, USE > 0 OR = 0 (IN WHERE)
,PATINDEX('%[xwq]%', last_name) -- can USE wildcards % _ []
```

## math
``` sql
,ABS(@amount) -- non negative VALUE
,SIGN(@amount) -- RETURN -1,0,1 based IF negative
,CEILING(@amount) -- rounds to TOP
,FLOOR(@amount) -- rounds to bottom
,ROUND(@amount, 2) -- rounds to 2 decimals
,POWER(@amount, 3) -- ^3
,SQUARE(@amount) -- ^2
,SQRT(@amount) -- ^(1/2)
,RAND() -- random FROM 0-1, can also be used IN ORDER BY to RETURN random ROWS
```