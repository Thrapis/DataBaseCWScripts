
CREATE OR REPLACE PACKAGE TariffPlan_Package IS
    -- Вставка тарифного плана
	PROCEDURE InsertTariffPlan(par_tariff_name in nvarchar2, par_tariff_amount in float, inserted out int);
	-- Обновление тарифоного плана
	PROCEDURE UpdateTariffPlan(par_id in int, par_tariff_name in nvarchar2, par_tariff_amount in float, updated out int);
    -- Удаление тарифного плана
	PROCEDURE DeleteTariffPlan(par_id in int, deleted out int);
	-- Получение тарифного плана по его идентификатору
	PROCEDURE GetTariffPlanById(par_id in int, tariff_plan_cur out sys_refcursor);
	-- Получение всех тарифных планов базы данных
	PROCEDURE GetAllTariffPlans(tariff_plan_cur out sys_refcursor);
END TariffPlan_Package;



CREATE OR REPLACE PACKAGE BODY TariffPlan_Package IS

    PROCEDURE InsertTariffPlan(par_tariff_name in nvarchar2, par_tariff_amount in float, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM TARIFF_PLAN WHERE TARIFF_NAME = par_tariff_name;
        IF LikeInsertion = 0 THEN
            INSERT INTO TARIFF_PLAN (TARIFF_NAME, TARIFF_AMOUNT) VALUES (par_tariff_name, ROUND(par_tariff_amount, 2))
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

    PROCEDURE UpdateTariffPlan(par_id in int, par_tariff_name in nvarchar2, par_tariff_amount in float, updated out int) IS
    BEGIN
        UPDATE TARIFF_PLAN set TARIFF_NAME = par_tariff_name, TARIFF_AMOUNT = ROUND(par_tariff_amount, 2) WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeleteTariffPlan(par_id in int, deleted out int) IS
    BEGIN
        DELETE TARIFF_PLAN WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetTariffPlanById(par_id in int, tariff_plan_cur out sys_refcursor) IS
    BEGIN
        OPEN tariff_plan_cur FOR SELECT * FROM TARIFF_PLAN WHERE ID = par_id;
    END;

    PROCEDURE GetAllTariffPlans(tariff_plan_cur out sys_refcursor) IS
    BEGIN
        OPEN tariff_plan_cur FOR SELECT * FROM TARIFF_PLAN;
    END;

END TariffPlan_Package;