
CREATE OR REPLACE PACKAGE Payment_Package IS
	PROCEDURE InsertPayment(par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, inserted out int);
	PROCEDURE UpdatePayment(par_id in int, par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, updated out int);
    PROCEDURE DeletePayment(par_id in int, deleted out int);
	PROCEDURE GetPaymentById(par_id in int, payment_cur out sys_refcursor);
	PROCEDURE GetAllPayments(payment_cur out sys_refcursor);
END Payment_Package;



CREATE OR REPLACE PACKAGE BODY Payment_Package IS

    PROCEDURE InsertPayment(par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO PAYMENT (CONTRACT_ID, PAYMENT_AMOUNT, PAYMENT_DATETIME) VALUES (par_contract_id, ROUND(par_payment_amount, 2), TO_TIMESTAMP(par_payment_datetime, 'YYYY-MM-DD HH24:MI:SS'))
        RETURNING ID INTO inserted;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := -1;
    END;

    PROCEDURE UpdatePayment(par_id in int, par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, updated out int) IS
    BEGIN
        UPDATE PAYMENT set CONTRACT_ID = par_contract_id, PAYMENT_AMOUNT = ROUND(par_payment_amount, 2), PAYMENT_DATETIME = TO_TIMESTAMP(par_payment_datetime, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeletePayment(par_id in int, deleted out int) IS
    BEGIN
        DELETE PAYMENT WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetPaymentById(par_id in int, payment_cur out sys_refcursor) IS
    BEGIN
        OPEN payment_cur FOR SELECT * FROM PAYMENT WHERE ID = par_id;
    END;

    PROCEDURE GetAllPayments(payment_cur out sys_refcursor) IS
    BEGIN
        OPEN payment_cur FOR SELECT * FROM PAYMENT;
    END;

END Payment_Package;