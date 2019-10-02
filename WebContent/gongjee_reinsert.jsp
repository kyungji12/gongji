<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.text.SimpleDateFormat,java.util.Calendar" %>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>공지 신규 작성</title>
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
		//날짜 처리
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdt = new SimpleDateFormat("YYYY-MM-dd");
		//DB연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
		Statement stmt = conn.createStatement();	
		ResultSet rset = null;
		
		//gongjee_list.jsp에서 값 받아오기
		String gKey = request.getParameter("key");
		int viewKey = Integer.parseInt(gKey);
		
		String relevel = request.getParameter("relevel");
		String rootid = request.getParameter("rootid");
		
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
	$(function() {
        $("#imgInp").on('change', function(){
            readURL(this);
        });
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
                $('#blah').attr('src', e.target.result);
            }
          reader.readAsDataURL(input.files[0]);
        }
    }
	</script>
	</head>
	<body>
	<br>
	<h3 align=center>-*-*-*-*-*-*-　　답글 쓰기　　-*-*-*-*-*-*-</h3>
		<form method=post action="gongjee_rewrite.jsp?key=<%=viewKey%>&rootid=<%=rootid %>&relevel=<%=relevel%>" enctype="multipart/form-data">
			<table class=mytable align=center>
			<tr>
				<th width=50px bgcolor=#babaff name=id>번호</th>
				<td>자동 부여</td>
			</tr>			
			<tr>
				<th width=50px bgcolor=#babaff>제목</th>
				<td><input style=width:500px type=text maxlength=100 required name=title 
				required placeholder="최대 100자까지만 입력가능합니다." ></td>
			</tr>		
			<tr>
				<th width=50px bgcolor=#babaff>날짜</th>
				<td><%=sdt.format(cal.getTime()) %></td>
			</tr>		
			<tr>
				<th width=50px bgcolor=#babaff>내용</th>
				<!--<td><textarea maxlength=500 rows="20" cols="80" name=content aria-required=true required=required 
				placeholder='최대 500자까지만 입력가능합니다.'></textarea></td>  -->
				<td><textarea name="content" id="summernote" name=content value=""></textarea></td>
				<!-- html에디터 이용 -->
			</tr>
			<tr>
				<th width=50px bgcolor=#babaff>첨부파일</th>
				<td><input type=file name=refile1 id="refileInp1"/>
				<br>
				<img id="blah" src="#" alt="your refile1"/></td>
				<!-- <input type=file name=file2 id="fileInp2"/> -->
				<!--<img id="blah" src="#" alt="your file2"/></td> 파일 미리보기  -->
   			</tr>
			<tr>
   				<td colspan="2" align="right"><input type="submit" value="추가"></td>
   			</tr>
			</table>
		</form>
	</body>
</html>