<p>This commnad will backup and restore directly ;
form one database Server to another database Server  without lossing any 
DB;
Permission;
Table;

</p>

<p>Its will  only work on server . not for  manageable DB like AWS RDS </p>


<p><h4>This will Restore full of DataBase from One Server to another Server</h4></p>


<h3> BACKUP full DB FROM EXISTING DB  </h3>


Run below cmd on server end.

```bash
pg_dumpall \
    --host="domain/iP address of server" \
    --port=5432 \
    --username="DB admin user name" \
    --file=full_backup.sql
```

After success fully end the backup move/copy the full_backup.sql to new server then run below cmd. 

<h3> RESTORE TO CURRRENT DB FROM EXISTING DB </h3>



```bash

psql \
    --host=localhost \
    --port=5432 \
    --username="DB admin user name" \
    --file=full_backup.sql
```