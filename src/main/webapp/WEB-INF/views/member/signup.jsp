<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>Insert title here</title>
<script type="text/javascript">
$(function(){
	// 아이디 이벤트
	$("#memberId").on("blur", function () {
		let tmpMemberId = $("#memberId").val();
		console.log(tmpMemberId);
		// 아이디 : 필수, 중복 불가, 길이 (4~8자)
		
		if (tmpMemberId.length < 4 || tmpMemberId.length > 8) {
			outputError("아이디는 4~8자로 입력하세요", $("#memberId"), "red");
			$("#idValid").val("");
			
		} else {
			// 아이디 중복 체크
			$.ajax({
	          url: '/member/isDuplicate', // 데이터가 송수신될 서버의 주소
	          type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			  data: {
				  "tmpMemberId" : tmpMemberId
			  },  // 보내는 데이터
	          dataType: "json", // 수신받을 데이터 타입 (MIME TYPE)
	          // async: false, // 동기 통신 방식
	          success: function (data) {
	            // 통신이 성공하면 수행할 함수
	            console.log(data);
	            if (data.msg == "duplicate") {
	            
	            	outputError("중복된 아이디입니다.", $("#memberId"), "red");
	            	$("#memberId").focus();
	            	$("#idValid").val("");
	            	
	            } else if (data.msg == "not duplicate") {
					outputError("완료", $("#memberId"), "green");
					$("#idValid").val("checked");
	            	
	            }
	          },
	          error: function () {},
	          complete: function () {
	          },
        	});
		}
		
	});

	// 비밀번호 검사
	$("#memberPwd1").blur(function () {
		// 비밀번호 4 ~ 8자
		let tmpPwd = $("#memberPwd1").val();
		
		if (tmpPwd.length < 4 || tmpPwd.length > 8) {
			outputError("비밀번호는 4 ~ 8자로 입력하세요", $("#memberPwd1"), "red");
			$("#memberPwd1").val("");
			$("#memberPwd1").focus();
			
		} else {
			outputError("완료", $("#memberPwd1"), "green");
		}
	});
	
	$("#memberPwd2").blur(function () {
		
		let tmpPwd2 = $("#memberPwd2").val();
		let tmpPwd1 = $("#memberPwd1").val();
		
		if (tmpPwd1.length < 4 || tmpPwd1.length > 8) {
			return;
		}
		
		if (tmpPwd1 != tmpPwd2) {
			outputError("패스워드가 다릅니다", $("#memberPwd2"), "red");
			outputError("패스워드가 다릅니다", $("#memberPwd1"), "red");
			$("#memberPwd1").val("");
			$("#memberPwd2").val("");
			$("#memberPwd1").focus();
			$("#pwdValid").val("");
			
		} else {
			
			outputError("일치", $("#memberPwd1"), "green");
			outputError("일치", $("#memberPwd2"), "green");
			$("#pwdValid").val("checked");
			
		}
		
	});
	
	// 이메일 
	$("#email").blur(function(){
		if ($("#email").val().length > 0) {
			checkEmail();
		} else {
			outputError("이메일은 필수항목입니다.", $("#email"), "red");
		}
	});
	
	
	
});


function checkEmail() {
// 	alert("checkEmail");
// 1) 정규표현식을 이용하여 이메일 주소 형식인지 아닌지 판단 + 중복체크
// 2) 이메일 주소 형식이면.. 인증번호를 이메일로 보내고
//       인증번호를 입력받을 태그 생성해서 다시 입력받아서 보낸 인증번호와 유저가 입력한 인증번호가 일치하는지 검증
	
	let tmpMemberEmail = $("#email").val();
	let emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	
	if (!emailRegExp.test(tmpMemberEmail)) {
		outputError("이메일 형식이 아입니다.", $("#email"), "red");
	} else {
		outputError("이메일 형식입니다.", $("#email"), "green");
		
		callSendMail(); // 이메일 발송 	
		
		
		
	}
	
	
	
}

function callSendMail() {
	
	$.ajax({
        url: '/member/callSendMail', // 데이터가 송수신될 서버의 주소
        type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
		  data: {
			  "tmpMemberEmail" :  $("#email").val()
		  },  // 보내는 데이터
        dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
        // async: false, // 동기 통신 방식
        success: function (data) {
          // 통신이 성공하면 수행할 함수
          console.log(data);
          if (data == "success") {
        	  if ($(".authenticationDiv").length == 0) {
	        	  showAuthenticateDiv(); // 인증번호를 입력받을 태그 요소를 출력
        	  }
          }

        },
        error: function () {},
        complete: function () {
        },
  	});
	
}

function showAuthenticateDiv() {
	
	let authDiv = `
		<div class="authenticationDiv mt-2">
		<input type="text" class="form-control" id="memberAuthCode" placeholder="인증번호를 입력하세요.." />
		<button type="button" class="btn btn-info" onclick="checkAuthCode();">인증하기</button>
		</div>
	`;
	
	$(authDiv).insertAfter("#email");
}

function checkAuthCode(){
	let memberAuthCode = $("#memberAuthCode").val();
// 	alert(memberAuthCode);
	
	$.ajax({
        url: '/member/checkAuthCode', // 데이터가 송수신될 서버의 주소
        type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
		data: {
			  "memberAuthCode" :  memberAuthCode
		  },  // 보내는 데이터
        dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
        // async: false, // 동기 통신 방식
        success: function (data) {
          // 통신이 성공하면 수행할 함수
          console.log(data);
          if (data == "success") {
        	  outputError("인증완료", $("#email"), "green");
        	  $(".authenticationDiv").remove();
        	  $("#emailValid").val("checked");
          } 
        },
        error: function () {},
        complete: function () {
        },
  	});

	
	// 34분까지~~~~
}


function outputError(errorMsg, tagObj, color) {
	let errTag = $(tagObj).prev(); // <span></span>
	$(errTag).html(errorMsg);
	$(errTag).css("color", color);
	$(tagObj).css("border-color", color);
}

function idValid() {
	let result = false;
	
	if ($("#idValid").val() == "checked") {
		result = true;
	}
	
	return result;
}

function isValid(){
		// 아이디 : 필수, 중복 불가, 길이 (4~8자)
		
		let result = false;	
		let idCheck = idValid();
		
		return result;
		
}
</script>
</head>
<body>
<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">

			<h1>회 원 가 입</h1>
			
			<form action="signup" method="POST">
			    <div class="mb-3 mt-3">
			      <label for="memberId">아이디 :</label><span></span>
			      <input type="text" class="form-control" id="memberId" name="memberId" placeholder="아이디를 입력하세요..." >
			      <input type="hidden" id="idValid"/>
			    </div>
			    <div class="mb-3">
			      <label for="memberPwd1">비밀번호 : </label><span></span>
			      <input type="password" class="form-control" id="memberPwd1" placeholder="비밀번호를 입력하세요...." name="memberPwd">
			    </div>
		    	<div class="mb-3">
			      <label for="memberPwd2">비밀번호 확인 : </label>
			      <input type="password" class="form-control" id="memberPwd2" placeholder="비밀번호를 다시 한번 입력하세요...." >
			      <input type="hidden" id="pwdValid"/>
			    </div>
			    <div class="mb-3 mt-3">
			      <label for="email">이메일 :</label><span></span>
			      <input type="email" class="form-control" id="email" placeholder="Enter email" name="email">
			       <input type="hidden" id="emailValid"/>
			    </div>
				<div class="mb-3 mt-3">
			      <label for="memberName">이름 :</label><span></span>
			      <input type="text" class="form-control" id="memberName" name="memberName" placeholder="이름을 입력하세요..." >
			    </div>			    
			    
			    <button type="submit" class="btn btn-success" onclick="return isValid();" >가입</button>
			    <button type="submit" class="btn btn-danger">취소</button>
			  </form>
					</div>
				</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>