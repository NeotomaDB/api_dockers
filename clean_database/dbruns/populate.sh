#!/bin/sh
set -e

DATABASE=neotoma
PGUSER=postgres
PGHOST=0.0.0.0
PGPORT=5432

# mkdir -p dbout
# if [ ! -f /tmp/pg_data/clean_dump.tar.gz ]; then
#     wget https://neotoma-remote-store.s3.us-east-2.amazonaws.com/clean_dump.tar.gz --no-check-certificate -P /tmp/pg_data/
# fi
mkdir -p /pg_data
tar -xf /data/clean_dump.tar.gz -C /pg_data/


psql -v ON_ERROR_STOP=1 --username "$PGUSER" --dbname postgres <<-EOSQL
DROP DATABASE IF EXISTS neotoma;
CREATE DATABASE neotoma;
\c neotoma
CREATE EXTENSION postgis;
CREATE EXTENSION pg_trgm;
EOSQL

psql -U $PGUSER -h $PGHOST -p $PGPORT -d $DATABASE -f /pg_data/archives/neotoma_clean.sql


