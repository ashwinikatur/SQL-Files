--1. SQL query to find all dates' id with higher temperature compared to its previous dates.

select w1.id Id
from weather w1 join weather w2
on datediff(w1.recordDate, w2.recordDate)=1
and w1.temperature > w2.temperature

--2. SQL query to reformat the table such that there is a department id column and a revenue column for each month.

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

update salary
set 
sex = case sex 
		when 'm' then 'f'
		else 'm'
	  end

--4. SQL query to find all duplicate emails in a table named Person.

select email
from person
group by email
having count(id)>1

--5. SQL query to find all customers who never order anything.

select name as Customers
from customers
where id not in (select customerId
                from orders)

--6. SQL query to get the nth highest salary from the Employee table.

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

