<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>다이어리 등록</title>
<script type="text/javascript">
	$(function(){
		
		$("#title").on("blur", function(){
			validTitle();
		});
		
		$("#dueDate").on("blur", function(){
			validDueDate();
		});
		
		$("#writer").on("blur", function(){
			validWriter();
		});
		
	});
	
	function validTitle(){
		let result = false;
		// 필수,  +++++++ 100자
		let title = $("#title").val();
		
		if (title == '') {
			$("#titleError").html("제목을 입력하세요");
		} else {
			$("#titleError").html("");
			result = true;
		}
		
		return result;
	}
	
	function validDueDate(){
		// 완료일 : 오늘이나 그 이전 날짜는 입력받지 않도록 한다.
		// 필수
		let result = false;
	
		let dueDate = $("#dueDate").val(); // 2025-04-11
		
		console.log(dueDate == "");
		
		let today = new Date().toISOString().split("T")[0];
// 		console.log(today); // 오늘의 날짜만
		
		if (dueDate == "") {
			$("#dueDateError").html("완료일은 필수항목입니다.");
		} else if ((new Date(dueDate) - Date.now() ) < 0) {
			$("#dueDateError").html("완료일은 오늘 이후로 선택하세요.");
		} else {
			$("#dueDateError").html("");
			result = true;
		}
		
		return result;
	}
	
	function validWriter () {
		// 작성자는 not null
		let result = false;
		let writer = $("#writer").val();
		
		if (writer == '') {
			$("#writerError").html("작성자는 필수항목입니다.");
		} else {
			$("#writerError").html("");
			result = true;
		}
		
		return result;
	}
	
	
	function isValid(){
		
		let result = false;
		
		let titleValid =  validTitle();
		let dueDateValid = validDueDate();
		let writerValid = validWriter();
		
		console.log(titleValid, dueDateValid, writerValid);
		
		if (titleValid && dueDateValid && writerValid) {
			result = true;	
		}
		return result;
	}
	
	function clearErrors() {
		$("#titleError").html("");
		$("#dueDateError").html("");
		$("#writerError").html("");
		
	}

</script>
</head>
<body>
<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">

			<h1>다이어리 등록</h1>
			
			<form action="/diary/register" method="post">
			  <div class="mb-3 mt-3">
			    <label for="title" class="form-label">Title:</label>
			    <span id="titleError"></span>
			    <input type="text" class="form-control" id="title" placeholder="제목" name="title">
			  </div>
			  <div class="mb-3">
			    <label for="dueDate" class="form-label">Due Date:</label>
			     <span id="dueDateError"></span>
			    <input type="date" class="form-control" id="dueDate" name="dueDateStr">
			  </div>
			  <div class="mb-3 mt-3">
<!-- 			    <label for="writer" class="form-label">Writer:</label> -->
<!-- 			    <span id="writerError"></span> -->
			    <input type="hidden" class="form-control" id="writer" placeholder="작성자" name="writer" value="${loginMember.memberId}">
			  </div>
			  
			  <button type="submit" class="btn btn-primary" onclick="return isValid();">Submit</button>
			  <button type="reset" class="btn btn-secondary" onclick="clearErrors();">Reset</button>
			</form>

		</div>
	</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>