
CREATE OR REPLACE PACKAGE Service_Package IS
	PROCEDURE InsertService(par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, inserted out int);
	PROCEDURE UpdateService(par_id in int, par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, updated out int);
    PROCEDURE DeleteService(par_id in int, deleted out int);
	FUNCTION GetServiceById(par_id in int) RETURN SERVICE%rowtype;
	PROCEDURE GetAllServices(service_cur out sys_refcursor);
	PROCEDURE ClearExpiredServices;
END Service_Package;



CREATE OR REPLACE PACKAGE BODY Service_Package IS

    PROCEDURE InsertService(par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM SERVICE WHERE CONTRACT_ID = par_contract_id and DESCRIPTION_ID = par_description_id;
        IF LikeInsertion = 0 THEN
            INSERT INTO SERVICE (CONTRACT_ID, DESCRIPTION_ID, SERVICE_AMOUNT, CONNECTION_DATE, DISCONNECTION_DATE) VALUES (par_contract_id, par_description_id, ROUND(par_service_amount, 2), TO_TIMESTAMP(par_connection_date, 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP(par_disconnection_date, 'YYYY-MM-DD HH24:MI:SS'));
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

    PROCEDURE UpdateService(par_id in int, par_contract_id in int, par_description_id in int, par_service_amount in float, par_connection_date in nvarchar2, par_disconnection_date in nvarchar2, updated out int) IS
    BEGIN
        UPDATE SERVICE set DESCRIPTION_ID = par_description_id, SERVICE_AMOUNT = ROUND(par_service_amount, 2), CONNECTION_DATE = TO_TIMESTAMP(par_connection_date, 'YYYY-MM-DD HH24:MI:SS'), DISCONNECTION_DATE = TO_TIMESTAMP(par_disconnection_date, 'YYYY-MM-DD HH24:MI:SS') WHERE ID = par_id and CONTRACT_ID = par_contract_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeleteService(par_id in int, deleted out int) IS
    BEGIN
        DELETE SERVICE WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetServiceById(par_id in int) RETURN SERVICE%rowtype IS
        service_row SERVICE%rowtype;
    BEGIN
        SELECT * INTO service_row FROM SERVICE WHERE ID = par_id;
        return service_row;
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