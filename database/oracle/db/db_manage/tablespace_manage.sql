-- 表空间管理

-- segment使用情况
select tablespace_name,initial_extent,next_extent,extent_management,allocation_type, segment_space_management from dba_tablespaces;

