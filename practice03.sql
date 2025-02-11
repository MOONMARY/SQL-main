-- Practice03. JOIN
USE hrdb;
/*
문제1.
직원들의 사번 (employee_id), 이름 (firt_name), 
	성 (last_name) 과 부서명 (department_name) 을
조회하여 부서이름 (department_name) 오름차순 , 
	사번 (employee_id) 내림차순 으로 정렬하세요
(106건)
*/
SELECT emp.employee_id AS 사번,
	emp.first_name AS 이름,
    emp.last_name AS 성,
    dept.department_name AS 부서명
FROM employees AS emp INNER JOIN departments AS dept
		ON emp.department_id = dept.department_id
ORDER BY dept.department_name, emp.employee_id DESC;


/*
문제2.
employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다
직원들의 사번 (employee_id), 이름 (first_name), 
	월급 (salary), 부서명 (department_name),
	현재업무 (job_title) 를 
사번 (employee_id) 오름차순 으로 정렬하세요
부서가 없는 Kimberely(사번 178) 은 표시하지 않습니다
(106건)
*/
SELECT emp.employee_id, emp.first_name,
	emp.salary, dept.department_name, emp.job_id,
    j.job_title
FROM employees emp INNER JOIN departments dept
	ON emp.department_id = dept.department_id
		INNER JOIN jobs j
			ON emp.job_id = j.job_id
ORDER BY emp.employee_id;


/*
문제2-1.
문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요
(107건)
*/
SELECT emp.employee_id, emp.first_name,
	emp.salary, dept.department_name, emp.job_id,
    j.job_title
FROM employees emp LEFT JOIN departments dept
	ON emp.department_id = dept.department_id
		INNER JOIN jobs j
			ON emp.job_id = j.job_id
ORDER BY emp.employee_id;



/*
문제3.
도시별로 위치한 부서들을 파악하려고 합니다
도시아이디, 도시명, 부서명, 부서아이디를 
도시아이디 오름차순으로 정렬하여 출력하세요
부서가 없는 도시는 표시하지 않습니다
(27건)
*/
SELECT loc.location_id,
		loc.city,
        dept.department_name,
        dept.department_id
FROM locations loc INNER JOIN departments dept
	ON loc.location_id = dept.location_id
ORDER BY loc.location_id;


/*
문제3-1.
문제3에서 부서가 없는 도시도 표시합니다
(43건)
*/
SELECT loc.location_id,
		loc.city,
        dept.department_name,
        dept.department_id
FROM locations loc LEFT JOIN departments dept
	ON loc.location_id = dept.location_id
ORDER BY loc.location_id;


/*
문제4.
지역(regions)에 속한 나라들을 
	지역이름 (region_name), 
    나라이름 (country_name) 으로 출력하되 
지역이름 (오름차순), 나라이름 (내림차순) 으로 정렬하세요
(25건)
*/
SELECT reg.region_name 지역이름,
		cou.country_name 나라이름
FROM regions reg INNER JOIN countries cou
	ON reg.region_id = cou.region_id
ORDER BY reg.region_name, cou.country_name DESC;

/*
문제5.
자신의 매니저보다 채용일 (hire_date)이 빠른 사원의
사번 (employee_id), 이름 (first_name) 과 
	채용일 (hire_date), 
	매니저이름 (first_name), 매니저입사일 (hire_date) 을 조회하세요
(37건)
*/
SELECT emp.employee_id 사번,
	emp.first_name 이름,
    emp.hire_date 채용일,
    man.first_name 매니저이름,
    man.hire_date 매니저입사일
FROM employees emp INNER JOIN employees man
	ON emp.manager_id = man.employee_id
WHERE emp.hire_date < man.hire_date;


/*
문제6.
나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다
나라명, 나라아이디, 
도시명, 도시아이디, 
부서명, 부서아이디를 
나라명 오름차순으로 정렬하여 출력하세요
값이 없는 경우 표시하지 않습니다
(27건)
*/
SELECT cou.country_name,
		cou.country_id,
        loc.city,
        loc.location_id,
        dept.department_name,
        dept.department_id
FROM countries cou
	INNER JOIN locations loc
		ON cou.country_id = loc.country_id
			INNER JOIN departments dept
				ON loc.location_id = dept.location_id
ORDER BY cou.country_name;


/*
문제7.
job_history
테이블은 과거의 담당업무의 데이터를 가지고 있다
과거의 업무아이디 (job_id)가 'AC_ACCOUNT'로 근무한 사원의 
사번, 이름(풀네임), 
업무아이디, 시작일, 종료일을 출력하세요
이름은 first_name과 last_name을 합쳐 출력합니다
(2건)
*/
SELECT emp.employee_id 사번,
	CONCAT(first_name, ' ', last_name) 이름,
    jh.job_id 업무아이디,
    jh.start_date 시작일,
    jh.end_date 종료일
FROM employees emp
	INNER JOIN job_history jh
		ON emp.employee_id = jh.employee_id
WHERE jh.job_id = 'AC_ACCOUNT';


/*
문제8.
각 부서 (department)에 대해서 
	부서번호 (department_id), 부서이름 (department_name), 
	매니저(manager)의 이름 (first_name), 
    위치 (locations) 한 도시 (city), 
    나라 (countries) 의 이름 (country_name) 그리고 
    지역구분 (regions) 의 이름 (region_name) 까지 전부 출력해 보세요
(11건)
*/
SELECT dept.department_id 부서번호,
		dept.department_name 부서이름,
        emp.first_name 매니저이름,
        loc.city 위치한도시,
        cou.country_name 나라이름,
        reg.region_name 지역명
FROM departments dept,
	employees emp,
    locations loc,
    countries cou,
    regions reg
WHERE dept.manager_id = emp.employee_id AND
	dept.location_id = loc.location_id AND
    loc.country_id = cou.country_id AND
    cou.region_id = reg.region_id
ORDER BY dept.department_id ASC;


/*
문제9.
각 사원 (employee)에 대해서 
	사번 (employee_id), 이름 (first_name), 
    부서명(department_name), 
	매니저 (manager)의 이름 (first_name) 을 조회하세요
부서가 없는 직원 (Kimberely)도 표시합니다
매니저가 없는 Steven 도 표시합니다
(107 명)
*/
SELECT emp.employee_id 사번,
		emp.first_name 이름,
        dept.department_name 부서명,
        man.first_name 매니저이름
FROM employees emp
	LEFT JOIN departments dept
		ON emp.department_id = dept.department_id
	LEFT JOIN employees man
		ON emp.manager_id = man.employee_id;

/*
문제9-1.
문제9에서 부서가 없는 직원 (Kimberly) 도 표시 하고
매니저가 없는 Steven은 표시하지 않습니다
(106 명)
*/
SELECT emp.employee_id 사번,
		emp.first_name 이름,
        dept.department_name 부서명,
        man.first_name 매니저이름
FROM employees emp
	LEFT JOIN departments dept
		ON emp.department_id = dept.department_id
	INNER JOIN employees man
		ON emp.manager_id = man.employee_id;
        
/*
문제9-2.
문제9 에서 부서가 없는 직원 (Kimberly) 도 표시 하지 않고
매니저가 없는 Steven 도 표시하지 않습니다
(105 명)
*/
SELECT emp.employee_id 사번,
		emp.first_name 이름,
        dept.department_name 부서명,
        man.first_name 매니저이름
FROM employees emp
	INNER JOIN departments dept
		ON emp.department_id = dept.department_id
	INNER JOIN employees man
		ON emp.manager_id = man.employee_id
ORDER BY emp.employee_id;
        
