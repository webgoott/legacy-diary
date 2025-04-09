package com.legacydiary.service.member;

import com.legacydiary.domain.MemberDTO;

public interface MemberService {

	// 아이디 중복검사
	 boolean idIsDuplicate(String tmpMemberId);

	 // 회원가입
	boolean saveMember(MemberDTO registerMember);
	
	
}
