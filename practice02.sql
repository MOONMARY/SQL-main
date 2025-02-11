-- Practice02. Aggragation
/*
문제1.
매니저가있는 직원은 몇 명입니까 ? 아래의 결과가 나오도록 쿼리문을 작성하세요
(106명)
*/
SELECT COUNT(*) haveMngCnt
FROM employees 
WHERE manager_id IS NOT NULL;

-- 집계함수는 NULL을 제외하고 집계
SELECT COUNT(manager_id) haveMngCnt
FROM employees;


/*
문제2.
직원중에
최고임금(salary)과 최저임금을 최고임금 , 최저임금 으로 출력해 보세요.
두 임금의 차이는 얼마인가요 ? "최고임금-최저임금"이란 타이틀로 함께 출력해 보세요
*/
SELECT MAX(salary) 최고임금,
		MIN(salary) 최저임금,
        MAX(salary) - MIN(salary) "최고임금-최저임금"
FROM employees;

/*
문제3.
마지막으로 신입사원이 들어온 날은 언제 입니까 ? 다음 형식으로 출력해주세요
예) 2014년 07월 10일
*/

SELECT DATE_FORMAT(MAX(hire_date), "%Y년 %m월 %d일")
FROM employees;


/*
문제4.
부서별로 
평균임금, 최고임금, 최저임금을 부서 아이디(department_id) 와 함께 출력합니다
정렬순서는 부서번호 (department_id) 내림차순입니다
*/
SELECT department_id,
	AVG(salary) 평균임금, 
    MAX(salary) 최고임금, MIN(salary) 최저임금
FROM employees
GROUP BY department_id
ORDER BY department_id DESC;

/*
문제5.
업무(job_id)별로 
평균임금, 최고임금, 최저임금을 업무아이디(job_id) 와 함께 출력하고 
정렬 순서는 최저임금 내림차순, 평균임금(소수점 반올림) 오름차순 순 입니다
(정렬순서는 최소임금 2500 구간일때 확인해볼 것)
*/
SELECT job_id,
		MAX(salary) 최고임금,
        MIN(salary) 최저임금,
		ROUND(AVG(salary), 0) 평균임금
FROM employees
GROUP BY job_id
ORDER BY MIN(salary) DESC, AVG(salary) ASC;
        


/*
문제6.
가장 오래 근속한 직원의 입사일은 언제인가요? 다음 형식으로 출력해주세요
예) 2005-08-20 Saturday
*/
SELECT DATE_FORMAT(MIN(hire_date), '%Y-%m-%d %W')  
FROM employees;

/*
문제7.
평균임금과 최저임금의 차이가 2000 미만인 
부서(department_id), 평균임금, 최저임금 그리고 
(평균임금-최저임금)를
(평균임금-최저임금)의 내림차순으로 정렬해서
 출력하세요
*/
SELECT department_id,
	AVG(salary) 평균임금,
    MIN(salary) 최저임금,
    AVG(salary) - MIN(salary) "평균임금-최저임금"
FROM employees
GROUP BY department_id
	HAVING AVG(salary) - MIN(salary) < 2000
ORDER BY AVG(salary) - MIN(salary) DESC;


/*
문제8.
업무(JOBS)별로 최고임금과 최저임금의 차이를 출력해보세요
차이를 확인할 수 있도록 내림차순으로 정렬하세요
*/
SELECT job_id,
	MAX(salary) - MIN(salary) diff_salary
FROM employees
GROUP BY job_id
ORDER BY diff_salary DESC;

/*
문제9.
2005년 이후 입사자중 
관리자별로 
평균급여 최소급여 최대급여를 알아보려고 한다
출력은 관리자별로 평균급여가 5000 이상 중에 
평균급여 최소급여 최대급여를 출력합니다
평균급여의 내림차순으로 정렬하고 
	평균급여는 소수점 첫째짜리에서 반올림 하여 출력합니다
매니저아이디는 manager_id 
	평균급여는 avg, 
    최대급여는 max, 
    최소급여는 min 으로 출력합니다
*/
SELECT manager_id, ROUND(AVG(salary), 0) avg,
	MIN(salary) min, MAX(salary) max
FROM employees
WHERE hire_date > '2005-01-01'
GROUP BY manager_id
	HAVING AVG(salary) >= 5000
ORDER BY AVG(salary) DESC;
    



/*
문제10.
아래회사는 보너스 지급을 위해 직원을 입사일 기준으로 나누려고 합니다.
	입사일이 02/12/31 일 이전이면 '창립맴버', 
    03년은 '03년입사', 
    04년은 '04년입사'
	이후입사자는 '상장이후입사' optDate 컬럼의 데이터로 출력하세요
정렬은 입사일로 오름차순으로 정렬합니다
*/
SELECT CONCAT(first_name, ' ', last_name) 이름,
	hire_date 입사일,
    CASE
		WHEN hire_date < '2002-12-31' THEN '창립멤버'
        WHEN hire_date BETWEEN '2003-01-01' 
				AND '2003-12-31' THEN '03년 입사'
		WHEN hire_date BETWEEN '2003-01-01'
				AND '2004-12-31' THEN '04년 입사'
		ELSE '상장이후입사'
	END AS optDate
FROM employees
ORDER BY hire_date;
-- CASE ~ WHEN ~ ELSE 문

/*
문제11. 필요한 함수를 검색 하고 사용법을 주석으로 남겨두세요
가장 오래 근속한 직원의 입사일은 언제인가요 ? 다음 형식으로 출력해주세요
예) 2005 년 08 월 20 일 토요일
*/
-- 환경 변수 : 소프트웨어가 실행될 때 로딩되는 실행을 위한 데이터
-- lc_ -> Locale 정보
SHOW VARIABLES;	--	환경 변수 확인

SET lc_time_names = 'ko_KR';	-- 세션 환경 변수
SET GLOBAL lc_time_names = 'ko_KR';	--	글로벌 환경 변수

SHOW VARIABLES LIKE 'lc_time_names'; -- 확인

SELECT DATE_FORMAT(MIN(hire_date), '%Y년 %m월 %d일 %W')
	AS "가장 오래 근속한 직원의 입사일"
FROM employees;
/*
https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html#function_date-format
%Y : Year
%m : Month (00..12)
%d : Day of the Month (00..31)
%W : Weekday name (Sunday..Saturday)
