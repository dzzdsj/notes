# oracle 数据库概念

[TOC]



## 数据库安装

## 数据库体系结构

### 后台进程

#### 查询后台进程

```
select name,description from v$bgprocess;
```

几个主要的后台进程

![](../../../pictures/database/oracle主要后台进程.jpg)



## 数据库概念

### 表

#### 表类型

![](./pictures/oracle表类型.jpg)

##### 分区表

###### 相关查询

```sql
-- user_tables, dba_part_tables, user_segments
```



#### 数据类型

| 类型   | 具体类型                                                     | 注意点                                                       |
| ------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 字符型 | varchar2(n byte/n char)<br />char<br />nchar<br />nvarchar2  | 1.varchar2的两种定义形式（字节长度和字符长度）<br />2.varchar2最大长度（12c以前4000字符，12c及以后32767）,设置可扩展字符类型max_string_size=extended<br />3.char类型所分配的空间是固定的，即使没有占满<br />select dump(column) from table; |
| 数值型 | number(scale,precision)<br />binary_double<br />binary_float | 1.number(5,2)范围 -> +/-999.99<br />2.number最大长度38位     |
| 日期型 | date<br />timestamp(n)<br />interval                         | 1.date默认含时分秒<br /><br />2.timestamp精度0-9,默认6（附加类型：timestamp with time zone/timestamp with local time zone）<br />3.interval存储时间段(子类型interval year to month/interval day to second) |
| RAW    |                                                              | 1.raw类型存储二进制数据，长度（12c以前4000B，12c及以后32767B）<br />2.检索时默认会调用rawtohex函数，因此不能建普通索引，而要建基于函数的索引 |
| ROWID  |                                                              |                                                              |
| 大对象 | clob<br />nclob<br />blob<br />bfile                         | 1.clob->文本 <br />2.blob->图像、音视频<br />3.clob/nclob/blob属于内部大对象<br />4.bfile属于外部大对象，存储指向外部os中的文件的指针，但不参与事务，也不受安全性和备份和恢复的保护 |

#### 数据字典

##### 静态视图

查询用户、表、索引、约束、权限等。

/$ORACLE_HOME/rdbms/admin/sql.bsq -> 创建基础表USER$、TAB$、IND$等。

/$ORACLE_HOME/rdbms/admin/catalog.sql -> 创建静/动态视图

| 等级 | 常用视图 | 备注             |
| ---- | -------- | ---------------- |
| user |          | 当前用户         |
| all  |          | 可访问的         |
| dba  |          | 所有             |
| cdb  |          | 容器db（con_id） |

##### 动态视图

查询连接用户、在执行的sql、内存使用情况、锁、I/O等。

以X$表为基础表。

/$ORACLE_HOME/rdbms/admin/catalog.sql ->创建静/动态视图

v$  /  gv$

##### 逻辑物理结构和常用视图

![](./pictures/oracle数据库逻辑和物理结构的关系.jpg)

![](./pictures/oracle常用数据字典.jpg)



### 表空间

#### 表空间分类

- 永久表空间
- 撤销表空间
- 临时表空间

#### 表空间管理语句

```sql
--调整表空间大小
alter database datafile 'xxx.dbf' resize 1g;
--查询自动段空间管理ASSM(automatic segment space management)
select tablespace_name,initial_extent,next_extent,extent_management,allocation_type, segment_space_management from dba_tablespaces;
--创建本地管理的表空间并使用统一分配
create tablespace user_256k_dat datafile '/u01/user_256k_dat.dbf' size 100m extent management local uniform size 256k;
--修改用户默认表空间/临时表空间
Alter user test1 default tablespace tbs_test1;              --修改 test1用户的默认表空间是tbs_test1
Alter user test1 temporary tablespace temp_tbs_test1;       --修改 test1用户的临时表空间temp_tbs_test1

```



### 索引

#### 索引的特点

- 索引对性能改进的程度取决于：
  1. 数据的选择性 
  
     (评估user_index中distinct_keys 和num_rows列的比值，对于组合索引， 在索引中添加额外的列不会显著改善选择性)
  
  2. 数据在表的数据块中的分布方式（是否单个数据块）
  
- 索引对性能的影响：

  1. 提升 select、update、delete命令的where子句的性能（访问的行较少时）

  2. 降低 insert语句性能

  3. 降低 索引列上 的update操作性能

  4. 降低 大量行的delete 性能
  
- 使用索引的一般情况：
  1. 在表上加一个索引都会使该表上INSERT 操作的执行时间变成原来的三倍；
     再加一个索引就会再慢一倍；
  2. 然而， 一个由两列组成的索引并不比只有一个列的索引差很多
  3. 对于组合索引：索引的第一列，应该是最有可能在where子句中使用的列， 并且
     也是索引中最具选择性的列；另外要注意前导列问题，如果where子句不含索引的第一列，无跳跃扫描的版本（9i以前无法使用索引），有跳跃扫描的版本优化器会选择走索引、索引快速全扫描、全表扫描之一。
  4. 创建主键或唯一约束时，将自动对指定列创建唯一索引，除非使用disable子句创建约束。
  
- 索引的扫描方式

  1. unique scan（unique index的情况）：从索引中返回唯一值
  2. range scan：从索引中返回多个值

  

#### 索引相关查询

- dba_indexes (未显示索引包含的列)

```sql
--建索引
create index empidl on emp(empno, ename, deptno);
create index emp_id2 on emp (sal);

```

- dba_ind_columns (显示索引包含的列)

```sql
select table_name, index_name, column_name, column_position from user_ind_columns order by table_name, index_name, column_position;
```

#### 索引的调试

不可视索引

```sql
--创建不可视索引
create index ... invisible;
alter index idx1 invisible;
alter index idx1 visible;
--通过提示强制使用/不使用索引
select /*+ use_invisible_indexes */ count(*) from emp where deptno=30;
select /*+ no_index(emp emp_idx1) */ count(*) from emp where deptno=30;
```

#### 索引抑制

以下情况会导致索引无法使用：

1. 使用不等于<> , !=
2. 使用is null , is not null
3. 使用like的情况：只有like 'abcd%'这种值在开始的情况才能使用索引。而like '%abcd%'则无法使用。
4. 使用函数时会忽略列上的索引（除非基于函数的索引）
5. 比较不匹配的数据类型：例如列 a varchar2(3)，查询 where a=123时，会使用函数隐式转换为数值，使索引失效

## 数据库调优

### 初始化参数

```sql
--查询sga组件内存分配情况  v$_sga_dynamic_components

```

#### 自动共享内存管理

**ASMM (Automatic Shared Memory Management）**

SGA_TARGET======》SHARED_POOL_SlZE、LARGE_POOL_SIZE、STREAMS_POOL_SIZE和JAVA_POOL_ SIZE

### SQL调优

#### 执行计划

```sql
--第一种形式
SQL>EXPLAIN PLAN FOR 
SELECT * FROM SCOTT.EMP; --要解析的SQL脚本 
SQL>SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY); 
--或者(这个表更详细)
SQL>select * from plan_table;
--第二种形式(多个开发同时使用的时候用于区分)
SQL>EXPLAIN PLAN 
set statement_id='dzzdsj'  FOR
select statement
SQL>select * from plan_table where statement_id='dzzdsj';

--如果无法创建可能需要执行utlxplan.sql脚本创建执行计划表
```

#### 开启autotrace

```sql
sqlplus / as sysdba;
set autotrace on
select statement
----其他选项
--关闭
set autotrace off
--仅显示执行计划
set autot on exp
--仅显示统计信息
set autotrace on stat
--不显示查询的输出结果
set autot trace
```

