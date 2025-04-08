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