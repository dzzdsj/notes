## 基础



### 安装
#### tar方式安装
https://www.modb.pro/db/1994345626583769088
部署概述
  本文档详细描述了在龙蜥OS 8.6操作系统上，使用二进制压缩包安装MySQL 8.4.7数据库的完整步骤，并配置基于GTID的异步主从复制。所有参数配置均遵循生产环境最佳实践，旨在充分利用16核CPU、64GB内存和SSD磁盘的硬件性能，确保数据库系统的稳定性、安全性与高性能。

环境介绍
操作系统： Anolis OS 8.6 x86-64
CPU：16核
内存：64GB
硬盘：1TB SSD
操作系统环境准备
在安装MySQL之前，需对操作系统进行必要的配置优化，以满足数据库运行的基础要求。

1. 系统参数调整
编辑 /etc/sysctl.conf文件，添加或修改以下内核参数，优化网络、内存和文件系统性能。

# 编辑系统参数配置文件
vi /etc/sysctl.conf

# 添加或修改如下内容：
# 网络核心参数
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

# 网络TCP参数
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_keepalive_time = 600

# 内存与虚拟内存
vm.swappiness = 1
vm.dirty_ratio = 60
vm.dirty_background_ratio = 5

# 文件系统与Inode
fs.file-max = 655350
fs.aio-max-nr = 1048576
2. 资源限制调整
编辑 /etc/security/limits.conf文件，提高MySQL用户可用的进程数和文件打开数。

vi /etc/security/limits.conf

# 在文件末尾添加：
mysql soft nproc 65535
mysql hard nproc 65535
mysql soft nofile 65535
mysql hard nofile 65535
3. 创建用户与目录
为MySQL服务创建专用的用户、组和数据目录，并设置严格的权限控制。

# 创建mysql用户组和用户
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

# 创建MySQL基础目录和数据目录
mkdir -p /usr/local/mysql
mkdir -p /data/mysql/{data,logs,binlogs,tmp,run}

# 更改目录所有者
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /data/mysql
4. 磁盘IO调度策略（针对SSD优化）
建议将SSD磁盘的I/O调度策略设置为 deadline或 none（对应多队列的blk-mq）。

# 查看磁盘调度策略，假设数据盘为 /dev/nvme0n1
cat /sys/block/nvme0n1/queue/scheduler

# 临时修改调度策略（重启失效）
echo deadline | sudo tee /sys/block/nvme0n1/queue/scheduler

# 永久生效，可写入 /etc/rc.local 
安装部署
二进制包安装
1. 下载与解压
从MySQL官方网站下载对应的二进制包（mysql-8.4.7-linux-glibc2.17-x86_64.tar.xz或根据龙蜥OS的glibc版本选择），并解压到安装目录。
image.png

# 切换到安装包所在目录
cd /tmp

# 下载（见上图）
下载后拷贝至/tmp目录下

# 解压并移动到目标目录
tar -xvf mysql-8.4.7-linux-glibc2.17-x86_64.tar.xz -C /usr/local/mysql
2. 设置环境变量
# 编辑全局profile文件
vi /etc/profile.d/mysql.sh

# 添加以下内容：
export MYSQL_HOME=/usr/local/mysql
export PATH=$MYSQL_HOME/bin:$PATH

# 使环境变量立即生效
source /etc/profile.d/mysql.sh
3. MySQL参数配置
根据64G内存和SSD磁盘的特性，精心调优的 my.cnf配置文件是数据库性能的关键。以下为主库的配置示例，从库的 server-id不同。
主库配置文件/etc/my.cnf

[client]
port = 3306
socket = /data/mysql/run/mysql.sock

[mysql]
prompt="\\u@\\h : \\d \\r:\\m:\\s> "
default_character_set = utf8mb4
no_auto_rehash

[mysqld]
# === 基础路径与标识 ===
port = 3306
basedir = /usr/local/mysql
datadir = /data/mysql/data
socket = /data/mysql/run/mysql.sock
pid_file = /data/mysql/run/mysql.pid
tmpdir = /data/mysql/tmp

# === 服务器标识（主从必须不同）===
server_id = 101
report_host = master_ip_or_hostname # 请替换为主库实际IP或主机名

# === 字符集与语言设置 ===
character_set_server = utf8mb4
collation_server = utf8mb4_general_ci
lower_case_table_names = 1

# === 内存配置（64G内存优化）===
# InnoDB缓冲池，约占物理内存的50%
innodb_buffer_pool_size = 32G
# 缓冲池实例数
innodb_buffer_pool_instances = 8

# 其他内存缓冲区
key_buffer_size = 64M
innodb_log_buffer_size = 256M
sort_buffer_size = 4M
read_buffer_size = 1M
read_rnd_buffer_size = 4M
join_buffer_size = 4M
thread_stack = 512K
binlog_cache_size = 2M

# === 连接与线程 ===
max_connections = 2000
max_connect_errors = 1000000
thread_cache_size = 64
table_open_cache = 4096
table_definition_cache = 2048

# === InnoDB引擎核心优化（针对SSD）===
# 事务日志刷盘策略，1为最安全，2性能更好但可能丢失1秒数据
innodb_flush_log_at_trx_commit = 1
# redo日志文件大小
innodb_redo_log_capacity = 6G


# IO线程数，可设置为CPU核心数
innodb_read_io_threads = 8
innodb_write_io_threads = 8
# 刷盘方式，Linux下建议O_DIRECT避免双缓冲
innodb_flush_method = O_DIRECT
# 每个表独立表空间
innodb_file_per_table = 1
# 打开文件数限制
innodb_open_files = 65535

# === 二进制日志与复制（GTID模式）===
log_bin = /data/mysql/binlogs/mysql-bin
binlog_format = ROW
relay_log = /data/mysql/binlogs/relay-log
relay_log_index = /data/mysql/binlogs/relay-log.index
# 为GTID复制启用
gtid_mode = ON
enforce_gtid_consistency = ON
log_replica_updates = ON
# 二进制日志保留时间（秒），7天
binlog_expire_logs_seconds = 604800
max_binlog_size = 1G
sync_binlog = 1

# === 其他重要参数 ===
# 跳过域名解析，提升连接速度
skip_name_resolve = 1
# 错误日志路径
log_error = /data/mysql/logs/error.log
# 慢查询日志
slow_query_log = 1
long_query_time = 1
slow_query_log_file = /data/mysql/logs/slow.log
# 最大数据包大小
max_allowed_packet = 1G
# 自动超时时间
interactive_timeout = 10800
wait_timeout = 10800
从库配置差异
从库的 my.cnf文件绝大部分与主库相同，只需修改以下参数：

[mysqld]
# 服务器标识必须唯一
server_id = 102
report_host = slave_ip_or_hostname # 请替换为从库实际IP或主机名
# 从库可选项：延迟复制（按需设置）
# relay_log_recovery = 1
# 从库可选项：禁止写入（增强只读状态）
# read_only = 1
# super_read_only = 1 (如果希望超级用户也只读)
4. 初始化数据库与启动服务
4.1 初始化数据目录
使用 --initialize 选项进行初始化，初始化过程中会为root用户生成一个临时密码。

sudo -u mysql /usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize --user=mysql &
重要：​ 初始化完成后，务必在错误日志中记下生成的临时密码。

grep 'temporary password' /data/mysql/logs/error.log
4.2 配置启动关闭脚本

cd /data/mysql
vi startMySQL.sh
/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf --user=mysql &

vi stopMySQL.sh
/usr/local/mysql/bin/mysqladmin -uroot -p'passwrod' -S /data/mysql/run/mysql.sock shutdown

chmod +x /data/mysql/startMySQL.sh
chmod +x /data/mysql/stopMySQL.sh

##后面可以通过执行脚本来启动和关闭MySQL实例
/data/mysql/startMySQL.sh
/data/mysql/stopMySQL.sh

启动MySQL服务

/data/mysql/startMySQL.sh
4.3 修改root密码并初始化权限
使用临时密码登录，并立即修改密码。

mysql -uroot -p -S /data/mysql/run/mysql.sock
在MySQL提示符下执行：

-- 输入临时密码登录后，立即修改密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'my_passwrod123!';

-- 刷新权限
FLUSH PRIVILEGES;
5. 配置GTID主从复制
5.1 主库操作

-- 创建复制用户
CREATE USER 'repl'@'%' IDENTIFIED BY 'repl_password_123!';
GRANT REPLICATION SLAVE,REPLICATION CLIENT ON *.* TO 'repl'@'%';

-- 刷新权限
FLUSH PRIVILEGES;

5.2 从库操作

-- 配置主库连接信息
CHANGE REPLICATION SOURCE TO 
SOURCE_HOST='master_ip',  --替换为主库IP地址
SOURCE_PORT=3306,
SOURCE_USER='repl',
SOURCE_PASSWORD='repl_password_123!',
SOURCE_AUTO_POSITION=1,
GET_SOURCE_PUBLIC_KEY=1; 

-- 启动复制
START REPLICA;

-- 检查复制状态
SHOW REPLICA STATUS\G
关键检查点：

Slave_IO_Running: Yes
Slave_SQL_Running: Yes
Seconds_Behind_Master: 0
Retrieved_Gtid_Set 和 Executed_Gtid_Set 应正常显示和增长。
总结
  本文档提供了一套完整的、针对生产环境的MySQL 8.4.7二进制安装与GTID主从复制部署方案。所有参数均基于16C/64G/SSD的硬件配置进行了优化。在实际生产环境中，请根据具体的业务负载特点进行微调，并严格执行备份、监控和告警策略。

#### rpm方式

默认目录及文件位置：
root@thinkbook-rhel:~# which mysqld
/usr/sbin/mysqld
root@thinkbook-rhel:~# which mysql
/usr/bin/mysql

root@thinkbook-rhel:~# cat /etc/my.cnf
#
# This group is read both both by the client and the server
# use it for options that affect everything
#
[client-server]

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d


root@thinkbook-rhel:~# cat /etc/my.cnf.d/
client.cnf        mysql-server.cnf  
root@thinkbook-rhel:~# cat /etc/my.cnf.d/mysql-server.cnf 
#
# This group are read by MySQL server.
# Use it for options that only the server (but not clients) should see
#
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/en/server-configuration-defaults.html

# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mysqld according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
log-error=/var/log/mysql/mysqld.log
pid-file=/run/mysqld/mysqld.pid


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

### root密码重置

```
#https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html
#方案一 
/usr/sbin/mysqld --user=root --skip-grant-tables &
   mysql
   FLUSH PRIVILEGES;
   ALTER USER 'root'@'localhost' IDENTIFIED BY 'Root_1991';
#root启动后应该有权限问题  
sudo chown -R mysql:mysql /var/lib/mysql
sudo chown -R mysql:mysql /var/run/mysqld
sudo chown -R mysql:mysql /var/log/mysqld
#方案二
echo "   ALTER USER 'root'@'localhost' IDENTIFIED BY 'Root_1991';" >mysql-init
mysqld --init-file=/home/me/mysql-init &
之后正常重启并删除mysql-init文件
```



