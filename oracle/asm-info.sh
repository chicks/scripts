#! /usr/bin/bash

su - oracle -c 'sqlplus -s "/ as sysdba"' <<'EOF'

column path format a25;
column disk_name format a15;
set pagesize 500;
set linesize 300;

select
  g.name as group_name,
  d.path, d.disk_number,
  d.name as disk_name,
  g.total_mb / 1024 as group_total_gb,
  g.free_mb / 1024 as group_free_gb,
  100 - Round((((g.free_mb / 1024) / (g.total_mb / 1024)) * 100), 2) as group_percent_used,
  d.total_mb / 1024 as disk_total_gb
from
  SYS.V$ASM_DISK d,
  SYS.V$ASM_DISKGROUP g
where
  g.group_number= d.group_number;
exit;
EOF

