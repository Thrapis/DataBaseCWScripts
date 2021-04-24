
CREATE OR REPLACE PACKAGE PhoneNumber_Package IS
	PROCEDURE InsertPhoneNumber(par_phone_number in nvarchar2, par_contract_id in int, inserted out int);
	PROCEDURE UpdatePhoneNumber(par_id in int, par_phone_number in nvarchar2, par_contract_id in int, updated out int);
    PROCEDURE DeletePhoneNumber(par_id in int, deleted out int);
	FUNCTION GetPhoneNumberById(par_id in int) RETURN PHONE_NUMBER%rowtype;
	PROCEDURE GetAllPhoneNumbers(phone_number_cur out sys_refcursor);
END PhoneNumber_Package;



CREATE OR REPLACE PACKAGE BODY PhoneNumber_Package IS

    PROCEDURE InsertPhoneNumber(par_phone_number in nvarchar2, par_contract_id in int, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM PHONE_NUMBER WHERE PHONE_NUMBER = par_phone_number;
        IF LikeInsertion = 0 THEN
            INSERT INTO PHONE_NUMBER (PHONE_NUMBER, CONTRACT_ID) VALUES (par_phone_number, par_contract_id);
            inserted := sql%rowcount;
        ELSE
            inserted := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := 0;
            ROLLBACK;
    END;

    PROCEDURE UpdatePhoneNumber(par_id in int, par_phone_number in nvarchar2, par_contract_id in int, updated out int) IS
    BEGIN
        UPDATE PHONE_NUMBER set PHONE_NUMBER = par_phone_number, CONTRACT_ID = par_contract_id WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeletePhoneNumber(par_id in int, deleted out int) IS
    BEGIN
        DELETE PHONE_NUMBER WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetPhoneNumberById(par_id in int) RETURN PHONE_NUMBER%rowtype IS
        phone_number_row PHONE_NUMBER%rowtype;
    BEGIN
        SELECT * INTO phone_number_row FROM PHONE_NUMBER WHERE ID = par_id;
        return phone_number_row;
    END;

    PROCEDURE GetAllPhoneNumbers(phone_number_cur out sys_refcursor) IS
    BEGIN
        OPEN phone_number_cur FOR SELECT * FROM PHONE_NUMBER;
    END;

END PhoneNumber_Package;