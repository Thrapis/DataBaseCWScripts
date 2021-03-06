
CREATE OR REPLACE PACKAGE Contract_Package IS
    -- Вставка договора
	PROCEDURE InsertContract(par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, inserted out int);
	-- Обновление договора
	PROCEDURE UpdateContract(par_id in int, par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, updated out int);
    -- Удаление договора
	PROCEDURE DeleteContract(par_id in int, deleted out int);
	-- Получение договора по его идентификатору
	PROCEDURE GetContractById(par_id in int, contract_cur out sys_refcursor);
	-- Получение всех договоров в базе данных
	PROCEDURE GetAllContracts(contract_cur out sys_refcursor);
	-- Получение баланса договора
	PROCEDURE GetContractBalance(par_id in int, balance out float);
	-- Получение всех сервисов договора по его идентификатору
	PROCEDURE GetAllServicesByContractId(par_id in int, service_cur out sys_refcursor);
	-- Получение всех номеров телефона договора по его идентификатору
	PROCEDURE GetAllPhoneNumbersByContractId(par_id in int, phone_number_cur out sys_refcursor);
	-- Получение всех оплат договора по его идентификатору
	PROCEDURE GetAllPaymentsByContractId(par_id in int, payment_cur out sys_refcursor);
	-- Получение всех списаний договора по его идентификатору
	PROCEDURE GetAllDebitsByContractId(par_id in int, debit_cur out sys_refcursor);
	-- Получение рекомендаций сервисов по идентификатору договора
	PROCEDURE GetServiceRecommendationsByContract(par_id in int, par_recommendations_count in int, service_descriptions_cur out sys_refcursor);
END Contract_Package;



CREATE OR REPLACE PACKAGE BODY Contract_Package IS

    PROCEDURE InsertContract(par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO CONTRACT (TARIFF_ID, CLIENT_ID, EMPLOYEE_ID, SIGNING_DATETIME) VALUES (par_tariff_id, par_client_id, par_employee_id, TO_TIMESTAMP(par_signing_datetime, 'YYYY-MM-DD HH24:MI:SS'))
        RETURNING ID INTO inserted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := -1;
            ROLLBACK;
    END;

    PROCEDURE UpdateContract(par_id in int, par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, updated out int) IS
    BEGIN
        UPDATE CONTRACT set TARIFF_ID = par_tariff_id, CLIENT_ID = par_client_id, EMPLOYEE_ID = par_employee_id, SIGNING_DATETIME = TO_TIMESTAMP(par_signing_datetime, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteContract(par_id in int, deleted out int) IS
    BEGIN
        DELETE CONTRACT WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetContractById(par_id in int, contract_cur out sys_refcursor) IS
    BEGIN
        OPEN contract_cur FOR SELECT * FROM CONTRACT WHERE ID = par_id;
    END;

    PROCEDURE GetAllContracts(contract_cur out sys_refcursor) IS
    BEGIN
        OPEN contract_cur FOR SELECT * FROM CONTRACT;
    END;

    PROCEDURE GetContractBalance(par_id in int, balance out float) IS
        debits float(126) := 0;
        payments float(126) := 0;
    BEGIN
        SELECT COALESCE(SUM(DEBIT_AMOUNT), 0) INTO debits FROM DEBIT WHERE CONTRACT_ID = par_id;
        SELECT COALESCE(SUM(PAYMENT_AMOUNT), 0) INTO payments FROM PAYMENT WHERE CONTRACT_ID = par_id;
        balance := payments - debits;
    END;

    PROCEDURE GetAllServicesByContractId(par_id in int, service_cur out sys_refcursor) IS
    BEGIN
        OPEN service_cur FOR SELECT S.* FROM SERVICE S
            INNER JOIN CONTRACT C on S.CONTRACT_ID = C.ID
            WHERE C.ID = par_id;
    END;

    PROCEDURE GetAllPhoneNumbersByContractId(par_id in int, phone_number_cur out sys_refcursor) IS
    BEGIN
        OPEN phone_number_cur FOR SELECT PN.* FROM PHONE_NUMBER PN
            INNER JOIN CONTRACT C on PN.CONTRACT_ID = C.ID
            WHERE C.ID = par_id;
    END;

    PROCEDURE GetAllPaymentsByContractId(par_id in int, payment_cur out sys_refcursor) IS
    BEGIN
        OPEN payment_cur FOR SELECT P.* FROM PAYMENT P
            INNER JOIN CONTRACT C ON P.CONTRACT_ID = C.ID
            WHERE C.ID = par_id;
    END;

	PROCEDURE GetAllDebitsByContractId(par_id in int, debit_cur out sys_refcursor) IS
    BEGIN
        OPEN debit_cur FOR SELECT D.* FROM DEBIT D
            INNER JOIN CONTRACT C ON D.CONTRACT_ID = C.ID
            WHERE C.ID = par_id;
    END;

    PROCEDURE GetServiceRecommendationsByContract(par_id in int, par_recommendations_count in int, service_descriptions_cur out sys_refcursor) IS
        selected_item_set int := -1;
    BEGIN
        SELECT DISTINCT COALESCE(ITEMSET_ID, -1) INTO selected_item_set FROM DM$P4SERVICE_ASSOC_MODEL a
        WHERE NOT EXISTS(SELECT S.DESCRIPTION_ID FROM SERVICE S INNER JOIN
                            CONTRACT C on S.CONTRACT_ID = C.ID WHERE C.ID = par_id
                         MINUS
                        SELECT ITEM_ID FROM DM$P4SERVICE_ASSOC_MODEL a1
                            WHERE a.ITEMSET_ID = a1.ITEMSET_ID)
        GROUP BY ITEMSET_ID
        HAVING COUNT(ITEMSET_ID) =
                    (SELECT COUNT(S.DESCRIPTION_ID) FROM SERVICE S INNER JOIN
                            CONTRACT C on S.CONTRACT_ID = C.ID WHERE C.ID = par_id);

        OPEN service_descriptions_cur FOR SELECT * FROM SERVICE_DESCRIPTION WHERE ID IN
            (SELECT ITEM_ID FROM DM$P4SERVICE_ASSOC_MODEL WHERE ITEMSET_ID IN
            (SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0SERVICE_ASSOC_MODEL
            WHERE ANTECEDENT_ITEMSET_ID = selected_item_set ORDER BY LIFT DESC) WHERE ROWNUM <= par_recommendations_count));

    EXCEPTION
        WHEN OTHERS THEN
            selected_item_set := -1;
            OPEN service_descriptions_cur FOR SELECT * FROM SERVICE_DESCRIPTION WHERE ID IN
                (SELECT ITEM_ID FROM DM$P4SERVICE_ASSOC_MODEL WHERE ITEMSET_ID IN
                (SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0SERVICE_ASSOC_MODEL
                WHERE ANTECEDENT_ITEMSET_ID = selected_item_set ORDER BY LIFT DESC) WHERE ROWNUM <= par_recommendations_count));
    END;

END Contract_Package;