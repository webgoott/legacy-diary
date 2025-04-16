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
	            if (data == 'success'){
	            	if (checked) {
	            		$("#dlist-" + dno).addClass("completed");
	            	} else {
	            		$("#dlist-" + dno).removeClass("completed");
	            	}
	            	self.location='/diary/list';
	            }
	            
	          },
	          error: function () {},
	          complete: function () {
	          },
      	});
	});
	
	// 수정 (title, dueDate)
	$(".modifyBtn").click(function(){
		let dno = $(this).data("dno"); // data-XXXX -> data("XXXX")
		let title = $(this).data("title");
		let date = $(this).data("date");
		
		console.log(dno, title, date);
		
		$("#modifyDno").val(dno);
		$("#modifyTitle").val(title);
		$("#modifyDueDate").val(date); // 2025-04-16
		
		
		$("#modifyModal").show();
		
		
		
	});
	
	
	$(".closeModal").click(function(){
		$("#modifyModal").hide();
	});
	
	
	$("#searchBtn").click(function () {
		$("#searchFormCard").toggle();
	})
	
});

function modifyDiary() {
	let dno = $("#modifyDno").val();
	let title = $("#modifyTitle").val();
	let dueDateStr = $("#modifyDueDate").val();
	
	console.log(dno, title, dueDateStr);
	// 유효성검사
	if (title == "" || dueDateStr == "") {
		alert("제목, 날짜를 입력하세요");
		return;
	}
	
	// 수정 요청
	$.ajax({
        url: '/diary/modify', // 데이터가 송수신될 서버의 주소
        type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
		data: {
			  dno : dno,
			  title : title,
			  dueDateStr : dueDateStr
		  },  // 보내는 데이터
        dataType: "text", // 수신받을 데이터 타입 (MIME TYPE)
        // async: false, // 동기 통신 방식
        success: function (data) {
          // 통신이 성공하면 수행할 함수
          console.log(data);
		  $("#modifyModal").hide();
		  self.location='/diary/list';
        },
        error: function () {},
        complete: function () {
        },
  	});
	
	
}

</script>
<style>
	li.completed .titleDiv,
	li.completed .dueDateDiv {
		color : gray;
		text-decoration : line-through;
	}
</style>

</head>
<body>
<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">

			<h1>다이어리 목록</h1>
			
			<div class="mb-3">
				<button class="btn btn-primary" id="searchBtn"> 🔍검색옵션</button>
			</div>
			
			<div class="card" id="searchFormCard" style="display:none;">
    			<div class="card-body">
    				<form action="/diary/search" method="post">
    					<div class="mb-3 mt-3">
    						<label for="searchWord" class="form-label">제목 검색:</label>
    						<input type="text" class="form-control" id="searchWord" placeholder="검색어를 입력하세요..." name="searchWord">
    						<input type="hidden" name="searchTypes" value="title" />
  						</div>
  						<div>
  						<label for="finishedSelect" class="form-label">완료여부 (select one):</label>
						    <select class="form-select" id="finishedSelect" name="finished">
						      <option value="">모두보기</option>
						      <option value="0">미완료</option>
						      <option value="1">완료</option>
						    </select>
    					</div>
    					<div>
    						<label for="from" class="form-label">dueDate (From):</label>
    						<input type="date" class="form-control" id="from" name="from">
    					</div>
    					<div>
    						<label for="to" class="form-label">dueDate (To) :</label>
    						<input type="date" class="form-control" id="to" name="to">
    					</div>
    					
    					<div>
    						<button type="submit" class="btn btn-primary">검색</button>
    					</div>
    				</form>
    			</div>
  			</div>
			
<%-- 			<div>${diaryList }</div> --%>
			
			<ul class="list-group">
				<c:forEach var="diary" items="${diaryList }">
    				<li class="list-group-item d-flex align-items-center ${diary.finished ? 'completed' : '' }"  
    				    id="dlist-${diary.dno }" >
						<!-- 	체크박스 -->
	    				 <input type="checkbox" class="form-check-input finishedCheckbox" data-dno="${diary.dno }"
	    				 <c:if test="${diary.finished }">checked</c:if> />
	    				 
	      				 <div class="titleDiv" >${diary.title } </div>
	      				 
						 <div class="dueDateDiv"> (${diary.dueDate })</div>		
						 
						 <button type="button" class="btn btn-outline-info btn-sm modifyBtn" 
						 		data-dno="${diary.dno }"
						 		data-title="${diary.title }"
						 		data-date=${diary.dueDate }	>수정</button>	
    				</li>
				</c:forEach>
			</ul>
			
			
			
		</div>
	</div>
	
	
	<!-- The Modal -->
<div class="modal" id="modifyModal">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Modal Heading</h4>
        <button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
        <input type="hidden" id="modifyDno" name="dno" />
        <div class="mb-3 mt-3">
	        <label for="modifyTitle" class="form-label">Title:</label>
	   	    <input type="text" class="form-control" id="modifyTitle" name="title">
		</div>
		<div class="mb-3">
			    <label for="modifyDueDate" class="form-label">Due Date:</label>
			    <input type="date" class="form-control" id="modifyDueDate" name="dueDateStr">
		</div>
		
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-success"  onclick="modifyDiary();">저장</button>
        <button type="button" class="btn btn-danger closeModal" data-bs-dismiss="modal">Close</button>
      </div>
	</div>
  </div>
</div>
</div>
	
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>