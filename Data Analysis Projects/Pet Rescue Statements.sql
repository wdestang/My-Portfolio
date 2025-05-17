--RESPONSIBLE FOR TASKS 3-5

--Task 2 Scripts

-- Creating temp_donation table; Matches donation except there are no constraints
CREATE TABLE TEMP_DONATION(
	Don_ID NUMBER,
	Donor_First_name VARCHAR2(16),
	Donor_Last_name VARCHAR2(16),
	Donation_Date DATE,
	Donation_Amount NUMBER (7,1),
	Address_ID NUMBER,
	Volunteer_ID NUMBER
);


-- Bulk inserting into donations table, leaving behind invalid entries
DECLARE
	TYPE rec_donation IS TABLE OF DONATION%ROWTYPE;	-- Create record type rec_donation and give it the same schema as donation
	table_donation rec_donation; -- Create record of the type rec_donation
	CURSOR cur IS SELECT * FROM TEMP_DONATION WHERE -- Create cursor
		ADDRESS_ID IN (SELECT ADDRESS_ID FROM ADDRESS) AND -- Address ID should be present in the address table
		VOLUNTEER_ID IN (SELECT VOLUNTEER_ID FROM VOLUNTEER) AND -- Volunteer ID should be present in the volunteer table
		DON_ID NOT IN (SELECT DON_ID FROM DONATION) AND -- There should not be a donation with the same ID already present in the donation table
		DON_ID IS NOT NULL AND -- Don ID is the primary key, it shouldn't be null
		DONATION_DATE IS NOT NULL AND -- Donation date should not be null
		DONATION_AMOUNT IS NOT NULL AND -- Donation amount should be a positive number
		DONATION_AMOUNT > 0;
BEGIN
	OPEN cur; -- Open the cursor
		FETCH cur BULK COLLECT INTO table_donation; -- Bulk collect entries from the cursor to the record
	CLOSE cur; -- Close the cursor after it is finished being used
	FOR ind IN 1 .. table_donation.LAST LOOP -- For loop iterates to the last entry of the record
		INSERT INTO DONATION VALUES table_donation(ind); -- Insert the entry from the record to the donation table
	END LOOP; -- End of the loop
	DELETE FROM TEMP_DONATION WHERE DON_ID IN (SELECT DON_ID FROM DONATION); -- Delete all entries in temp_donation that have an ID present in donation
END;
/

COMMIT; --Commit changes
	

--Task 3 Scripts

-- Creating Date Dimension table
CREATE TABLE Date_Dimension (
    D_ID NUMBER PRIMARY KEY,  -- Surrogate key for Date dimension
    Full_Date DATE NOT NULL,  -- Date (e.g., '2021-07-01')
    Year NUMBER(4) NOT NULL,  -- Year (e.g., 2021)
    Month_Number NUMBER(2) NOT NULL,  -- Month number (1-12)
    Day_Number NUMBER(2) NOT NULL,  -- Day of the month (1-31)
    Month_Name_Short CHAR(3) NOT NULL,  -- Abbreviated month name 
    Month_Name_Long VARCHAR2(10) NOT NULL  -- Full month name 
);

-- Creating Address Dimension table
CREATE TABLE Address_Dimension (
    A_ID NUMBER PRIMARY KEY,  -- Surrogate key for Address dimension
    Address_ID NUMBER,  -- Original Address ID from source data (to maintain reference)
    Postal_Code CHAR(7),  -- Postal code of the address
    Address VARCHAR2(255) NOT NULL  -- Full address 
);

-- Creating Volunteer Dimension table
CREATE TABLE Volunteer_Dimension (
    V_ID NUMBER PRIMARY KEY,  -- Surrogate key for Volunteer dimension
    Volunteer_ID NUMBER,  -- Original Volunteer ID from source data (to maintain reference)
    Volunteer_Name VARCHAR2(32) NOT NULL  -- Volunteer name 
);

-- Creating Fact table for donations
CREATE TABLE Donation_Fact (
    D_ID NUMBER NOT NULL,  -- Foreign key from Date_Dimension
    A_ID NUMBER NOT NULL,  -- Foreign key from Address_Dimension
    V_ID NUMBER NOT NULL,  -- Foreign key from Volunteer_Dimension
    Donation_Count NUMBER NOT NULL,  -- Total count of donations (e.g., number of donations made)
    Total_Donations NUMBER(10,2) NOT NULL,  -- Total sum of donations (e.g., total monetary amount)
    
    -- Foreign Key Constraints
    CONSTRAINT fk_fact_date FOREIGN KEY (D_ID) REFERENCES Date_Dimension(D_ID),
    CONSTRAINT fk_fact_address FOREIGN KEY (A_ID) REFERENCES Address_Dimension(A_ID),
    CONSTRAINT fk_fact_volunteer FOREIGN KEY (V_ID) REFERENCES Volunteer_Dimension(V_ID),
    
    -- Primary Key on the combination of D_ID, A_ID, and V_ID
    CONSTRAINT pk_fact PRIMARY KEY (D_ID, A_ID, V_ID)
);


-- Task 4 Scripts

CREATE SEQUENCE Dim_ID;    -- To ensure that surrogate keys are unique

INSERT INTO address_dimension
SELECT Dim_ID.NEXTVAL, address_id, postal_code, street_num || ' ' || street_name || ' ' ||
       city || ' ' || province AS address
FROM prc.address;    -- Inserting data into dimension table from central repository

INSERT INTO volunteer_dimension
SELECT Dim_ID.NEXTVAL, volunteer_id, first_name || ' ' || last_name AS volunteer_name
FROM prc.volunteer;

INSERT INTO date_dimension
SELECT Dim_ID.NEXTVAL, donation_date as full_date, 
       EXTRACT(YEAR FROM donation_date) AS "Year",    -- Using extract to retrieve the year as a number
       EXTRACT(MONTH FROM donation_date) AS month_number,
       EXTRACT(DAY FROM donation_date) AS day_number,
       TO_CHAR(donation_date, 'Mon') AS month_name_short,    -- Using TO_CHAR to retrieve short version of month
       TO_CHAR(donation_date, 'Month') AS month_name_long
FROM prc.donation;

COMMIT;

-- FACT TABLE INSERT 

INSERT INTO donation_fact
SELECT dd.d_id, ad.a_id, vd.v_id,
       COUNT(d.don_id) AS donation_count, 
       SUM(d.donation_amount) AS total_donations
FROM prc.donation d
JOIN date_dimension dd ON d.donation_date = dd.full_date    -- Join statements are the sum of values needed for the fact table (grain of the fact table)
JOIN address_dimension ad ON d.address_id = ad.address_id
JOIN volunteer_dimension vd ON d.volunteer_id = vd.volunteer_id
GROUP BY dd.d_id, ad.a_id, vd.v_id;

COMMIT;

-- Task 3 star schema

-- UPDATED DIM TABLES


CREATE TABLE Date_Dimension (
    D_ID NUMBER PRIMARY KEY,    -- This will hold the surrogate key
    Full_Date DATE NOT NULL,  
    Year NUMBER(4) NOT NULL,  
    Month_Number NUMBER(2) NOT NULL,  
    Day_Number NUMBER(2) NOT NULL,
    Month_Name_Short CHAR(3) NOT NULL,
    Month_Name_Long VARCHAR2(10) NOT NULL
);

 
CREATE TABLE Address_Dimension (
    A_ID NUMBER PRIMARY KEY,    -- Holds surrogate key
    Address_ID NUMBER,  
    Postal_Code CHAR(7),  
    Address VARCHAR2(255) NOT NULL
);

 
CREATE TABLE Volunteer_Dimension (
    V_ID NUMBER PRIMARY KEY,    -- Holds surrogate key
    Volunteer_ID NUMBER,  
    Volunteer_Name VARCHAR2(32) NOT NULL
);

 
CREATE TABLE Donation_Fact (
    D_ID NUMBER NOT NULL,  
    A_ID NUMBER NOT NULL,  
    V_ID NUMBER NOT NULL,  
    Donation_Count NUMBER NOT NULL,  
    Total_Donations NUMBER(10,2) NOT NULL,  
    CONSTRAINT fk_fact_date FOREIGN KEY (D_ID) REFERENCES Date_Dimension(D_ID),  
    CONSTRAINT fk_fact_address FOREIGN KEY (A_ID) REFERENCES Address_Dimension(A_ID),  
    CONSTRAINT fk_fact_volunteer FOREIGN KEY (V_ID) REFERENCES Volunteer_Dimension(V_ID),  
    CONSTRAINT pk_fact PRIMARY KEY (D_ID, A_ID, V_ID)    -- Composite primary key from surrogate keys of dimension tables
);

-- Task 5 Views

CREATE OR REPLACE VIEW donations_by_date AS
SELECT donation_date AS "Date", TO_CHAR(donation_date, 'YYYY') AS "Year",   -- TO_CHAR used to retrieve the year from donation date
       TO_CHAR(donation_date, 'Month') AS "Month",
       TO_CHAR(donation_date, 'DD') AS "Day",
       COUNT(don_id) AS Number_of_Donations,    -- Using don_id to determine to number of donations
       ROUND(SUM(donation_amount), 2) AS Total_Donation_Amount
FROM donation
GROUP BY donation_date, TO_CHAR(donation_date, 'YYYY'),
         TO_CHAR(donation_date, 'Month'),
         TO_CHAR(donation_date, 'DD')
ORDER BY donation_date, "Year", "Month", "Day";

       
CREATE OR REPLACE VIEW donations_by_location AS
SELECT a.postal_code, 
       a.street_num || ' ' || a.street_name || ' ' || a.city || ' ' || a.province AS Address,    -- Concatinating columns to create a single address line
       COUNT(d.don_id) AS Number_of_Donations, ROUND(SUM(d.donation_amount), 2) AS Total_Donation_Amount,
       ROUND(AVG(d.donation_amount), 2) AS Average_Donation
FROM donation d JOIN address a ON d.address_id = a.address_id   -- Join is needed as I am grabbing information from more than one table
GROUP BY a.postal_code, a.street_num || ' ' || a.street_name || ' ' || a.city || ' ' || a.province
ORDER BY a.postal_code, Address;

CREATE OR REPLACE VIEW donations_by_volunteer AS
SELECT v.group_leader AS Volunteer_Leader, v.first_name || ' ' || v.last_name AS Volunteer,    --Combining multiple columns to create the volunteer column
       COUNT(d.don_id) AS Number_of_Donations, ROUND(SUM(d.donation_amount), 2) AS Total_Donation_Amount,
       ROUND(AVG(d.donation_amount), 2) AS Average_Donation
FROM donation d JOIN volunteer v ON d.volunteer_id = v.volunteer_id    -- Join is needed to grab information from multiple tables
GROUP BY v.group_leader, v.first_name || ' ' || v.last_name
ORDER BY Volunteer_Leader, Volunteer;

-- Task 6 - Basic Security
-- Create DMLUser with permissions to perform DML (INSERT, UPDATE, DELETE) on address, donation, and volunteer tables
CREATE USER DMLUser IDENTIFIED BY Pass123;
GRANT CONNECT TO DMLUser;
-- Grant DML privileges to DMLUser
GRANT INSERT, UPDATE, DELETE ON PRC.Address TO DMLUser;
GRANT INSERT, UPDATE, DELETE ON PRC.Donation TO DMLUser;
GRANT INSERT, UPDATE, DELETE ON PRC.Volunteer TO DMLUser;

-- Create Dashboard user with read-only permissions on views
CREATE USER Dashboard IDENTIFIED BY ReadOnly123;
GRANT CONNECT TO Dashboard;

-- Grant SELECT permissions on views to Dashboard user
GRANT SELECT ON PRC.View_DonationsByDate TO Dashboard;
GRANT SELECT ON PRC.View_DonationsByLocation TO Dashboard;
GRANT SELECT ON PRC.View_DonationsByVolunteer TO Dashboard;

-- Verify privileges for both users
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE IN ('DMLUser', 'Dashboard');
