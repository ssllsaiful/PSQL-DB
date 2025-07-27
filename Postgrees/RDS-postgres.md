<h1 style="text-align: center;"><u>DB Backup From RDS-Postgres</u></h1>

Step 1: 
     Install PostgreSQL Client (if not already installed)
     First, ensure you have the PostgreSQL client installed on your Ubuntu EC2 instance:

     #in ubuntu server user postgresql client  for backup and restore db 

     sudo apt update
     sudo apt install postgresql-client -y

Step 2:

Find RDS Endpoint and Credentials

Here is an
 

example1:

     PGPASSWORD='trd$Xc*LTjkkkju3OrqzM#VVb' pg_dump -h host-name -U username -d -d ajpproductiondb -F c -b -v -f /home/ubuntu/filename.dump





details of  tags :

-h specifies the host (your RDS endpoint).

-U is the username.

-d is the database name.

-F c specifies the format (custom format is recommended for PostgreSQL).

-b includes large objects.

-v enables verbose mode for more detailed output.

-f specifies the path and filename for the backup file.


Step 3: 
     Create a Backup Directory (optional):
     mkdir -p ~/db_backups
     Run the pg_dump Command



Step 4:

<h3 style="text-align: center;"><u>automation using script and crontab and upload s3 bucket</u></h3>

step 1 :
     crete a bucket and  copy the bucket arn 
     ex:

<h3>code:</h3>

    #!/bin/bash

    # Database and S3 credentials
    DB_HOST="Hostnmae"
    DB_USER="username"
    DB_NAME="dbname"
    DB_PASSWORD='your-secure-password'  # Store sensitive information in a secure manner (e.g., environment variables)
    S3_BUCKET="s3://example/"

    # Date and file naming setup
    TIMESTAMP=$(date +%y_%m_%d)
    BACKUP_FILE="${DB_NAME}_${TIMESTAMP}_backup.dump"
    BACKUP_PATH="/home/ubuntu/$BACKUP_FILE"
    LOG_FILE="/home/ubuntu/${DB_NAME}_${TIMESTAMP}.log"

    # Create log file and set permissions
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    # Export database password for pg_dump
    export PGPASSWORD="$DB_PASSWORD"

    # Step 1: Perform backup and log output
    {
        echo "---- Backup Started on $(date) ----"
        pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -F c -b -v -f "$BACKUP_PATH"

        # Step 2: Check if backup was successful
        if [ $? -eq 0 ]; then
            echo "Backup of $DB_NAME completed successfully."

            # Step 3: Upload to S3 and check success
            if aws s3 cp "$BACKUP_PATH" "$S3_BUCKET"; then
                echo "Uploaded $BACKUP_FILE to S3 bucket."
            else
                echo "Error: Upload to S3 failed!"
            fi
        else
            echo "Error: Backup of $DB_NAME failed!"
        fi

        # Optional: Cleanup old backups (e.g., older than 7 days)
        find /home/ubuntu/ -type f -name "${DB_NAME}_*_backup.dump" -mtime +20 -exec rm {} \;

        echo "---- Backup Ended on $(date) ----"
    } >> "$LOG_FILE" 2>&1

    # Unset the PGPASSWORD
    unset PGPASSWORD
    # End of script


<h1><u> Copy db form s3</u></h1>

    aws configure

<h3><u>Restore the Backup</u></h3>

    aws s3 cp s3://filename-backup.dump /home/ubuntu


<h1><u> To restore your PostgreSQL backup file</u></h1>

example:

    PGPASSWORD='new_password' pg_restore -h target_host -U new_user -d new_database --no-owner --no-privileges --clean -v /home/ubuntu/filename-backup.dump


    PGPASSWORD='trd$Xyu6ju3OrqzM#VVb' pg_restore -h hostname -U ihub -d dbnmae --no-owner --no-privileges --clean -v /home/ubuntu/filename_backup.dump
--no-owner Restore with no owner "" --no-privileges no privileges "" --clean clear  DB before  restore 

<h3>command details :</h3>

        -h: Specifies the host (RDS instance endpoint).
        -U: Specifies the PostgreSQL user.
        -d: Specifies the name of the new database to restore into.
        -v: Enables verbose mode, showing more details of the restoration.
        ~/db_backups/your_database_backup.backup: The path to your backup file.


   

Step : final:

 Run below cmd after resote and if any permission issue happend 
open specific db or go to specific db by cmd or  pgadmin4 then run the following cmd 

 ```bash
 GRANT ALL PRIVILEGES ON DATABASE dbname TO username;


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO username;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO username;
GRANT USAGE ON SCHEMA public TO username;

```



change table  ownership:

```bash

DO $$
DECLARE
    tbl RECORD;
BEGIN
    FOR tbl IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' -- Replace 'public' with your schema name if different
    LOOP
        EXECUTE format('ALTER TABLE public.%I OWNER TO username;', tbl.tablename);
    END LOOP;
END $$;
```


<h3>Change DB View Owner  </h3>

 ```bash
DO $$ 
DECLARE 
    v_name TEXT;
BEGIN 
    FOR v_name IN 
        SELECT table_name FROM information_schema.views WHERE table_schema = 'public'
    LOOP 
        EXECUTE format('ALTER VIEW public.%I OWNER TO username', v_name);
    END LOOP;
END $$;

```

# Db size:

```bash
SELECT pg_size_pretty(pg_database_size('your_database_name')) AS database_size;
```

<h3> Total Database List check cmd</h3>

    SELECT datname FROM pg_database;
