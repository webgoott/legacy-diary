<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>다이어리 목록</title>
<script type="text/javascript">
// .finishedCheckbox
$(function(){
	
	$(".finishedCheckbox").change(function(){
		
		let dno = $(this).data("dno");
		let checked = $(this).is(":checked") // true | false
		
		console.log(dno, checked);
		
		$.ajax({
	          url: '/diary/updateFinished', // 데이터가 송수신될 서버의 주소
	          type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			  data: {
				  "dno" : dno,
				  "finished" : checked
			  },  // 보내는 데이터
	          // async: false, // 동기 통신 방식
	          success: function (data) {
	            // 통신이 성공하면 수행할 함수
	            console.log(data);
	            
	          },
	          error: function () {},
	          complete: function () {
	          },
      	});
	});
	
});

</script>

</head>
<body>
<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">

			<h1>다이어리 목록</h1>
			<div>${diaryList }</div>
			
			<ul class="list-group">
				<c:forEach var="diary" items="${diaryList }">
    				<li class="list-group-item" >
						<!-- 	체크박스 -->
	    				 <input type="checkbox" class="form-check-input finishedCheckbox" data-dno="${diary.dno }"
	    				 <c:if test="${diary.finished }">checked</c:if> />
	      				 <label class="form-check-label" for="check1">${diary.title }   </label>
						 <span>  (${diary.dueDate })</span>			
    				</li>
				</c:forEach>
			</ul>
			
			
			
		</div>
	</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>