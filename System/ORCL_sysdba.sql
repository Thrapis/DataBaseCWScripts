/*---1---*/
create tablespace TS_BAA
datafile 'C:\app\Tablespaces\TS_BAA.dbf'
size 10 m
autoextend on next 10 m
maxsize UNLIMITED
extent management local;

/*---2---*/
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
TEMPORARY TABLESPACE TS_BAA_TEMP
ACCOUNT UNLOCK;

grant create session to C##BAA;


BEGIN

  --Bye Sequences!
  FOR i IN (SELECT us.sequence_name
              FROM USER_SEQUENCES us) LOOP
    EXECUTE IMMEDIATE 'drop sequence '|| i.sequence_name ||'';
  END LOOP;

END;

PURGE RECYCLEBIN;


UPDATE PAYMENT SET PAYMENT_AMOUNT = ROUND(PAYMENT_AMOUNT, 2);

select * from DEBIT;
SELECT * FROM DEBIT WHERE CONTRACT_ID BETWEEN 1000 AND 3000 AND DEBIT_AMOUNT > 2;

begin
    DEBIT_PACKAGE.DETECTANDINSERTTERMDEBITS();
end;