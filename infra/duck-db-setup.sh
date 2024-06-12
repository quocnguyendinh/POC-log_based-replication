#!/bin/bash

echo "Installing DuckDB on Linux..."
wget https://github.com/duckdb/duckdb/releases/download/v1.0.0/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip
rm duckdb_cli-linux-amd64.zip
echo "export PATH=\$PATH:$(pwd)/duckdb" >> ~/.bashrc
source ~/.bashrc
echo "DuckDB installed and path set."

duckdb data_warehouse.duckdb "CREATE TABLE INIT (id INTEGER);"