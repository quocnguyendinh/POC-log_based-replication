#!/bin/bash

# Get user input
read -p "Enter your operating system (mac os or linux): " os

# Convert input to lowercase
os=${os,,}

# Perform actions based on the input
if [[ "$os" == "mac os" ]]; then
    echo "Installing DuckDB on macOS using Homebrew..."
    brew install duckdb
elif [[ "$os" == "linux" ]]; then
    echo "Installing DuckDB on Linux..."
    wget https://github.com/duckdb/duckdb/releases/download/v1.0.0/duckdb_cli-linux-amd64.zip
    unzip duckdb_cli-linux-amd64.zip
    rm duckdb_cli-linux-amd64.zip
    echo "export PATH=\$PATH:$(pwd)/duckdb" >> ~/.bashrc
    source ~/.bashrc
    echo "DuckDB installed and path set."
else
    echo "Unsupported operating system. Please enter 'mac os' or 'linux'."
    exit 1
fi

duckdb data_warehouse.duckdb "CREATE TABLE INIT (id INTEGER);"