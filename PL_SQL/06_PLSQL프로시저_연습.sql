
/*
프로시저명 divisor_proc
숫자 하나를 전달받아 해당 값의 약수의 개수를 출력하는 프로시저를 선언합니다.
*/

CREATE OR REPLACE PROCEDURE divisor_proc
    (p_num IN NUMBER)
IS
    p_cnt NUMBER := 0;
BEGIN
    FOR i IN 1..p_num
        LOOP
            IF MOD(p_num, i) = 0 THEN
            p_cnt := p_cnt +1;
            -- dbms_output.put_line(i);
            END IF;
        END LOOP;
    dbms_output.put_line(p_num||'의 약수의 개수: '||p_cnt||'개');
END;

EXEC divisor_proc(13);
/*
부서번호, 부서명, 작업 flag(I: insert, U:update, D:delete)을 매개변수로 받아 
depts 테이블에 
각각 INSERT, UPDATE, DELETE 하는 depts_proc 란 이름의 프로시저를 만들어보자.
그리고 정상종료라면 commit, 예외라면 롤백 처리하도록 처리하세요.
*/

CREATE OR REPLACE PROCEDURE depts_proc
    (p_department_id IN depts.department_id%TYPE,
    p_department_name IN depts.department_name%TYPE,
    p_flag IN VARCHAR2
    )
IS
BEGIN
    
    CASE
    WHEN p_flag = 'I' THEN
        INSERT INTO depts
            (department_id, department_name)
        VALUES 
            (p_department_id, p_department_name);
    WHEN p_flag = 'U' THEN
        UPDATE depts
        SET 
        department_name = p_department_name
        WHERE
        department_id = p_department_id;
    WHEN p_flag = 'D' THEN
        DELETE FROM depts
        WHERE department_id = p_department_id;
    END CASE;
    COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN ROLLBACK;
END;

EXEC depts_proc(400, '인사부', 'D');
SELECT * FROM depts;

------------------------------------------------------------

CREATE OR REPLACE PROCEDURE depts_proc
    (p_department_id IN depts.department_id%TYPE,
    p_department_name IN depts.department_name%TYPE,
    p_flag IN VARCHAR2
    )
IS
    v_cnt NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_cnt
    FROM depts
    WHERE department_id = p_department_id;
    
    IF p_flag = 'I' THEN
        INSERT INTO depts
        (department_id, department_name)
        VALUES (p_department_id, p_department_name);
    ELSIF p_flag = 'U' THEN
        UPDATE depts
        SET department_name = p_department_name
        WHERE department_id = p_department_id;
    ELSIF p_flag = 'D' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('삭제하고자 하는 부서가 존재하지 않습니다.');
            RETURN;
        END IF;
        
        DELETE FROM depts
        WHERE department_id = p_department_id;
    ELSE
        dbms_output.put_line('해당 flag에 대한 동작이 준비되지 않았습니다.');
    END IF;
    
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('예외가 발생했습니다.');
        dbms_output.put_line('ERROR MSG: ' || SQLERRM);
        ROLLBACK;
END;

EXEC depts_proc(400, '오락부', 'I');
SELECT * FROM depts;

/*
employee_id를 입력받아 employees에 존재하면,
근속년수를 out하는 프로시저를 작성하세요. (익명블록에서 프로시저를 실행)
없다면 exception처리하세요
*/

CREATE OR REPLACE PROCEDURE hire_year_proc
    (p_employee_id IN employees.employee_id%TYPE,
    p_result OUT NUMBER)
IS
    v_hire_year NUMBER :=0 ;
BEGIN
    
    SELECT
        TRUNC((sysdate - hire_date) / 365)
    INTO v_hire_year
    FROM employees
    WHERE employee_id = p_employee_id;

        p_result := v_hire_year;
    
    EXCEPTION WHEN OTHERS THEN 
        dbms_output.put_line('ERROR MSG:' || SQLERRM);
        ROLLBACK;
END;

DECLARE
    msg NUMBER(10):=0;
BEGIN
    hire_year_proc(200, msg);
    dbms_output.put_line('근속년수: '||msg||'년');
END;

SELECT 
    TRUNC((sysdate - hire_date) / 365) 
FROM employees
WHERE employee_id = 200;

/*
프로시저명 - new_emp_proc
employees 테이블의 복사 테이블 emps를 생성합니다.
employee_id, last_name, email, hire_date, job_id를 입력받아
존재하면 이름, 이메일, 입사일, 직업을 update, 
없다면 insert하는 merge문을 작성하세요

머지를 할 타겟 테이블 -> emps
병합시킬 데이터 -> 프로시저로 전달받은 employee_id를 dual에 select 때려서 비교.
프로시저가 전달받아야 할 값: 사번, last_name, email, hire_date, job_id
*/

CREATE TABLE emps AS (SELECT * FROM employees);
DROP TABLE emps;

CREATE OR REPLACE PROCEDURE new_emp_proc
    (p_employee_id IN employees.employee_id%TYPE,
    p_last_name IN employees.last_name%TYPE,
    p_email IN employees.email%TYPE,
    p_hire_date IN employees.hire_date%TYPE,
    p_job_id IN employees.job_id%TYPE)
IS
BEGIN
    
    MERGE INTO emps e
        USING
            (SELECT p_employee_id AS employee_id FROM dual) d -- 단일 테이블 MERGE문에서 데이터 존재 유무를 파악하기 위해 dual에다 단순 값만 만들어 놓고 ON 절에서 비교.
        ON
            (e.employee_id = d.employee_id) -- p_employee_id로 전달받은 사번이 emps에 존재하는지를 알기 위해서 dummy로 만든 조회 결과.
    WHEN MATCHED THEN
        UPDATE SET
            e.last_name = p_last_name,
            e.email = p_email,
            e.hire_date = p_hire_date,
            e.job_id = p_job_id
    WHEN NOT MATCHED THEN
        INSERT 
            (employee_id, last_name, email, hire_date, job_id)
        VALUES
            (p_employee_id, p_last_name, p_email, p_hire_date, p_job_id);
END;

SELECT 120 AS employee_id FROM dual;

EXEC new_emp_proc (400, 'test','test',sysdate,'test');

SELECT * FROM emps;




