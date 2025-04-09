package com.legacydiary.controller.member;

import java.io.IOException;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.legacydiary.domain.MemberDTO;
import com.legacydiary.domain.MyResponse;
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
	public ResponseEntity<String> sendMailAuthCode(@RequestParam String tmpMemberEmail, HttpSession session) {
		
		log.info("tmpMemberEmail : {} " + tmpMemberEmail);
		
		String result = "";
		
		String authCode = UUID.randomUUID().toString(); // Universally Unique Identifier
		log.info("authCode : {} ", authCode);
		
		try {
			sendMailService.sendMail(tmpMemberEmail, authCode); // 메인 전송
			
			session.setAttribute("authCode", authCode); // 인증코드를 세션객체에 저장 
			result = "success";
			
		} catch (IOException | MessagingException e) {
			e.printStackTrace();
			result = "fail";
		}
		
		return new ResponseEntity<String>(result, HttpStatus.OK);
		
	}
	
	@PostMapping("/checkAuthCode")
	public ResponseEntity<String> checkAuthCode(@RequestParam String memberAuthCode, HttpSession session) {
		
		// 유저가 보낸 AuthCode와 우리가 보낸 AuthCode가 일치하는지 확인
		log.info("memberAuthCode : {}", memberAuthCode);
		log.info("session에 저장된 코드 : {} " , session.getAttribute("authCode"));
		
		String result = "fail";
		
		if (session.getAttribute("authCode") != null) {
			String sesAuthCode = (String) session.getAttribute("authCode");
			
			if (memberAuthCode.equals(sesAuthCode)) {
				result = "success";
			}
		}
		
		return new ResponseEntity<String>(result, HttpStatus.OK);
		
	}
	
	@PostMapping("/signup")
	public String registerMember(MemberDTO registerMember, RedirectAttributes rttr) {
		
		log.info("registerMember : {} ", registerMember + "회원가입하러 가자~~~");
		
		String result = "";
		if (mService.saveMember(registerMember)) {
			// 가입 완료 후 index.jsp로 가자.
			rttr.addAttribute("status", "success");
			result = "redirect:/";
			
		} else {
			// 가입 실패 -> 다시 회원가입 페이지로
			rttr.addAttribute("status", "fail");
			result = "redirect:/member/signup";
		}
		
		return result;
	}
	
	
}
