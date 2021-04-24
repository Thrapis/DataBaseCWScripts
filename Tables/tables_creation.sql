CREATE TABLE Account (
login nvarchar2(50) PRIMARY KEY,
hash_password nvarchar2(32) NOT NULL,
access_level int NOT NULL
);

CREATE TABLE Account_event (
id int GENERATED AS IDENTITY PRIMARY KEY,
account_login nvarchar2(50) NOT NULL,
event_datetime timestamp NOT NULL,
message nvarchar2(200) NOT NULL,
FOREIGN KEY (account_login) REFERENCES Account(login)
);

------------------------------------------
CREATE TABLE Post (
id int GENERATED AS IDENTITY PRIMARY KEY,
post_name nvarchar2(50) NOT NULL,
category nvarchar2(50) NOT NULL
);

CREATE TABLE Client(
id int GENERATED AS IDENTITY PRIMARY KEY,
full_name nvarchar2(50) NOT NULL,
passport_number nvarchar2(12) NOT NULL,
account_login nvarchar2(50) NOT NULL,
FOREIGN KEY (account_login) REFERENCES Account(login)
);


CREATE TABLE Service_description(
id int GENERATED AS IDENTITY PRIMARY KEY,
service_name nvarchar2(50) NOT NULL,
service_description nvarchar2(500) NOT NULL
);


CREATE TABLE Tariff_plan(
id int GENERATED AS IDENTITY PRIMARY KEY,
tariff_name nvarchar2(50) NOT NULL,
tariff_amount float(126) NOT NULL
);


----------------------

CREATE TABLE Employee(
id int GENERATED AS IDENTITY PRIMARY KEY,
full_name nvarchar2(50) NOT NULL,
post_id int NOT NULL,
account_login nvarchar2(50) NOT NULL,
FOREIGN KEY (post_id) REFERENCES Post(id),
FOREIGN KEY (account_login) REFERENCES Account(login)
);


----------------------

CREATE TABLE Contract (
id int GENERATED AS IDENTITY PRIMARY KEY,
tariff_id int NOT NULL,
client_id int NOT NULL,
employee_id int NOT NULL,
signing_datetime timestamp NOT NULL,
FOREIGN KEY (tariff_id) REFERENCES Tariff_plan(id),
FOREIGN KEY (client_id) REFERENCES Client(id),
FOREIGN KEY (employee_id) REFERENCES Employee(id)
);


----------------------

CREATE TABLE Phone_number (
id int GENERATED AS IDENTITY PRIMARY KEY,
phone_number nvarchar2(14) NOT NULL,
contract_id int NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);

CREATE TABLE Call (
id int GENERATED AS IDENTITY PRIMARY KEY,
contract_id int NOT NULL,
to_phone_number nvarchar2(14) NOT NULL,
talk_time interval day to second NOT NULL,
call_datetime timestamp NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);


CREATE TABLE Payment(
id int GENERATED AS IDENTITY PRIMARY KEY,
contract_id int NOT NULL,
payment_amount float(126) NOT NULL,
payment_datetime timestamp NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);

CREATE TABLE Debit(
id int GENERATED AS IDENTITY PRIMARY KEY,
contract_id int NOT NULL,
debit_amount float(126) NOT NULL,
debit_datetime timestamp NOT NULL,
reason nvarchar2(250) NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id)
);


------------------------

CREATE TABLE Service (
id int GENERATED AS IDENTITY PRIMARY KEY,
contract_id int NOT NULL,
description_id int NOT NULL,
service_amount float(126) NOT NULL,
connection_date timestamp NOT NULL,
disconnection_date timestamp NOT NULL,
FOREIGN KEY (contract_id) REFERENCES Contract(id),
FOREIGN KEY (description_id) REFERENCES Service_description(id)
);

-----------------------


