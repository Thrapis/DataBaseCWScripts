
CREATE OR REPLACE PACKAGE Employee_Package IS
	PROCEDURE InsertEmployee(par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, inserted out int);
	PROCEDURE UpdateEmployee(par_id in int, par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, updated out int);
    PROCEDURE DeleteEmployee(par_id in int, deleted out int);
	FUNCTION GetEmployeeById(par_id in int) RETURN EMPLOYEE%rowtype;
	PROCEDURE GetAllEmployees(employee_cur out sys_refcursor);
END Employee_Package;



CREATE OR REPLACE PACKAGE BODY Employee_Package IS

    PROCEDURE InsertEmployee(par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM EMPLOYEE WHERE FULL_NAME = par_full_name;
        IF LikeInsertion = 0 THEN
            INSERT INTO EMPLOYEE (FULL_NAME, POST_ID, ACCOUNT_LOGIN) VALUES (par_full_name, par_post_id, par_account_login);
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

    PROCEDURE UpdateEmployee(par_id in int, par_full_name in nvarchar2, par_post_id in int, par_account_login in nvarchar2, updated out int) IS
    BEGIN
        UPDATE EMPLOYEE set FULL_NAME = par_full_name, POST_ID = par_post_id, ACCOUNT_LOGIN = par_account_login WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeleteEmployee(par_id in int, deleted out int) IS
    BEGIN
        DELETE EMPLOYEE WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetEmployeeById(par_id in int) RETURN EMPLOYEE%rowtype IS
        employee_row EMPLOYEE%rowtype;
    BEGIN
        SELECT * INTO employee_row FROM EMPLOYEE WHERE ID = par_id;
        return employee_row;
    END;

    PROCEDURE GetAllEmployees(employee_cur out sys_refcursor) IS
    BEGIN
        OPEN employee_cur FOR SELECT * FROM EMPLOYEE;
    END;

END Employee_Package;