
CREATE OR REPLACE PACKAGE Call_Package IS
	PROCEDURE InsertCall(par_contract_id in int, par_to_phone_number in nvarchar2, par_talk_time in nvarchar2, par_call_datetime in nvarchar2, inserted out int);
	PROCEDURE UpdateCall(par_id in int, par_contract_id in int, par_to_phone_number in nvarchar2, par_talk_time in nvarchar2, par_call_datetime in nvarchar2, updated out int);
    PROCEDURE DeleteCall(par_id in int, deleted out int);
	FUNCTION GetCallById(par_id in int) RETURN CALL%rowtype;
	PROCEDURE GetAllCalls(call_cur out sys_refcursor);
END Call_Package;



CREATE OR REPLACE PACKAGE BODY Call_Package IS

    PROCEDURE InsertCall(par_contract_id in int, par_to_phone_number in nvarchar2, par_talk_time in nvarchar2, par_call_datetime in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO CALL (CONTRACT_ID, TO_PHONE_NUMBER, TALK_TIME, CALL_DATETIME) VALUES (par_contract_id, par_to_phone_number, TO_DSINTERVAL(par_talk_time), TO_TIMESTAMP(par_call_datetime, 'YYYY-MM-DD HH24:MI:SS'));
        inserted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := 0;
            ROLLBACK;
    END;

    PROCEDURE UpdateCall(par_id in int, par_contract_id in int, par_to_phone_number in nvarchar2, par_talk_time in nvarchar2, par_call_datetime in nvarchar2, updated out int) IS
    BEGIN
        UPDATE CALL set CONTRACT_ID = par_contract_id, TO_PHONE_NUMBER = par_to_phone_number, TALK_TIME = TO_DSINTERVAL(par_talk_time), CALL_DATETIME = TO_TIMESTAMP(par_call_datetime, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeleteCall(par_id in int, deleted out int) IS
    BEGIN
        DELETE CALL WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetCallById(par_id in int) RETURN CALL%rowtype IS
        call_row CALL%rowtype;
    BEGIN
        SELECT * INTO call_row FROM CALL WHERE ID = par_id;
        return call_row;
    END;

    PROCEDURE GetAllCalls(call_cur out sys_refcursor) IS
    BEGIN
        OPEN call_cur FOR SELECT * FROM CALL;
    END;

END Call_Package;