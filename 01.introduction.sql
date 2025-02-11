-- 이것은 SQL 주석입니다.
-- 기본적인 확인
SHOW DATABASES;	-- 현재 접근 가능한 스키마 목록
-- or
SHOW SCHEMAS;

USE hrdb;	-- HRDB를 사용하겠음

-- 현재 사용중인 USER는?
SELECT USER();
-- 현재 사용중인 데이터베이스 확인
SELECT DATABASE();

-- 현재 스키마에 있는 테이블 목록
SHOW TABLES;

-- employees 테이블 구조 확인
DESCRIBE employees;

-- 서비스에서 root 사용은 위험
-- root 계정은 전체 DB의 모든 권한을 가지고 있어서
-- 가급적 개별 서비스 계정을 만들어서 데이터베이스에 
-- 적절한 접근 권한을 부여하여 제어해야 한다.

-- 로컬 호스트의 hrdb 계정 생성
CREATE USER 'hrdb'@'localhost' IDENTIFIED BY 'hrdb';

-- 데이터베이스 접근 권한 부여
GRANT all privileges ON hrdb.* TO 'hrdb'@'localhost';

-- 새로 Workbench Connection을 만들어 접속