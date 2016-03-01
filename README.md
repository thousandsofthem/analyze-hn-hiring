

Analyze data with:

```
CREATE EXTENSION IF NOT EXISTS "tablefunc";

SELECT *
FROM crosstab('
select date, keyword, count from keywords
where keyword=''postgres, postgresql'' OR keyword=''mysql''
ORDER BY 1,2'
) AS ct(row_name timestamp, "postgres, postgresql" integer, "mysql" integer);
```
