# Prepare data

* configure postrges & credentials in `config.yml`
* create table `keywords`

```sql
CREATE TABLE keywords (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    keyword character varying NOT NULL,
    count integer NOT NULL
);
```
* Add new thread IDs to `config.yml`

# Run script

* `ruby analyze.rb`
* `ruby report.rb`
* open generated html



# Misc

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
