## 基础



### 安装



### 启停

#### 启动三板斧

```shell
/mysql/bin/mysqld_safe --defaults-file=/mysql/my.cnf &
/mysql/bin/mysqld --defaults-file=/mysql/my.cnf &
#不使用默认配置文件
/mysql/bin/mysqld --no-defaults --basedir=/mysql --datadir=/mysql/data --user=mysql
```

### 目录结构

```shell
[root@dev mysql]# ls -l /mysql/data/
#记录实例的server-uuid
-rw-r----- 1 mysql mysql       56 Jun 23  2023 auto.cnf
#
-rw-r----- 1 mysql mysql      180 Dec  2 18:53 binlog.000003
-rw-r----- 1 mysql mysql      180 Dec  2 18:53 binlog.000004
-rw-r----- 1 mysql mysql      180 Dec  2 20:29 binlog.000005
-rw-r----- 1 mysql mysql      180 Dec 29 22:00 binlog.000006
-rw-r----- 1 mysql mysql      157 Dec 29 22:17 binlog.000007
-rw-r----- 1 mysql mysql      157 Dec 29 22:17 binlog.000008
-rw-r----- 1 mysql mysql       96 Dec 29 22:17 binlog.index
-rw------- 1 mysql mysql     1680 Jun 23  2023 ca-key.pem
-rw-r--r-- 1 mysql mysql     1112 Jun 23  2023 ca.pem
-rw-r--r-- 1 mysql mysql     1112 Jun 23  2023 client-cert.pem
-rw------- 1 mysql mysql     1676 Jun 23  2023 client-key.pem
#双写缓冲区
-rw-r----- 1 mysql mysql   196608 Dec 29 22:19 #ib_16384_0.dblwr
-rw-r----- 1 mysql mysql  8585216 Jun 23  2023 #ib_16384_1.dblwr
#记录缓冲池中数据页的地址(space_id,page_no)，这样数据库启动后可直接将指定数据页加载到缓冲池中，避免了较长的预热时间
-rw-r----- 1 mysql mysql     3353 Dec 29 22:00 ib_buffer_pool
#系统表空间（主要包括字典信息、插入缓冲区等）
-rw-r----- 1 mysql mysql 12582912 Dec 29 22:17 ibdata1
#全局级别的临时表空间。
-rw-r----- 1 mysql mysql 12582912 Dec 29 22:17 ibtmp1
drwxr-x--- 2 mysql mysql     4096 Dec 29 22:17 #innodb_redo
#会话级别的临时表空间
drwxr-x--- 2 mysql mysql      187 Dec 29 22:17 #innodb_temp
#系统表空间（放日志相关）
drwxr-x--- 2 mysql mysql      143 Jun 23  2023 mysql
#系统表空间（放除日志相关外的其他内容）
-rw-r----- 1 mysql mysql 25165824 Dec 29 22:17 mysql.ibd
-rw-r----- 1 mysql mysql        5 Dec 29 22:17 mysql.pid
#运行时的性能数据
drwxr-x--- 2 mysql mysql     8192 Jun 23  2023 performance_schema
#证书文件和私钥文件，用于SSL加密连接
-rw------- 1 mysql mysql     1676 Jun 23  2023 private_key.pem
-rw-r--r-- 1 mysql mysql      452 Jun 23  2023 public_key.pem
-rw-r--r-- 1 mysql mysql     1112 Jun 23  2023 server-cert.pem
-rw------- 1 mysql mysql     1680 Jun 23  2023 server-key.pem
#只有一个基表sys_config.ibd，其他是基于information_schema,performance_schema的视图，弥补performance_schema可读性差的缺点
drwxr-x--- 2 mysql mysql       28 Jun 23  2023 sys
#回滚表空间
-rw-r----- 1 mysql mysql 16777216 Dec 29 22:19 undo_001
-rw-r----- 1 mysql mysql 16777216 Dec 29 22:19 undo_002

```

### 配置文件

#### 配置文件读取顺序

在未显示指定--defaults-file时，依此读取以下配置文件

```shell
/etc/my.cnf
/etc/mysql/my.cnf
/usrl/local/mysql/etc/my.cnf （官方二进制包） 或 /usr/etc/my.cnf (rpm包)(由编译时 -DCMAKE_INSTALL_PREFIX选项指定)
~/.my.cnf

#查看配置文件加载顺序
[root@dev bin]# mysqld --verbose --help |grep -A1 "Default options"
Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
```

```sql
--查看变量相关信息
select * from performance_schema.variables_info where variable_name='max_connections'\G
```



### 主从复制

#### 基本原理

复制主要涉及三个线程：

​		主库：binlog dump线程 -> 从指定位置发送binlog

​		从库：I/O线程 -> 接收binlog，写入relay log

​					SQL线程 -> 读取relay log，进行重放



GTID(global transaction identifier,全局事务ID)：为每个事务分配一个全局唯一的事务ID。引入GTID后，就无需关心binlog的具体位置点信息。

​	格式：source_id:transaction_id

​	source_id:  事务是在哪个实例上产生的，通常用实例的server_uuid来表示

​	transaction_id: 事务的序列号，按照事务的提交顺序从1开始顺序分配



#### 主从搭建

##### 传统主从复制

配置信息my.cnf

```
#主：
[mysqld]
bind-address=0.0.0.0
port=3306
user=mysql
basedir=/mysql
datadir=/mysql/data
socket=/mysql/mysql.sock
log-error=/mysql/log/mysql.err
pid-file=/mysql/data/mysql.pid
character_set_server=utf8mb4
#以下主从配置
log-bin=/mysql/mysql-bin
#主从需不同
server-id=1

#从：
[mysqld]
server-id=2

```

初始化数据

```shell
#master
mysqldump -S /mysql/mysql.sock --single-transaction --master-data=2 -E -R --triggers -A > full_backup.sql

#replica
mysqldump -S /mysql/mysql.sock < full_backup.sql
```

配置主从

```
#创建复制用户
create user 'replicat'@'%' identified by 'Dzzdsj@1991';
GRANT ALL PRIVILEGES ON *.* TO 'replicat'@'%' ;
alter user 'replicat'@'%'  identified with mysql_native_password by 'Dzzdsj@1991'; 
flush privileges;

#master
reset master;
show master status;

#slave
stop slave;
reset slave;
change master to master_host='master_ip',master_user='replicat',master_port=3306,master_password='Dzzdsj@1991',master_log_file='mysql-bin.000001',master_log_pos=157;
start slave;
show slave status \G

#修改从节点只读
set global read_only=1;
--即使super权限也无法写
set global super_read_only=1;
show global variables like '%read_only%';
```



##### 基于GTID的主从复制

区别于传统搭建需补充配置：

```
#主从节点都增加配置
gtid-mode=on
enforce-gtid-consistency=1

#只需配置master_auto_position=1，不再需要具体位置信息
change master to master_host='master_ip',master_user='replicat',master_port=3306,master_password='Dzzdsj@1991',master_auto_position=1;
start slave;
```



