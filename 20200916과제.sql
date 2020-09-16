------------- 226page --------------join6
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm,SUM(cycle.cnt)cnt
  FROM customer JOIN cycle ON(customer.cid = cycle.cid)  
                    JOIN product ON(cycle.pid = product.pid)
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;

-----------227page --------------join7
SELECT cycle.pid, product.pnm, SUM(cycle.cnt)cnt
FROM  cycle,  product 
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm;

-----------229page --------------join8
SELECT regions.region_id, regions.region_name, countries.country_name
FROM countries, regions
WHERE countries.region_id = regions.region_id
AND region_name IN 'Europe';

---------join9-------------------
SELECT r.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l
WHERE r. region_id = c. region_id AND c.country_id = l.country_id
AND region_name = 'Europe';

------------join10----------------
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM countries c, regions r, locations l, departments d
WHERE r. region_id = c. region_id
AND c.country_id = l.country_id
AND l.location_id = d.location_id
AND region_name = 'Europe';

------------join11-------------
SELECT r.region_id, r.region_name, c.country_name, l.city,
d.department_name, CONCAT(e.first_name, e.last_name) name
FROM countries c, regions r, locations l, departments d
, employees e
WHERE r. region_id = c. region_id
AND c.country_id = l.country_id
AND l.location_id = d.location_id
AND d.department_id = e.department_id 
AND region_name = 'Europe';

----------------join12-------------
SELECT e.employee_id, CONCAT(e.first_name, e.last_name) name,
j.job_id, j.job_title
FROM  employees e, jobs j
WHERE e.job_id = j.job_id;

-----------outerjoin5 -------------------                                   
SELECT p.pid, p.pnm, :cid cid, NVL(t.cnm,'brown')cnm, NVL(c.day,0)day,NVL(c.cnt,0) cnt
FROM product p, customer t, cycle c
WHERE c.pid(+) = p.pid AND c.cid = t.cid(+) AND c.cid(+)=1
AND t.cid(+) = :cid;