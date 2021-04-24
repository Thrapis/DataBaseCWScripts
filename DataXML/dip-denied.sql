CREATE OR REPLACE PACKAGE DataImport_Package IS
    PROCEDURE ImportPosts(par_directory_name in nvarchar2, par_file_name in nvarchar2, imported out int);
END DataImport_Package;


CREATE OR REPLACE PACKAGE BODY DataImport_Package IS

    PROCEDURE ImportPosts(par_directory_name in nvarchar2, par_file_name in nvarchar2, imported out int) IS
        items_cur sys_refcursor;
        temp_post_table POST%rowtype;
        type temp_xml_row is record (xml_col xmltype);
        xml_temp_table temp_xml_row;
    BEGIN
        SELECT data INTO items_cur FROM
            (SELECT XMLTYPE(bfilename(par_directory_name, par_file_name), nls_charset_id('UTF8')) data FROM dual);
        --OPEN items_cur FOR SELECT * FROM xml_temp_table;
        DBMS_SQL.RETURN_RESULT(items_cur);

        /*SELECT x.* INTO temp_post_table FROM
            XMLTABLE('/data/row' PASSING xml_temp_table
                            COLUMNS ID          int           PATH 'ID',
                                    POST_NAME   nvarchar2(50) PATH 'POST_NAME',
                                    CATEGORY    nvarchar2(50) PATH 'CATEGORY') x;*/
    END;

END DataImport_Package;


    create or replace procedure p as
begin
  insert into orders
    select x.order_id, x.customer
    from   xml_tab t,
           xmltable('/orders/order'
             passing t.xml_doc
             columns
               order_id integer path 'order_id',
               customer varchar2(10) path 'customer_name'
           ) x;
end;