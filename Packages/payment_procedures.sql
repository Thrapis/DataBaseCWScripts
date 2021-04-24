
CREATE OR REPLACE PACKAGE Payment_Package IS
	PROCEDURE InsertPayment(par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, inserted out int);
	PROCEDURE UpdatePayment(par_id in int, par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, updated out int);
    PROCEDURE DeletePayment(par_id in int, deleted out int);
	FUNCTION GetPaymentById(par_id in int) RETURN PAYMENT%rowtype;
	PROCEDURE GetAllPayments(payment_cur out sys_refcursor);
END Payment_Package;



CREATE OR REPLACE PACKAGE BODY Payment_Package IS

    PROCEDURE InsertPayment(par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO PAYMENT (CONTRACT_ID, PAYMENT_AMOUNT, PAYMENT_DATETIME) VALUES (par_contract_id, ROUND(par_payment_amount, 2), TO_TIMESTAMP(par_payment_datetime, 'YYYY-MM-DD HH24:MI:SS'));
        inserted := sql%rowcount;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := 0;
    END;

    PROCEDURE UpdatePayment(par_id in int, par_contract_id in int, par_payment_amount in float, par_payment_datetime in nvarchar2, updated out int) IS
    BEGIN
        UPDATE PAYMENT set CONTRACT_ID = par_contract_id, PAYMENT_AMOUNT = ROUND(par_payment_amount, 2), PAYMENT_DATETIME = TO_TIMESTAMP(par_payment_datetime, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeletePayment(par_id in int, deleted out int) IS
    BEGIN
        DELETE PAYMENT WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetPaymentById(par_id in int) RETURN PAYMENT%rowtype IS
        payment_row PAYMENT%rowtype;
    BEGIN
        SELECT * INTO payment_row FROM PAYMENT WHERE ID = par_id;
        return payment_row;
    END;

    PROCEDURE GetAllPayments(payment_cur out sys_refcursor) IS
    BEGIN
        OPEN payment_cur FOR SELECT * FROM PAYMENT;
    END;

END Payment_Package;