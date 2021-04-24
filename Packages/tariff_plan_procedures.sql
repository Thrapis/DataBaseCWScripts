
CREATE OR REPLACE PACKAGE TariffPlan_Package IS
	PROCEDURE InsertTariffPlan(par_tariff_name in nvarchar2, par_tariff_amount in float, inserted out int);
	PROCEDURE UpdateTariffPlan(par_id in int, par_tariff_name in nvarchar2, par_tariff_amount in float, updated out int);
    PROCEDURE DeleteTariffPlan(par_id in int, deleted out int);
	FUNCTION GetTariffPlanById(par_id in int) RETURN TARIFF_PLAN%rowtype;
	PROCEDURE GetAllTariffPlans(tariff_plan_cur out sys_refcursor);
END TariffPlan_Package;



CREATE OR REPLACE PACKAGE BODY TariffPlan_Package IS

    PROCEDURE InsertTariffPlan(par_tariff_name in nvarchar2, par_tariff_amount in float, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM TARIFF_PLAN WHERE TARIFF_NAME = par_tariff_name;
        IF LikeInsertion = 0 THEN
            INSERT INTO TARIFF_PLAN (TARIFF_NAME, TARIFF_AMOUNT) VALUES (par_tariff_name, ROUND(par_tariff_amount, 2));
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

    PROCEDURE UpdateTariffPlan(par_id in int, par_tariff_name in nvarchar2, par_tariff_amount in float, updated out int) IS
    BEGIN
        UPDATE TARIFF_PLAN set TARIFF_NAME = par_tariff_name, TARIFF_AMOUNT = ROUND(par_tariff_amount, 2) WHERE ID = par_id;
        updated := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := 0;
            ROLLBACK;
    END;

    PROCEDURE DeleteTariffPlan(par_id in int, deleted out int) IS
    BEGIN
        DELETE TARIFF_PLAN WHERE ID = par_id;
        deleted := sql%rowcount;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := 0;
            ROLLBACK;
    END;

    FUNCTION GetTariffPlanById(par_id in int) RETURN TARIFF_PLAN%rowtype IS
        tariff_plan_row TARIFF_PLAN%rowtype;
    BEGIN
        SELECT * INTO tariff_plan_row FROM TARIFF_PLAN WHERE ID = par_id;
        return tariff_plan_row;
    END;

    PROCEDURE GetAllTariffPlans(tariff_plan_cur out sys_refcursor) IS
    BEGIN
        OPEN tariff_plan_cur FOR SELECT * FROM TARIFF_PLAN;
    END;

END TariffPlan_Package;