Begin
for c in (select table_name from user_tables) loop
execute immediate ('drop table '||c.table_name||' cascade constraints');
end loop;
End; 
/
Begin
for c in (select sequence_name from user_sequences) loop
execute immediate ('drop sequence '||c.sequence_name||'');
end loop;
End; 
/

--
CREATE TABLE DENTIST (  
dentist_id  NUMBER CONSTRAINT dentist_id_pk PRIMARY KEY, 
f_name 	VARCHAR(25) NOT NULL,
l_name  VARCHAR(25) NOT NULL,
mobile_number NUMBER UNIQUE,
address VARCHAR(250));

--
CREATE TABLE PATIENT (  
patient_id 	NUMBER CONSTRAINT patient_id_PK PRIMARY KEY, 
p_fname     VARCHAR(25) NOT NULL,  
p_lname 	VARCHAR(25) NOT NULL,  
p_address   VARCHAR(250),  
p_age 	NUMBER(3) NOT NULL,  
p_phone_number 	NUMBER(12) UNIQUE,
p_bill_balance number(6,2)NOT NULL);


--
CREATE TABLE APPOINTMENT (
appointment_id NUMBER CONSTRAINT appointment_id_pk PRIMARY KEY,
patient_id   NUMBER CONSTRAINT app_patientid_fk REFERENCES PATIENT ON DELETE CASCADE,
dentist_id  NUMBER CONSTRAINT app_dentistid_fk REFERENCES DENTIST ON DELETE CASCADE,
appointment_date  DATE DEFAULT SYSDATE, 
appointment_type CHAR(1) NOT NULL CHECK (appointment_type IN ('S', 'U')));

--
CREATE TABLE VISIT (  
visit_id   NUMBER CONSTRAINT visit_id_pk PRIMARY KEY, 
appointment_id  NUMBER CONSTRAINT v_appointmentid_fk REFERENCES APPOINTMENT ON DELETE CASCADE,  
appointment_time TIMESTAMP,
missed_appointment  CHAR(1) NOT NULL CHECK (missed_appointment IN ('Y', 'N')));

--

CREATE TABLE VISIT_DETAILS (
visit_line  NUMBER ,
visit_id  NUMBER CONSTRAINT vd_visitid_fk REFERENCES VISIT ON DELETE CASCADE,
CONSTRAINT vd_pk PRIMARY KEY(visit_line, visit_id),
diagnosis   VARCHAR(75) NOT NULL,
treatment  VARCHAR(250));


--
CREATE TABLE BILLING (
biiling_id  NUMBER CONSTRAINT biiling_id_pk PRIMARY KEY,
visit_id   NUMBER CONSTRAINT billing_visitid_fk REFERENCES VISIT ON DELETE CASCADE,
patient_id  NUMBER CONSTRAINT billing_patientid_fk REFERENCES PATIENT ON DELETE CASCADE,
bill_amount  NUMBER(6,2) NOT NULL);

--
CREATE TABLE PATIENT_PAYMENT (
pat_pay_id  NUMBER CONSTRAINT pat_pay_id_pk PRIMARY KEY,
patient_id  NUMBER CONSTRAINT patientpayment_patient_id_fk REFERENCES PATIENT ON DELETE CASCADE,
pat_pay_date  DATE DEFAULT SYSDATE NOT NULL,
pat_pay_amount  NUMBER (6,2) NOT NULL,
billing_id NUMBER CONSTRAINT patientpayment_billingid_fk REFERENCES BILLING ON DELETE CASCADE);


SELECT * FROM DENTIST;

-- DENTIST
CREATE SEQUENCE dentist_id_s START WITH 101 INCREMENT BY 10 NOCACHE;

INSERT INTO DENTIST VALUES(dentist_id_s.NEXTVAL, 'Martin', 'Garrix', 5147896520, '82, columbia street, Montreal');
INSERT INTO DENTIST VALUES(dentist_id_s.NEXTVAL, 'Rehanna', 'brown', 4502369854, '91,avenue laval,Laval');
INSERT INTO DENTIST VALUES(dentist_id_s.NEXTVAL, 'Phillip', 'Trump', 4368541203, '710 notre Dame west, Montreal');
INSERT INTO DENTIST VALUES(dentist_id_s.NEXTVAL, 'Alpach', 'Khan', 8195623487, '105 Cartier west, Laval');


Select * FROM patient; 

-- PATIENT
CREATE SEQUENCE patient_id_s START WITH 9000 INCREMENT BY 10 NOCACHE;

INSERT INTO PATIENT VALUES(patient_id_s.NEXTVAL, 'Zora', 'Randhawa', '30 rue louise,laval', '45', '4502364478','0.0');
INSERT INTO PATIENT VALUES(patient_id_s.NEXTVAL, 'Jassie', 'Gill', '585 st hubert st ,pointe claire', '30', '4386542147','1500.25');
INSERT INTO PATIENT VALUES(patient_id_s.NEXTVAL, 'Babbal', 'Rai', '50 blvd jukes poitras', '50', '5142365478','0.0');
INSERT INTO PATIENT VALUES(patient_id_s.NEXTVAL, 'Neha', 'Kakkar', '1265 notre dame fatima ,st jerome', '25', '4386521478','0.0');
INSERT INTO PATIENT VALUES(patient_id_s.NEXTVAL, 'Malik', 'Kumar', '323 rue chabanel ouest,montreal', '33', '5423541125','1497.50');

select * from Appointment;

-- APPOINTMENT
CREATE SEQUENCE appointment_id_s START WITH 1 INCREMENT BY 1 NOCACHE;

INSERT INTO APPOINTMENT VALUES(appointment_id_s.NEXTVAL,'9020' , 111, TO_DATE('3-AUG-2020','DD-MON-YYYY'),'U');
INSERT INTO APPOINTMENT VALUES(appointment_id_s.NEXTVAL, '9010', 131, TO_DATE('13-AUG-2020','DD-MON-YYYY'),'S');
INSERT INTO APPOINTMENT VALUES(appointment_id_s.NEXTVAL, '9040', '121', TO_DATE('31-AUG-2020','DD-MON-YYYY'),'S');
INSERT INTO APPOINTMENT VALUES(appointment_id_s.NEXTVAL, '9050', '141', TO_DATE('25-AUG-2020','DD-MON-YYYY'),'S');

select * from visit;

-- VISIT
CREATE SEQUENCE visit_id_s START WITH 32 INCREMENT BY 9 NOCACHE;

INSERT INTO VISIT VALUES(visit_id_s.NEXTVAL, '2', TO_DATE('2020-08-03 05:35','YYYY-MM-DD HH24:MI'), 'N');
INSERT INTO VISIT VALUES(visit_id_s.NEXTVAL, '3', TO_DATE('2020-08-13 16:30','YYYY-MM-DD HH24:MI'), 'Y');
INSERT INTO VISIT VALUES(visit_id_s.NEXTVAL, '4', TO_DATE('2020-08-31 18:45','YYYY-MM-DD HH24:MI'), 'Y');
INSERT INTO VISIT VALUES(visit_id_s.NEXTVAL, '5', TO_DATE('2020-08-25 07:45','YYYY-MM-DD HH24:MI'), 'N');

select * from visit_details;

-- VISIT_DETAILS
CREATE SEQUENCE visit_details_id_s START WITH 400 INCREMENT BY 10 NOCACHE;

INSERT INTO VISIT_DETAILS VALUES(visit_details_id_s.NEXTVAL, '41', 'oral cancer , cavities,plaque', 'plaque,cavities');
INSERT INTO VISIT_DETAILS VALUES(visit_details_id_s.NEXTVAL, '68',  'gingivitis,bleeding gums,','gingivitis,bleeding gums');

select * from billing;

-- BILLING
CREATE SEQUENCE billing_id_s START WITH 120 NOCACHE;

INSERT INTO BILLING VALUES(billing_id_s.NEXTVAL, '41 ','9050', 2000);
INSERT INTO BILLING VALUES(billing_id_s.NEXTVAL, '68 ','9020', 5000);

select * from patient_payment;

-- PATIENT_PAYMENT
CREATE SEQUENCE patient_payment_id_s START WITH 500 INCREMENT BY 3 NOCACHE;

INSERT INTO PATIENT_PAYMENT VALUES(patient_payment_id_s.NEXTVAL,'9020', TO_DATE('3-AUG-2020','DD-MON-YYYY'),'499.75' ,121);
INSERT INTO PATIENT_PAYMENT VALUES(patient_payment_id_s.NEXTVAL,'9050', TO_DATE('25-AUG-2020','DD-MON-YYYY'),'3502.50',122);

select * from patient;
select * from dentist;
select * from appointment;
select * from billing;
select * from visit_details;
select * from visit;
select * from patient_payment;


--1st
CREATE VIEW ALL_DENTIST AS SELECT *FROM DENTIST WITH READ ONLY;
SELECT*FROM ALL_DENTIST;


--2nd
SELECT * FROM APPOINTMENT,DENTIST WHERE APPOINTMENT.DENTIST_ID = DENTIST.DENTIST_ID AND APPOINTMENT.APPOINTMENT_DATE = '03-AUG-20';


--3rd
SELECT * FROM APPOINTMENT,PATIENT WHERE APPOINTMENT.PATIENT_ID = PATIENT.PATIENT_ID AND PATIENT.PATIENT_ID=9050;


--4th
SELECT (SELECT COUNT(VISIT.VISIT_ID) FROM VISIT WHERE VISIT.MISSED_APPOINTMENT='Y' AND VISIT.APPOINTMENT_ID=APPOINTMENT.APPOINTMENT_ID) 
AS MISSED_APPOINTMENTS,APPOINTMENT.PATIENT_ID 
FROM APPOINTMENT WHERE (SELECT COUNT(VISIT.VISIT_ID) FROM VISIT WHERE VISIT.MISSED_APPOINTMENT='Y' 
AND VISIT.APPOINTMENT_ID=APPOINTMENT.APPOINTMENT_ID)>0;


--5th
SELECT * FROM VISIT,VISIT_DETAILS,APPOINTMENT 
WHERE APPOINTMENT.APPOINTMENT_ID = VISIT.APPOINTMENT_ID 
AND VISIT.VISIT_ID = VISIT_DETAILS.VISIT_ID AND APPOINTMENT.APPOINTMENT_ID=2;
