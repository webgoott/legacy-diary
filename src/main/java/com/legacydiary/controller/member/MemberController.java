package com.legacydiary.controller.member;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.legacydiary.domain.MyResponse;
import com.legacydiary.service.member.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member") // 이 컨트롤러는 /member로 시작하는 요청url을 모두 담당
@Slf4j
@RequiredArgsConstructor
public class MemberController {

	private final MemberService mService; // 서비스 객체 주입
	
	@GetMapping("/signup")
	public void  registerForm() {
		
	}
	
	@PostMapping("/isDuplicate")
	public ResponseEntity<MyResponse> idIsDuplicate(@RequestParam("tmpMemberId") String tmpMemberId) {
		
		log.info("tmpMemberId : {}", tmpMemberId + "가 중복되는지 확인하자");
		MyResponse myResponse = null;
		ResponseEntity<MyResponse> result = null;
		
		if (mService.idIsDuplicate(tmpMemberId)) { // 아이디가 중복됨
			myResponse = new MyResponse(200, tmpMemberId, "duplicate");
			
		} else { // 아이디가 중복되지 않음 
			myResponse = MyResponse.builder()
					.code(200)
					.data(tmpMemberId)
					.msg("not duplicate")
					.build();
		}
		log.info("myResponse : {} " , myResponse);
		
		result = new ResponseEntity<MyResponse>(myResponse, HttpStatus.OK);
		
		return result; 
	}
	
	
	
}
