
SELECT * FROM employees;

-- WHERE절 비교 (데이터 값은 대/소문자를 구분합니다.)
SELECT first_name, last_name, job_id
FROM employees
WHERE job_id = 'IT_PROG';

SELECT * FROM employees
WHERE last_name = 'King';

SELECT *
FROM employees
WHERE department_id = 90;

SELECT *
FROM employees
WHERE salary >= 15000
AND salary < 20000;

SELECT * FROM employees
WHERE hire_date = '04/01/30';

-- 데이터 행 제한
SELECT * FROM employees
WHERE salary BETWEEN 15000 AND 20000;

SELECT * FROM employees
WHERE hire_date BETWEEN '03/01/01' AND '03/12/31';

-- IN 연산자의 사용 (특정 값들과 비교할 때 사용)
SELECT * FROM employees
WHERE manager_id IN (100, 101, 102);

SELECT * FROM employees
--WHERE job_id IN ('IT_PROG', 'AD_VP');

-- LIKE 연산자
-- %는 어떠한 문자든, _는 데이터 자리(위치)를 찾아낼 때
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '03%';

SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '%15';

SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '%05%';
