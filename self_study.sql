-- ���� ���� ����
/*
���� 1.
-EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
-EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ�
���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� �ּ����� Ȯ��)
*/

SELECT * FROM employees e
JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id;

SELECT * FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id; -- department_id �� null�� 178 kimberly�� ��µ�

SELECT * FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id; -- ��� ���� �μ��� ��ȸ��

SELECT * FROM employees e
FULL JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id; -- ��� ���� �μ�, �μ� ���� kimberly�� ��� ��µ�


-- �������� ���� ����
/*
���� 12. 
employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 
1-10��° �����͸� ����մϴ�.
����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, 
�μ����̵�, �μ��̸� �� ����մϴ�.
����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.
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
���� 13. 
--EMPLOYEES �� DEPARTMENTS ���̺��� JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID, 
DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���.
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

-- 1. ��� �������� ����ϴ� �͸� ����� ���弼��. (2 ~ 9��)
-- ¦���ܸ� ����� �ּ���. (2, 4, 6, 8)
-- ����� ����Ŭ ������ �߿��� �������� �˾Ƴ��� �����ڰ� �����. (% ����~)

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

-- 2. INSERT�� 300�� �����ϴ� �͸� ����� ó���ϼ���.
-- board��� �̸��� ���̺��� ���弼��. (bno, writer, title �÷��� �����մϴ�.)
-- bno�� SEQUENCE�� �÷� �ֽð�, writer�� title�� ��ȣ�� �ٿ��� INSERT ������ �ּ���.
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

