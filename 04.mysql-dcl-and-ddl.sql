--------------------
-- DCL and DDL
--------------------
-- root 계정으로 수행

-- 사용자 생성
CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'test';

-- 사용자 수정
ALTER USER 'testuser'@'localhost'
	IDENTIFIED BY 'abcd';
    
-- 사용자 삭제
DROP USER 'testuser'@'localhost';

-- 사용자 생성(다시)
CREATE USER 'testuser'@'localhost' 
	IDENTIFIED BY 'test';
    
-- 접속 후 계정 정보 확인
SELECT CURRENT_USER;

--------------------
-- GRANT / REVOKE
--------------------
-- 권한 (Privilege)
-- 특정 작업을 수행할 수 있는 권리

-- 권한을 부여하는 작업을 GRANT
-- 권한을 회수하는 작업을 REVOKE

SHOW GRANTS;	-- 권한의 확인
SHOW GRANTS FOR CURRENT_USER; -- 현재 유저에게 부여된 권한들
SHOW GRANTS FOR 'testuser'@'localhost'; -- 특정 유저의 권한

-- testuser에게 hrdb 스키마의 모든 테이블 조회 권한
GRANT SELECT ON hrdb.* TO 'testuser'@'localhost'; -- 권한 부여
REVOKE SELECT ON hrdb.* FROM 'testuser'@'localhost';

--------------------
-- ROLE
--------------------
DROP ROLE READER;
DROP ROLE AUTHOR;
DROP ROLE EDITOR;

-- ROLE을 활용하면 특정 권한의 묶음을 일괄적으로 적용, 회수할 수 있음
CREATE ROLE READER;	--	역할의 생성
GRANT SELECT ON hrdb.* TO READER;	--	hr스키마의 모든 객체의 SELECT 권한을 READER에게 부여

CREATE ROLE AUTHOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON hrdb.* TO AUTHOR;

CREATE ROLE EDITOR;
GRANT SELECT, UPDATE ON hrdb.* TO EDITOR;

--	ROLE에게 부여된 Grant 확인
SHOW GRANTS FOR READER;
SHOW GRANTS FOR AUTHOR;
SHOW GRANTS FOR EDITOR;

-- 권한을 묶음으로 관리할 수 있어서 편하다
GRANT READER TO 'testuser'@'localhost';
REVOKE READER FROM 'testuser'@'localhost';
GRANT AUTHOR TO 'testuser'@'localhost';

-- ROLE에 의해 부여된 권한 확인
SHOW GRANTS FOR 'testuser'@'localhost' USING READER;
SHOW GRANTS FOR 'testuser'@'localhost' USING AUTHOR;

-- ROLE 삭제
DROP ROLE READER;
DROP ROLE AUTHOR;
DROP ROLE EDITOR;

-- CREATE : DB 객체 생성 키워드
-- ALTER : DB 객체 수정 키워드
-- DROP : DB 객체 삭제 키워드

--------------------
-- DDL
--------------------
-- 데이터베이스(스키마 생성과 삭제)
CREATE DATABASE test_db;	--	기본 생성법
DROP DATABASE test_db;		--  데이터베이스 삭제

CREATE DATABASE test_db 
	DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;
    
-- 현재 선택된 데이터베이스 확인
SELECT DATABASE();

-- 데이터베이스 사용
USE test_db;
SELECT DATABASE();

-- 여기서부터는 test_user로 진행
CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON test_db.* TO 'test_user'@'localhost';
GRANT SELECT ON hrdb.* TO 'test_user'@'localhost';

-- 테이블 생성 CREATE TABLE
CREATE TABLE book (
	book_id INTEGER,
    title VARCHAR(50),
    author VARCHAR(20),
    pub_date DATETIME DEFAULT CURRENT_TIMESTAMP);
    
-- 테이블 구조 확인
DESCRIBE book;

-- 테이블 삭제
DROP TABLE book;

-- 트랜잭션 활성화
SELECT @@autocommit;	-- 1: 자동 커밋, 0: 자동 커밋 안함
SET autocommit=0;	--	자동 커밋 OFF, 트랜잭션 작동

-- Subquery를 이용한 테이블 생성
-- job_id가 FI_ACCOUNT인 모든 직원의 레코드를 새 테이블로 생성
CREATE TABLE account_employees AS (
	SELECT * FROM hrdb.employees
    WHERE job_id='FI_ACCOUNT'
);

DESC account_employees;
SELECT * FROM account_employees;

CREATE TABLE book (
	book_id INTEGER,
    title VARCHAR(50),
    author VARCHAR(20),
    pub_date DATETIME DEFAULT CURRENT_TIMESTAMP);
    
    
-- 테이블 변경 ALTER TABLE
-- 컬럼 추가 (ADD)
ALTER TABLE book ADD (pubs VARCHAR(50));
DESC book;

-- 컬럼 변경 (MODIFY)
ALTER TABLE book MODIFY title VARCHAR(100);
DESC book;

-- 컬럼 삭제 (DROP)
ALTER TABLE book DROP author;
DESC book;

-- 컬럼 코멘트
ALTER TABLE book MODIFY title VARCHAR(100) COMMENT '도서 제목';
DESC book;
SHOW CREATE TABLE book;

-- RENAME
RENAME TABLE book TO article;

-- 주요 제약 조건(Constraints)
CREATE TABLE book (
	book_id INTEGER NOT NULL);	
INSERT INTO book VALUES(1);
INSERT INTO book VALUES(NULL);
-- NOT NULL : 컬럼 레벨 제약 조건

DROP TABLE book;
-- UNIQUE
CREATE TABLE book (
	book_id INTEGER,
    UNIQUE(book_id));
    
INSERT INTO book VALUES(1);
INSERT INTO book VALUES(2);
INSERT INTO book VALUES(2);	-- ERROR
-- UNIQUE : 유일한 값, 테이블 레벨, 인덱스 자동 부여
DROP TABLE book;

-- PK
CREATE TABLE book (
	book_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    book_title VARCHAR(100));
    
INSERT INTO book (book_title) VALUES ('홍길동전');
INSERT INTO book (book_title) VALUES ('전우치전');
INSERT INTO book (book_title) VALUES ('춘향전');

SELECT * FROM book;
-- PRIMARY KEY : NOT NULL + UNIQUE -> 자동 인덱스
DROP TABLE book;

-- CHECK
CREATE TABLE book (
	rate INTEGER CHECK (rate IN (1, 2, 3, 4, 5))
);

INSERT INTO book VALUES(1);
INSERT INTO book VALUES(6);	-- Error: 체크 조건에 위배

DROP TABLE book;

-- 제약조건 포함 book 테이블 생성
CREATE TABLE book (
	book_id INTEGER PRIMARY KEY AUTO_INCREMENT COMMENT '도서 아이디',
    book_title VARCHAR(50) NOT NULL COMMENT '도서 제목',
    author VARCHAR(20) NOT NULL COMMENT '작가명',
    rate INTEGER CHECK (rate IN (1, 2, 3, 4, 5)) COMMENT '별점',
    pub_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '출간일')
    COMMENT '도서 정보';
    
-- AUTHOR 테이블 생성
CREATE TABLE author (
	author_id INTEGER PRIMARY KEY COMMENT '작가 아이디',
    author_name VARCHAR(100) NOT NULL COMMENT '작가 이름',
    author_desc VARCHAR(256) COMMENT '작가 설명')
    COMMENT '작가 정보';
    
-- book 테이블의 author 컬럼 삭제
-- -> author_id (FK) -> author.author_id 참조
ALTER TABLE book DROP author;

-- book 테이블의 book_title 뒤에 author_id 추가
ALTER TABLE book ADD author_id INTEGER AFTER book_title;

-- FOREIGN KEY 추가
ALTER TABLE book ADD CONSTRAINT c_book_fk
	FOREIGN KEY (author_id) REFERENCES author(author_id)
		ON DELETE SET NULL;
        
SHOW CREATE TABLE book;

DROP TABLE book;

-- 테이블 생성 시점에 Constraints 부여
CREATE TABLE book (
	book_id INTEGER PRIMARY KEY COMMENT '도서 아이디',
    book_title VARCHAR(50) NOT NULL COMMENT '도서 제목',
    author_id INTEGER COMMENT '작가 테이블 참조',
    rate INTEGER CHECK(rate IN (1, 2, 3, 4, 5)) COMMENT '별점',
    pub_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '출간일',
    FOREIGN KEY (author_id) REFERENCES
		author(author_id) ON DELETE SET NULL
) COMMENT '도서 정보';

DROP TABLE author;

-- AUTHOR 테이블 생성
CREATE TABLE author (
	author_id INTEGER PRIMARY KEY AUTO_INCREMENT COMMENT '작가 아이디',
    author_name VARCHAR(100) NOT NULL COMMENT '작가 이름',
    author_desc VARCHAR(256) COMMENT '작가 설명',
    regdate DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작가 정보 등록일')
    COMMENT '작가 정보';