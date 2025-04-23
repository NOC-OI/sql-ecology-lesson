curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/init.sql

sqlplus -s bodc/bodc@//localhost/PORTAL_MAMMALS @init.sql

rm init.sql
