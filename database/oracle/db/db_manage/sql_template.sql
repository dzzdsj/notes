--------------- delete duplicate data 数据去重----------------------------------------------
create table dzzdsj.t_duplicate
(
    id number(20),
    sname varchar2(20)
);
INSERT INTO DZZDSJ.T_DUPLICATE (ID,SNAME) VALUES (1,'2');
INSERT INTO DZZDSJ.T_DUPLICATE (ID,SNAME) VALUES (1,'2');
INSERT INTO DZZDSJ.T_DUPLICATE (ID,SNAME) VALUES (2,'2');
INSERT INTO DZZDSJ.T_DUPLICATE (ID,SNAME) VALUES (2,'2');
INSERT INTO DZZDSJ.T_DUPLICATE (ID,SNAME) VALUES (3,'2');
INSERT INTO DZZDSJ.T_DUPLICATE (ID,SNAME) VALUES (3,'1');

--use rowid & not in
select t.rowid,t.* from dzzdsj.t_duplicate  t where t.rowid not in (select max(rowid) from dzzdsj.t_duplicate group by id,sname); 
delete from dzzdsj.t_duplicate  t where t.rowid not in (select max(rowid) from dzzdsj.t_duplicate group by id,sname); 
-- use rowid & left join
select t1.rowid,t1.*,t2.maxrowid from dzzdsj.t_duplicate t1 left join  (select max(rowid) as maxrowid from dzzdsj.t_duplicate group by id,sname) t2 on t1.rowid=t2.maxrowid where t2.maxrowid is null;
-- use rowid & not exists
select t1.rowid,t1.* from dzzdsj.t_duplicate t1 where not exists (select 'x' from (select max(rowid) as maxrowid from dzzdsj.t_duplicate group by id,sname) t2 where t1.rowid=t2.maxrowid);

---------------merge 写法----------------------------------------------
--merge delete
merge into dzzdsj.T_A t1 using dzzdsj.T_B t2 on (t1.xxx=t2.xxx) 
when matched then 
update set t1.id=t2.id delete where 1=1;

merge into dzzdsj.T_A t1 using dzzdsj.T_B t2 on (t1.xxx=t2.xxx) 
when matched then 
update set t1.id=t2.id delete where t1.upd_time<to_date('xxxx','yyyyMMddHH24miss');

--merge update & insert
merge into tname t1
using tmpname t2
on (t1.uniq_col=t2.uniq_col)
when matched then
update set 
updatelist
when not matched then 
insert(colrow)
values(t2colrow)













