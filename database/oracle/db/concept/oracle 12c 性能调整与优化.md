oracle 12c 性能调整与优化

#



# 第2章 索引基本原理

## 2.1 索引基本概念

1. 访问表数据的两种方式：从表中读取所有行（即全表扫描）， 或者通过ROWID 一次读取一行。

2. 索引对性能改进的程度：取决于数据的选择性以及数据在表的数据块中的分布方式。

3. 当数据分散在表的多个数据块中时， 最好是不使用索引， 而是选择全表扫描。执行全表扫描时， Oracle使用多块读取以快速扫描表。基于索引的读是单块读。

4. 索引对性能的影响：

   - 提升 select、update、delete命令的where子句的性能（访问的行较少时）
   - 降低 insert语句性能
   - 降低 索引列上 的update操作性能
   - 降低 大量行的delete 性能
   - 在表上加一个索引都会使该表上INSERT 操作的执行时间变成原来的三倍；再加一个索引就会再慢一倍；然而， 一个由两列组成的索引并不比只有一个列的索引差很多． 索引列的UPDATE和DELETE操作同样也会变慢。

5. 索引相关视图

   dba_indexes:

   dba_ind_columns:

   ```sql
   select table_name, index_name, column_name, column_position from user_ind_columns order by table_name, index_name, column_position;
   ```

   

## 2.2 不可视索引

```sql
ALTER INDEX idxl INVISIBLE;
ALTER INDEX idxl VISIBLE;
CREATE INDEX... INVISIBLE;
--通过提示强制使用/不使用索引
select /*+ use_invisible_indexes */ count(*) from emp where deptno=30;
select /*+ no_index(emp emp_idx1) */ count(*) from emp where deptno=30;
```

## 2.3 组合索引

1. 索引的第一列应该是最有可能在where子句中使用的列， 并且也是索引中最具选择性的列。
2. 在引入跳跃式扫描功能之前，只有当索引中的前导列也出现在where子句中时， 查询才能使用索引。9i版本引入之后，优化器也可能会选择使用该索引。另外， 优化器也可能会选择索引快速全扫描(Index Fast Full Scan)或全表扫描。
3. 两种最常见的索引扫描方式是唯一扫描(Unique Scan)和范围扫描(Range Scan) 。

## 2.4 索引抑制

以下情况会导致索引无法使用：

1. 使用不等于<> , !=
2. 使用is null , is not null
3. 使用like的情况：只有like 'abcd%'这种值在开始的情况才能使用索引。而like '%abcd%'则无法使用。
4. 使用函数时会忽略列上的索引（除非基于函数的索引）
5. 比较不匹配的数据类型：例如列 a varchar2(3)，查询 where a=123时，会使用函数隐式转换为数值，使索引失效

## 2.5 选择性

1. 通过对表或索引进行分析的方法来确定不同键的数量， 之后就可以查询USER_INDEXES视图的DISTINCT_KEYS列来查看分析结果。比较一下不同键的数矗和表中的行数(USER_INDEXES视图中的NUM_ROWS列）， 就可以知道索引的选择性。
2. 对于组合索引， 在索引中添加额外的列不会显著改善选择性， 额外列增加的成本可能会超出收益。

## 2.6 集群因子

1. 集群因子是索引与它所在的表相比较的有序性度量， 它用于检查在索引访问之后执行的表查找的成本（将集群因子与选择性相乘即可得到该操作的成本）。集群因子记录在扫描索引时需要读取的数据块数量。
2. 如果集群因子接近于表中的数据块数量， 就表示索引对应数据行的排序情况良好； 但是， 如果集群因子接近于表中的数据行数量，就表示索引对应的数据块排序情况不佳。

## 2.7 二元高度

1. 索引的二元高度对把ROWID返回给用户进程时所要求的1/0数盘起到关键作用 。 二元高度的每个级别都会增加一 个额外的块读取操作， 而且由千这些块不能按顺序读取， 它们都要求一个独立的1/0操作。
2. 







