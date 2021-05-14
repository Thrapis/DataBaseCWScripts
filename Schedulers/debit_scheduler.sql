alter system set job_queue_processes = 5;

select * from user_jobs;

select * from dba_jobs_running;

BEGIN
    dbms_scheduler.create_schedule
    (
        schedule_name => 'sch_debits_detection',
        start_date => TO_DATE('20-04-21 11:15','DD-MM-YY HH24:MI'),
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=1',
        comments => 'sch_debits_detection MINUTELY at *:00'
    );
END;

BEGIN
    dbms_scheduler.create_program
    (
        program_name => 'program_debits_detection',
        program_type => 'STORED_PROCEDURE',
        program_action => 'Debit_Package.DetectAndInsertTermDebits',
        number_of_arguments => 0,
        enabled => true,
        comments => 'program_debits_detection doing DetectAndInsertTermDebits'
    );
END;

BEGIN
    dbms_scheduler.create_job
    (
        job_name => 'job_debits_detection',
        program_name => 'program_debits_detection',
        schedule_name => 'sch_debits_detection',
        enabled => true
    );
END;

ALTER DATABASE SET TIME_ZONE = 'Europe/Minsk';

SELECT DBTIMEZONE FROM DUAL;

SELECT SYSDATE from dual;

select * from user_scheduler_schedules;
select * from user_scheduler_programs;
select * from user_scheduler_jobs;


select * from user_scheduler_job_log;

begin
    dbms_scheduler.enable('job_debits_detection');
end;

begin
    dbms_scheduler.enable('program_debits_detection');
end;

begin
    dbms_scheduler.run_job('job_debits_detection');
end;

begin
    dbms_scheduler.stop_job('job_debits_detection');
end;

begin
    dbms_scheduler.set_attribute
    (
        name         =>  'sch_debits_detection',
        attribute    =>  'repeat_interval',
        value        =>  'FREQ=HOURLY; INTERVAL=1'
    );
end;

begin
    dbms_scheduler.set_attribute
    (
        name         =>  'sch_debits_detection',
        attribute    =>  'comments',
        value        =>  'sch_debits_detection HOURLY at *:00:00'
    );
end;