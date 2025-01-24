##SGA
###
--查询SGA各组件分配内存大小
show sga;
select pool, name, bytes from V$SGASTAT;
--SGA动态组件大小
select component, current_size, min_size, max_size from v$sga_dynamic_components;
select component, current_size/1024/1024/1024 , min_size/1024/1024/1024 , max_size/1024/1024/1024 from v$sga_dynamic_components;

Database Buffers = DEFAULT buffer cache + Shared IO Pool 
----
show sga;

Total System Global Area 4999608360 bytes
Fixed Size                  8906792 bytes
Variable Size             905969664 bytes
Database Buffers         4076863488 bytes
Redo Buffers                7868416 bytes
SQL> select component, current_size, min_size, max_size from v$sga_dynamic_components;

COMPONENT                                                        CURRENT_SIZE   MIN_SIZE   MAX_SIZE
---------------------------------------------------------------- ------------ ---------- ----------
shared pool                                                         889192448  889192448  889192448
large pool                                                           16777216   16777216   16777216
java pool                                                                   0          0          0
streams pool                                                                0          0          0
unified pga pool                                                            0          0          0
memoptimize buffer cache                                                    0          0          0
DEFAULT buffer cache                                               3942645760 3942645760 3942645760
KEEP buffer cache                                                           0          0          0
RECYCLE buffer cache                                                        0          0          0
DEFAULT 2K buffer cache                                                     0          0          0
DEFAULT 4K buffer cache                                                     0          0          0
DEFAULT 8K buffer cache                                                     0          0          0
DEFAULT 16K buffer cache                                                    0          0          0
DEFAULT 32K buffer cache                                                    0          0          0
Shared IO Pool                                                      134217728  134217728  134217728
Data Transfer Cache                                                         0          0          0
In-Memory Area                                                              0          0          0
In Memory RW Extension Area                                                 0          0          0
In Memory RO Extension Area                                                 0          0          0
ASM Buffer Cache                                                            0          0          0


##PGA
###
--查询PGA分配了多少内存
select name, value from v$pgastat where name in ('maximum PGA allocated','total PGA allocated');

--
NAME                                                                  VALUE
---------------------------------------------------------------- ----------
total PGA allocated                                               194502656
maximum PGA allocated                                             500019200




--AWR
select * from dba_hist_wr_control;





--
SELECT a.value curr_cached, p.value max_cached,
s.username, s.sid, s.serial#
FROM v$sesstat a, v$statname b, v$session s, v$parameter2 p
WHERE a.statistic# = b.statistic# and s.sid=a.sid and a.sid=&sid
AND p.name='session_cached_cursors'
AND b.name = 'session cursor cache count';

--伪列
--ora_rowscn
--dml
--ora_rowscn记录的是块级别的改动，即该块上有任何一行进行了修改，该块的ora_rowscn都发生变化，而且一个块的ora_rowscn是相同的
SELECT t.*, rowid, dbms_rowid.rowid_block_number(rowid) block_id, ora_rowscn FROM DZZDSJ.t_test t;
--ddl
--新增一列，ora_rowscn没有发生变化;删除一列，所有的ora_rowscn全部发生变化.这是因为新增一列只是修改了表的定义，对表的行没有影响，而删除一列，会同步修改表的行，所以ora_rowscn会发生变化
--rowdependencies 
--rowdependencies的表是细颗粒的，ora_rowscn精确到每一行，而创建表默认是norowdependencies，只精确到块
create table t2(id int, name varchar2(10)) rowdependencies;
--判断表是否是rowdependencies
select table_name, dependencies from user_tables where table_name in ('T1', 'T2');


--SCN
SELECT SCN_TO_TIMESTAMP(2348089) FROM dual;
--scn_to_timestamp函数能够转换成时间的最小scn记录在表smon_scn_time中，只有大于等于这个最小值才能使用scn_to_timestamp函数
select min(scn),SCN_TO_TIMESTAMP(min(scn)),max(scn),SCN_TO_TIMESTAMP(max(scn)) from sys.smon_scn_time;


--变量定义  
-- def(ine) ,var(iable), declare ,accept 分别适用于不同的环境
--define  define 可以定义一个变量，在调用该变量时使用符号 & . 
--  sqlplus 环境(command窗口) 中用于定义变量, 适用于人机交互处理，或者sql脚本。
define abc=1;
select * from dual where rownum=&abc;

--accept 人机交互给变量赋值时使用acc(ecpt)命令
SQL> acc i number prompt "Please input a number:"
Please input a number:4
SQL> select &i from dual;

--variable   变量作用域为当前sqlplus环境。需要通过 : 来标记为变量
--  plsql 匿名块中使用。非匿名块中不能使用。
col scn for 9999999999999999999999
var a number;   -- 通过variable 定义变量
begin
-- 在匿名块中给 :a 变量赋值
select DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER into :a from dual;
end;
/
define current_scn = :a
select &current_scn as scn from dual;

--declare  declare 定义变量后，变量标识符在整个块结构内部都代表变量,在结构块外部不可用, 也就是说 declare的作用域只是结构体内部。这点与variable定义变量不同。变量的调用方式也不一样, declare定义的变量， 不需要添加任何额外的标记，而variable 定义的变量需要和冒号配合使用
--  plsql 块中使用,适用于匿名块或者非匿名块。
declare current_scn number;
begin
-- 注意： into 后面的变量就是declare定义的变量    
     select DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER into current_scn from dual;
     dbms_output.put_line(current_scn);
  end;
  /


--
alter system flush shared_pool;

 alter system flush buffer_cache;




-- hit ratio for the buffer cache （缓存命中率） 
--缓存命中率的高低不能说明一定有问题，而应该持续跟踪，如果突然发生重大变动，那么很可能预示着数据库的重大变更。
--oracle 一般使用完成工作的时间（cpu time）和等待工作所消耗的时间来评估性能
--缓存命中率的计算 目前存在两套公式：
--其一  数据中心 和 《oracle database 11g 性能调整与优化》在用
--  Hit Ratio = 1 - (physical reads / (db block gets + consistent gets))。
--命中率仅包括缓存读操作而不包括写操作
select sum(decode(name,'physical reads',value,0)) phys,
       sum(decode(name,'db block gets',value,0)) gets,
       sum(decode(name,'consistent gets',value,0)) con_gets,
       (1-(sum(decode(name,'physical reads',value,0))/
       (sum(decode(name,'db block gets',value,0)) + 
       sum(decode(name,'consistent gets',value,0))))) * 100 hitratio 
from   v$sysstat;
--其二 《database-performance-tuning-guide》在用，每项都分成了cache和direct，如physical reads=physical reads cache + physical reads direct等。
--     hit ratio for the buffer cache = 1 - (('physical reads cache') / ('consistent gets from cache' + 'db block gets from cache'))
SELECT name, value
FROM V$SYSSTAT
WHERE name IN ('db block gets from cache', 'consistent gets from cache','physical reads cache');

select sum(decode(name,'physical reads cache',value,0)) phys,
       sum(decode(name,'db block gets from cache',value,0)) gets,
       sum(decode(name,'consistent gets from cache',value,0)) con_gets,
       (1-(sum(decode(name,'physical reads cache',value,0))/
       (sum(decode(name,'db block gets from cache',value,0)) + 
       sum(decode(name,'consistent gets from cache',value,0))))) * 100 hitratio 
from   v$sysstat;
-- 变更可以参考以下视图
SELECT * FROM V$DB_CACHE_ADVICE

--DB_BLOCK_SIZE
--数据块大小越大，单个块能容纳的数据就越多，大量数据返回时的效率越高
--小的数据块，检索单条记录的速度更快，节省内存空间（同等内存可缓存更多的有效信息），较小的块能提高事务并发能力，减少日志文件的生成速度
--OLAP系统，如数据仓库应当使用对应平台上最大的块大小（16KB或32KB）
--OLTP系统，联机交易型系统建议使用8KB
--系统的事务处理的吞吐量特别高或内存不足时，或许可以考虑把块大小设置成小于8KB


--何时考虑增大SHARE_POOL_SIZE ？
--数据字典缓存命中率低于95%，库缓存重载率超过1%，库缓存命中率低于95%
--数据字典缓存命中率 , 除了数据块最初启动时，应当维持大于95%
select ((1 - (sum(GetMisses) / (sum(Gets) + sum(GetMisses)))) * 100) "Hit Rate"
from v$rowcache
where Gets + GetMisses <> 0;
--库缓存重载率  不是0，说明有些“过时”的语句后来又需要重新载入内存
select sum(Pins) "Hits",
       sum(Reloads) "Misses",
       ((sum(Reloads)/sum(Pins))*100) "Reload%"
from v$librarycache;
--库缓存命中率
select sum(Pins) "Hits",
       sum(Reloads) "Misses",
       sum(Pins)/(sum(Pins) + sum(Reloads)) "Hit Ratio"
from v$librarycache;

Log buffer
Other buffer caches, such as KEEP, RECYCLE, and other block sizes
Fixed SGA and other internal allocations



 --SELECT * FROM V$DB_CACHE_ADVICE;
set linesize 200
set pagesize 1000
col SIZE_FOR_ESTIMATE                for 999999.99
col SIZE_FACTOR                      for 999999.99  
col ESTD_PHYSICAL_READ_FACTOR        for 999999.99 
col ESTD_PHYSICAL_READ_TIME          for 999999.99
select SIZE_FOR_ESTIMATE,SIZE_FACTOR,ESTD_PHYSICAL_READ_FACTOR,ESTD_PHYSICAL_READ_TIME from V$DB_CACHE_ADVICE; 

-- SELECT * FROM V$SGA_TARGET_ADVICE;
set linesize 500
set pagesize 1000
col SGA_SIZE                         for 99999999999
col SGA_SIZE_FACTOR                  for 99.99
col ESTD_DB_TIME                     for 99999999999
col ESTD_DB_TIME_FACTOR              for 99.99
col ESTD_PHYSICAL_READS              for 99999999999
col ESTD_BUFFER_CACHE_SIZE           for 99999999999
col ESTD_SHARED_POOL_SIZE            for 99999999999
select SGA_SIZE,SGA_SIZE_FACTOR,ESTD_DB_TIME,ESTD_DB_TIME_FACTOR,ESTD_PHYSICAL_READS,ESTD_BUFFER_CACHE_SIZE,ESTD_SHARED_POOL_SIZE from V$SGA_TARGET_ADVICE;

--EXECUTIONS,SQL_FULLTEXT (find  "table access full" sql )
set linesize 500
set pagesize 1000
col EXECUTIONS                         for 99999999999
col SQL_TEXT                           for a200
SELECT S.EXECUTIONS,S.SQL_TEXT from V$SQL_PLAN P JOIN V$SQLAREA S ON P.SQL_ID=S.SQL_ID where P.OBJECT_OWNER='CIB' and P.object_type='TABLE' and P.OPERATION='TABLE ACCESS' and P.OPTIONS='FULL'  order by S.EXECUTIONS desc ;

--determine which segments have many buffers in the pool
--The V$BH view shows the data object ID of all blocks that currently reside in the SGA,One method to determine which segments have many buffers in the pool is to query the number of blocks for all segments that reside in the buffer cache at a given time
COLUMN object_name FORMAT A40
COLUMN number_of_blocks FORMAT 999,999,999,999
SELECT o.object_name, COUNT(*) number_of_blocks
FROM DBA_OBJECTS o, V$BH bh
WHERE o.data_object_id = bh.OBJD
AND o.owner != 'SYS'
GROUP BY o.object_Name
ORDER BY COUNT(*);

SELECT o.object_name, COUNT(*) number_of_blocks
FROM DBA_OBJECTS o, V$BH bh
WHERE o.data_object_id = bh.OBJD
AND (o.owner = 'DZZDSJ' OR o.owner = 'CIB' )
GROUP BY o.object_Name
ORDER BY COUNT(*);

--To calculate the percentage of the buffer cache used by an individual object
1. Find the Oracle Database internal object number of the segment by querying the
DBA_OBJECTS view:
SELECT data_object_id, object_type
FROM DBA_OBJECTS
WHERE object_name = UPPER('segment_name');
Because two objects can have the same name (if they are different types of
objects), use the OBJECT_TYPE column to identify the object of interest.
2. Find the number of buffers in the buffer cache for SEGMENT_NAME:
SELECT COUNT(*) buffers
FROM V$BH
WHERE objd = data_object_id_value;
For data_object_id_value, use the value of DATA_OBJECT_ID from the previous
step.
3. Find the number of buffers in the database instance:
SELECT name, block_size, SUM(buffers)
FROM V$BUFFER_POOL
GROUP BY name, block_size
HAVING SUM(buffers) > 0;
4. Calculate the ratio of buffers to total buffers to obtain the percentage of the cache
currently used by SEGMENT_NAME:
% cache used by segment_name = [buffers(Step2)/total buffers(Step3)]

--查看隐藏参数的值
select
x.ksppinm  name,
y.ksppstvl  value,
y.ksppstdf  isdefault,
decode(bitand(y.ksppstvf,7),1,'MODIFIED',4,'SYSTEM_MOD','FALSE')  ismod,
decode(bitand(y.ksppstvf,2),2,'TRUE','FALSE')  isadj
from
sys.x$ksppi x,
sys.x$ksppcv y
where
x.inst_id = userenv('Instance') and
y.inst_id = userenv('Instance') and
x.indx = y.indx 
--具体隐藏参数
--and x.ksppinm ='_gc_undo_affinity'
and x.ksppinm ='control_files'
order by
translate(x.ksppinm, ' _', ' ');

