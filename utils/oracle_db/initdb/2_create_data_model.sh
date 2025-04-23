#!/bin/bash

# Download init.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/init.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/surveys.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/species.sql
curl -LJO https://raw.githubusercontent.com/NOC-OI/sql-ecology-lesson/refs/heads/main/utils/oracle_db/data/plots.sql


NUM_USERS=20  # Same number as in generate_users.sh
PREFIX="BODC"
PDB="PORTAL_MAMMALS"
PWD="bodc"
sqlplus -s bodc/bodc@//localhost/${PDB} @init.sql
sqlplus -s bodc/bodc@//localhost/${PDB} @surveys.sql
sqlplus -s bodc/bodc@//localhost/${PDB} @species.sql
sqlplus -s bodc/bodc@//localhost/${PDB} @plots.sql

for i in $(seq 1 $NUM_USERS); do
  USER="${PREFIX}${i}"
  PASSWORD="${PWD}${i}"

  echo "Populating schema for $USER..."

  sqlplus -s ${USER}/${PASSWORD}@//localhost/${PDB} @init.sql
done

# Clean up
rm init.sql
rm surveys.sql
rm species.sql
rm plots.sql
