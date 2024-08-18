#!/bin/bash

# Prompt for MySQL root password
read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
echo

# Get a list of databases
DATABASES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -v "Database\|information_schema\|performance_schema\|mysql\|sys")

# Let the user select a database using fzf
DATABASE_NAME=$(echo "$DATABASES" | fzf --height 40% --border --prompt="Select a database to export: ")

if [ -z "$DATABASE_NAME" ]; then
  echo "No database selected. Exiting..."
  exit 1
fi

# Prompt for the output file name
read -p "Enter the output file name (without extension): " OUTPUT_FILE

# Perform the export using mysqldump
mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" "$DATABASE_NAME" > "${OUTPUT_FILE}.sql"

if [ $? -eq 0 ]; then
  echo "Database '$DATABASE_NAME' exported successfully to '${OUTPUT_FILE}.sql'."
else
  echo "Failed to export database '$DATABASE_NAME'."
fi
