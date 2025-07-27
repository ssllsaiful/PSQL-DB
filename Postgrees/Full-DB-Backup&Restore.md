<p>This commnad will backup and restore directly ;
form one database to current database without lossing any 
DB;
Permission;
Table;
this is so beautiful db  restore system ;
</p>


<p>But The problem is its only work on server base no manageable DB like AWS RDS will work on it </p>


<p><h4>This will Restore full of DataBase for One Server to another Server</h4></p>


<h3> BACKUP full DB FROM EXISTING DB  </h3>

```bash
pg_dumpall \
    --host=cmsdb.ideahubbd.com \
    --port=5432 \
    --username=ihub \
    --file=full_backup.sql
```

<h3> RESTORE TO CURRRENT DB FROM EXISTING DB </h3>

```bash

psql \
    --host=localhost \
    --port=5432 \
    --username=postgres \
    --file=full_backup.sql
```