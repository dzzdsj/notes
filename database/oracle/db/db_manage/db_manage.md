# oracle数据库管理相关语句

## 归档日志

```sql
--归档日志满问题
select * from v$flash_recovery_area_usage;
show parameter recover;
alter system set db_recovery_file_dest_size=32768M scope=both;

--rman删归档
rman target /
cross check archivelog all;                           --->校验日志的可用性
list expired archivelog all;                         --->列出所有失效的归档日志
delete noprompt archivelog until time "to_date('XXXX-XX-XX','YYYY-MM-DD')";    ---> 清理到某天日期之前的归档
delete noprompt archivelog until time "to_date('2016-09-14 18:00:00','YYYY-MM-DD hh24:mi:ss')";   ---> 清理到具体时分秒之前的归档日志
delete archivelog until sequence 16;                 --->删除log sequence为16及16之前的所有归档日志
delete archivelog all completed before 'sysdate-7';   --->删除系统时间7天以前的归档日志，不会删除闪回区有效的归档日志
delete archivelog from time 'sysdate-1';             --->注意这个命令，删除系统时间1天以内到现在的归档日志
delete noprompt archivelog all completed before 'sysdate';  --->该命令清除当前所有的归档日志
delete noprompt archivelog all completed before 'sysdate-0';  --->该命令清除当前所有的归档日志
delete noprompt archivelog all; 

--删归档定时任务  注意：任务要先执行profile文件
0 */3 * * * sh /home/oracle/script/clear_arch.sh > logfile.log  -->linux
0,10,20 * * * * sh /home/oracle/script/clear_arch.sh > logfile.log  -->aix

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

## 表空间管理

### 普通表空间

```sql
--
create tablespace dzzdsj_tbs datafile '/oracle/app/oracle/oradata/DZZDSJDB/dzzdsj01.dbf' size 50m autoextend on next 50m maxsize 30G;
--
alter tablespace dzzdsj_tbs add datafile '/oracle/app/oracle/oradata/DZZDSJDB/dzzdsj02.dbf' size 50m autoextend on next 50m maxsize 30G;
```

### 临时表空间

```
create temporary tablespace tmp_dzzdsj_tbs tempfile '/oracle/app/oracle/oradata/DZZDSJDB/tmp_dzzdsj01.dbf' size 50m autoextend on next 50m maxsize 30G;
--
alter tablespace tmp_dzzdsj_tbs add tempfile '/oracle/app/oracle/oradata/DZZDSJDB/tmp_dzzdsj02.dbf' size 50m autoextend on next 50m maxsize 30G;
```



## 用户管理

### 用户创建

```sql
--
create user dzzdsj identified by dzzdsj default tablespace dzzdsj_tbs temporary tablespace tmp_dzzdsj_tbs profile unlimited_profile;
--

```

### 免密用户

```sql
create user ops$dzzdsj identified externally;
grant connect to ops$dzzdsj;
grant select any dictionary to ops$dzzdsj;
grant select any table to ops$dzzdsj;
grant unlimited tablespace to ops$dzzdsj;
```





### 用户权限

```sql
grant connect to dzzdsj;
grant resource to dzzdsj;
grant unlimited tablespace to dzzdsj;

--
SELECT * FROM dba_tab_privs WHERE grantee = 'PUBLIC'
```



## 安全策略

### profile配置

```
--
select username,profile from dba_users;
--
create profile unlimited_profile limit
failed_login_attempts unlimited
password_life_time unlimited
password_reuse_time unlimited
password_reuse_max unlimited;

--配置密码永不过期
alter profile unlimited_profile limit password_life_time unlimited;
alter profile unlimited_profile limit password_reuse_time unlimited;
alter profile unlimited_profile limit password_reuse_max unlimited;
alter user xxx identified by xxx;
```



## 实例初始化参数

```sql
--调整初始化参数
show parameter processes;
alter system set processes=1000 scope=spfile;

show parameter sessions;
alter system set sessions=1000 scope=spfile;

show parameter sga;
alter system set sga_max_size=10240m scope=spfile;
alter system set sga_target=10240m scope=spfile;

show parameter pga;
alter system set pga_aggregate_target=3276m scope=spfile;
alter system set pga_aggregate_limit=3276m scope=spfile;（会无法启动）

show parameter streams_pool_size;
alter system set streams_pool_size=3276m scope=spfile;

--pfile/spfile
create pfile='/home/oracle/initcibdb.ora' from spfile;
create spfile from pfile='/home/oracle/initcibdb.ora';

```

## session和连接数

```sql
select count(*) FROM v$session;

--todo
show parameter workare;
```

--统计信息时间修改
调整统计信息收集时间：
select * from dba_scheduler_windows;

BEGIN
  DBMS_SCHEDULER.DISABLE(
  name => '"SYS"."MONDAY_WINDOW"',
  force => TRUE);
END;
/

BEGIN
  DBMS_SCHEDULER.SET_ATTRIBUTE(
  name => '"SYS"."MONDAY_WINDOW"',
  attribute => 'REPEAT_INTERVAL',
  value => 'freq=daily;byday=THU;byhour=22;byminute=0; bysecond=0 ');
END;
/

BEGIN
  DBMS_SCHEDULER.ENABLE(
  name => '"SYS"."MONDAY_WINDOW"');
END;
/

（此为修改持续时间：）

BEGIN
  DBMS_SCHEDULER.SET_ATTRIBUTE(
  name => '"SYS"."SATURDAY_WINDOW"',
  attribute => 'DURATION',
  value => numtodsinterval(240,'minute'));
END;  
/

## 失效对象
```sql
SELECT * FROM dba_objects WHERE status !='VALID';
--某些角色或用户的权限不正确，如public的某些权限被收回，也可能导致失效对象问题

--失效对象修复
@?/rdbms/admin/utlrp.sql
--推荐方式？待测试
$ cd $ORACLE_HOME/rdbms/admin
$ORACLE_HOME/perl/bin/perl catcon.pl --n 1 --e --b utlrp --d '''.''' utlrp.sql
```
