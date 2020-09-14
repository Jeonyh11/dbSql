customer: 고객
cid : 고객 아이디
cnm : 고객 이름

SELECT *
FROM customer;

product : 제품
pid : product id : 제품 번호
pnm : product name : 제품 이름

SELECT*
FROM product;

cycle : 고객애음주기
cid : 고객 아이디
pid : product id : 제품 번호
day : 1-7 (일 - 토)
cnt : COUNT, 수량


SELECT*
FROM cycle;

--------------- 224page 실습 join4  --------------------------
SELECT cycle.cid,customer.cnm,cycle.pid,cycle.day,cycle.cnt
FROM cycle JOIN customer ON(cycle.cid = customer.cid)
WHERE cnm IN ('brown', 'sally');

------------- ORACLE VERSION ----------------
SELECT customer.*, cycle.pid, cycle.day,cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND cnm IN ('brown', 'sally');

------------ USING VERSION ---------------------
SELECT cid,cnm,pid,day,cnt
FROM cycle JOIN customer USING(cid)
WHERE customer.cnm IN ('brown', 'sally');

------------- 225page join5 ----------------
EXPLAIN PLAN FOR
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)  
                    JOIN product ON(cycle.pid = product.pid)
WHERE cnm IN ('brown', 'sally');
SELECT*
FROM TABLE(dbms_xplan.display);
-- SQL : 실행에 대한 순서가 없다. 조인할 테이블에 대해서 FROM 절에 기술한
            순서대로  테이블을 읽지 않음. 
            FROM customer, cycle, product ==> 오라클에서는 product테이블부터 읽을 수 있다.
            
------------JOIN 구분----------------
OUTER JOIN : 자주 쓰이지는 않지만 중요

1. 문법에 따른 구분 : ANSI - SQL, ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CORSS-JOIN
3.join 성공여부에 따라 데이터 표시여부
        : INNER JOIN -조인이 성공했을 때 데이터를 표시
        : OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시
        
-----사번, 사원의 이름, 관리자 사번, 관리자 이름 --------
KING (PRESIDENT)의 경우 MGR 컬럼의 값이 NULL이기 때문에 조인에 실패 ==> 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;                                 --사원쪽에 매니저를 조회 매니저의 사번 조회

------------- ANSI VERSION ----------------
SELECT e.empno, e.ename, e.mgr, e.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);  --왼쪽에 있는 데이터는 조인에 실패해도 결과값이 나온다


SELECT e.empno, e.ename, e.mgr, e.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

행에 대한 제한 조건 기술시 WHERE절에 기술 했을 때와 ON 절에 기술 했을 때 결과가 다르다

--사원의 부서가 10번인 사람들만 조회 되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, e.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND e.deptno =10);

--------- ANSI VERSION -------------------------
SELECT e.empno, e.ename, e.deptno, e.mgr, e.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno =10;

SELECT e.empno, e.ename, e.deptno, e.mgr, e.ename, m.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno =10;

-----------ORACLE VERSION -------------------
 데이터가 없는 쪽에 컬럼에 (+) 기호를 붙인다
 ANSI -SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다
 WHERE 절 연결 조건에 적용
 
SELECT e.empno, e.ename, e.mgr, e.ename
FROM emp e,  emp m
WHERE e.mgr = m.empno(+);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION          -- 중복 제거
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)

SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);



SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION          -- 중복 제거
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


-------------248page outer join1 ----------------------
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b. BUY_DATE(+) = TO_DATE('2005/01/25', 'yyyy/mm/dd');


-----------ANSI VERSION -------------------
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p
ON ( b.buy_prod = p.prod_id AND b. BUY_DATE = TO_DATE('2005/01/25', 'yyyy/mm/dd') );

-----------My ----------------------
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod = p.prod_id)
UNION          -- 중복 제거
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM prod p RIGHT OUTER JOIN buyprod b ON (b.buy_prod = p.prod_id)





