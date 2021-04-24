-- set server--output on;

CREATE OR REPLACE PACKAGE Account_Package IS
	PROCEDURE CreateAccount(par_username in nvarchar2, par_password in nvarchar2, par_access_level in int, created out int);
    PROCEDURE GetAccount(par_username in out nvarchar2, par_password in nvarchar2, ret_access_level out int);
    PROCEDURE ChangeAccountPassword(par_username in out nvarchar2, par_old_password in nvarchar2, par_new_password in nvarchar2, changed out int);
    PROCEDURE InsertAccountEvent(par_username in nvarchar2, par_event_datetime in nvarchar2, par_message in nvarchar2, inserted out int);
END Account_Package;



CREATE OR REPLACE PACKAGE BODY Account_Package IS                -----Start of package body
    PROCEDURE CreateAccount(par_username in nvarchar2, par_password in nvarchar2, par_access_level in int, created out int) IS
        hash_pass nvarchar2(32);
    BEGIN
        hash_pass := sys.dbms_crypto.hash(utl_i18n.string_to_raw(par_password, 'AL32UTF8'), 2);
        INSERT INTO Account VALUES (par_username, hash_pass, par_access_level);
        created := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            created := 0;
            ROLLBACK;
    END;

    PROCEDURE GetAccount(par_username in out nvarchar2, par_password in nvarchar2, ret_access_level out int) IS
        hash_pass nvarchar2(32);
        new_par_event_datetime nvarchar2(50);
        new_par_message nvarchar2(200);
        event_inserted int;
    BEGIN
        hash_pass := sys.dbms_crypto.hash(utl_i18n.string_to_raw(par_password, 'AL32UTF8'), 2);
        DBMS_OUTPUT.PUT_LINE(hash_pass);
        SELECT ACCESS_LEVEL INTO ret_access_level FROM ACCOUNT
            WHERE LOGIN = par_username AND HASH_PASSWORD = hash_pass;
        new_par_event_datetime := TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
        new_par_message := 'Authorization account by login "'||par_username||'"';
        InsertAccountEvent(par_username, new_par_event_datetime, new_par_message, event_inserted);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            par_username := '';
            ret_access_level := -999;
            ROLLBACK;
    END;

    PROCEDURE ChangeAccountPassword(par_username in out nvarchar2, par_old_password in nvarchar2, par_new_password in nvarchar2, changed out int) IS
        old_hash_pass nvarchar2(32);
        new_hash_pass nvarchar2(32);
    BEGIN
        old_hash_pass := sys.dbms_crypto.hash(utl_i18n.string_to_raw(par_old_password, 'AL32UTF8'), 2);
        new_hash_pass := sys.dbms_crypto.hash(utl_i18n.string_to_raw(par_new_password, 'AL32UTF8'), 2);
        UPDATE ACCOUNT SET HASH_PASSWORD = new_hash_pass WHERE LOGIN = par_username AND HASH_PASSWORD = old_hash_pass;
        changed := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            changed := 0;
            ROLLBACK;
    END;

    PROCEDURE InsertAccountEvent(par_username in nvarchar2, par_event_datetime in nvarchar2, par_message in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO ACCOUNT_EVENT (ACCOUNT_LOGIN, EVENT_DATETIME, MESSAGE) VALUES (par_username, TO_TIMESTAMP(par_event_datetime, 'YYYY-MM-DD HH24:MI:SS'), par_message);
        inserted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := 0;
            ROLLBACK;
    END;

END Account_Package;
