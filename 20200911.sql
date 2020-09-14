-------grp5------------
SELECT TO_CHAR(hiredate,'yyyy') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY  TO_CHAR(hiredate,'yyyy');

------grp6--------------
SELECT  COUNT(*) cnt
FROM dept;


-----grp7---------------
직원이 속한 부서의 개수를 구하기
1. 부서가 몇개 존재 하는지 ? 3행

SELECT  COUNT(COUNT(*)) cnt
FROM emp
GROUP BY deptno;

SELECT COUNT(*)
FROM
        (SELECT deptno
        FROM emp
        GROUP BY deptno) a;


--------join0-----------

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
ORDER BY emp.deptno ASC ;


-------join0_1------------

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE emp.deptno LIKE 10 OR emp.deptno LIKE 30;

------------join0_2-----------------
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE sal >2500
ORDER BY emp.deptno ASC ;

----------join0_3-----------------
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE   sal > 2500 AND empno > 7600
ORDER BY emp.deptno ASC ;

----------join0_4-----------------
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE   sal >2500 AND empno > 7600 AND dname IN ('RESEARCH')
ORDER BY emp.empno DESC;

----------- 220 page -------------------

---------- ANSI VERSION ------------------
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu);


 -----------ORCLE VERSION ----------------   
SELECT lprod.lprod_gu,lprod.lprod_nm,prod.prod_id,prod.prod_name
FROM prod, lprod
WHERE prod.prod_lgu =lprod.lprod_gu;

-----prod 테이블 건수 --------------------
SELECT COUNT (*)
FROM prod;

----------- 221 page -------------------

---------- ANSI VERSION ------------------
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer.buyer_id = prod.prod_buyer);


 -----------ORCLE VERSION ----------------   
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE prod.prod_buyer =  buyer.buyer_id;

----------- 222 page -------------------

 -----------ORCLE VERSION ----------------  
//join시 생각할 부분 1. 테이블 기술 2. 연결조건

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

---------- ANSI VERSION ------------------
테이블 JOIN 테이블 ON ()
         JOIN 테이블 ON ()
         
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
                    JOIN prod ON (member.mem_id = cart.cart_member)
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

