CREATE OR REPLACE TRIGGER Account_AfterTrigger AFTER INSERT OR UPDATE OR DELETE ON ACCOUNT FOR EACH ROW
DECLARE
    new_par_event_datetime nvarchar2(50);
    new_par_message nvarchar2(200);
    login_par nvarchar2(50);
    event_inserted int;
BEGIN
    IF INSERTING THEN
        login_par := :new.LOGIN;
        new_par_message := 'Created new account by login "'||login_par||'"';
    ELSIF UPDATING THEN
        login_par := :old.LOGIN;
        new_par_message := 'Updated account by login "'||login_par||'"';
    ELSIF DELETING THEN
        login_par := :old.LOGIN;
        new_par_message := 'Account by login "'||login_par||'" was deleted';
    END IF;
    new_par_event_datetime := TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
    Account_Package.InsertAccountEvent(login_par, new_par_event_datetime, new_par_message, event_inserted);
END;

