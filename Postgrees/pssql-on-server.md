<h1 style="text-align: center;"><u>Full DB Backup From one Postgres server to another </u></h1>

Step1 :

Run this cmd:

    sudo -i -u postgres



Step2 :

Run this cmd: 
```bash
pg_dumpall > /tmp/all_databases.sql

```


this cmd  will copy to full psql  db including  user, permission, and others 


Step3 :

Run this cmd: 
```bash
ls -lh /tmp/all_databases.sql
```
this cmd will show  the file  with storage capacity of this db 

if get any error or no permission issue 


Run:
```bash
sudo -i
```

Step-4 :
after successfully dump all cmd execute tranfer this file to new server
     
Run this cmd: 


<h1> if it is  manages RDS like AWS </h1>

example:
```bash
export PGPASSWORD='your-rds-password'
psql -h your-rds-endpoint -U master-username -d postgres -f /tmp/all_databases.sql
```

```bash
export PGPASSWORD='trd$87809909787Xc*99LTju3OrqzM#VVb'
psql -h server-ip/domain -U username -d dbname -f /tmp/all_databases.sql
```
Step-5 :

Switch to the postgres user on the new server:

    sudo -i -u postgres


    psql < /tmp/all_databases.sql


    psql

step-6: 

<h3>now check the  db </h3>


Step : final:

 Run belwo cmd after resote and if any permission issue happend 


 ```bash
 GRANT ALL PRIVILEGES ON DATABASE bdgen24new TO bdgen24newuser;


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bdgen24newuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bdgen24newuser;
GRANT USAGE ON SCHEMA public TO bdgen24newuser;

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
        EXECUTE format('ALTER VIEW public.%I OWNER TO dbuser', v_name);
    END LOOP;
END $$;

```

# Fetch DB base site 
 ```bash
SELECT pg_size_pretty(pg_database_size('db-name')) AS db_size;
```