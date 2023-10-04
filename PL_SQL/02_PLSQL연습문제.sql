
-- 1. employees 테이블에서 201번 사원의 이름과 이메일 주소를 출력하는
-- 익명블록을 만들어 보자. (변수에 담아서 출력하세요.)

SET SERVEROUTPUT ON;

DECLARE
    emp_name VARCHAR2(50); -- emp_name employees.first_name%TYPE;
    emp_email VARCHAR2(50); -- emp_name employees.email%TYPE;
BEGIN
    SELECT
        first_name,
        email
    INTO emp_name, emp_email
    FROM employees
    WHERE employee_id = 201;
    DBMS_OUTPUT.put_line(emp_name ||'-'|| emp_email);
END;

-- 2. employees 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤 (MAX 함수 사용)
-- 이 번호 + 1번으로 아래의 사원을 emps 테이블에
-- employee_id, last_name, email, hire_date, job_id를 신규 삽입하는 익명 블록을 만드세요.
-- SELECT절 이후에 INSERT문 사용이 가능합니다.
/*
<사원명>: steven
<이메일>: stevenjobs
<입사일자>: 오늘날짜
<JOB_ID>: CEO
*/

DECLARE
    emp_max_id NUMBER(10); -- emp_max_id employees.employee_id%TYPE;
BEGIN
    SELECT 
        MAX(employee_id)
    INTO emp_max_id
    FROM employees;
    
    INSERT INTO emps
        (employee_id, last_name, email, hire_date, job_id)
    VALUES
        (emp_max_id+1, 'steven', 'stevenjobs', sysdate, 'CEO');
END;

SELECT * FROM emps;