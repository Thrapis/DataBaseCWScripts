
CREATE OR REPLACE PACKAGE ServiceDescription_Package IS
	PROCEDURE InsertServiceDescription(par_service_name in nvarchar2, par_service_description in nvarchar2, inserted out int);
	PROCEDURE UpdateServiceDescription(par_id in int, par_service_name in nvarchar2, par_service_description in nvarchar2, updated out int);
    PROCEDURE DeleteServiceDescription(par_id in int, deleted out int);
	PROCEDURE GetServiceDescriptionById(par_id in int, service_desc_cur out sys_refcursor);
	PROCEDURE GetAllServiceDescriptions(service_desc_cur out sys_refcursor);
END ServiceDescription_Package;



CREATE OR REPLACE PACKAGE BODY ServiceDescription_Package IS

    PROCEDURE InsertServiceDescription(par_service_name in nvarchar2, par_service_description in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM SERVICE_DESCRIPTION WHERE SERVICE_NAME = par_service_name;
        IF LikeInsertion = 0 THEN
            INSERT INTO SERVICE_DESCRIPTION (SERVICE_NAME, SERVICE_DESCRIPTION) VALUES (par_service_name, par_service_description)
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

    PROCEDURE UpdateServiceDescription(par_id in int, par_service_name in nvarchar2, par_service_description in nvarchar2, updated out int) IS
    BEGIN
        UPDATE SERVICE_DESCRIPTION set SERVICE_NAME = par_service_name, SERVICE_DESCRIPTION = par_service_description WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteServiceDescription(par_id in int, deleted out int) IS
    BEGIN
        DELETE SERVICE_DESCRIPTION WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetServiceDescriptionById(par_id in int, service_desc_cur out sys_refcursor) IS
    BEGIN
        OPEN service_desc_cur FOR SELECT * FROM SERVICE_DESCRIPTION WHERE ID = par_id;
    END;

    PROCEDURE GetAllServiceDescriptions(service_desc_cur out sys_refcursor) IS
    BEGIN
        OPEN service_desc_cur FOR SELECT * FROM SERVICE_DESCRIPTION;
    END;

END ServiceDescription_Package;