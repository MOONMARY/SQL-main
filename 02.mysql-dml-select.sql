-- DML - SELECT
USE hrdb;
SELECT USER();
SELECT DATABASE();	--	선택된 DB 확인

-------------------
-- SELECT ~ FROM
-------------------
-- 테이블 구조 확인
DESCRIBE employees;
DESCRIBE departments;

-- 가장 기본적인 SELECT의 형태: 전체 데이터(모든 컬럼, 모든 레코드)
SELECT * FROM employees; -- 107 rows
SELECT * FROM departments; -- 27 rows
-- 테이블 내 정의된 모든 컬럼을 Projection
-- 순서는 테이블을 작성할 때 정의한 순서를 따른다

-- 특정 컬럼만 선별적으로 Projection 할 수 있다.
SELECT first_name FROM employees;
SELECT first_name, salary FROM employees;
-- Alias (별칭)
SELECT first_name 이름, salary 월급 FROM employees;
SELECT first_name AS 이름, salary AS 월급 FROM employees;

/*
연습문제
사원의 이름 (first_name), 전화번호, 입사일, 급여를 출력해 봅시다
*/
SELECT first_name, phone_number, hire_date, salary
FROM employees;
/*
연습문제
사원의 이름 (first_name), 성(last_name), 급여, 
	전화번호, 입사일을 출력해 봅시다
*/
SELECT first_name, last_name, salary,
	phone_number, hire_date
FROM employees;

-- 산술연산 : 기본적인 산술 연산을 사용할 수 있다.
SELECT 3.14159 * 10 * 10 FROM dual;
-- 특정 테이블이 아니라 데이터베이스 자체에 문의할 경우 DUAL
-- 특정 필드의 값을 수치로 산술 계산을 할 수 있음
SELECT first_name, salary, salary * 12 AS 연봉
FROM employees;

-- NULL
-- 비어있는 데이터
-- 어떠한 타입에서도 사용할 수 있다.
-- NOT NULL 컬럼, PK 컬럼에서는 사용할 수 없다.
SELECT first_name, salary, salary * NULL 
FROM employees;
-- NULL이 포함된 산술식의 결과는 항상 NULL
SELECT salary, ISNULL(salary * NULL)
FROM employees;
SELECT salary, NOT ISNULL(salary * NULL)
FROM employees;

-- 
SELECT first_name, salary, salary * 12 AS 연봉
FROM employees;
-- 커미션까지 포함한 최종 급여
SELECT first_name, salary, commission_pct,
	salary + salary * commission_pct 최종급여
FROM employees;

-- COALESCE or IFNULL
-- COALESCE (ANSI-SQL) : 주어진 인수 중, NULL이 아닌 첫 값
SELECT coalesce(NULL, NULL, "A", "B");

-- IFNULL (MySQL) : 두개의 인수 중 첫 값이 NULL이면 두번째 값

SELECT IFNULL(NULL, "대체값");

SELECT first_name,
	salary, commission_pct,
    salary + salary * IFNULL(commission_pct, 0)
FROM employees;

SELECT first_name,
	salary, commission_pct,
    salary + salary * COALESCE(commission_pct, 0)
FROM employees;

-- FULL Name과 salary
SELECT first_name + " " + last_name, salary
FROM employees;
-- 문자열을 합칠때는 concat 함수를 사용
SELECT CONCAT(first_name, " ", last_name) AS 이름
FROM employees;

-- DISTINCT
SELECT job_id FROM employees;	-- 107개
SELECT DISTINCT job_id FROM employees; -- 19개

------------------
-- WHERE
------------------
-- SELECTION을 위한 조건

-- 부서 번호가 10번이 부서 정보
SELECT * FROM departments;

SELECT * FROM departments
WHERE department_id = 10;

-- 급여가 15000이상인 사원의 목록을 출력
SELECT * FROM employees
WHERE salary >= 15000;

-- 입사일이 2008-01-01 이후인 사원들의 이름과 입사일을 출력
SELECT CONCAT(first_name, ' ', last_name) AS name,
	hire_date AS "입사일"
FROM employees
WHERE hire_date > '2008-01-01';

-- 급여가 10000미만이거나 17000초과인 사원의 이름과 급여
SELECT CONCAT(first_name, ' ', last_name) AS name,
	salary
FROM employees
WHERE salary < 10000 OR
	salary > 17000;
    
-- 급여가 10000이상이고 17000이하인 사원의 이름과 급여
SELECT CONCAT(first_name, ' ', last_name) AS name,
	salary
FROM employees
WHERE salary >= 10000 AND
	salary <= 17000;
-- BETWEEN 연산자
SELECT CONCAT(first_name, ' ', last_name) AS name,
	salary
FROM employees
WHERE salary BETWEEN 10000 AND 17000;

-- IN 연산자 
-- 10, 20, 30번 부서에 소속된 직원 정보
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id = 10 OR
	department_id = 20 OR
    department_id = 30;
    
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id IN (10, 20, 30);

-- 10, 20, 30부서가 아닌 부서에 소속된 직원들
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id <> 10 AND
	department_id != 20 AND
    department_id <> 30;
    
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id NOT IN (10, 20, 30);

-- WHERE 절에서 null 체크
-- IS NULL로 체크
-- = null 불가
SELECT first_name, commission_pct
FROM employees
WHERE commission_pct IS NULL;	-- = null로 하면 안됨

SELECT first_name, commission_pct
FROM employees
WHERE commission_pct = NULL;	-- 잘못된 NULL 체크

--------------------
-- LIKE 
--------------------
-- 부분 문자열 검색
-- Wildcard
-- % : 정해지지 않은 길이의 문자열
-- _ : 문자 1개

-- 이름에 am을 포함한 사원의 이름과 급여
SELECT first_name, salary
FROM employees
WHERE LOWER(first_name) LIKE "%am%";

-- 이름의 두번째 글자가 a인 사원의 이름과 급여
SELECT first_name, salary
FROM employees
WHERE LOWER(first_name) LIKE "_a%";

--------------------
-- ORDER BY
--------------------

-- 부서 번호를 오름차순으로 정렬하고 이름, 부서번호, 급여 출력
SELECT first_name, department_id, salary
FROM employees
ORDER BY department_id ASC;	-- ASC는 생략 가능(기본값)

-- 정렬 기준은 여러 컬럼에 지정할 수 있음
SELECT * FROM employees
ORDER BY first_name, hire_date DESC LIMIT 10;

-- 급여가 15000 이하인 직원들 중에서 목록을 급여의 내림차순으로 출력
SELECT * FROM employees
WHERE salary <= 15000
ORDER BY salary DESC;

-- 부서 번호를 오름차순으로 정렬하고
-- 같은 부서 사람들은 급여가 높은 사람부터 
-- 이름, 부서번호, 급여 출력
SELECT first_name, department_id, salary
FROM employees
ORDER BY department_id, salary DESC;

--------------------
-- 문자열 단일행 함수
--------------------
SELECT first_name, last_name,
	CONCAT(first_name, ' ', last_name),
    LOWER(first_name), LCASE(first_name),
    UPPER(first_name), UCASE(first_name)
FROM employees;

SELECT '    MySQL    ',
	"*****Database****"
FROM DUAL;

SELECT LTRIM('     MySQL     ') AS "LTRIM",
	RTRIM('     MySQL     ') AS "RTRIM",
    TRIM(BOTH '*' FROM "*****Database****") AS "TRIM",
    TRIM(LEADING '*' FROM "*****Database****")
		AS 'LEADING TRIM',
	TRIM(TRAILING '*' FROM "*****Database****")
		AS 'TRAILING TRIM'
FROM DUAL;

SELECT "Oracle Database",
	LENGTH("Oracle Database"),	-- 1 Base
    SUBSTRING("Oracle Database", 8, 4),
    SUBSTRING("Oracle Database", -8, 8) --	음수 인덱싱
FROM DUAL;

SELECT
	REPLACE("Sad Day", "Sad", "Happy"),
    LPAD(first_name, 20, '*'),
    RPAD(first_name, 20, '*')
FROM employees;

--------------------
-- 수치형 단일행 함수
--------------------
SELECT ABS(-3.14),	-- 절대값
	CEILING(3.14),	-- 소수점을 올림 (천정)
    FLOOR(3.14),	-- 소수점을 버림 (바닥)
    MOD(7, 3),		-- 나눗셈의 나머지
    POWER(2,4),		--	제곱
    ROUND(3.5),		--	반올림
    ROUND(3.56, 1),	--	반올림 (소수점 1자리까지)
    TRUNCATE(3.56, 1)	--	내림 (소수점 1자리까지)
FROM dual;

SELECT SIGN(-10),
	SIGN(0),
    SIGN(10),
    GREATEST(2, 1, 0),
    GREATEST(4.0, 5.0, 3.0),
    GREATEST('B', 'A', 'C'),
    LEAST(2, 1, 0),
    LEAST(4.0, 5.0, 3.0),
    LEAST('B', 'A', 'C')
FROM DUAL;

--------------------
-- 날짜형 단일행 함수
--------------------

SELECT CURDATE(), CURRENT_DATE,
	CURTIME(), CURRENT_TIME,
    CURRENT_TIMESTAMP,
    NOW(), SYSDATE()
FROM DUAL;

-- EXTRACT 함수: 날짜 혹은 시간에서 특정 요소 추출
SELECT EXTRACT(YEAR FROM '2024-11-18') FROM DUAL;

-- 모든 직원들의 입사년도 조회
SELECT first_name, 
	hire_date, 
	EXTRACT(YEAR FROM hire_date) AS 입사년도
FROM employees;

-- 2008년 이후 입사한 직원 목록 출력
SELECT first_name, hire_date,
	EXTRACT(YEAR FROM hire_date) AS hire_year
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) >= 2008;

-- DATE_FORMAT : 날짜 출력 형식 지정
SELECT DATE_FORMAT(CURDATE(), '%W %M %Y'),
	DATE_FORMAT(CURDATE(), '%Y. %m. %d')
FROM DUAL;

-- PERIOD_DIFF : 두 날짜 정보 사이의 간격값을 반환
-- 직원들이 지금까지 몇 개월 근속했는가?
SELECT first_name,
	DATE_FORMAT(CURDATE(), '%Y%m') AS 현재시간,
    DATE_FORMAT(hire_date, '%Y%m') AS 입사일,
    PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), 
				DATE_FORMAT(hire_date, '%Y%m')) 
                AS 근속월수
FROM employees;

-- DATE_ADD, DATE_SUB : 특정 간격을 더하거나 뺄 수 있다
SELECT first_name, hire_date,
	DATE_ADD(hire_date, INTERVAL 1 YEAR),
    DATE_SUB(hire_date, INTERVAL 1 YEAR)
FROM employees;

-- CAST : 변환
SELECT CAST(now() AS DATE);
SELECT CAST("123" AS UNSIGNED);	--	문자열 -> unsigned int

-- CONVER 함수로 대신할 수 있음
SELECT CONVERT(now(), DATE) FROM DUAL;
SELECT CONVERT("123", UNSIGNED) FROM DUAL;