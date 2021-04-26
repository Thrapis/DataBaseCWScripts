DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from ACCOUNT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'ACCOUNT.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from ACCOUNT_EVENT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'ACCOUNT_EVENT.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from POST') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'POST.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from CLIENT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'CLIENT.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from SERVICE_DESCRIPTION') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'SERVICE_DESCRIPTION.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from TARIFF_PLAN') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'TARIFF_PLAN.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from EMPLOYEE') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'EMPLOYEE.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from CONTRACT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'CONTRACT.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from PHONE_NUMBER') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'PHONE_NUMBER.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from CALL') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'CALL.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from PAYMENT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'PAYMENT.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from DEBIT') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'DEBIT.xml');
END;

DECLARE
    xml_clob clob;
BEGIN
    select dbms_xmlgen.getxml('select * from SERVICE') into xml_clob from dual;
    DBMS_XSLPROCESSOR.CLOB2FILE(cl => xml_clob, flocation => 'XMLDATA', fname => 'SERVICE.xml');
END;