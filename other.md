## identity Insert
``` sql
SET IDENTITY_INSERT [invoice].[docs_numerator_lkp] ON
INSERT [dbo].[status] ([status_id], ... ) VALUES (5, ...)
SET IDENTITY_INSERT [invoice].[docs_numerator_lkp] OFF
```

## sequences
``` sql
CREATE SEQUENCE order_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 1000;

INSERT INTO Orders (order_id, customer_id, order_date)
VALUES (CONVERT(nvarchar, NEXT VALUE FOR order_seq) + '/' + YEAR(@date), '244', GETDATE());
```
