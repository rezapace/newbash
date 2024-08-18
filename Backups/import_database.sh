#!/bin/bash

# Prompt for MySQL root password
read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
echo

# Prompt for the new database name
read -p "Enter the new database name: " DATABASE_NAME

# Create the new database
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $DATABASE_NAME;"

if [ $? -eq 0 ]; then
  echo "Database '$DATABASE_NAME' created successfully."
else
  echo "Failed to create database '$DATABASE_NAME'. Exiting..."
  exit 1
fi

# Allow user to select SQL file using fzf
SQL_FILE=$(find /home/r/github/app-weding/database -type f -name "*.sql" | fzf --height 40% --border --prompt="Select SQL file to import: ")

if [ -z "$SQL_FILE" ]; then
  echo "No file selected. Exiting..."
  exit 1
fi

# Import the selected SQL file into the new database
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DATABASE_NAME" < "$SQL_FILE"

if [ $? -eq 0 ]; then
  echo "File '$SQL_FILE' imported successfully into database '$DATABASE_NAME'."
else
  echo "Failed to import file '$SQL_FILE'."
fi
