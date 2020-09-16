SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);

본인 속한 부서의 급여 평균보다 높은 급여를 받는 사람들 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp
                    WHERE deptno = emp.deptno);

sub4
테스트용 데이터 추가
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

SELECT*
FROM dept
WHERE deptno  IN (99, 40) 
---------sub4----------------------
SELECT*
FROM dept
WHERE deptno  NOT IN (SELECT deptno FROM emp); 

------------sub5---------------
SELECT*
FROM product
WHERE pid NOT IN (100, 400);

SELECT*
FROM product
WHERE pid NOT IN ( SELECT pid
                            FROM cycle 
                            WHERE cid = 1);
                            
   
 -------------sub6 -------------------
 SELECT *
 FROM cycle
 WHERE cid = 1
 AND pid IN( SELECT pid
                       FROM cycle
                       WHERE cid =2);
 
 
 AND cid IN (1,2)
 AND pid = '100';
 
 
 
 
 
 
