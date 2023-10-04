-- 조인 연습 문제
/*
문제 1.
-EMPLOYEES 테이블과, DEPARTMENTS 테이블은 DEPARTMENT_ID로 연결되어 있습니다.
-EMPLOYEES, DEPARTMENTS 테이블을 엘리어스를 이용해서
각각 INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER 조인 하세요. (달라지는 행의 개수 주석으로 확인)
*/

SELECT * FROM employees e
JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id;

SELECT * FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id; -- department_id 가 null인 178 kimberly도 출력됨

SELECT * FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id; -- 사원 없는 부서도 조회됨

SELECT * FROM employees e
FULL JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id; -- 사원 없는 부서, 부서 없는 kimberly도 모두 출력됨


-- 서브쿼리 연습 문제
/*
문제 12. 
employees테이블, departments테이블을 left조인 hire_date를 오름차순 기준으로 
1-10번째 데이터만 출력합니다.
조건) rownum을 적용하여 번호, 직원아이디, 이름, 전화번호, 입사일, 
부서아이디, 부서이름 을 출력합니다.
조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 틀어지면 안됩니다.
*/

SELECT * FROM
    (
    SELECT ROWNUM AS rn, tbl.*
        FROM
        (
        SELECT
            e.employee_id, e.first_name, e.phone_number, e.hire_date,
            d.department_id, d.department_name
        FROM employees e
        LEFT JOIN departments d
        ON e.department_id = d.department_id
        ORDER BY hire_date ASC
        ) tbl
    )    
WHERE rn BETWEEN 1 AND 10;    
    
/*
문제 13. 
--EMPLOYEES 와 DEPARTMENTS 테이블에서 JOB_ID가 SA_MAN 사원의 정보의 LAST_NAME, JOB_ID, 
DEPARTMENT_ID,DEPARTMENT_NAME을 출력하세요.
*/   

SELECT
    e.last_name, e.job_id, d.department_id, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE job_id = 'SA_MAN';
    
SELECT
    e.last_name, e.job_id, e.department_id,
    (
        SELECT
           d.department_name
        FROM departments d
        WHERE e.department_id = d.department_id
    )
FROM employees e
WHERE job_id = 'SA_MAN';

-- 1. 모든 구구단을 출력하는 익명 블록을 만드세요. (2 ~ 9단)
-- 짝수단만 출력해 주세요. (2, 4, 6, 8)
-- 참고로 오라클 연산자 중에는 나머지를 알아내는 연산자가 없어요. (% 없음~)

DECLARE
BEGIN
    FOR dan IN 1..9
    LOOP
    IF MOD(dan , 2) =0 THEN
        FOR hang IN 2..9
        LOOP
            dbms_output.put_line(dan||'x'||hang||'='||dan*hang);
        END LOOP;
        dbms_output.put_line('------------------');
    END IF;
    END LOOP;    
END;

-- 2. INSERT를 300번 실행하는 익명 블록을 처리하세요.
-- board라는 이름의 테이블을 만드세요. (bno, writer, title 컬럼이 존재합니다.)
-- bno는 SEQUENCE로 올려 주시고, writer와 title에 번호를 붙여서 INSERT 진행해 주세요.
-- ex) 1, test1, title1 -> 2 test2 title2 -> 3 test3 title3 ....

DROP TABLE board;

CREATE TABLE board (
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(20),
    title VARCHAR2(20)
);

DROP SEQUENCE brd_seq;

CREATE SEQUENCE brd_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE  1
    NOCACHE
    NOCYCLE;

