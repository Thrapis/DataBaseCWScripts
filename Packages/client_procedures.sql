
CREATE OR REPLACE PACKAGE Client_Package IS
    -- Вставка клиента
	PROCEDURE InsertClient(par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, inserted out int);
	-- Обновление клиента
    PROCEDURE UpdateClient(par_id in int, par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, updated out int);
    -- Удаление клиента
    PROCEDURE DeleteClient(par_id in int, deleted out int);
	-- Получение клиента по его идентификатору
    PROCEDURE GetClientById(par_id in int, client_cur out sys_refcursor);
	-- Получение клиента по логину его аккаунта
    PROCEDURE GetClientByLogin(par_login in nvarchar2, client_cur out sys_refcursor);
	-- Получене всех пользователей базы данных
    PROCEDURE GetAllClients(client_cur out sys_refcursor);
	-- Получение всех услуг клиента по его идентификатору
    PROCEDURE GetAllServicesByClientId(par_id in int, service_cur out sys_refcursor);
	-- Получение всех договоров по его идентификатору
    PROCEDURE GetAllContractsByClientId(par_id in int, contract_cur out sys_refcursor);
    -- Получение рекомендаций тарифов по идентификатору клиента
    PROCEDURE GetTariffRecommendationsByClientId(par_id in int, par_recommendations_count in int, tariff_plan_cur out sys_refcursor);
END Client_Package;



CREATE OR REPLACE PACKAGE BODY Client_Package IS

    PROCEDURE InsertClient(par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM CLIENT WHERE PASSPORT_NUMBER = par_passport_number;
        IF LikeInsertion = 0 THEN
            INSERT INTO CLIENT (FULL_NAME, PASSPORT_NUMBER, ACCOUNT_LOGIN) VALUES (par_full_name, par_passport_number, par_account_login)
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

    PROCEDURE UpdateClient(par_id in int, par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, updated out int) IS
    BEGIN
        UPDATE CLIENT set FULL_NAME = par_full_name, PASSPORT_NUMBER = par_passport_number, ACCOUNT_LOGIN = par_account_login WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteClient(par_id in int, deleted out int) IS
    BEGIN
        DELETE CLIENT WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetClientById(par_id in int, client_cur out sys_refcursor) IS
    BEGIN
        OPEN client_cur FOR SELECT * FROM CLIENT WHERE ID = par_id;
    END;

    PROCEDURE GetClientByLogin(par_login in nvarchar2, client_cur out sys_refcursor) IS
    BEGIN
        OPEN client_cur FOR SELECT * FROM CLIENT WHERE ACCOUNT_LOGIN = par_login;
    END;

    PROCEDURE GetAllClients(client_cur out sys_refcursor) IS
    BEGIN
        OPEN client_cur FOR SELECT * FROM CLIENT;
    END;

    PROCEDURE GetAllServicesByClientId(par_id in int, service_cur out sys_refcursor) IS
    BEGIN
        OPEN service_cur FOR SELECT S.* FROM SERVICE S
            INNER JOIN CONTRACT C on S.CONTRACT_ID = C.ID
            INNER JOIN CLIENT CL on C.CLIENT_ID = CL.ID
            WHERE CL.ID = par_id;
    END;

	PROCEDURE GetAllContractsByClientId(par_id in int, contract_cur out sys_refcursor) IS
    BEGIN
        OPEN contract_cur FOR SELECT C.* FROM CONTRACT C
            INNER JOIN CLIENT CL ON C.CLIENT_ID = CL.ID
            WHERE CL.ID = par_id;
    END;

    PROCEDURE GetTariffRecommendationsByClientId(par_id in int, par_recommendations_count in int, tariff_plan_cur out sys_refcursor) IS
        selected_item_set int := -1;
    BEGIN
        SELECT DISTINCT COALESCE(ITEMSET_ID, -1) INTO selected_item_set FROM DM$P4TARIFF_ASSOC_MODEL a
            WHERE NOT EXISTS(SELECT C.TARIFF_ID FROM CONTRACT C WHERE CLIENT_ID = par_id
                         MINUS
                        SELECT ITEM_ID FROM DM$P4TARIFF_ASSOC_MODEL a1
                            WHERE a.ITEMSET_ID = a1.ITEMSET_ID)
        GROUP BY ITEMSET_ID
            HAVING COUNT(ITEMSET_ID) =
                    (SELECT COUNT(*) FROM CONTRACT C WHERE CLIENT_ID = par_id);

        OPEN tariff_plan_cur FOR SELECT * FROM TARIFF_PLAN WHERE ID IN
            (SELECT ITEM_ID FROM DM$P4TARIFF_ASSOC_MODEL M4 WHERE ITEMSET_ID IN
            (SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0TARIFF_ASSOC_MODEL
            WHERE ANTECEDENT_ITEMSET_ID = selected_item_set ORDER BY LIFT DESC) WHERE ROWNUM <= par_recommendations_count));
    EXCEPTION
        WHEN OTHERS THEN
            selected_item_set := -1;
            OPEN tariff_plan_cur FOR SELECT * FROM SERVICE_DESCRIPTION WHERE ID IN
                (SELECT ITEM_ID FROM DM$P4SERVICE_ASSOC_MODEL WHERE ITEMSET_ID IN
                (SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0SERVICE_ASSOC_MODEL
                WHERE ANTECEDENT_ITEMSET_ID = selected_item_set ORDER BY LIFT DESC) WHERE ROWNUM <= par_recommendations_count));
    END;

END Client_Package;

