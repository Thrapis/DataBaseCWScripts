
CREATE OR REPLACE PACKAGE Service_Package IS
    -- Вставка услуги
	PROCEDURE InsertService(par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, inserted out int);
	-- Обновление услуги
	PROCEDURE UpdateService(par_id in int, par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, updated out int);
    -- Удаление услуги
	PROCEDURE DeleteService(par_id in int, deleted out int);
	-- Получение услуги по его идентификатору
	PROCEDURE GetServiceById(par_id in int, service_cur out sys_refcursor);
	-- Получение всех услуг базы данных
	PROCEDURE GetAllServices(service_cur out sys_refcursor);
	-- Очистка базы данных от простроченных услуг
	PROCEDURE ClearExpiredServices;
END Service_Package;



CREATE OR REPLACE PACKAGE BODY Service_Package IS

    PROCEDURE InsertService(par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM SERVICE WHERE CONTRACT_ID = par_contract_id and DESCRIPTION_ID = par_description_id;
        IF LikeInsertion = 0 THEN
            INSERT INTO SERVICE (CONTRACT_ID, DESCRIPTION_ID, SERVICE_AMOUNT, CONNECTION_DATE, DISCONNECTION_DATE) VALUES (par_contract_id, par_description_id, ROUND(par_service_amount, 2), TO_TIMESTAMP(par_connection_date, 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP(par_disconnection_date, 'YYYY-MM-DD HH24:MI:SS'))
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

    PROCEDURE UpdateService(par_id in int, par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, updated out int) IS
    BEGIN
        UPDATE SERVICE set DESCRIPTION_ID = par_description_id, SERVICE_AMOUNT = ROUND(par_service_amount, 2), CONNECTION_DATE = TO_TIMESTAMP(par_connection_date, 'YYYY-MM-DD HH24:MI:SS'), DISCONNECTION_DATE = TO_TIMESTAMP(par_disconnection_date, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id and CONTRACT_ID = par_contract_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteService(par_id in int, deleted out int) IS
    BEGIN
        DELETE SERVICE WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetServiceById(par_id in int, service_cur out sys_refcursor) IS
    BEGIN
        OPEN service_cur FOR SELECT * FROM SERVICE WHERE ID = par_id;
    END;

    PROCEDURE GetAllServices(service_cur out sys_refcursor) IS
    BEGIN
        OPEN service_cur FOR SELECT * FROM SERVICE;
    END;

    PROCEDURE ClearExpiredServices IS
    BEGIN
        DELETE SERVICE WHERE SYSDATE > DISCONNECTION_DATE;
    END;

END Service_Package;