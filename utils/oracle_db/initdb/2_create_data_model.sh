#!/bin/bash

# Download init.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/init.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/surveys1.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/surveys2.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/surveys3.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/surveys4.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/species.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/plots.sql


NUM_USERS=20  # Same number as in generate_users.sh
PREFIX="BODC"
PDB="DIGIOCEAN"
PWD="bodc"
sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @init.sql
sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @surveys1.sql
sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @surveys2.sql
sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @surveys3.sql
sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @surveys4.sql
# sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @species.sql
sqlplus -s ${PREFIX}/${PWD}@//localhost/${PDB} @plots.sql

for i in $(seq 1 $NUM_USERS); do
  USER="${PREFIX}${i}"
  PASSWORD="${PWD}${i}"

  echo "Populating schema for $USER..."

  sqlplus -s ${USER}/${PASSWORD}@//localhost/${PDB} @init.sql
done

# Clean up
rm init.sql
rm surveys1.sql
rm surveys2.sql
rm surveys3.sql
rm surveys4.sql
rm species.sql
rm plots.sql
