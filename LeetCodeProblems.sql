--1. SQL query to find all dates' id with higher temperature compared to its previous dates.
--Given table: Weather

select w1.id Id
from weather w1 join weather w2
on datediff(w1.recordDate, w2.recordDate)=1
and w1.temperature > w2.temperature

--2. SQL query to reformat the table such that there is a department id column and a revenue column for each month.
--Given table: Department

select id,
sum(case when month='Jan' then revenue else null end) as Jan_Revenue,
sum(case when month='Feb' then revenue else null end) as Feb_Revenue,
sum(case when month='Mar' then revenue else null end) as Mar_Revenue,
sum(case when month='Apr' then revenue else null end) as Apr_Revenue,
sum(case when month='May' then revenue else null end) as May_Revenue,
sum(case when month='Jun' then revenue else null end) as Jun_Revenue,
sum(case when month='Jul' then revenue else null end) as Jul_Revenue,
sum(case when month='Aug' then revenue else null end) as Aug_Revenue,
sum(case when month='Sep' then revenue else null end) as Sep_Revenue,
sum(case when month='Oct' then revenue else null end) as Oct_Revenue,
sum(case when month='Nov' then revenue else null end) as Nov_Revenue,
sum(case when month='Dec' then revenue else null end) as Dec_Revenue
from department
group by id 

--3. SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) with a single update statement and no intermediate temp table(s).
--Given table: Salary

update salary
set 
sex = case sex 
		when 'm' then 'f'
		else 'm'
	  end

--4. SQL query to find all duplicate emails in a table named Person.
--Given table: Person

select email
from person
group by email
having count(id)>1

--5. SQL query to find all customers who never order anything.
--Given tables: Customer, Orders

select name as Customers
from customers
where id not in (select customerId
                from orders)

--6. SQL query to get the nth highest salary from the Employee table.
--Given table: Employee

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
set N = N-1;
  RETURN (
      select distinct ifnull(salary,null)
      from employee
      order by salary desc
      limit 1 offset N
  );
END

--Also

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      select distinct ifnull(salary,null)
      from (select salary, dense_rank() over(order by salary desc) as rnk from employee) temp1
      where rnk=N
  );
END

--7.SQL query to find employees who have the highest salary in each of the departments. 
--Given tables: Employee, Department

select department, employee, salary from
(select d.name as Department, e.name as Employee, e.salary as Salary,
	rank() over(partition by departmentId order by salary desc) as rnk
from employee e
join department d
on e.departmentId = d.id) table1
where rnk = 1

--Also

select d.name as Department, e.name as Employee, e.Salary
from department d
join employee e
on d.id = e.departmentId
where (e.departmentID ,salary) 
in (select departmentId, max(salary)
	from employee 
	group by departmentId)

--8. SQL query to find employees who earn the top three salaries in each of the department.
--Given tables: Employee, Department

select Department, Employee, Salary from
(select d.name as Department, e.name as Employee, e.salary as Salary,
	dense_rank() over(partition by departmentId order by salary desc) as rnk
from employee e
join department d
on e.departmentId = d.id) table1
where rnk in (1,2,3)


--9.SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. 
--Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.
--Given tables: scores

select Score,
dense_rank() over(order by score desc) 'Rank'
from scores

--10. SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.
--The indirect relation between managers will not exceed 3 managers as the company is small.
--Given table: Employees

with recursive givenManager(id,n) as
(
    select employee_id as id, 1 as n
    from employees
    where manager_id=1 and employee_id!=1
    union
    select employee_id as id,n+1 as n
    from employees, givenManager
    where manager_id=givenManager.id and n+1<4
)
select id as employee_id 
from givenManager
