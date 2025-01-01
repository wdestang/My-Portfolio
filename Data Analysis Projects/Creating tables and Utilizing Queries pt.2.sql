USE section31


CREATE TABLE review(
    test_id INT PRIMARY KEY,
    test_section INT,
    test_date DATE,
    EmpID INT

CONSTRAINT EmpIDfk FOREIGN KEY(EmpID) REFERENCES Employee(EmpID)
);
INSERT INTO review
VALUES(1, 31, '5-OCT-2023', 99);

EXEC sp_rename 'review', 'Practice';
EXEC sp_rename 'Practice.test_section', 'test_sections','COLUMN';

SELECT * FROM review;
DROP TABLE review;

CREATE TABLE Employee(
    EmpID INT PRIMARY KEY,
    EmpFirstName VARCHAR(24) UNIQUE,
    EmpLastName VARCHAR(24) UNIQUE,
    EmpHireDate DATE,
    EmpSalaray NUMERIC(8,2),
    EmpAge INT CHECK (EmpAge > 16),
    EmpBirthdate DATE,
    EmpYrsExp NUMERIC(3,1)
);


SELECT * FROM Employee;

INSERT INTO Employee
VALUES(1, 'Bob', 'Sagg', '2-OCT-2022', 10000.443, 17, '2-NOV-1995', 3.4),
      (2, 'Brob', 'Saggg', '4-SEP-2023', 95000.5432, 30, '4-JAN-1990', 6.7);

UPDATE Employee
SET EmpFirstName = 'Goku'
WHERE EmpFirstName = 'Bob';

DELETE FROM Employee
Where EmpHireDate LIKE '%SEP%';

SELECT EmpFirstName, EmpLastName, EmpSalaray, EmpSalaray + 500 AS Bonus
    FROM Employee;

SELECT EmpFirstName, EmpLastName
FROM Employee
WHERE EmpFirstName LIKE 'br%';

SELECT COUNT(EmpID)
FROM Employee;

SELECT MIN(EmpAge), MAX(EmpAge)
FROM Employee;

SELECT EmpAge, AVG(EmpSalaray)
FROM Employee
GROUP BY EmpAge;

Q4

1.  select employee_id, last_name, job_id, hire_date as STARTDATE
        from Employees;

2.  select distinct job_id
        from Employees;

3.  select employee_id, last_name, salary, (salary + 100) * 12 as yearly_compensation
        from Employees;

4. select city + ',' +  country_id as 'City and Country'
        from Locations;

5. select last_name, salary
    from Employees
    where salary > 12000;

6. select last_name, salary
    from Employees
    where salary not in (5000,12000);

7.  select last_name, department_id
        from Employees
        where department_id = 20;

8. select last_name, salary, commission_pct
        from Employees
        where commission_pct > 0
        order by salary, commission_pct desc;

9. select last_name
        from Employees
        where last_name like '_ae%';

10. select last_name, job_id, salary
        from Employees
        where job_id in ('SR', 'SC') and salary not in (2500, 3500, 7000);