
CREATE OR REPLACE PACKAGE Debit_Package IS
	PROCEDURE InsertDebit(par_contract_id in int, par_debit_amount in float, par_debit_datetime in nvarchar2, par_reason in nvarchar2, inserted out int);
	PROCEDURE UpdateDebit(par_id in int, par_contract_id in int, par_debit_amount in float, par_debit_datetime in nvarchar2, par_reason in nvarchar2, updated out int);
    PROCEDURE DeleteDebit(par_id in int, deleted out int);
	PROCEDURE GetDebitById(par_id in int, debit_cur out sys_refcursor);
	PROCEDURE GetAllDebits(debit_cur out sys_refcursor);
	PROCEDURE DetectAndInsertTermDebits;
END Debit_Package;



CREATE OR REPLACE PACKAGE BODY Debit_Package IS

    PROCEDURE InsertDebit(par_contract_id in int, par_debit_amount in float, par_debit_datetime in nvarchar2, par_reason in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO DEBIT (CONTRACT_ID, DEBIT_AMOUNT, DEBIT_DATETIME, REASON) VALUES (par_contract_id, ROUND(par_debit_amount, 2), TO_TIMESTAMP(par_debit_datetime, 'YYYY-MM-DD HH24:MI:SS'), par_reason)
        RETURNING ID INTO inserted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := -1;
            ROLLBACK;
    END;

    PROCEDURE UpdateDebit(par_id in int, par_contract_id in int, par_debit_amount in float, par_debit_datetime in nvarchar2, par_reason in nvarchar2, updated out int) IS
    BEGIN
        UPDATE DEBIT set CONTRACT_ID = par_contract_id, DEBIT_AMOUNT = ROUND(par_debit_amount, 2), DEBIT_DATETIME = TO_TIMESTAMP(par_debit_datetime, 'YYYY-MM-DD HH24:MI:SS'), REASON = par_reason WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteDebit(par_id in int, deleted out int) IS
    BEGIN
        DELETE DEBIT WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetDebitById(par_id in int, debit_cur out sys_refcursor) IS
    BEGIN
        OPEN debit_cur FOR SELECT * FROM DEBIT WHERE ID = par_id;
    END;

    PROCEDURE GetAllDebits(debit_cur out sys_refcursor) IS
    BEGIN
        OPEN debit_cur FOR SELECT * FROM DEBIT;
    END;

    PROCEDURE DetectAndInsertTermDebits IS
        contract_row CONTRACT%rowtype;
        tariff_plan_row TARIFF_PLAN%rowtype;
        service_row SERVICE%rowtype;
        service_description_row SERVICE_DESCRIPTION%rowtype;
        contract_cur sys_refcursor;
        services_cur sys_refcursor;
        ReasonBuf nvarchar2(250);
        LastDebitCount int := 0;
        LastDebitMonths int := 0;
        ServiceConnectionMonths int := 0;
        counter int := 0;
    BEGIN
        OPEN contract_cur FOR SELECT * FROM CONTRACT;
        FETCH contract_cur INTO contract_row;
        WHILE contract_cur%found LOOP
            SELECT * INTO tariff_plan_row FROM TARIFF_PLAN WHERE ID = contract_row.TARIFF_ID;

            ReasonBuf := 'Payment for "'||tariff_plan_row.TARIFF_NAME||'" tariff plan';
            SELECT COUNT(*) INTO LastDebitCount FROM DEBIT WHERE CONTRACT_ID = contract_row.ID AND REASON = ReasonBuf;
            IF LastDebitCount = 0 THEN
                LastDebitMonths := FLOOR(MONTHS_BETWEEN(SYSDATE, contract_row.SIGNING_DATETIME));
            ELSE
                SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, DEBIT_DATETIME)) INTO LastDebitMonths FROM (
                    SELECT * FROM DEBIT WHERE CONTRACT_ID = contract_row.ID AND REASON = ReasonBuf ORDER BY DEBIT_DATETIME DESC)
                WHERE ROWNUM = 1;
            END IF;

            counter := 0;
            WHILE counter < LastDebitMonths LOOP
                INSERT INTO DEBIT (CONTRACT_ID, DEBIT_AMOUNT, DEBIT_DATETIME, REASON)
                    VALUES (contract_row.ID, tariff_plan_row.TARIFF_AMOUNT, SYSDATE, ReasonBuf);
                counter := counter + 1;
            END LOOP;

            OPEN services_cur FOR SELECT * FROM SERVICE WHERE CONTRACT_ID = contract_row.ID;
            FETCH services_cur INTO service_row;
            WHILE services_cur%found LOOP
                SELECT * INTO service_description_row FROM SERVICE_DESCRIPTION WHERE ID = service_row.DESCRIPTION_ID;
                ReasonBuf := 'Payment for "'||service_description_row.SERVICE_NAME||'" service';
                SELECT COUNT(*) INTO LastDebitCount FROM DEBIT WHERE CONTRACT_ID = contract_row.ID AND REASON = ReasonBuf;

                IF LastDebitCount = 0 THEN
                    LastDebitMonths := FLOOR(MONTHS_BETWEEN(SYSDATE, contract_row.SIGNING_DATETIME));
                ELSE
                    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, DEBIT_DATETIME)) INTO LastDebitMonths FROM (
                        SELECT * FROM DEBIT WHERE CONTRACT_ID = contract_row.ID AND REASON = ReasonBuf ORDER BY DEBIT_DATETIME DESC)
                    WHERE ROWNUM = 1;

                    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, service_row.CONNECTION_DATE)) INTO ServiceConnectionMonths FROM DUAL;

                    IF LastDebitMonths > ServiceConnectionMonths THEN
                        LastDebitMonths := ServiceConnectionMonths;
                    END IF;
                END IF;

                counter := 0;
                WHILE counter < LastDebitMonths LOOP
                    INSERT INTO DEBIT (CONTRACT_ID, DEBIT_AMOUNT, DEBIT_DATETIME, REASON)
                        VALUES (contract_row.ID, service_row.SERVICE_AMOUNT, SYSDATE, ReasonBuf);
                    counter := counter + 1;
                END LOOP;

                FETCH services_cur INTO service_row;
            END LOOP;
            CLOSE services_cur;

            FETCH contract_cur INTO contract_row;
        END LOOP;
    END;

END Debit_Package;