
/*
���ν����� divisor_proc
���� �ϳ��� ���޹޾� �ش� ���� ����� ������ ����ϴ� ���ν����� �����մϴ�.
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
    dbms_output.put_line(p_num||'�� ����� ����: '||p_cnt||'��');
END;

EXEC divisor_proc(13);
/*
�μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
depts ���̺� 
���� INSERT, UPDATE, DELETE �ϴ� depts_proc �� �̸��� ���ν����� ������.
�׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
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

EXEC depts_proc(400, '�λ��', 'D');
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
            dbms_output.put_line('�����ϰ��� �ϴ� �μ��� �������� �ʽ��ϴ�.');
            RETURN;
        END IF;
        
        DELETE FROM depts
        WHERE department_id = p_department_id;
    ELSE
        dbms_output.put_line('�ش� flag�� ���� ������ �غ���� �ʾҽ��ϴ�.');
    END IF;
    
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('���ܰ� �߻��߽��ϴ�.');
        dbms_output.put_line('ERROR MSG: ' || SQLERRM);
        ROLLBACK;
END;

EXEC depts_proc(400, '������', 'I');
SELECT * FROM depts;

/*
employee_id�� �Է¹޾� employees�� �����ϸ�,
�ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���. (�͸��Ͽ��� ���ν����� ����)
���ٸ� exceptionó���ϼ���
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
    dbms_output.put_line('�ټӳ��: '||msg||'��');
END;

SELECT 
    TRUNC((sysdate - hire_date) / 365) 
FROM employees
WHERE employee_id = 200;

/*
���ν����� - new_emp_proc
employees ���̺��� ���� ���̺� emps�� �����մϴ�.
employee_id, last_name, email, hire_date, job_id�� �Է¹޾�
�����ϸ� �̸�, �̸���, �Ի���, ������ update, 
���ٸ� insert�ϴ� merge���� �ۼ��ϼ���

������ �� Ÿ�� ���̺� -> emps
���ս�ų ������ -> ���ν����� ���޹��� employee_id�� dual�� select ������ ��.
���ν����� ���޹޾ƾ� �� ��: ���, last_name, email, hire_date, job_id
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
            (SELECT p_employee_id AS employee_id FROM dual) d -- ���� ���̺� MERGE������ ������ ���� ������ �ľ��ϱ� ���� dual���� �ܼ� ���� ����� ���� ON ������ ��.
        ON
            (e.employee_id = d.employee_id) -- p_employee_id�� ���޹��� ����� emps�� �����ϴ����� �˱� ���ؼ� dummy�� ���� ��ȸ ���.
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




