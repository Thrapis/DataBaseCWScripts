create tablespace TS_BAA
datafile 'C:\app\Tablespaces\TS_BAA.dbf'
size 10 m
autoextend on next 10 m
maxsize UNLIMITED
extent management local;

create temporary tablespace TS_BAA_TEMP
tempfile 'C:\app\Tablespaces\TS_BAA_TEMP.dbf'
size 5 m
autoextend on next 3 m 
maxsize 100 m
extent management local;

create temporary tablespace TS_BAA_TEMP_2
tempfile 'C:\app\Tablespaces\TS_BAA_TEMP_2.dbf'
size 5 m
autoextend on next 15 m
maxsize 500 m
extent management local;

alter session set "_ORACLE_SCRIPT"=true;

CREATE USER C##BAA IDENTIFIED BY 12345
DEFAULT TABLESPACE TS_BAA QUOTA UNLIMITED ON TS_BAA
TEMPORARY TABLESPACE TS_BAA_TEMP_2
ACCOUNT UNLOCK;

grant create session to C##BAA;

select * from dba_sys_privs where grantee = 'C##BAA';

select * from DBA_SYS_PRIVS;