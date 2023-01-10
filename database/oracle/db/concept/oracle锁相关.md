## 标准SQL隔离级别

| Isolation Level  | Dirty Read   | Nonrepeatable Read | Phantom Read |
| ---------------- | ------------ | ------------------ | ------------ |
| Read uncommitted | Possible     | Possible           | Possible     |
| Read committed   | Not possible | Possible           | Possible     |
| Repeatable       | Not possible | Not possible       | Possible     |
| Serializable     | Not possible | Not possible       | Not possible |



• Dirty reads（脏读）
A transaction reads data that has been written by another transaction that has not
been committed yet.（读到了其他事务未提交的内容）

• Nonrepeatable (fuzzy) reads（不可重复读）
A transaction rereads data it has previously read and finds that another committed
transaction has modified or deleted the data. For example, a user queries a row
and then later queries the same row, only to discover that the data has changed.（先前查询的数据改变了）

• Phantom reads（幻影读）
A transaction reruns a query returning a set of rows that satisfies a search
condition and finds that another committed transaction has inserted additional
rows that satisfy the condition.More data satisfies the query criteria
than before, but unlike in a fuzzy read the previously read data is unchanged.（专指新增插入，之前的数据未改变）



## ORACLE隔离级别

• Read Committed Isolation Level

In the read committed isolation level, every query executed by a transaction sees
only data committed before the query—not the transaction—began.（指的是查询执行之前的数据不可见，而非事务开始之前）

This isolation level is the default. It is appropriate for database environments in which
few transactions are likely to conflict.（默认隔离级别，适用于冲突较少的环境）





• Serializable Isolation Level



• Read-Only Isolation Level



