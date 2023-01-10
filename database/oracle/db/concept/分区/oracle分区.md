
# 分区概念
## 分区概述
### 哪些对象可以分区
Partitioning allows a table, index, or index-organized table to be subdivided into smaller pieces
1. 表（分区表不能含LONG or LONG RAW字段类型）
2. 索引
    无论关联的表是否分区，索引都可以分区或者不分区。
    A nonpartitioned table can have partitioned or nonpartitioned indexes.
    A partitioned table can have partitioned or nonpartitioned indexes.
3. 索引组织表

### 分区的限制条件分区表不能含LONG or LONG RAW字段类型
1. 分区表不能含LONG or LONG RAW字段类型
Any table can be partitioned up to a million separate partitions except those tables containing columns with LONG or LONG RAW data types. You can, however, use tables containing columns with CLOB or BLOB data types （不能含 LONG or LONG RAW字段类型）
2. 分区对象的表空间必须有相同的块大小
All partitions of a partitioned object must reside in tablespaces of the same block size.


### 分区键
分区键可以是一列或多列，oracle根据分区键定位分区。
The partitioning key consists of one or more columns that determine the partition where each row is stored. Oracle automatically directs insert, update, and delete operations to the appropriate partition with the partitioning key

### 分区数据校验

可以使用ORA_PARTITION_VALIDATION 函数对分区数据进行校验。

```sql
SELECT test1.*, ORA_PARTITION_VALIDATION(rowid) FROM test1;
--SQL function takes a rowid as input and returns 1 if the row is in the correct partition and 0 otherwise
```

### 何时考虑表分区
1. 大于2GB的表
• Tables that are greater than 2 GB.
These tables should always be considered as candidates for partitioning.
2. 含历史数据的表
• Tables that contain historical data, in which new data is added into the newest partition.
A typical example is a historical table where only the current month's data is updatable and the other 11 months are read only.
3. 需要存储在不同存储介质中的表
• Tables whose contents must be distributed across different types of storage devices.

### 何时考虑索引分区
1. 规避索引维护
• Avoid index maintenance when data is removed.
2. 避免分区操作时使索引失效
• Perform maintenance on parts of the data without invalidating the entire index.
3. 减轻索引倾斜
• Reduce the effect of index skew caused by an index on a column with a monotonically increasing value.


## 分区的优势
### 性能方面
By limiting the amount of data to be examined or operated on, and by providing data distribution for parallel execution, partitioning provides multiple performance benefits. Partitioning features include:
#### 分区修剪
• Partition Pruning for Performance
在分区修剪中，优化器在构建分区访问列表时分析SQL语句中的FROM和WHERE子句以消除不需要的分区。该功能使Oracle数据库只能在与SQL语句相关的分区上执行操作。
In partition pruning, the optimizer analyzes FROM and WHERE clauses in SQL statements to eliminate unneeded partitions when building the partition access list. This functionality enables Oracle Database to perform operations only on those partitions that are relevant to the SQL statement.
分区修剪极大地减少了从磁盘检索的数据量，缩短了处理时间，从而提高了查询性能，优化了资源利用
Partition pruning dramatically reduces the amount of data retrieved from disk and shortens processing time, thus improving query performance and optimizing resource utilization.
如果在不同的列上对索引和表进行分区(使用全局分区索引)，那么即使底层表的分区无法消除，分区修剪也会消除索引分区。（意即至少能减少索引扫描的数量）
根据实际的SQL语句，Oracle数据库可以使用静态或动态剪枝。静态修剪发生在编译时，使用预先访问的分区信息。动态剪枝发生在运行时，这意味着预先不知道语句要访问的确切分区。静态剪枝的示例场景是一个SQL语句，其中包含一个WHERE条件，在分区键列上有一个常量文字。动态修剪的一个例子是在WHERE条件中使用操作符或函数。
If you partition the index and table on different columns (with a global partitioned index), then partition pruning also eliminates index partitions even when the partitions of the underlying table cannot be eliminated.Depending upon the actual SQL statement, Oracle Database may use static or dynamic pruning. Static pruning occurs at compile-time, with the information about the partitions accessed beforehand. Dynamic pruning occurs at run-time, meaning that the exact partitions to be accessed by a statement are not known beforehand. A sample scenario for static pruning is a SQL statement containing a WHERE condition with a constant literal on the partition key column. An example

##### 分区剪枝何时生效

当你在范围或列表分区列上使用range、LIKE、equal和IN-list谓词时，
当你在哈希分区列上使用equal和IN-list谓词时
Oracle Database prunes partitions when you use range, LIKE, equality, and IN-list predicates on the range or list partitioning columns, and when you use equality and INlist predicates on the hash partitioning columns.
在复合分区上，oracle可以使用相关的谓词在各自的级别进行剪枝操作。（基于各自的hash、range等分区类型）
On composite partitioned objects, Oracle Database can prune at both levels using the relevant predicates.
引用分区在与被引用表进行连接时，
A reference-partitioned table can take advantage of partition pruning through the join with the referenced table.
基于虚拟列的分区 -sql语句使用与分区定义相同的表达式时
Virtual column-based partitioned tables benefit from partition pruning for statements that use the virtual column-defining expression in the SQL statement.

##### 如何确定分区剪枝是否生效

Whether Oracle uses partition pruning is reflected in the execution plan of a statement, either in the plan table for the EXPLAIN PLAN statement or in the shared SQL area.
The partition pruning information is reflected in the plan columns PSTART (PARTITION_START) and PSTOP (PARTITION_STOP). For serial statements, the pruning information is also reflected in the OPERATION and OPTIONS columns.


##### 静态修剪
For many cases, Oracle determines the partitions to be accessed at compile time. Static partition pruning occurs if you use static predicates, except for the following cases:
• Partition pruning occurs using the result of a subquery.
• The optimizer rewrites the query with a star transformation and pruning occurs after the star transformation.
• The most efficient execution plan is a nested loop.
These three cases result in the use of dynamic pruning
##### 动态修剪
对分区列使用绑定变量的语句会导致动态修剪
Statements that use bind variables against partition columns result in dynamic pruning.
显式地对分区列使用子查询的语句会导致动态修剪
Statements that explicitly use subqueries against partition columns result in dynamic pruning.
数据库使用星型转换转换的语句会导致动态修剪。
Statements that get transformed by the database using the star transformation result in dynamic pruning.
当嵌套查询是最有效的执行计划时
Statements that are most efficiently executed using a nested loop join use dynamic pruning.

##### 分区剪枝注意点
避免类型转换
To get the maximum performance benefit from partition pruning, you should avoid constructs that require the database to convert the data type you specify.
To guarantee a static partition pruning plan, you should explicitly convert data types to match the partition column data type
避免在分区列上使用显式或隐式函数转换
Avoid using implicit or explicit functions on the partition columns. If your queries commonly use function calls, then consider using a virtual column and virtual column partitioning to benefit from partition pruning in these cases.


#### 智能分区连接
• Partition-Wise Joins for Performance

Partition-wise operations significantly reduce response time and improve the use of both CPU and memory resources.
##### 完全分区连接
完全分区连接将来自两个连接表的一对分区之间的大连接划分为较小的连接
A full partition-wise join divides a large join into smaller joins between a pair of partitions from the two joined tables
##### 部分分区连接

With partial partition-wise joins, only one table must be partitioned on the join key.

### 管理方面
表或索引的维护粒度可以从整体降为部分，从表级到分区级，分而治之，互不影响。

### 可用性方面
不同的分区可以存储在不同的表空间、进而可以存储在不同的存储介质，某个分区的故障不影响其他分区正常提供服务；分区后带来的性能提升也能降低维护停业时间。

## 分区的策略
分区可以是单层分区，也可以是复合分区
### 单层分区
Single-Level Partitioning
These strategies are:
1. 范围分区 
Range
基于分区键的范围进行分区
Range partitioning maps data to partitions based on ranges of values of the partitioning key that you establish for each partition.
除了首个分区，每个分区都有一个下边界。
All partitions, except the first, have an implicit lower bound specified by the VALUES LESS THAN clause of the previous partition.
可以为最高分区指定一个maxvalue，存储不在分区键定义的值（如null）。
A MAXVALUE literal can be defined for the highest partition. MAXVALUE represents a virtual infinite value that sorts higher than any other possible value for the partitioning key, including the NULL value 

    范围分区有两类扩展
    1. Interval partitioning
    按指定间隔自动建分区
        • Interval-range
        • Interval-hash
        • Interval-list
    2. Partition Advisor
        • Reference Partitioning
        • Virtual Column-Based Partitioning

2. hash分区
Hash
对分区键运用散列算法，均匀地分发数据到分区。
Hash partitioning maps data to partitions based on a hashing algorithm that Oracle applies to the partitioning key that you identify.The hashing algorithm evenly distributes rows among partitions, giving partitions approximately the same size

hash算法不可指定
You cannot change the hashing algorithms used by partitioning.

3. 列表分区
List
为分区键指定离散值进行分区。
List partitioning enables you to explicitly control how rows map to partitions by specifying a list of discrete values for the partitioning key in the description for each partition.
可以设置个默认分区，不必枚举所有值
The DEFAULT partition enables you to avoid specifying all possible values for a listpartitioned table by using a default partition, so that all rows that do not map to any other partition do not generate an error.

### 复合分区
Composite Partitioning
• Composite Range-Range Partitioning
• Composite Range-Hash Partitioning
• Composite Range-List Partitioning
• Composite List-Range Partitioning
• Composite List-Hash Partitioning
• Composite List-List Partitioning
• Composite Hash-Hash Partitioning
• Composite Hash-List Partitioning
• Composite Hash-Range Partitioning

### 扩展功能
#### 间隔分区
Interval partitioning
可以使用间隔分区自动创建分区。
Interval partitioning is an extension of range partitioning.
Interval partitioning instructs the database to automatically create partitions of a specified interval when data inserted into the table exceeds all of the existing range partitions.
#### 分区顾问
Partition Advisor
分区顾问可以根据提供的SQL语句工作负载为表推荐分区策略，这些工作负载可以由SQL缓存、SQL调优集提供，也可以由用户定义
The Partition Advisor can recommend a partitioning strategy for a table based on a supplied workload of SQL statements which can be supplied by the SQL Cache, a SQL Tuning set, or be defined by the user.
#### 引用分区
引用分区允许通过引用约束对彼此相关的两个表进行分区。
Reference partitioning enables the partitioning of two tables that are related to one another by referential constraints.
分区键通过现有的父-子关系解析，由启用和活动的主键和外键约束强制执行
The partitioning key is resolved through an existing parent-child relationship, enforced by enabled and active primary key and foreign key constraints
这个扩展的好处是，可以通过从父表继承分区键而不复制键列来在逻辑上对具有父子关系的表进行分区。
The benefit of this extension is that tables with a parent-child relationship can be logically equipartitioned by inheriting the partitioning key from the parent table without duplicating the key columns.
#### 基于虚拟列的分区
Virtual Column-Based Partitioning
虚拟列使分区键可以由表达式定义
Oracle partitioning includes a partitioning strategy defined on virtual columns. Virtual columns enable the partitioning key to be defined by an expression, using one or more existing columns of a table

## 分区索引
分区表上的索引可以分区也可以不分区
Indexes on partitioned tables can either be nonpartitioned or partitioned.
它们既可以独立分区(全局索引)，也可以自动链接到表的分区方法(本地索引)。
They can either be partitioned independently (global indexes) or automatically linked to a table's partitioning method (local indexes).
通常，对于OLTP应用程序应该使用全局索引，对于数据仓库或决策支持系统(DSS)应用程序应该使用本地索引。
In general, you should use global indexes for OLTP applications and local indexes for data warehousing or decision support systems (DSS) applications.

### 分区索引类型的选择
1. 如果表分区列是索引键的子集，则使用本地索引。
If the table partitioning column is a subset of the index keys, then use a local index.
分区的列是索引的子集->本地索引
2. 如果索引是唯一的，并且不包括分区键列，则使用全局索引。
If the index is unique and does not include the partitioning key columns, then use a global index. 

3. 如果优先考虑的是可管理性，那么可以考虑使用本地索引。
If your priority is manageability, then consider a local index. If this is the case, then you are finished.
   
4. 如果应用程序是OLTP类型，并且用户需要快速响应时间，则使用全局索引。如果应用程序是决策支持系统（DSS）类型，而用户对吞吐量更感兴趣，则使用本地索引。
If the application is an OLTP type and users need quick response times, then use a global index. If the application is a DSS type and users are more interested in throughput, then use a local index.

### 本地索引的特点
本地索引的每个分区只与表的一个分区相关联。这个功能使Oracle能够自动保持索引分区与表分区同步，并使每个表-索引对独立。任何使一个分区的数据无效或不可用的操作只会影响单个分区。
The reason for this is equipartitioning: each partition of a local index is associated with exactly one partition of the table. This functionality enables Oracle to automatically keep the index partitions synchronized with the table partitions, and makes each table-index pair independent. Any actions that make one partition's data invalid or unavailable only affect a single partition.

本地索引可以是唯一的。但是，为了使本地索引是唯一的，表的分区键必须是索引的键列的一部分。
A local index can be unique. However, in order for a local index to be unique, the partitioning key of the table must be part of the index's key columns.

本地索引的管理依托于基础表 （不能显式地将分区添加到本地索引。相反，只有在向底层表添加分区时，才会向本地索引添加新分区。同样，不能显式地从本地索引中删除分区。相反，只有在从基础表删除分区时才会删除本地索引分区。）
You cannot explicitly add a partition to a local index. Instead, new partitions are added to local indexes only when you add a partition to the underlying table. Likewise, you cannot explicitly drop a partition from a local index. Instead, local index partitions are dropped only when you drop a partition from the underlying table.

### 全局分区索引的特点
#### 全局范围分区索引
全局范围分区索引比较灵活，分区的程度和分区键与表的分区方法无关
Global range partitioned indexes are flexible in that the degree of partitioning and the partitioning key are independent from the table's partitioning method

#### 全局哈希分区索引
当索引单调增长时，全局哈希分区索引通过分散争用来提高性能
Global hash partitioned indexes improve performance by spreading out contention when the index is monotonically growing.
大多数索引插入只发生在索引的右边缘，对于全局哈希分区索引，索引均匀分布在N个哈希分区上
most of the index insertions occur only on the right edge of an index,which is uniformly spread across N hash partitions for a global hash partitioned index

### 分区索引的维护
以下操作将导致堆组织表上的索引标记为不可用。
By default, the following operations on partitions on a heap-organized table mark all global indexes as unusable:
ADD (HASH)
COALESCE (HASH) （合并）
DROP
EXCHANGE
MERGE
MOVE
SPLIT
TRUNCATE

可以通过追加 UPDATE INDEXES 子句的方法对索引进行一并维护。
These indexes can be maintained by appending the clause UPDATE INDEXES to the SQL statements for the operation.

维护全局索引的优点有：
在整个操作过程中，索引保持可用并在线。因此，此操作不会影响其他应用程序。
不需要再重建索引。
drop 和 truncate 基于元数据操作。
The two advantages to maintaining global indexes are:
• The index remains available and online throughout the operation. Hence no other applications are affected by this operation.
• The index does not have to be rebuilt after the operation.
• The global index maintenance for DROP and TRUNCATE is implemented as metadataonly operation.


Online Transaction Processing (OLTP) system，
The main characteristics of an OLTP environment are:
• Short response time
• Small transactions
• Data maintenance operations
• Large user populations
• High concurrency
• Large data volumes
• High availability
• Lifecycle-related data usage

benefits of partitioning for OLTP environments
• Support for bigger databases
更细粒度的维护，分区可以选择压缩或不压缩，节约空间
• Partition maintenance operations for data maintenance 
部分分区操作可以代替dml，产生更少的redo
• Potential higher concurrency through elimination of hot spots
热点更新分离到不同区域


A nonpartitioned index, while larger than individual partitioned index segments, always
leads to a single index probe (or scan) if an index access path is chosen; there is only
one segment for a table. The data access time and number of blocks being accessed are
identical for both a partitioned and a nonpartitioned table.

A nonpartitioned index does not provide partition autonomy and requires an index
maintenance operation for every partition maintenance operation that affects rowids (for
example, drop, truncate, move, merge, coalesce, or split operations).

分区索引
被分配到多个段，使用时需要扫描多个段，需更高的I/O，性能有一定损失。

本地索引和分区键紧密关联，在操作分区数据后（如分区卸载等），索引自动维护，无需手工干预


在使用自增主键时，如果对按自增主键进行hash分区，建立本地索引，那么可以有效避免热点块问题（id接近，在相同的索引块存在激烈竞争）



非分区表转分区表
1.在线重定义
2.modify操作





Partitioned Index      Local Partitioned Index     Local Prefixed Index
                                                   Local Nonprefixed Index
                        Global Partitioned Index
Nonpartitioned Index


------------
1. 支持分区级别的管理（数据和索引管理），分区可以独立维护
2. 提升查询性能
3. 支持并行执行（queries、 DML 、 DDL）
4. 应用sql无需改造
5. 支持分区的对象有表、索引、索引组织表
---------------


