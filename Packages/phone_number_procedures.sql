
CREATE OR REPLACE PACKAGE PhoneNumber_Package IS
	PROCEDURE InsertPhoneNumber(par_phone_number in nvarchar2, par_contract_id in int, inserted out int);
	PROCEDURE UpdatePhoneNumber(par_id in int, par_phone_number in nvarchar2, par_contract_id in int, updated out int);
    PROCEDURE DeletePhoneNumber(par_id in int, deleted out int);
	PROCEDURE GetPhoneNumberById(par_id in int, phone_number_cur out sys_refcursor);
	PROCEDURE GetPhoneNumberByNumber(par_number in nvarchar2, phone_number_cur out sys_refcursor);
	PROCEDURE GetAllPhoneNumbers(phone_number_cur out sys_refcursor);
END PhoneNumber_Package;



CREATE OR REPLACE PACKAGE BODY PhoneNumber_Package IS

    PROCEDURE InsertPhoneNumber(par_phone_number in nvarchar2, par_contract_id in int, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM PHONE_NUMBER WHERE PHONE_NUMBER = par_phone_number;
        IF LikeInsertion = 0 THEN
            INSERT INTO PHONE_NUMBER (PHONE_NUMBER, CONTRACT_ID) VALUES (par_phone_number, par_contract_id)
            RETURNING ID INTO inserted;
        ELSE
            inserted := -1;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := -1;
            ROLLBACK;
    END;

    PROCEDURE UpdatePhoneNumber(par_id in int, par_phone_number in nvarchar2, par_contract_id in int, updated out int) IS
    BEGIN
        UPDATE PHONE_NUMBER set PHONE_NUMBER = par_phone_number, CONTRACT_ID = par_contract_id WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeletePhoneNumber(par_id in int, deleted out int) IS
    BEGIN
        DELETE PHONE_NUMBER WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetPhoneNumberById(par_id in int, phone_number_cur out sys_refcursor) IS
    BEGIN
        OPEN phone_number_cur FOR SELECT * FROM PHONE_NUMBER WHERE ID = par_id;
    END;

    PROCEDURE GetPhoneNumberByNumber(par_number in nvarchar2, phone_number_cur out sys_refcursor) IS
    BEGIN
        OPEN phone_number_cur FOR SELECT * FROM PHONE_NUMBER WHERE PHONE_NUMBER = par_number;
    END;

    PROCEDURE GetAllPhoneNumbers(phone_number_cur out sys_refcursor) IS
    BEGIN
        OPEN phone_number_cur FOR SELECT * FROM PHONE_NUMBER;
    END;

END PhoneNumber_Package;