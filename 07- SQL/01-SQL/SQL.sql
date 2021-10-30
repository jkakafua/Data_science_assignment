
-- Select all the employees who were born between January 1, 1952 and December 31, 1955 and their titles and title date ranges
with employee_title as (select *
from employees
join titles on employees.emp_no = titles.emp_no
where birth_date between '1952-01-01' and '1955-12-31'
-- Order the results by emp_no
order by employees.emp_no asc)
select *
from employee_title

-- Select only the current title for each employee
with emp_hist as (
with impending_retirees as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
	
select impending_retirees.emp_no, 
		impending_retirees.first_name,
		impending_retirees.last_name,
		impending_retirees.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from impending_retirees join titles 
		on impending_retirees.emp_no=titles.emp_no
		order by emp_no),
		
latest_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select emp_hist.emp_no, emp_hist.first_name, emp_hist.last_name, emp_hist.title as current_title from emp_hist join latest_emp on ((emp_hist.emp_no=latest_emp.emp_no) and (emp_hist.from_date=latest_emp.most_recent));

-- Count the total number of employees about to retire by their current job title
with employee_title as (select *
from employees
join titles on employees.emp_no = titles.emp_no
where birth_date between '1952-01-01' and '1955-12-31')
select count(*)
from employee_title
where to_date != '9999-01-01'

-- Count the total number of employees per department
select count(*), dept_name as department
from (select *
from dept_emp
join departments on dept_emp.dept_no = departments.dept_no) as employee_dept
group by department

-- Bonus: Find the highest salary per department and department manager
-- query for highest salary per deparment manager

with dept_head_salary as (with salary_max_per_employee as (select distinct(emp_no), max(salary) as max_salary
from salaries
group by emp_no)  
select dept_manager.emp_no, max_salary, dept_no, from_date, to_date 
from salary_max_per_employee
join dept_manager on salary_max_per_employee.emp_no = dept_manager.emp_no)
select max(max_salary) as max_salary, dept_no
from dept_head_salary
--join departments on salary_max_per_employee.dept_no = departments.dept_no
group by dept_no
order by dept_no

--highest salary per department 
with emp_per_max_salary as (select salaries.emp_no, max(salary) as max_salary,dept_no 
from salaries
join dept_emp on salaries.emp_no = dept_emp.emp_no
group by salaries.emp_no, dept_no)
select max(max_salary) as max_salary, departments.dept_no
from emp_per_max_salary
join departments on emp_per_max_salary.dept_no = departments.dept_no
group by departments.dept_no
order by dept_no

