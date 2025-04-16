use ksy;
-- member 테이블 생성
CREATE TABLE `ksy`.`member` (
  `memberId` VARCHAR(8) NOT NULL,
  `memberPwd` VARCHAR(200) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `memberName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`memberId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);

-- 아이디 중복 검사
select count(*) from member where memberId = 'tosimi';

-- 회원 가입
insert into member(memberId, memberPwd, email, memberName)
values(?, sha1(md5(?)), ?, ?)

-- --------------------------------------------------
-- diary 테이블 생성

-- CREATE TABLE `ksy`.`diary` (
--   `dno` INT NOT NULL AUTO_INCREMENT,
--   `title` VARCHAR(100) NOT NULL,
--   `dueDate` DATE NOT NULL,
--   `writer` VARCHAR(8) NOT NULL,
--   `finished` TINYINT NULL DEFAULT '0',
--   PRIMARY KEY (`dno`));

-- insert into diary (title, dueDate, writer) values(?, ?, ?) 

use ksy;
select * from diary order by dno desc;

-- 다이어리 title, dueDate 수정
update dairy set title = ?, dueDate = ? where dno = ?


-- 로그인
select * from member where memberId = ? and memberPwd = sha1(md5(?))

-- memberId로 글 목록 조회
select * from diary where writer = ?;

-- 내일이 마감인 목록
select * from diary where dueDate = date_add(curdate(), interval 1 day);

-- 멤버아이디로 이메일 조회
select email from member where memberId = ?





