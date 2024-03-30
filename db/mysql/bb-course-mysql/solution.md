# Practice Solution

## Chapter 7

```sql
-- Q1
SELECT e.ename, e.deptno, d.dname, d.loc  FROM emp e LEFT OUTER JOIN dept d ON e.deptno = d.deptno;

-- Q2
SELECT e.ename, e.comm, d.dname, d.loc FROM emp e LEFT OUTER JOIN dept d ON e.deptno = d.deptno WHERE comm > 0;

-- Q3
SELECT e.ename, d.dname FROM emp e JOIN dept d ON e.deptno = d.deptno WHERE e.ename LIKE '%A%';

-- Q4
SELECT e.ename, e.job, d.deptno, d.dname FROM dept d JOIN emp e ON d.deptno = e.deptno WHERE d.loc = 'DALLAS';

-- Q5
SELECT e.ename 'Employee', e.empno 'Emp#', e.mgr 'Manager', m.ename 'Mgr#' FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno;

-- Q6
SELECT e.ename, e.job, d.dname, e.sal, s.grade FROM emp e LEFT OUTER JOIN dept d ON e.deptno = d.deptno LEFT OUTER JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal) ORDER BY e.sal, e.ename;

-- Q7
SELECT e.ename 'Employee', e.hiredate 'Emp Hiredate', m.ename 'Manager', m.hiredate 'Mgr Hiredate' FROM emp e JOIN emp m ON e.mgr = m.empno WHERE e.hiredate < m.hiredate;

-- Q8
SELECT d.dname 'dname', d.loc 'loc', count(*) 'Number of People', round(avg(e.sal),2) 'Salary' FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno GROUP BY d.dname, d.loc ORDER BY d.dname;

```


## Chapter 8

```sql
-- Q1
SELECT ename, hiredate FROM emp WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'Blake') ORDER BY ename;

-- Q2
SELECT ename, hiredate FROM emp WHERE hiredate > (SELECT hiredate FROM emp WHERE ename = 'Blake') ORDER BY hiredate;

-- Q3
SELECT empno, ename, sal FROM emp where sal > (SELECT AVG(sal) FROM emp) ORDER BY sal DESC;

-- Q4
SELECT e.EMPNO, e.ENAME FROM emp e WHERE e.DEPTNO IN (SELECT e2.DEPTNO FROM emp e2 WHERE e2.ENAME LIKE '%T%') AND e.ENAME LIKE '%T%';

-- Q5
SELECT ename, deptno, job FROM emp WHERE deptno = (SELECT deptno FROM dept WHERE loc = 'DALLAS');

-- Q6
SELECT ename, sal FROM emp WHERE mgr =(SELECT empno FROM emp WHERE ename = 'KING');

-- Q7
SELECT deptno, ename, job FROM emp WHERE deptno =(SELECT deptno FROM dept WHERE dname = 'SALES');

-- Q8


-- Q9


-- Q10


-- Q11


-- Q12


```


# 效能比較 - 查 order資料表內，最近與我下單的所有客戶

## 1. Correlated subqueries 效能差

```sql
SELECT custid, ordid, orderdate
FROM ord o
WHERE orderdate = 
    (
        SELECT MAX(orderdate) 
        FROM ord i
        WHERE i.custid = o.custid
    )
ORDER BY custid;
```


## 2.1. Subquery + Join方法 改寫

```sql
-- SELF-contained + Join

SELECT o.custid, o.ordid, o.orderdate
FROM ord o JOIN (
        SELECT custid, MAX(orderdate) LastOrder
        FROM ord 
        GROUP BY custid
    ) i 
    ON (o.custid = i.custid)
WHERE o.orderdate = i.LastOrder
ORDER BY custid;
```


## 2.2. Subquery + Join方法 改寫

```sql
-- SELF-contained + Join

SELECT o.custid, o.ordid, o.orderdate
FROM ord o JOIN (
        SELECT custid, MAX(orderdate) LastOrder
        FROM ord 
        GROUP BY custid
    ) i 
    ON (o.custid = i.custid AND o.orderdate = i.LastOrder)
ORDER BY custid;
```


### 3. Table-valued Subquery

```sql
-- Self-Subquery
-- Oracle、MySQL5.6後可，但是SQL Server無法下multi-column subquery (相容性較差) - (2018 當時, 但現在不曉得能否)

SELECT custid, ordid, orderdate
FROM ord
WHERE (custid, orderdate) in (
        SELECT custid, MAX(orderdate)
        FROM ord
        group by custid
    )
ORDER BY custid;
```
