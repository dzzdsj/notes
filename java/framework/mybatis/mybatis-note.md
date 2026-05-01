
1. #{}和${}的区别
#{ } 的特点
底层实现：使用 PreparedStatement，支持SQL预编译
安全性：有效防止SQL注入攻击，相对更安全
工作原理：本质是占位符赋值，编译后转换为问号(?)占位符
自动处理：为字符串类型或日期类型字段赋值时，自动添加单引号
${ } 的特点
底层实现：使用 Statement 执行SQL语句
安全性：存在SQL注入风险，需谨慎使用
工作原理：本质是字符串拼接
手动处理：为字符串类型或日期类型字段赋值时，需手动添加单引号

2. 全局配置文件 mybatis-config.xml解析
   configuration（配置）
   properties（属性）
   settings（设置）
   typeAliases（类型别名）
   typeHandlers（类型处理器）
   objectFactory（对象工厂）
   plugins（插件）
   environments（环境配置）
     environment（环境变量）
       transactionManager（事务管理器）
       dataSource（数据源）
   databaseIdProvider（数据库厂商标识）
   mappers（映射器）

3. 