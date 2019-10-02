<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.text.SimpleDateFormat,java.util.Calendar" %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>공지 수정</title>
			<!-- html 에디터 -->
	<!-- include libraries(jQuery, bootstrap) -->
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script> 
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 
	
	<!-- include summernote css/js-->
	<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script>
	<style>
		.mytable { 
			border-collapse:collapse;
			}  
		.mytable th, .mytable td { 
			border:1px solid black; 
			padding: 10;
			}
		a.no_line{
		text-decoration: none; <%--밑줄이 없애기 --%>
		}	
	</style>	
	<%
	try{
	//날짜 처리 
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdt = new SimpleDateFormat("YYYY-MM-dd");
	
	String id = request.getParameter("key");

//한글 처리할 필요없어짐 	
// 	String ti = request.getParameter("title");
// 	String title = new String(ti.getBytes("8859_1"),"UTF-8"); 
	
// 	String co = request.getParameter("content");
// 	String content = new String(co.getBytes("8859_1"),"UTF-8");

	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	String imgurl = request.getParameter("img");
	%>
	<script>
	$(document).ready(function() {
	     $('#summernote').summernote({
	             height: 300,                 // set editor height
	             minHeight: 200,             // set minimum height of editor
	             maxHeight: 300,             // set maximum height of editor
	             width: 750,
	             lang:'ko-KR',
	             focus: true,                  // set focus to editable area after initializing summernote
	    	     toolbar: [
	 	    	    // [groupName, [list of button]]
	 	    	    ['style', ['bold', 'italic', 'underline', 'clear']],
	 	    	    ['font', ['strikethrough', 'superscript', 'subscript']],
	 	    	    ['fontsize', ['fontsize']],
	 	    	    ['color', ['color']],
	 	    	    ['para', ['ul', 'ol', 'paragraph']],
	 	    	    ['height', ['height']]
	 	    	  ]
	     });

	});
	</script>
	</head>
	
	<body>
		<br>
		<h3 align=center>-*-*-*-*-*-*-　　글 수정　　-*-*-*-*-*-*-</h3>
			<form border=1 method=post action="gongjee_updatewrite.jsp" enctype="multipart/form-data">
			<table class=mytable align=center>
			<tr>
				<th width=50px bgcolor=#babaff name=id>번호</th>
				<td><input type="hidden" style=width:500px name=id value="<%=id %>" ></td>
			</tr>
				
			<tr>
				<th width=50px bgcolor=#babaff>제목</th>
				<td><input type=text style=width:500px name=title value="<%=title %>" required></td>
			</tr>
				
			<tr>
				<th width=50px bgcolor=#babaff>날짜</th>
				<td><%=sdt.format(cal.getTime()) %></td>
			</tr>
				
			<tr>
				<th width=50px bgcolor=#babaff>내용</th>
				<!--<td><textarea maxlength=500 rows="20" cols="80" name=content aria-required=true required=required 
				placeholder='최대 500자까지만 입력가능합니다.'></textarea></td>  -->
				<td><textarea name="content" id="summernote" name="content" value=""><%=content %></textarea></td>
				<!-- html에디터 이용 -->
			</tr>
			<tr>
				<th width=50px bgcolor=#babaff>첨부파일</th>
				<td>이전 파일: <img style="width:100px; height:50px;" src='<%=imgurl %>'>
						<input type="hidden" name='oldfile1' name="oldimg" value="<%=imgurl %>"><br>
					새 파일: <input type='file' name='file1' id="imgInp"/>
					<img id="blah" src="#" alt="your image"/></td>	
			</tr>
			</table>
			<table align=center style=margin-top:10px>
				<tr>
					<td width=550px></td>
					<td align=right ><button type="button" onclick="location.href='gongjee_list.jsp'">취소</button></td>
					<td><input type=submit value=수정></td>
					<td align=right ><button type="button" onclick="location.href='gongjee_delete.jsp?key=<%=id %>'">삭제</button></td>
				</tr>		
			</table>
			</form>
		<%
		}catch(Exception e){
			out.println("<p align=center>수정오류가 발생하였습니다.</p>");
		}
		%>			
	</body>
</html>