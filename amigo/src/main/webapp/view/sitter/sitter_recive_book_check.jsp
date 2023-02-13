<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<script
  src="https://code.jquery.com/jquery-3.6.3.min.js"
  integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
  crossorigin="anonymous"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<title>파트너03예약신청~예약확인</title>
    <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
    <![endif]-->
<style>
	.book_item{
		 margin-bottom: 20px;
		 padding: 20px;
	}
	.book_item:hover{
		cursor:pointer;
	}
	.modal{
		 position: absolute; top:0;left:0;
		 width:100%; height:100%;
		 background-color: rgba(0, 0, 0, 0.4);
		 display:none;
	}
	.modal_body {
		 position:absolute; top:50%;left:50%;
		 width: 400px;height: 400px;
		
		 padding: 40px;		
		 text-align: center;
		
		 background-color: rgb(255, 255, 255);
		 border-radius: 10px;
		 box-shadow: 0 2px 3px 0 rgba(34, 36, 38, 0.15);
		
		 transform: translateX(-50%) translateY(-50%);
	}
	.book_content{
		width: 100%;height: 90%;
	}
	
	
	table {
	  border-radius: 10px;
	  border-style: hidden;
	  box-shadow: 0 0 0 1.5px #000;
	  overflow: hidden;

	}
	#main_table{
	box-shadow: 5px 2px 20px rgb(0 0 0 / 20%);
	}
	.modal_tTitle{
		background:rgb(87, 160, 227);
		color:white;
	 
	}
	
</style>

<script>

	function open_book_modal(e){
		console.log("입장확인");
		let rno = $(e).find("#book_res_no").text();		
		//let res_state = $(e).find("#book_res_state").text();
		getBook_detail(rno);
		$('.modal').fadeIn();
		$('body').css("overflow", "hidden");
		
	}
	
	function close_book_modal(){
		$('.modal').fadeOut();
		$('.book_content').remove();
		$('.book_btn').remove();	
		$('body').css("overflow", "auto");
	}
	
	function getBook_detail(rno){
 		$.ajax({
			url : '/amigo/ajax/getBook_detail.do',
			type : 'POST',
			data : {
				'rno' : rno
			},
			success : function(result) {
				let modalBody = $('.modal_body');
				if (result != null) {
					let temp='<ul class="book_content list-group" style="overflow: auto;">';
					result.forEach((content, index) =>{
						temp += '<li style="padding:5px;"><table class="table-sm table-bordered" border="2" style="width:95%;">';
						temp += '<tr style="border-bottom:solid 1px black;"><td style="width:50%;" class="modal_tTitle">일자</td><td style="width:50%;">' + content.res_date +'</td></tr>';
						temp += '<tr style="border-bottom:solid 1px black;"><td class="modal_tTitle">시간</td><td>' + content.res_time +'</td></tr>';
						temp += '<tr style="border-bottom:1px solid black; vertical-align: middle;"><td class="modal_tTitle">장소</td><td>' + content.res_addr +'</td></tr>';
						temp += '</table></li>';
					});
					temp+='</ul>';
/* 					if(res_state.trim()=='대기'){
						temp+='<button class="btn btn-danger book_btn" onclick="book_refuse('+rno+')" style="position:relative;">거부하기</button>';
						temp+='<button class="btn btn-danger book_btn" onclick="book_refuse('+rno+')" style="position:relative;">승인하기</button>';
					} */
					modalBody.append(temp);
				} else {
					alert('예약정보가 없습니다! 다시 시도해주세요!');
					close_book_modal();
				}
			}
		});
		
	}
	
/* 	function book_refuse(rno){
		if(confirm('정말로 거부하시겠습니까?')){
			$.ajax({
				url  : '/amigo/ajax/refuseBook.do',
				type : 'POST',
				data : {
					'rno' : rno	
				},
				success : function(result){
					if(result>0){
						alert('성공적으로 거부됐습니다!');
						history.go(0);
					}else{
						alert('거부에 실패했습니다!');
					    close_book_modal();
					}
				},
			    error : function(request, status, error) { // 결과 에러 콜백함수
			        console.log(error);
			        alert('거부에 실패했습니다!');
			        close_book_modal();
			    }
			});
			
		}
	} */
	function book_update(rno){
		if(confirm('정말로 승인하시겠습니까?')){
			$.ajax({
				url  : '/amigo/ajax/updateBook.do',
				type : 'POST',
				data : {
					'rno' : rno 
				},
				success : function(result){
					if(result>0){
						alert('승인됐습니다!');
						history.go(0);
					}else{
						alert('승인에 실패했습니다!');
					    close_book_modal();
					}
				},
			    error : function(request, status, error) { // 결과 에러 콜백함수
			        console.log(error);
			        alert('승인에 실패했습니다!');
			        close_book_modal();
			    }
			});
			
		}
	}
	
</script>
</head>
<body>
			<c:set var="cp" value="${searchVO.getCurPage()}" />
			<c:set var="rp" value="${searchVO.getRowSizePerPage()}" />
			<c:set var="fp" value="${searchVO.getFirstPage()}" />
			<c:set var="lp" value="${searchVO.getLastPage()}" />
			<c:set var="ps" value="${searchVO.getPageSize()}" />
			<c:set var="tp" value="${searchVO.getTotalPageCount()}" />
			<c:set var="sc" value="${searchVO.getSearchCategory()}" />
			<c:set var="st" value="${searchVO.getSearchType()}" />
			<c:set var="sw" value="${searchVO.getSearchWord()}" />
	<%@include file="/includes/header.jsp" %>
		<div class="container">
			<section>	
				<article>
					<h3>예약확인</h3>
					<c:if test='${user.getUser_type().equals("S") }'>
						<button class="btn btn-primary" onclick="location.href='/amigo/book_check.do'">유저모드</button>
					</c:if>
					<c:choose>
					<c:when test="${sc eq 'past' }">
						<button class="btn btn-primary" onclick="location.href='/amigo/receiveBook_check.do'">현재기록</button>
					</c:when>
					<c:otherwise>
						<button class="btn btn-primary" onclick="location.href='/amigo/receiveBook_check.do?searchCategory=past'">이전기록</button>
					</c:otherwise>
					</c:choose>
				</article>
 				<article id="sitter_book">
					<h1>시터전용</h1>
					<c:choose>
						<c:when test="${sitBookList!=null && !sitBookList.isEmpty() }">
							<ul style="list-style: none;">
							<c:forEach var="book" items="${sitBookList }">
								<c:forEach var="usr" items="${userList }">
								<c:if test="${ book.getUser_no()==usr.getUser_no()}">
								<li class="book_item">
									<table class="table" id="main_table">
										<tbody onclick="open_book_modal(this)">
										<tr style="background:rgb(87, 160, 227);"><th colspan="2" style="text-align: center; color:white;">${usr.getUser_name() } 고객님</th></tr>
										<tr>
											<th class="tTitle" style="width:35%;">예약번호</th><td id="book_res_no" style="width:65%;">${book.res_no }</td>
										</tr>
										<tr>
											<th class="tTitle">방문여부</th>
											<th colspan="2" style="color:blue;'">
												
												<c:choose>
													<c:when test="${book.res_visit_is }">
														방문
													</c:when> 
													<c:otherwise>
														위탁
													</c:otherwise>
												</c:choose>
												
											</th>
										</tr>
										<tr>
											<th class="tTitle">예약일자</th><td>${book.res_regdate }</td>
										</tr>
										<tr>
											<th class="tTitle">예약날짜</th><td>${book.getRes_date() }</td>
										</tr>
										<tr>
											<th class="tTitle">결제금액</th><td><fmt:formatNumber value="${book.getRes_pay() }" pattern="#,###"/>원</td>
										</tr>
<%-- 										<tr style="border-bottom: 1px solid">
											<th class="tTitle">승인여부</th>
											<td>
												<c:choose>
													<c:when test="${book.res_state eq '1' }">
														<mark>승인</mark>
													</c:when>
													<c:otherwise>
														<mark>대기</mark>
													</c:otherwise>
												</c:choose>
											</td>
										</tr> --%>
										
										</tbody>
									</table>
								</li>
												
								</c:if>	
								</c:forEach>
							</c:forEach>
							</ul>
							<div class="row align-items-start mt-3">
									<ul class="col pagination justify-content-center">
										<c:if test="${ fp != 1 }">
											<li class="page-item"><a
												href="receiveBook_check.do?curPage=1&rowSizePerPage=${rp}&searchCategory=${sc}&searchWord=${sw}"
												class="page-link"><i class="fas fa-fast-backward"></i></a></li>
											<li class="page-item"><a
												href="receiveBook_check.do?curPage=${fp-1}&rowSizePerPage=${rp}&searchCategory=${sc}&searchWord=${sw}"
												class="page-link"><i class="fas fa-backward"></i></a></li>
										</c:if>

										<c:forEach var="page" begin="${fp}" end="${lp}">
											<li class="page-item ${cp==page ? 'active' : ''}"><a
												href="receiveBook_check.do?curPage=${page}&rowSizePerPage=${rp}&searchCategory=${sc}&searchWord=${sw}"
												class="page-link">${page}</a></li>
										</c:forEach>

										<c:if test="${ lp < tp }">
											<li class="page-item "><a
												href="receiveBook_check.do?curPage=${lp+1}&rowSizePerPage=${rp}&searchCategory=${sc}&searchWord=${sw}"
												class="page-link"><i class="fas fa-forward"></i></a></li>
											<li class="page-item"><a
												href="receiveBook_check.do?curPage=${tp}&rowSizePerPage=${rp}&searchCategory=${sc}&searchWord=${sw}"
												class="page-link"><i class="fas fa-fast-forward"></i></a></li>
										</c:if>
									</ul>
									<!-- pagination -->

								</div>
						</c:when>
						<c:otherwise>
							<h2>예약된 정보가 없습니다!</h2>
						</c:otherwise>
					</c:choose>
				</article>
				
			</section>	
		</div>
		
		<!-- 모달 -->
		
		<div class="modal">
			<div class="modal_body">
				<button class="btn-close btn-dark" style="position: relative; left:50%; top: -5%" onclick="close_book_modal()"></button>
			</div>
			
		</div>
				
		
	<%@include file="/includes/footer.jsp" %>

	
</body>
</html>