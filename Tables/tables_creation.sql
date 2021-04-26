CREATE TABLE Account (
login nvarchar2(50) PRIMARY KEY,
hash_password nvarchar2(32) NOT NULL,
access_level int NOT NULL
);

CREATE SEQUENCE account_event_seq INCREMENT BY 1;

CREATE TABLE Account_event (
id int DEFAULT account_event_seq.NEXTVAL PRIMARY KEY,
account_login nvarchar2(50) NOT NULL,
event_datetime timestamp NOT NULL,
message nvarchar2(200) NOT NULL,
FOREIGN KEY (account_login) REFERENCES Account(login)
);

------------------------------------------
CREATE SEQUENCE post_seq INCREMENT BY 1;

CREATE TABLE Post (
id int DEFAULT post_seq.NEXTVAL PRIMARY KEY,
post_name nvarchar2(50) NOT NULL,
category nvarchar2(50) NOT NULL
);

CREATE SEQUENCE client_seq INCREMENT BY 1;

CREATE TABLE Client(
id int DEFAULT client_seq.NEXTVAL PRIMARY KEY,
full_name nvarchar2(50) NOT NULL,
passport_number nvarchar2(12) NOT NULL,
account_login nvarchar2(50) NOT NULL,
FOREIGN KEY (account_login) REFERENCES Account(login)
);

CREATE SEQUENCE service_description_seq INCREMENT BY 1;

CREATE TABLE Service_description(
id int DEFAULT service_description_seq.NEXTVAL PRIMARY KEY,
service_name nvarchar2(50) NOT NULL,
service_description nvarchar2(500) NOT NULL
);

CREATE SEQUENCE tariff_plan_seq INCREMENT BY 1;

CREATE TABLE Tariff_plan(
id int DEFAULT tariff_plan_seq.NEXTVAL PRIMARY KEY,
tariff_name nvarchar2(50) NOT NULL,
tariff_amount float(126) NOT NULL
);


----------------------

CREATE SEQUENCE employee_seq INCREMENT BY 1;

CREATE TABLE Employee(
id int DEFAULT employee_seq.NEXTVAL PRIMARY KEY,
full_name nvarchar2(50) NOT NULL,
post_id int NOT NULL,
account_login nvarchar2(50) NOT NULL,
FOREIGN KEY (post_id) REFERENCES Post(id),
FOREIGN KEY (account_login) REFERENCES Account(login)
);


----------------------

CREATE SEQUENCE contract_seq INCREMENT BY 1;

CREATE TABLE Contract (
id int DEFAULT contract_seq.NEXTVAL PRIMARY KEY,
tariff_id int NOT NULL,
client_id int NOT NULL,
employee_id int NOT NULL,
signing_datetime timestamp NOT NULL,
FOREIGN KEY (tariff_id) REFERENCES Tariff_plan(id),
FOREIGN KEY (client_id) REFERENCES Client(id),
FOREIGN KEY (employee_id) REFERENCES Employee(id)
);


----------------------
--SELECT * FROM PHONE_NUMBER
--WHERE REGEXP_LIKE (phone_number, '^((\+\d{3})|(\d{2}))\d{2}\d{3}\d{4}$');

CREATE SEQUENCE phone_number_seq INCREMENT BY 1;

CREATE TABLE Phone_number (
id int DEFAULT phone_number_seq.NEXTVAL PRIMARY KEY,
phone_number nvarchar2(14) NOT NULL,
contract_id int NOT NULL,
CONSTRAINT phone_regex_pn  CHECK (REGEXP_LIKE (phone_number, '^((\+\d{3})|(\d{2}))\d{2}\d{3}\d{4}$')),
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);

CREATE SEQUENCE call_seq INCREMENT BY 1;

CREATE TABLE Call (
id int DEFAULT call_seq.NEXTVAL PRIMARY KEY,
contract_id int NOT NULL,
to_phone_number nvarchar2(14) NOT NULL,
talk_time interval day to second NOT NULL,
call_datetime timestamp NOT NULL,
CONSTRAINT phone_regex_c  CHECK (REGEXP_LIKE (to_phone_number, '^((\+\d{3})|(\d{2}))\d{2}\d{3}\d{4}$')),
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);

CREATE SEQUENCE payment_seq INCREMENT BY 1;

CREATE TABLE Payment(
id int DEFAULT payment_seq.NEXTVAL PRIMARY KEY,
contract_id int NOT NULL,
payment_amount float(126) NOT NULL,
payment_datetime timestamp NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);

CREATE SEQUENCE debit_seq INCREMENT BY 1;

CREATE TABLE Debit(
id int DEFAULT debit_seq.NEXTVAL PRIMARY KEY,
contract_id int NOT NULL,
debit_amount float(126) NOT NULL,
debit_datetime timestamp NOT NULL,
reason nvarchar2(250) NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);


------------------------

CREATE SEQUENCE service_seq INCREMENT BY 1;

CREATE TABLE Service (
id int DEFAULT service_seq.NEXTVAL PRIMARY KEY,
contract_id int NOT NULL,
description_id int NOT NULL,
service_amount float(126) NOT NULL,
connection_date timestamp NOT NULL,
disconnection_date timestamp NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id),
FOREIGN KEY (description_id) REFERENCES Service_description(id)
);

-----------------------


