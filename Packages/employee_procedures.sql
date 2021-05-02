
CREATE OR REPLACE PACKAGE Employee_Package IS
	PROCEDURE InsertEmployee(par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, inserted out int);
	PROCEDURE UpdateEmployee(par_id in int, par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, updated out int);
    PROCEDURE DeleteEmployee(par_id in int, deleted out int);
	PROCEDURE GetEmployeeById(par_id in int, employee_cur out sys_refcursor);
	PROCEDURE GetEmployeeByLogin(par_login in nvarchar2, employee_cur out sys_refcursor);
	PROCEDURE GetAllEmployees(employee_cur out sys_refcursor);
	PROCEDURE GetAllContractsByEmployeeId(par_id in int, contract_cur out sys_refcursor);
END Employee_Package;



CREATE OR REPLACE PACKAGE BODY Employee_Package IS

    PROCEDURE InsertEmployee(par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM EMPLOYEE WHERE FULL_NAME = par_full_name;
        IF LikeInsertion = 0 THEN
            INSERT INTO EMPLOYEE (FULL_NAME, POST_ID, ACCOUNT_LOGIN) VALUES (par_full_name, par_post_id, par_account_login)
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

    PROCEDURE UpdateEmployee(par_id in int, par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, updated out int) IS
    BEGIN
        UPDATE EMPLOYEE set FULL_NAME = par_full_name, POST_ID = par_post_id, ACCOUNT_LOGIN = par_account_login WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteEmployee(par_id in int, deleted out int) IS
    BEGIN
        DELETE EMPLOYEE WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetEmployeeById(par_id in int, employee_cur out sys_refcursor) IS
    BEGIN
        OPEN employee_cur FOR SELECT * FROM EMPLOYEE WHERE ID = par_id;
    END;

    PROCEDURE GetEmployeeByLogin(par_login in nvarchar2, employee_cur out sys_refcursor) IS
    BEGIN
        OPEN employee_cur FOR SELECT * FROM EMPLOYEE WHERE ACCOUNT_LOGIN = par_login;
    END;

    PROCEDURE GetAllEmployees(employee_cur out sys_refcursor) IS
    BEGIN
        OPEN employee_cur FOR SELECT * FROM EMPLOYEE;
    END;

    PROCEDURE GetAllContractsByEmployeeId(par_id in int, contract_cur out sys_refcursor) IS
    BEGIN
        OPEN contract_cur FOR SELECT C.* FROM CONTRACT C
            INNER JOIN EMPLOYEE E ON C.EMPLOYEE_ID = E.ID
            WHERE E.ID = par_id;
    END;

END Employee_Package;