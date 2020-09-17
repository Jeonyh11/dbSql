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
 
 2항 연산자 : 1+2
 3항 연산자 int a =b ==
 
 EXISTS 연산자 : 조건을 만족하는 서브 쿼리의 행이 존재하면 TRUE
 
 SELECT *
 FROM emp e
 WHERE EXISTS (SELECT 'X'  --EXISTS 연산자는 컬럼 표현을 'X' 한다    
                    FROM emp m
                    WHERE e.mgr = m.empno);
 
 SELECT*
 FROM emp  JOIN ON emp  (a.empno = b.mgr);
 
 -----sub9 4개 제품중 1번 고객이 먹는 제품만 조회
 SELECT*
 FROM product 
 WHERE EXISTS (SELECT *
                      FROM cycle 
                      WHERE  cid = 1
                      AND pid = product.pid );
 
  SELECT*
 FROM product 
 WHERE EXISTS (SELECT *
                      FROM cycle 
                      WHERE  cid = 1
                      AND pid = 200 );
                      
 -----sub10 4개 제품중 1번 고객이 먹지 않는제품만 조회
  SELECT*
 FROM product 
 WHERE NOT EXISTS (SELECT *
                      FROM cycle 
                      WHERE  cid = 1
                      AND pid = product.pid );
 
 집합 연산자 : 알아두자
 수학의 집합 연산
 A = {1,3,5}
 B = {1,4,5}

합집합 A U B = {1,3,4,5}         교환법칙 성립            A U B = B U A
교집합 A n B = {1,5}         교환법칙 성립            A n B = B n A
차집합 A -B = {3}         교환법칙 성립하지 않음            A - B != B - A = {4}

--SQL에서의 집합 연산자
합집합 : UNION  : 수학적 합집합과 개념이 동일(중복 허용하지 않음) 
                        중복을 체크 ==> 두 집합에서 중복된 값을 확인 ==> 연산이 느림
          UNION ALL : 수학적 합집합 개념을 떠나 두개의 집합을 단순히 합친다.(중복 데이터 존재가능)
                           중복 체크 없음 -> 중복된 값 확인 없음 -> 연산이 빠름
                           개발자가 두개의 집합에 중복이 없다는 것을 안다면 UNION 연산자보다 UNION ALL을 사용하여 연산을 절약한다.
        INTERSECT : 수학적 교집합 개념과 동일
        MINUS : 수학적 차집합 개념과 동일
        
--위아래 집합이 동일 하기 때문에 합집합을 하더라도 행이 추가되지 않는다
SELECT empno, ename
FROM emp
WHERE deptno =10
UNION 
SELECT empno, ename
FROM emp
WHERE deptno =10;          

--위아래 집합이 7369번 사번은 중복되므로 한번만 나온다
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION 
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782) ;
          
--중복이 제거 되지 않는다        
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)  ;

 --두 집합의 공통된 부분은 7369행 밖에 없음
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)  ;


--위 집합에서 아래 집합의 행을 제거하고 남는 행 (7566)
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)  ;

집합 연산자 특징
1. 컬럼명은 첫번째 집합의 컬럼명을 따라간다.
2. ORDER BY 절은 마지막 집합에 적용한다.
    마지막 sql이 아닌 SQL에서 정렬을 사용하고 싶은 경우 INLINE - VIEW 를 활용
    UNION ALL 의 경우 위, 아래 집합을 이어 주기 때문에 집합의 순서를 그대로 유지 하기 때문에
    요구사항에 따라 정렬된 데이터 집합이 필요하다면 해당 방법을 고려
    
SELECT empno e, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782) 
ORDER BY ename;
