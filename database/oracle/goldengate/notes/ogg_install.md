## ogg安装配置

### 软件安装

```
mkdir /ogg
useradd -u 53321 -g oinstall ogg
chown ogg:oinstall /ogg
passwd ogg
su - ogg
cd /ogg

vi ~/.bash_profile
追加
umask 022
export ORACLE_SID=dzzdsjdb
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19c/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export NLS_DATE_FORMAT="YYYY-MM-DD HH24:MI:SS"
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export ORACLE_PATH=.:$ORACLE_BASE/dba_scripts/sql:$ORACLE_HOME/rdbms/admin
export SQLPATH=$ORACLE_HOME/sqlplus/admin
export NLS_LANG="AMERICAN_AMERICA.AL32UTF8"

export OGG_HOME=/ogg
export PATH=$OGG_HOME:$PATH


cp /opt/software/191004_fbo_ggs_Linux_x64_shiphome.zip .
unzip 191004_fbo_ggs_Linux_x64_shiphome.zip

export DISPLAY=172.20.10.2:0.0
sh /ogg/fbo_ggs_Linux_x64_shiphome/Disk1/runInstaller
```

### 归档模式和配置变更

```
--开启归档日志、强制日志模式、附加日志
select log_mode,force_logging from v$database;
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;
alter database force logging;
alter database add supplemental log data;
alter system switch logfile;
show parameter ENABLE_GOLDENGATE_REPLICATION;
alter system set ENABLE_GOLDENGATE_REPLICATION = TRUE SCOPE = BOTH;
```

### 配置数据库ogg用户

```
create tablespace ogg_tbs datafile '/oracle/app/oracle/oradata/DZZDSJDB/ogg01.dbf' size 10m autoextend on next 10m maxsize 30G;

create user ogg identified by ogg default tablespace dzzdsj_tbs temporary tablespace tmp_dzzdsj_tbs profile unlimited_profile;
```



```sql
grant connect to ogg;
grant resource to ogg;
grant select any dictionary to ogg;
grant select any table to ogg;
grant unlimited tablespace to ogg;
grant alter system to ogg;
grant select any table to ogg;
grant insert any table to ogg;
grant update any table to ogg;
grant delete any table to ogg;
grant flashback any table to ogg;
grant lock any table to ogg;
grant alter user to ogg;
grant select any transaction to ogg;
grant create any view to ogg;
exec dbms_goldengate_auth.grant_admin_privilege('OGG');
exec dbms_goldengate_auth.grant_admin_privilege('OGG','*',grant_optional_privileges=>'*');

```

### 配置hosts和tnsname.ora

hosts

172.20.10.9 db1
172.20.10.10 db2

```
db1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = db1)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dzzdsjdb)
    )
  )
db2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = db2)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dzzdsjdb)
    )
  )
```

### 编辑GLOBALS配置文件

cd /ogg

vi GLOBALS

```
ggschema ogg
checkpointtable ogg.ogg_checkpoint
```

### 生成密钥

```
cd /ogg
touch /ogg/ENCKEYS
KEY=$(keygen 128 1)
echo "oggkey" "${KEY}" >/ogg/ENCKEYS
OGG_USER_PASSWORD=ogg
ggsci <<EOF
  ENCRYPT PASSWORD ${OGG_USER_PASSWORD} AES128 ENCRYPTKEY oggkey
EOF

##
cat /ogg/ENCKEYS
oggkey 0x6AED1F18777AD22B33BDDB7FF9E8D54D
ogg => AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

ENCRY_PASSWD=AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
ggsci<<EOF
  dblogin userid ogg@db1,password ${ENCRY_PASSWD},AES128,ENCRYPTKEY oggkey
EOF
```

### 编辑配置文件

#### mgr.prm

vi /ogg/dirprm/mgr.prm

```
PORT 7809
DYNAMICPORTLIST 7800-7900
AUTORESTART ER *,RETRIES 5,WAITMINUTES 3,RESETMINUTES 60
PURGEOLDEXTRACTS ./dirdat/*,USECHECKPOINTS,MINKEEPHOURS 1,FREQUENCYMINUTES 10
LAGREPORTHOURS 1
LAGINFOMINUTES 2
LAGCRITICALMINUTES 4
ACCESSRULE,PROG *,IPADDR *,ALLOW
```

#### 主中心配置

vi /ogg/dirprm/efzog001.prm

```
EXTRACT efzog001
SETENV (NLS_LANG=AMERICAN_AMERICA.AL32UTF8)
userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ,AES128, ENCRYPTKEY oggkey
--FLUSHCSECS 10
--EOFDELAYCSECS 10
BR BRINTERVAL 20M
--TRANLOGOPTIONS INTEGRATEDPARAMS (MAX_SGA_SIZE 2048, PARALLELISM 2)
TRANLOGOPTIONS CHECKPOINTRETENTIONTIME 1
--TRANLOGOPTIONS ASYNCTRANSPROCESSING 1024
TRANLOGOPTIONS EXCLUDETAG 2001
REPORTCOUNT EVERY 1 MINUTE,RATE
EXTTRAIL ./dirdat/la
DISCARDFILE ./dirrpt/efzog001.dsc, APPEND, MEGABYTES 1024
CACHEMGR CACHESIZE 1024MB, CACHEDIRECTORY ./dirtmp
TABLE dzzdsj.t_test,
GETBEFORECOLS (
ON UPDATE ALL,
ON DELETE ALL
);
```

vi /ogg/dirprm/pfzog001.prm

```
EXTRACT Pfzog001
SETENV (NLS_LANG=AMERICAN_AMERICA.AL32UTF8)
PASSTHRU
RMTHOST db2,compress,MGRPORT 7809,TCPBUFSIZE 1000000, TCPFLUSHBYTES 1000000
RMTTRAIL ./dirdat/ra
REPORTCOUNT EVERY 1 MINUTE, RATE
DISCARDFILE ./dirrpt/Pfzog001.dsc, APPEND, MEGABYTES 1024
TABLE dzzdsj.t_test;
```

vi /ogg/dirprm/rfzog201.prm

```
REPLICAT rfzog201
userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ,AES128, ENCRYPTKEY oggkey
DBOPTIONS SETTAG 2001
--DBOPTIONS ENABLE_INSTANTIATION_FILTERING
REPORTCOUNT EVERY 1 MINUTE, RATE
BATCHSQL BATCHESPERQUEUE 100,OPSPERBATCH 2000, BATCHTRANSOPS 1000
REPERROR (DEFAULT, DISCARD)
DISCARDFILE ./dirrpt/rfzog201.dsc, APPEND, MEGABYTES 1024
CACHEMGR CACHESIZE 1024MB, CACHEDIRECTORY ./dirtmp
MAP dzzdsj.t_test, TARGET dzzdsj.t_test,
COMPARECOLS (ON UPDATE ALL, ON DELETE ALL),
RESOLVECONFLICT (INSERTROWEXISTS,(DEFAULT,IGNORE)),
RESOLVECONFLICT (DELETEROWMISSING,(DEFAULT,IGNORE)),
RESOLVECONFLICT (DELETEROWEXISTS,(DEFAULT,IGNORE)),
RESOLVECONFLICT (UPDATEROWEXISTS,(DEFAULT,IGNORE)),
RESOLVECONFLICT (UPDATEROWMISSING,(DEFAULT,IGNORE));
```

#### 副中心配置

vi /ogg/dirprm/efzog001.prm

```
EXTRACT efzog001
SETENV (NLS_LANG=AMERICAN_AMERICA.AL32UTF8)
userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ,AES128, ENCRYPTKEY oggkey
--FLUSHCSECS 10
--EOFDELAYCSECS 10
BR BRINTERVAL 20M
--TRANLOGOPTIONS INTEGRATEDPARAMS (MAX_SGA_SIZE 2048, PARALLELISM 2)
TRANLOGOPTIONS CHECKPOINTRETENTIONTIME 1
--TRANLOGOPTIONS ASYNCTRANSPROCESSING 1024
TRANLOGOPTIONS EXCLUDETAG 2001
REPORTCOUNT EVERY 1 MINUTE,RATE
EXTTRAIL ./dirdat/la
DISCARDFILE ./dirrpt/efzog001.dsc, APPEND, MEGABYTES 1024
CACHEMGR CACHESIZE 1024MB, CACHEDIRECTORY ./dirtmp
TABLE dzzdsj.t_test,
GETBEFORECOLS (
ON UPDATE ALL,
ON DELETE ALL
);
```

vi /ogg/dirprm/pfzog001.prm

```
EXTRACT Pfzog001
SETENV (NLS_LANG=AMERICAN_AMERICA.AL32UTF8)
PASSTHRU
RMTHOST db2,compress,MGRPORT 7809,TCPBUFSIZE 1000000, TCPFLUSHBYTES 1000000
RMTTRAIL ./dirdat/ra
REPORTCOUNT EVERY 1 MINUTE, RATE
DISCARDFILE ./dirrpt/Pfzog001.dsc, APPEND, MEGABYTES 1024
TABLE dzzdsj.t_test;
```

vi /ogg/dirprm/rfzog201.prm

```
REPLICAT rfzog201
userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ,AES128, ENCRYPTKEY oggkey
DBOPTIONS SETTAG 2001
--DBOPTIONS ENABLE_INSTANTIATION_FILTERING
REPORTCOUNT EVERY 1 MINUTE, RATE
BATCHSQL BATCHESPERQUEUE 100,OPSPERBATCH 2000, BATCHTRANSOPS 1000
REPERROR (DEFAULT, DISCARD)
DISCARDFILE ./dirrpt/rfzog201.dsc, APPEND, MEGABYTES 1024
CACHEMGR CACHESIZE 1024MB, CACHEDIRECTORY ./dirtmp
MAP dzzdsj.t_test, TARGET dzzdsj.t_test,
COMPARECOLS (ON UPDATE ALL, ON DELETE ALL),
RESOLVECONFLICT (INSERTROWEXISTS,(DEFAULT,IGNORE)),
RESOLVECONFLICT (DELETEROWMISSING,(DEFAULT,IGNORE)),
RESOLVECONFLICT (DELETEROWEXISTS,(DEFAULT,IGNORE)),
RESOLVECONFLICT (UPDATEROWEXISTS,(DEFAULT,IGNORE)),
RESOLVECONFLICT (UPDATEROWMISSING,(DEFAULT,IGNORE));
```

extract 生成本地文件la，pump在目标端生成文件ra



### 配置ogg进程

#### 主中心配置

```
ggsci
dblogin userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,AES128,ENCRYPTKEY oggkey
add checkpointtable ogg.ogg_checkpoint
ADD TRANDATA dzzdsj.t_test allcols PREPARECSN
REGISTER EXTRACT efzog001 database
ADD EXTRACT efzog001, INTEGRATED TRANLOG, BEGIN NOW 
ADD EXTTRAIL ./dirdat/la, EXTRACT efzog001
ADD EXTRACT pfzog001, EXTTRAILSOURCE ./dirdat/la, BEGIN NOW
ADD RMTTRAIL ./dirdat/ra, EXTRACT pfzog001
REGISTER REPLICAT rfzog201 database
ADD REPLICAT rfzog201, INTEGRATED EXTTRAIL ./dirdat/ra, checkpointtable ogg.ogg_checkpoint
ADD HEARTBEATTABLE
```

#### 副中心配置
```
ggsci
dblogin userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,AES128,ENCRYPTKEY oggkey
add checkpointtable ogg.ogg_checkpoint
ADD TRANDATA dzzdsj.t_test allcols PREPARECSN
REGISTER EXTRACT efzog001 database
ADD EXTRACT efzog001, INTEGRATED TRANLOG, BEGIN NOW 
ADD EXTTRAIL ./dirdat/la, EXTRACT efzog001
ADD EXTRACT pfzog001, EXTTRAILSOURCE ./dirdat/la, BEGIN NOW
ADD RMTTRAIL ./dirdat/ra, EXTRACT pfzog001
REGISTER REPLICAT rfzog201 database
ADD REPLICAT rfzog201, INTEGRATED EXTTRAIL ./dirdat/ra, checkpointtable ogg.ogg_checkpoint
ADD HEARTBEATTABLE
```

#### 配置过程日志
```
[ogg@bogon ogg]$ ggsci

Oracle GoldenGate Command Interpreter for Oracle
Version 19.1.0.0.4 OGGCORE_19.1.0.0.0_PLATFORMS_191017.1054_FBO
Linux, x64, 64bit (optimized), Oracle 19c on Oct 17 2019 21:16:29
Operating system character set identified as UTF-8.

Copyright (C) 1995, 2019, Oracle and/or its affiliates. All rights reserved.



GGSCI (bogon) 1> dblogin userid ogg@db1,password AADAAAAAAAAAAADARDAIDCLGYBRHGAXCYIIFZIPEXGBCTDMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,AES128,ENCRYPTKEY oggkey
Successfully logged into database.

GGSCI (bogon as ogg@dzzdsjdb) 2> add checkpointtable ogg.ogg_checkpoint

Successfully created checkpoint table ogg.ogg_checkpoint.

GGSCI (bogon as ogg@dzzdsjdb) 3> ADD TRANDATA dzzdsj.t_test allcols PREPARECSN

2022-11-22 20:38:25  INFO    OGG-15132  Logging of supplemental redo data enabled for table DZZDSJ.T_TEST.

2022-11-22 20:38:25  INFO    OGG-15133  TRANDATA for scheduling columns has been added on table DZZDSJ.T_TEST.

2022-11-22 20:38:25  INFO    OGG-15134  TRANDATA for all columns has been added on table DZZDSJ.T_TEST.

2022-11-22 20:38:25  INFO    OGG-15135  TRANDATA for instantiation CSN has been added on table DZZDSJ.T_TEST.

2022-11-22 20:38:26  INFO    OGG-10471  ***** Oracle Goldengate support information on table DZZDSJ.T_TEST *****
Oracle Goldengate support native capture on table DZZDSJ.T_TEST.
Oracle Goldengate marked following column as key columns on table DZZDSJ.T_TEST: ID.

GGSCI (bogon as ogg@dzzdsjdb) 4> REGISTER EXTRACT efzog001 database

2022-11-22 20:39:27  INFO    OGG-02003  Extract EFZOG001 successfully registered with database at SCN 2111026.


GGSCI (bogon as ogg@dzzdsjdb) 5> ADD EXTRACT efzog001, INTEGRATED TRANLOG, BEGIN NOW
EXTRACT (Integrated) added.


GGSCI (bogon as ogg@dzzdsjdb) 6> ADD EXTTRAIL ./dirdat/la, EXTRACT efzog001
EXTTRAIL added.

GGSCI (bogon as ogg@dzzdsjdb) 7> ADD EXTRACT pfzog001, EXTTRAILSOURCE ./dirdat/la, BEGIN NOW
EXTRACT added.


GGSCI (bogon as ogg@dzzdsjdb) 8> ADD RMTTRAIL ./dirdat/ra, EXTRACT pfzog001
RMTTRAIL added.

GGSCI (bogon as ogg@dzzdsjdb) 9> REGISTER REPLICAT rfzog201 database

2022-11-22 20:45:06  INFO    OGG-02528  REPLICAT RFZOG201 successfully registered with database as inbound server OGG$RFZOG201.


GGSCI (bogon as ogg@dzzdsjdb) 10> ADD HEARTBEATTABLE

2022-11-22 20:47:04  INFO    OGG-14001  Successfully created heartbeat seed table ""ogg"."GG_HEARTBEAT_SEED"".

2022-11-22 20:47:04  INFO    OGG-14089  Successfully tracking extract restart position with heartbeat table ""ogg"."GG_HEARTBEAT_SEED"".

2022-11-22 20:47:04  INFO    OGG-14032  Successfully added supplemental logging for heartbeat seed table ""ogg"."GG_HEARTBEAT_SEED"".

2022-11-22 20:47:04  INFO    OGG-14000  Successfully created heartbeat table ""ogg"."GG_HEARTBEAT"".

2022-11-22 20:47:04  INFO    OGG-14089  Successfully tracking extract restart position with heartbeat table ""ogg"."GG_HEARTBEAT"".

2022-11-22 20:47:04  INFO    OGG-14033  Successfully added supplemental logging for heartbeat table ""ogg"."GG_HEARTBEAT"".

2022-11-22 20:47:04  INFO    OGG-14016  Successfully created heartbeat history table ""ogg"."GG_HEARTBEAT_HISTORY"".

2022-11-22 20:47:04  INFO    OGG-14089  Successfully tracking extract restart position with heartbeat table ""ogg"."GG_HEARTBEAT_HISTORY"".

2022-11-22 20:47:04  INFO    OGG-14086  Successfully disabled partitioning for heartbeat history table ""ogg"."GG_HEARTBEAT_HISTORY"".

2022-11-22 20:47:04  INFO    OGG-14023  Successfully created heartbeat lag view ""ogg"."GG_LAG"".

2022-11-22 20:47:04  INFO    OGG-14024  Successfully created heartbeat lag history view ""ogg"."GG_LAG_HISTORY"".

2022-11-22 20:47:04  INFO    OGG-14003  Successfully populated heartbeat seed table with "DZZDSJDB".

2022-11-22 20:47:04  INFO    OGG-14004  Successfully created procedure ""ogg"."GG_UPDATE_HB_TAB"" to update the heartbeat tables.

2022-11-22 20:47:04  INFO    OGG-14017  Successfully created procedure ""ogg"."GG_PURGE_HB_TAB"" to purge the heartbeat history table.

2022-11-22 20:47:04  INFO    OGG-14005  Successfully created scheduler job ""ogg"."GG_UPDATE_HEARTBEATS"" to update the heartbeat tables.

2022-11-22 20:47:04  INFO    OGG-14018  Successfully created scheduler job ""ogg"."GG_PURGE_HEARTBEATS"" to purge the heartbeat history table.
```