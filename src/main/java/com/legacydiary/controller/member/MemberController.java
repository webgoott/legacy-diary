package com.legacydiary.controller.member;

import java.io.IOException;
import java.util.UUID;

import javax.mail.MessagingException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.legacydiary.domain.MyResponse;
import com.legacydiary.domain.User;
import com.legacydiary.service.member.MemberService;
import com.legacydiary.util.SendMailService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member") // 이 컨트롤러는 /member로 시작하는 요청url을 모두 담당
@Slf4j
@RequiredArgsConstructor
public class MemberController {

	private final MemberService mService; // 서비스 객체 주입
	
	private final SendMailService sendMailService; // 메일 전송 담당 객체 주입
	
	@GetMapping("/signup")
	public void  registerForm() { // 가입 폼 페이지 보여주기 위한 메서드 
		
//		User user = new User.Builder()
//				.id("user1")
////				.name("홍길동")
//				.pwd("1234")
//				.build();
//		

//		User user = User.builder()
//				.name("홍길동")
//				.pwd("1234")
//				.build();
//		System.out.println(user);
		
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
	
	@PostMapping("/callSendMail")
	public void sendMailAuthCode(@RequestParam String tmpMemberEmail) {
		
		log.info("tmpMemberEmail : {} " + tmpMemberEmail);
		
		String authCode = UUID.randomUUID().toString(); // Universally Unique Identifier
		log.info("authCode : {} ", authCode);
		
		try {
			sendMailService.sendMail(tmpMemberEmail, authCode);
		} catch (IOException | MessagingException e) {
			e.printStackTrace();
		}
		
	}
	
	
}
