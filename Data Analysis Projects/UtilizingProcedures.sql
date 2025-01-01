SET SERVEROUTPUT ON

--Q1--
CREATE OR REPLACE PROCEDURE UPDATE_EMPLOYEE_SALARY(
    P_EMPLOYEE_ID NUMBER,
    P_PERFORMANCE_RATING NUMBER)
IS
    emp_salary EMPLOYEES.SALARY%TYPE;
    new_salary EMPLOYEES.SALARY%TYPE;

BEGIN
     IF P_PERFORMANCE_RATING NOT BETWEEN 1 AND 5 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Performance rating must be between 1 and 5.');
        RETURN;
    END IF;
    
    SELECT SALARY INTO emp_salary
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = P_EMPLOYEE_ID;
    
    IF P_PERFORMANCE_RATING = 5 THEN
        new_salary := emp_salary * 1.10;
    ELSIF P_PERFORMANCE_RATING = 4 THEN
        new_salary := emp_salary * 1.07;
    ELSIF P_PERFORMANCE_RATING = 3 THEN
        new_Salary := emp_salary * 1.05;
    ELSIF P_PERFORMANCE_RATING = 2 THEN
        new_salary := emp_salary * 1.03;
    ELSE
       new_salary := emp_salary;
    END IF;
    
    UPDATE EMPLOYEES
    SET SALARY = new_salary
    WHERE EMPLOYEE_ID = P_EMPLOYEE_ID;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salary successfully updated for Employee ID: ' || P_EMPLOYEE_ID);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with Employee ID: ' || P_EMPLOYEE_ID);
    
END;
/

EXEC UPDATE_EMPLOYEE_SALARY(101, 6);

--Q2--
CREATE TABLE EMPLOYEE_ARCHIVE (
    EMPLOYEE_ID NUMBER(6),
    FIRST_NAME VARCHAR2(20),
    LAST_NAME VARCHAR2(25),
    HIRE_DATE DATE,
    SALARY NUMBER(8, 2)
);

CREATE OR REPLACE PROCEDURE BULK_INSERT_EMPLOYEES
IS
    TYPE employee_rec IS RECORD(
        EMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE,
        FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE,
        LAST_NAME EMPLOYEES.LAST_NAME%TYPE,
        HIRE_DATE EMPLOYEES.HIRE_DATE%TYPE,
        SALARY EMPLOYEES.SALARY%TYPE
    );
    
    TYPE v_employee_rec IS TABLE OF employee_rec;
    
    l_employee_rec v_employee_rec;
    
    CURSOR cr IS SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY
        FROM EMPLOYEES
        WHERE SALARY > 5000;

BEGIN
    OPEN cr;
        FETCH cr BULK COLLECT INTO l_employee_rec;
    CLOSE cr;
    
    FORALL i IN 1..l_employee_rec.LAST
        INSERT INTO EMPLOYEE_ARCHIVE
        VALUES(
            l_employee_rec(i).EMPLOYEE_ID,
            l_employee_rec(i).FIRST_NAME,
            l_employee_rec(i).LAST_NAME,
            l_employee_rec(i).HIRE_DATE,
            l_employee_rec(i).SALARY
            );
      
END;
/
COMMIT;

EXEC BULK_INSERT_EMPLOYEES;

SELECT * FROM EMPLOYEE_ARCHIVE;

            
    
    

    
    