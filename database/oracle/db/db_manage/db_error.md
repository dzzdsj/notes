

### The listener supports no services

listener.ora添加

```
SID_LIST_LISTENER =  
(SID_LIST =  
  (SID_DESC =  
  (GLOBAL_DBNAME = orcl)
  (SID_NAME = orcl)
  )
)
```



```
lsnrctl status
lsnrctl start
lsnrctl stop
SQL>alter system register;
```

