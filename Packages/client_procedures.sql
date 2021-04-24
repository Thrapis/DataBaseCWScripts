
CREATE OR REPLACE PACKAGE Client_Package IS
	PROCEDURE InsertClient(par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, inserted out int);
	PROCEDURE UpdateClient(par_id in int, par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, updated out int);
    PROCEDURE DeleteClient(par_id in int, deleted out int);
	FUNCTION GetClientById(par_id in int) RETURN CLIENT%rowtype;
	PROCEDURE GetAllClients(client_cur out sys_refcursor);
	PROCEDURE GetAllServicesByClientId(par_id in int, service_cur out sys_refcursor);
	PROCEDURE GetAllContractsByClientId(par_id in int, contract_cur out sys_refcursor);
END Client_Package;



CREATE OR REPLACE PACKAGE BODY Client_Package IS

    PROCEDURE InsertClient(par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM CLIENT WHERE PASSPORT_NUMBER = par_passport_number;
        IF LikeInsertion = 0 THEN
            INSERT INTO CLIENT (FULL_NAME, PASSPORT_NUMBER, ACCOUNT_LOGIN) VALUES (par_full_name, par_passport_number, par_account_login);
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

    PROCEDURE UpdateClient(par_id in int, par_full_name in nvarchar2, par_passport_number in nvarchar2, par_account_login in nvarchar2, updated out int) IS
    BEGIN
        UPDATE CLIENT set FULL_NAME = par_full_name, PASSPORT_NUMBER = par_passport_number, ACCOUNT_LOGIN = par_account_login WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeleteClient(par_id in int, deleted out int) IS
    BEGIN
        DELETE CLIENT WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetClientById(par_id in int) RETURN CLIENT%rowtype IS
        client_row CLIENT%rowtype;
    BEGIN
        SELECT * INTO client_row FROM CLIENT WHERE ID = par_id;
        return client_row;
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

END Client_Package;


declare
    cur sys_refcursor;
begin
    Client_Package.GetAllContractsByClientId(2, cur)
    DBMS_SQL.return_result(cur);
end;