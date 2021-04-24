create or replace directory XMLData as 'C:\DataXML';

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from ACCOUNT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'ACCOUNTS.xml');
END;


INSERT INTO ACCOUNT SELECT x.*
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'C_BAA_ACCOUNT.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/data/row' PASSING xml_data
                            COLUMNS LOGIN           nvarchar2(50)   PATH 'LOGIN',
                                    HASH_PASSWORD   nvarchar2(32)   PATH 'HASH_PASSWORD',
                                    ACCESS_LEVEL    int             PATH 'ACCESS_LEVEL') x;

INSERT INTO POST (POST_NAME, CATEGORY) SELECT x.POST_NAME, x.CATEGORY
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'C_BAA_POST.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/data/row' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    POST_NAME   nvarchar2(50) PATH 'POST_NAME',
                                    CATEGORY    nvarchar2(50) PATH 'CATEGORY') x;

INSERT INTO POST (POST_NAME, CATEGORY) SELECT x.POST_NAME, x.CATEGORY
    FROM (SELECT XMLTYPE(bfilename('XMLDATA', 'C_BAA_POST.xml'), nls_charset_id('UTF8')) xml_data FROM dual),
    XMLTABLE('/data/row' PASSING xml_data
                            COLUMNS ID          int           PATH 'ID',
                                    POST_NAME   nvarchar2(50) PATH 'POST_NAME',
                                    CATEGORY    nvarchar2(50) PATH 'CATEGORY') x;


    




