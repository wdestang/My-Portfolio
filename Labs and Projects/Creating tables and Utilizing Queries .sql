USE section31
GO

CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT
    CONSTRAINT customer_idfk FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders 
VALUES(1101, '5-JAN-2023', 1),
      (1102, '7-AUG-2023', 2),
      (1103, '4-FEB-2023', 3);

ALTER TABLE orders ADD order_total INT;
EXEC sp_rename 'orders.order_total', 'bill_ammount', 'column';

CREATE TABLE orders_items(
    order_id INT,
    item_id INT
    CONSTRAINT order_idfk FOREIGN KEY(order_id) REFERENCES orders(order_id),
    CONSTRAINT item_idfk FOREIGN KEY(item_id) REFERENCES items(item_id)
);

INSERT INTO orders_items
VALUES(1101, 01),
      (1102, 02),
      (1103, 03);

CREATE TABLE customers(
    customer_id INT PRIMARY KEY,
    customer_phone VARCHAR(12),
    customer_email VARCHAR(24)
);

INSERT INTO customers 
VALUES(1, 6472349090, 'greg@gmail.com'),
      (2, 5749908765, 'kol12@gmail.com'),
      (3, 3345456665, 'nm@gmail.com' );

CREATE TABLE items(
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    item_price VARCHAR(24)
);

INSERT INTO items
VALUES(01, 'pencil', 3),
      (02, 'eraser', 2),
      (03, 'pen', 5);

UPDATE items
SET item_price = item_price * 1.05;




Q.6
1.  SELECT employee_id, last_name, job_id, hire_date
        FROM Employees
        WHERE manager_id = 108;

2.  select distinct department_id
        from Employees;

3.  select employee_id, last_name, salary, commission_pct (0.10) * 12 as yearly_compensation
        from Employees;

4. 

5. select last_name, salary
    from Employees
    where salary > 12000;

6. 

7.  select last_name, department_id
        from Employees
        where department_id IN(30,60)
        ORDER BY last_name;


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