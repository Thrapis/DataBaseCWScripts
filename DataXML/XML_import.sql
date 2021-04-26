INSERT INTO ACCOUNT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'ACCOUNT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS LOGIN           nvarchar2(50)   PATH 'LOGIN',
                                    HASH_PASSWORD   nvarchar2(32)   PATH 'HASH_PASSWORD',
                                    ACCESS_LEVEL    int             PATH 'ACCESS_LEVEL') x;

INSERT INTO ACCOUNT_EVENT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'ACCOUNT_EVENT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID              int           PATH 'ID',
                                    ACCOUNT_LOGIN   nvarchar2(50) PATH 'ACCOUNT_LOGIN',
                                    EVENT_DATETIME   nvarchar2(50) PATH 'EVENT_DATETIME',
                                    MESSAGE         nvarchar2(200) PATH 'MESSAGE') x;


DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM ACCOUNT_EVENT WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE account_event_seq INCREMENT BY '||last_val;
    SELECT account_event_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE account_event_seq INCREMENT BY 1';
END;

INSERT INTO POST SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'POST.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    POST_NAME   nvarchar2(50) PATH 'POST_NAME',
                                    CATEGORY    nvarchar2(50) PATH 'CATEGORY') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM POST WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE post_seq INCREMENT BY '||last_val;
    SELECT post_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE post_seq INCREMENT BY 1';
END;

INSERT INTO CLIENT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'CLIENT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    FULL_NAME   nvarchar2(50) PATH 'FULL_NAME',
                                    PASSPORT_NUMBER   nvarchar2(12) PATH 'PASSPORT_NUMBER',
                                    ACCOUNT_LOGIN    nvarchar2(50) PATH 'ACCOUNT_LOGIN') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM CLIENT WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE client_seq INCREMENT BY '||last_val;
    SELECT client_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE client_seq INCREMENT BY 1';
END;

INSERT INTO SERVICE_DESCRIPTION SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'SERVICE_DESCRIPTION.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    SERVICE_NAME   nvarchar2(50) PATH 'SERVICE_NAME',
                                    SERVICE_DESCRIPTION    nvarchar2(500) PATH 'SERVICE_DESCRIPTION') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM SERVICE_DESCRIPTION WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE service_description_seq INCREMENT BY '||last_val;
    SELECT service_description_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE service_description_seq INCREMENT BY 1';
END;

INSERT INTO TARIFF_PLAN SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'TARIFF_PLAN.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    TARIFF_NAME   nvarchar2(50) PATH 'TARIFF_NAME',
                                    TARIFF_AMOUNT    float(126) PATH 'TARIFF_AMOUNT') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM TARIFF_PLAN WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE tariff_plan_seq INCREMENT BY '||last_val;
    SELECT tariff_plan_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE tariff_plan_seq INCREMENT BY 1';
END;

INSERT INTO EMPLOYEE SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'EMPLOYEE.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    FULL_NAME   nvarchar2(50) PATH 'FULL_NAME',
                                    POST_ID     int           PATH 'POST_ID',
                                    ACCOUNT_LOGIN    nvarchar2(50) PATH 'ACCOUNT_LOGIN') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM EMPLOYEE WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE employee_seq INCREMENT BY '||last_val;
    SELECT employee_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE employee_seq INCREMENT BY 1';
END;

INSERT INTO CONTRACT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'CONTRACT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    TARIFF_ID   int         PATH 'TARIFF_ID',
                                    CLIENT_ID   int          PATH 'CLIENT_ID',
                                    EMPLOYEE_ID   int        PATH 'EMPLOYEE_ID',
                                    SIGNING_DATETIME     nvarchar2(50) PATH 'SIGNING_DATETIME') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM CONTRACT WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE contract_seq INCREMENT BY '||last_val;
    SELECT contract_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE contract_seq INCREMENT BY 1';
END;

INSERT INTO PHONE_NUMBER SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'PHONE_NUMBER.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    PHONE_NUMBER   nvarchar2(14) PATH 'PHONE_NUMBER',
                                    CONTRACT_ID    int PATH 'CONTRACT_ID') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM PHONE_NUMBER WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE phone_number_seq INCREMENT BY '||last_val;
    SELECT phone_number_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE phone_number_seq INCREMENT BY 1';
END;

INSERT INTO CALL SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'CALL.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    CONTRACT_ID   int PATH 'CONTRACT_ID',
                                    TO_PHONE_NUMBER   nvarchar2(14) PATH 'TO_PHONE_NUMBER',
                                    TALK_TIME   interval day to second PATH 'TALK_TIME',
                                    CALL_DATETIME    nvarchar2(50) PATH 'CALL_DATETIME') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM CALL WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE call_seq INCREMENT BY '||last_val;
    SELECT call_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE call_seq INCREMENT BY 1';
END;

INSERT INTO PAYMENT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'PAYMENT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    CONTRACT_ID   int PATH 'CONTRACT_ID',
                                    PAYMENT_AMOUNT   float(126) PATH 'PAYMENT_AMOUNT',
                                    PAYMENT_DATETIME  timestamp PATH 'PAYMENT_DATETIME') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM PAYMENT WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE payment_seq INCREMENT BY '||last_val;
    SELECT payment_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE payment_seq INCREMENT BY 1';
END;

INSERT INTO DEBIT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'DEBIT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    CONTRACT_ID   int PATH 'CONTRACT_ID',
                                    DEBIT_AMOUNT   float(126) PATH 'DEBIT_AMOUNT',
                                    DEBIT_DATETIME   nvarchar2(50) PATH 'DEBIT_DATETIME',
                                    REASON    nvarchar2(250) PATH 'REASON') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM DEBIT WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE debit_seq INCREMENT BY '||last_val;
    SELECT debit_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE debit_seq INCREMENT BY 1';
END;

INSERT INTO SERVICE SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'SERVICE.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/ROWSET/ROW' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    CONTRACT_ID   int PATH 'CONTRACT_ID',
                                    DESCRIPTION_ID   int PATH 'DESCRIPTION_ID',
                                    SERVICE_AMOUNT   float(126) PATH 'SERVICE_AMOUNT',
                                    CONNECTION_DATE   nvarchar2(50) PATH 'CONNECTION_DATE',
                                    DISCONNECTION_DATE    nvarchar2(50) PATH 'DISCONNECTION_DATE') x;

DECLARE
    last_val int := 0;
BEGIN
    SELECT ID INTO last_val FROM SERVICE WHERE ROWNUM = 1 ORDER BY ID DESC;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE service_seq INCREMENT BY '||last_val;
    SELECT service_seq.NEXTVAL INTO last_val FROM dual;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE service_seq INCREMENT BY 1';
END;