#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to control XAMPP services (Apache and MySQL)
xampp_control() {
    local action=$1
    local services=("apache2" "mysql")
    local action_capitalized=$(echo "${action:0:1}" | tr 'a-z' 'A-Z')${action:1}
    [[ -z "$action" ]] && { echo "Usage: xampp_control <start|stop|restart|status>"; return 1; }
    echo "${action_capitalized}ing XAMPP services..."
    for service in "${services[@]}"; do
        sudo service "$service" "$action" && echo "XAMPP service $service ${action}ed" || echo "Failed to ${action} XAMPP service $service"
    done
}

# Function to create a new MySQL database
create_database() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    read -p "Enter the new database name: " DATABASE_NAME
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $DATABASE_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$DATABASE_NAME' created successfully."
    else
        echo "Failed to create database '$DATABASE_NAME'."
    fi
}

# Function to delete a MySQL database
delete_database() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    DATABASES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -v "Database\|information_schema\|performance_schema\|mysql\|sys")
    DATABASE_NAME=$(echo "$DATABASES" | fzf --height 40% --border --prompt="Select a database to delete: ")
    if [ -z "$DATABASE_NAME" ]; then
        echo "No database selected. Exiting..."
        exit 1
    fi
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE $DATABASE_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$DATABASE_NAME' deleted successfully."
    else
        echo "Failed to delete database '$DATABASE_NAME'."
    fi
}

# Function to create a new table
create_table() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    DATABASES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -v "Database\|information_schema\|performance_schema\|mysql\|sys")
    DATABASE_NAME=$(echo "$DATABASES" | fzf --height 40% --border --prompt="Select a database to add a table: ")
    if [ -z "$DATABASE_NAME" ]; then
        echo "No database selected. Exiting..."
        exit 1
    fi
    read -p "Enter the new table name: " TABLE_NAME
    read -p "Enter columns definition (e.g., id INT PRIMARY KEY, name VARCHAR(100)): " COLUMNS_DEFINITION
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; CREATE TABLE $TABLE_NAME ($COLUMNS_DEFINITION);"
    if [ $? -eq 0 ]; then
        echo "Table '$TABLE_NAME' created successfully in database '$DATABASE_NAME'."
    else
        echo "Failed to create table '$TABLE_NAME'."
    fi
}

# Function to delete a table
delete_table() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    DATABASES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -v "Database\|information_schema\|performance_schema\|mysql\|sys")
    DATABASE_NAME=$(echo "$DATABASES" | fzf --height 40% --border --prompt="Select a database: ")
    if [ -z "$DATABASE_NAME" ]; then
        echo "No database selected. Exiting..."
        exit 1
    fi
    TABLES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; SHOW TABLES;" | grep -v "Tables_in_")
    TABLE_NAME=$(echo "$TABLES" | fzf --height 40% --border --prompt="Select a table to delete: ")
    if [ -z "$TABLE_NAME" ]; then
        echo "No table selected. Exiting..."
        exit 1
    fi
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; DROP TABLE $TABLE_NAME;"
    if [ $? -eq 0 ]; then
        echo "Table '$TABLE_NAME' deleted successfully from database '$DATABASE_NAME'."
    else
        echo "Failed to delete table '$TABLE_NAME'."
    fi
}

# Function to edit a table structure
edit_table_structure() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    DATABASES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -v "Database\|information_schema\|performance_schema\|mysql\|sys")
    DATABASE_NAME=$(echo "$DATABASES" | fzf --height 40% --border --prompt="Select a database: ")
    if [ -z "$DATABASE_NAME" ]; then
        echo "No database selected. Exiting..."
        exit 1
    fi
    TABLES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; SHOW TABLES;" | grep -v "Tables_in_")
    TABLE_NAME=$(echo "$TABLES" | fzf --height 40% --border --prompt="Select a table to edit: ")
    if [ -z "$TABLE_NAME" ]; then
        echo "No table selected. Exiting..."
        exit 1
    fi
    echo "Editing table structure for '$TABLE_NAME' in database '$DATABASE_NAME'."

    # Menu options for ALTER TABLE
    ALTER_OPTION=$(echo -e "Add Column\nDrop Column\nModify Column\nChange Column\nRename Table" | fzf --height 40% --border --prompt="Select ALTER TABLE operation: ")

    case "$ALTER_OPTION" in
        "Add Column")
            read -p "Enter the column definition to add (e.g., column_name COLUMN_TYPE): " COLUMN_DEFINITION
            ALTER_COMMAND="ADD COLUMN $COLUMN_DEFINITION"
            ;;
        "Drop Column")
            COLUMNS=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; SHOW COLUMNS FROM $TABLE_NAME;" | awk '{print $1}' | tail -n +2)
            COLUMN_NAME=$(echo "$COLUMNS" | fzf --height 40% --border --prompt="Select a column to drop: ")
            ALTER_COMMAND="DROP COLUMN $COLUMN_NAME"
            ;;
        "Modify Column")
            COLUMNS=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; SHOW COLUMNS FROM $TABLE_NAME;" | awk '{print $1}' | tail -n +2)
            COLUMN_NAME=$(echo "$COLUMNS" | fzf --height 40% --border --prompt="Select a column to modify: ")
            read -p "Enter the new definition for column '$COLUMN_NAME' (e.g., column_name NEW_COLUMN_TYPE): " COLUMN_DEFINITION
            ALTER_COMMAND="MODIFY COLUMN $COLUMN_DEFINITION"
            ;;
        "Change Column")
            COLUMNS=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; SHOW COLUMNS FROM $TABLE_NAME;" | awk '{print $1}' | tail -n +2)
            COLUMN_NAME=$(echo "$COLUMNS" | fzf --height 40% --border --prompt="Select a column to change: ")
            read -p "Enter the new column name and definition (e.g., new_column_name NEW_COLUMN_TYPE): " COLUMN_DEFINITION
            ALTER_COMMAND="CHANGE COLUMN $COLUMN_NAME $COLUMN_DEFINITION"
            ;;
        "Rename Table")
            read -p "Enter the new table name: " NEW_TABLE_NAME
            ALTER_COMMAND="RENAME TO $NEW_TABLE_NAME"
            ;;
        *)
            echo "Invalid option selected."
            exit 1
            ;;
    esac

    # Execute the ALTER TABLE command
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $DATABASE_NAME; ALTER TABLE $TABLE_NAME $ALTER_COMMAND;"
    if [ $? -eq 0 ]; then
        echo "Table '$TABLE_NAME' structure updated successfully."
    else
        echo "Failed to update table structure for '$TABLE_NAME'."
    fi
}



# Function to copy a folder to htdocs
copy_folder_to_htdocs() {
    source_folder=$(find ~/ -mindepth 1 -maxdepth 1 -type d | fzf --prompt="Select source folder to copy: " --height=40% --border --header="Source Folders")
    
    if [[ -n "$source_folder" ]]; then
        sudo cp -r "$source_folder" /var/www/html/
        echo "Folder $source_folder has been copied to /var/www/html."
    else
        echo "No source folder selected. Exiting."
        exit 1
    fi
}

# Function to export a MySQL database
export_database() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    DATABASES=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -v "Database\|information_schema\|performance_schema\|mysql\|sys")
    DATABASE_NAME=$(echo "$DATABASES" | fzf --height 40% --border --prompt="Select a database to export: ")
    if [ -z "$DATABASE_NAME" ]; then
        echo "No database selected. Exiting..."
        exit 1
    fi
    read -p "Enter the output file name (without extension): " OUTPUT_FILE
    mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" "$DATABASE_NAME" > "${OUTPUT_FILE}.sql"
    if [ $? -eq 0 ]; then
        echo "Database '$DATABASE_NAME' exported successfully to '${OUTPUT_FILE}.sql'."
    else
        echo "Failed to export database '$DATABASE_NAME'."
    fi
}

# Function to import a MySQL database
import_database() {
    read -sp "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    read -p "Enter the new database name: " DATABASE_NAME
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $DATABASE_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$DATABASE_NAME' created successfully."
    else
        echo "Failed to create database '$DATABASE_NAME'. Exiting..."
        exit 1
    fi
    SQL_FILE=$(find ~/ -type f -name "*.sql" | fzf --height 40% --border --prompt="Select SQL file to import: ")
    if [ -z "$SQL_FILE" ]; then
        echo "No file selected. Exiting..."
        exit 1
    fi
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DATABASE_NAME" < "$SQL_FILE"
    if [ $? -eq 0 ]; then
        echo "File '$SQL_FILE' imported successfully into database '$DATABASE_NAME'."
    else
        echo "Failed to import file '$SQL_FILE'."
    fi
}

# Main function to select the action
main_menu() {
    echo -e "Start XAMPP\nStop XAMPP\nRestart XAMPP\nCheck XAMPP Status\nCreate MySQL Database\nDelete MySQL Database\nCreate MySQL Table\nDelete MySQL Table\nEdit MySQL Table Structure\nCopy Folder to htdocs\nExport MySQL Database\nImport MySQL Database" | fzf --prompt="Select Action: " --height=20% --border
}

# Select the action and execute the corresponding function
action=$(main_menu)

case "$action" in
    "Start XAMPP")
        xampp_control start
        ;;
    "Stop XAMPP")
        xampp_control stop
        ;;
    "Restart XAMPP")
        xampp_control restart
        ;;
    "Check XAMPP Status")
        xampp_control status
        ;;
    "Create MySQL Database")
        create_database
        ;;
    "Delete MySQL Database")
        delete_database
        ;;
    "Create MySQL Table")
        create_table
        ;;
    "Delete MySQL Table")
        delete_table
        ;;
    "Edit MySQL Table Structure")
        edit_table_structure
        ;;
    "Copy Folder to htdocs")
        copy_folder_to_htdocs
        ;;
    "Export MySQL Database")
        export_database
        ;;
    "Import MySQL Database")
        import_database
        ;;
    *)
        echo "Invalid action selected"
        exit 1
        ;;
esac
