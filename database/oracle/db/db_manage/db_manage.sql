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


--数据块越大，能容纳的数据

