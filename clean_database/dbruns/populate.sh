#!/bin/sh
set -e

DATABASE=neotoma
PGUSER=postgres
PGHOST=0.0.0.0
PGPORT=5432

mkdir -p dbout
if [ ! -f /tmp/pg_data/clean_dump.tar.gz ]; then
    wget https://neotoma-remote-store.s3.us-east-2.amazonaws.com/clean_dump.tar.gz --no-check-certificate -P /tmp/pg_data/
fi

tar -xf /tmp/pg_data/clean_dump.tar.gz -C /tmp/pg_data/

psql -v ON_ERROR_STOP=1 --username "$PGUSER" --dbname postgres <<-EOSQL
CREATE DATABASE IF NOT EXISTS neotoma;
CREATE EXTENSION postgis;
CREATE EXTENSION pg_trgm;

EOSQL

pg_restore -U $PGUSER -h $PGHOST -p $PGPORT -c --no-owner --no-privileges -d $DATABASE /tmp/pg_data/neotoma_clean.sql
