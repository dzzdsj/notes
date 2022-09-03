

# zookeeper概念

## zookeeper的角色

1. leader:

   - 集群数据的写操作（所有写操作都经过leader，只有操作半数节点，不包括observer节点写入成功，请求才算成功）；

   - 发起并维护心跳

2. flower:

   - 集群在读操作
   - 参与集群leader的选举

3. observer:（不参与选举）（为了支持更多的并发读，但又不想引入过多的实例使投票过程变得复杂）

   - 集群在读操作

## ZAB协议

1. epoch：指的是当前集群的周期号，每次leader变更都会产生一个比上一个周期号多1的新的周期号。（崩溃后恢复的leader会发现自己的epoch小于当前值，知道已经选出了新的leader。将以flower身份加入集群）

2. zixd：指的是ZAB协议的事务编号。是一个64位的数字。其中低32位存储的是一个单调递增的计数器，客户端的每一个事务请求，计数器都加一。高32位存储的是当前的epoch值。每次选举出新leader，epoch加一，低32位将归零。



## zookeeper的选举机制

1. 服务启动时，默认提议自己为leader，询问其他server给谁投票

2. 收到返回信息包含推荐为leader的serverid和zxid，结果zxid最大的serverid成为下一次投票要推荐为leader的。

3. 继续投票，得票最多的server将获胜，如果获胜者的票数超过了集群server个数的一半，将被选为leader。

4. 成为leader的节点等待其他flower连接。flower连接leader后，发送最大的zxid给leader。leader确认该zxid为同步点。选举完成，可以接收客户端的请求提供服务。

