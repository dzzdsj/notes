--
show parameter spfile;
show parameter dump_dest;
show parameter control_files;
show parameter db_name;
show parameter sga;

select * from v$controlfile;
select * from v$sgastat;

select cphbt from x$kcccp;
--查询scn号 system change number
select dbms_flashback.get_system_change_number from dual;
select * from v$log;