
-- 
mysql -u root -p 
show databases;
use $database_name;

-- 
show processlist;

--连接超时时间
show global variables like 'wait_timeout'; -- 非交互式超时时间，如JDBC 程序，默认八小时。
show global variables like 'interactive_timeout'; -- 交互式超时时间，如数据库工具










