
# Restore the Backup

Step1: 

Collect .dump file ex:

    aws s3 cp s3://filename-backup.dump /home/ubuntu/backup/



# Restore  PostgreSQL backup file

Step2:


    PGPASSWORD='db-server-admin-passwd' pg_restore -h hostname -U username -d dbnmae --no-owner --no-privileges --clean -v /home/ubuntu/filename_backup.dump



<h3>command details :</h3>

        -h: Specifies the host (RDS instance endpoint).
        -U: Specifies the PostgreSQL user.
        -d: Specifies the name of the new database to restore into.
        -v: Enables verbose mode, showing more details of the restoration.
        ~/db_backups/your_database_backup.backup: The path to your backup file.


   
# Restored DB permission

Step3:

 Run below cmd after resote and if any permission issue happend 
open specific db or go to specific db by cmd or  pgadmin4 then run the following cmd's

 ```bash

 GRANT ALL PRIVILEGES ON DATABASE dbname TO username;


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO username;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO username;
GRANT USAGE ON SCHEMA public TO username;

```



# change table  ownership:

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


# Change DB View Owner

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

# Show Db size:

```bash
SELECT pg_size_pretty(pg_database_size('your_database_name')) AS database_size;
```