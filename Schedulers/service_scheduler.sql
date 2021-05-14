alter system set job_queue_processes = 5;

select * from user_jobs;

select * from dba_jobs_running;

BEGIN
    dbms_scheduler.create_schedule
    (
        schedule_name => 'sch_services_clear_expired',
        start_date => TO_DATE('20-04-21 11:20','DD-MM-YY HH24:MI'),
        repeat_interval => 'FREQ=HOURLY; INTERVAL=1',
        comments => 'sch_payments_clear_expired HOURLY at *:00:00'
    );
END;

BEGIN
    dbms_scheduler.create_program
    (
        program_name => 'program_services_clear_expired',
        program_type => 'STORED_PROCEDURE',
        program_action => 'Service_Package.ClearExpiredServices',
        number_of_arguments => 0,
        enabled => true,
        comments => 'program_payments_clear_expired doing ClearExpiredServices'
    );
END;

BEGIN
    dbms_scheduler.create_job
    (
        job_name => 'job_services_clear_expired',
        program_name => 'program_services_clear_expired',
        schedule_name => 'sch_services_clear_expired',
        enabled => true
    );
END;

select * from dba_sys_privs where grantee = 'C##BAA';

ALTER DATABASE SET TIME_ZONE = 'Europe/Minsk';

alter session set time_zone = 'Europe/Minsk';

SELECT DBTIMEZONE FROM DUAL;

SELECT SYSDATE from dual;

select * from user_scheduler_schedules;
select * from user_scheduler_programs;
select * from user_scheduler_jobs;


select * from user_scheduler_job_log;

begin
    dbms_scheduler.disable('job_services_clear_expired');
end;

begin
    dbms_scheduler.enable('program_services_clear_expired');
end;

begin
    dbms_scheduler.run_job('job_services_clear_expired');
end;

begin
    dbms_scheduler.stop_job('job_services_clear_expired');
end;

begin
    dbms_scheduler.set_attribute
    (
        name         =>  'sch_services_clear_expired',
        attribute    =>  'repeat_interval',
        value        =>  'FREQ=HOURLY; INTERVAL=1'
    );
end;

begin
    dbms_scheduler.set_attribute
    (
        name         =>  'sch_services_clear_expired',
        attribute    =>  'comments',
        value        =>  'sch_services_clear_expired HOURLY at *:00:00'
    );
end;