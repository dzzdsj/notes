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







