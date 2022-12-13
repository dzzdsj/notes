
--ESCAPE 转义字符定义
SELECT * FROM v$sql WHERE sql_fulltext LIKE '%T\_%' ESCAPE '\';




--rank() over  
--注意：结果相同的两个是并列关系
--以整个结果集分组，按a,b排序
SELECT a,b,c,rank() OVER(ORDER BY a,b) rank FROM dzzdsj.t_tmp;
--按a,b分组，每个组内按c倒序
SELECT a,b,c,rank() OVER(PARTITION BY a,b ORDER BY c desc) rank FROM dzzdsj.t_tmp;

创建一个dzzdsj.t_tmp表，并插入6条数据。
CREATE TABLE dzzdsj.t_tmp
(
	a INT,
	b INT,
	c CHAR
);
INSERT INTO dzzdsj.t_tmp VALUES(1,3,'E');
INSERT INTO dzzdsj.t_tmp VALUES(2,4,'A');
INSERT INTO dzzdsj.t_tmp VALUES(3,2,'D');
INSERT INTO dzzdsj.t_tmp VALUES(3,5,'B');
INSERT INTO dzzdsj.t_tmp VALUES(4,2,'C');
INSERT INTO dzzdsj.t_tmp VALUES(2,4,'B');
commit;

SELECT * from dzzdsj.t_tmp;
a           b           c
----------- ----------- ----
1           3           E
2           4           A
3           2           D
3           5           B
4           2           C
2           4           B









