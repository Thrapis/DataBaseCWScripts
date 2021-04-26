
CREATE OR REPLACE PACKAGE Contract_Package IS
	PROCEDURE InsertContract(par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, inserted out int);
	PROCEDURE UpdateContract(par_id in int, par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, updated out int);
    PROCEDURE DeleteContract(par_id in int, deleted out int);
	FUNCTION GetContractById(par_id in int) RETURN CONTRACT%rowtype;
	PROCEDURE GetAllContracts(contract_cur out sys_refcursor);
	PROCEDURE GetContractBalance(par_id in int, balance out float);
	PROCEDURE GetAllServicesByContractId(par_id in int, service_cur out sys_refcursor);
	PROCEDURE GetServiceRecommendationsByContract(par_id in int, par_recommendations_count in int, service_descriptions_cur out sys_refcursor);
END Contract_Package;



CREATE OR REPLACE PACKAGE BODY Contract_Package IS

    PROCEDURE InsertContract(par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, inserted out int) IS
    BEGIN
        INSERT INTO CONTRACT (TARIFF_ID, CLIENT_ID, EMPLOYEE_ID, SIGNING_DATETIME) VALUES (par_tariff_id, par_client_id, par_employee_id, TO_TIMESTAMP(par_signing_datetime, 'YYYY-MM-DD HH24:MI:SS'));
        inserted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := 0;
            ROLLBACK;
    END;

    PROCEDURE UpdateContract(par_id in int, par_tariff_id in int, par_client_id in int, par_employee_id in int, par_signing_datetime in nvarchar2, updated out int) IS
    BEGIN
        UPDATE CONTRACT set TARIFF_ID = par_tariff_id, CLIENT_ID = par_client_id, EMPLOYEE_ID = par_employee_id, SIGNING_DATETIME = TO_TIMESTAMP(par_signing_datetime, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeleteContract(par_id in int, deleted out int) IS
    BEGIN
        DELETE CONTRACT WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetContractById(par_id in int) RETURN CONTRACT%rowtype IS
        contract_row CONTRACT%rowtype;
    BEGIN
        SELECT * INTO contract_row FROM CONTRACT WHERE ID = par_id;
        return contract_row;
    END;

    PROCEDURE GetAllContracts(contract_cur out sys_refcursor) IS
    BEGIN
        open contract_cur for select * from CONTRACT;
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

