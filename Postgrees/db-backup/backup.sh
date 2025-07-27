#!/bin/bash

# Database credentials and S3 bucket details
DB_HOST="psql-cms-rds.cimek2zxs3ca.us-west-1.rds.amazonaws.com"  # Local PostgreSQL server
DB_USER="ihub"
DB_NAME="amardesh-db"
DB_PASSWORD='trd$Xc*LTju3OrqzM#VVb'
#S3_BUCKET="s3://ideahubdbbackup/rds-postgrees-db-backup/"
S3_BUCKET="s3://ideahubdbbackup/amardesh-db-backup/"
# Date and time format for backup file name
TIMESTAMP=$(date +"%Y_%m_%d_%I:%M%p")
BACKUP_FILE="${DB_NAME}_${TIMESTAMP}_backup.dump"
BACKUP_PATH="/home/ubuntu/amardesh-db/$BACKUP_FILE"

# Log file
LOG_FILE="/home/ubuntu/amardesh-db/${DB_NAME}_${TIMESTAMP}.log"
touch "$LOG_FILE"

# Create .pgpass file for secure password storage (optional, for local use)
echo "psql-cms-rds.cimek2zxs3ca.us-west-1.rds.amazonaws.com:5432:$DB_NAME:$DB_USER:$DB_PASSWORD" > ~/.pgpass
chmod 600 ~/.pgpass  # Secure the .pgpass file

# Step 1: Create a backup of the database and log output
{
    echo "---- Backup Started on $(date) ----"
    pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME -F c -b -v -f "$BACKUP_PATH"

    # Step 2: Check if the dump was successful
    if [ $? -eq 0 ]; then
        echo "Backup of $DB_NAME completed successfully."

        # Step 3: Upload the backup file to S3
        aws s3 cp "$BACKUP_PATH" "$S3_BUCKET"
        echo "Uploaded $BACKUP_FILE to S3 bucket."
    else
        echo "Error: Backup of $DB_NAME failed!"
    fi

    # Optional: Cleanup old backups locally (e.g., older than 20 days)
    find /home/ubuntu/amardesh-db/ -type f -name "${DB_NAME}_*_backup.dump" -mtime +20 -exec rm {} \;

    echo "---- Backup Ended on $(date) ----"
} >> "$LOG_FILE" 2>&1

# Remove .pgpass for security (optional)
rm ~/.pgpass

