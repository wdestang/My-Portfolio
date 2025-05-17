-- Q1.A. Create tables and users with passwords for the following:
CREATE TABLE location (
    location_id NUMBER(4,0) PRIMARY KEY,
    street_address VARCHAR2(40),
    postal_code VARCHAR2(12),
    city VARCHAR2(30) NOT NULL,
    state_province VARCHAR2(25),
    country_id CHAR(2)
);

/* Q1.B. Create users with passwords and allocate the default tablespace with
a quota, allocating a quota of 50 megabytes to each user on the user tablespace */
CREATE USER Wendell
IDENTIFIED BY 1234
DEFAULT TABLESPACE users
QUOTA 50M ON users;

CREATE USER Account_Manager
IDENTIFIED BY 12
DEFAULT TABLESPACE users
QUOTA 50M ON users;

CREATE USER Customer_Service
IDENTIFIED BY 1
DEFAULT TABLESPACE users
QUOTA 50M ON users;

CREATE USER SALE_REPS
IDENTIFIED BY 123
DEFAULT TABLESPACE users
QUOTA 50M ON users;

-- Q2. Create the following roles and grant privileges: 
-- Q2.A. Grant necessary privileges (connect) to all the users (Your_Name, Account_Manager, Customer_ Service, SALE_ REPS)
GRANT CONNECT TO Wendell;
GRANT CONNECT TO Account_Manager;
GRANT CONNECT TO Customer_Service;
GRANT CONNECT TO SALE_REPS;

/* Q2.B. Create the following:
Grant the Select, Update, delete on Location to the your_Name role.
Grant the Select, Update, delete on Location to the Account_Manager role.
Grant the Select, delete on Location to Customer_ Service role.
Grant the Create Table to the SALE_ REPS role.*/
GRANT SELECT, UPDATE, DELETE ON location TO Wendell;
GRANT SELECT, UPDATE, DELETE ON location TO Account_Manager;
GRANT SELECT, DELETE ON location TO Customer_Service;
GRANT CREATE TABLE TO SALE_REPS;

-- Q3. Grant and revoke the privileges for the following:
-- Q3.A. Grant all on Location table to all the users (Your_Name, Account_Manager, Customer_ Service, SALE_ REPS).
GRANT ALL ON location TO Wendell;
GRANT ALL ON location TO Account_Manager;
GRANT ALL ON location TO Customer_Service;
GRANT ALL ON location TO SALE_REPS;

-- Q3.B. Remove DELETE privilege on Location from Your_Name 
REVOKE DELETE ON location FROM Wendell;

--Q3.C. Remove all privileges on Location from account_manager
REVOKE ALL ON location FROM Account_Manager;

-- Q4. Make non-Identified default role called DBG_ROLL with the below privileges
-- Q4.A Create the role DBG_ROLL
CREATE ROLE DBG_ROLL;

/* Q4.B. Grant privileges to the role
•	Can create session and create views
•	Can SELECT update, and insert rows
Assign DBG_ROLL to account_manager */
GRANT CREATE SESSION, CREATE VIEW TO DBG_ROLL;
GRANT SELECT, UPDATE, INSERT ON location TO DBG_ROLL;
GRANT DBG_ROLL TO Account_Manager;








