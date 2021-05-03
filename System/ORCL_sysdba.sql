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

alter session set "_ORACLE_SCRIPT"=true;

CREATE ROLE AppConnectorRole;

GRANT CREATE SESSION TO AppConnectorRole;
GRANT EXECUTE ON C##BAA.ACCOUNT_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.CALL_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.CLIENT_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.CONTRACT_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.DEBIT_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.EMPLOYEE_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.PAYMENT_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.PHONENUMBER_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.POST_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.SERVICE_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.SERVICEDESCRIPTION_PACKAGE to AppConnectorRole;
GRANT EXECUTE ON C##BAA.TARIFFPLAN_PACKAGE to AppConnectorRole;

CREATE USER AppConnectorUser IDENTIFIED BY 12345
DEFAULT TABLESPACE TS_BAA QUOTA UNLIMITED ON TS_BAA
TEMPORARY TABLESPACE TS_BAA_TEMP_2
ACCOUNT UNLOCK;

GRANT AppConnectorRole TO AppConnectorUser;
