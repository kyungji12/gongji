<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.text.SimpleDateFormat,java.util.Calendar" %>
<%@ page import="java.net.URLEncoder"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>

<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>쓰기버튼 누르는 화면</title>
		<!-- html 에디터 -->
	<!-- include libraries(jQuery, bootstrap) -->
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script> 
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 
	
	<!-- include summernote css/js-->
	<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script>
	<style>
		.mytable{
			border-collapse:collapse;
			width:650px;
			cellspacing:0;
			cellpadding:5;
		}
		.mytable th, .mytable td { 
		border:1px solid black; 
		padding: 10;
		}
	</style>
	
	<%//try{
		//날짜 처리
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdt = new SimpleDateFormat("YYYY-MM-dd");
		
		//파일 업로드용 위치
		//String uploadPath = "C:\\Users\\user\\eclipse-workspace\\190722_lec08_comment\\upload";
		String uploadPath = request.getRealPath("");
		String id="";
		String title="";
		String content="";
		String fileName1 ="";
		//String fileName2 ="";
		String orgfileName1 ="";
		//String orgfileName2 ="";
		
		//파일 저장
		try{
			MultipartRequest multi = new MultipartRequest( // MultipartRequest 인스턴스 생성(cos.jar의 라이브러리)
					request, 
					uploadPath, // 파일을 저장할 디렉토리 지정
					12 * 1024 * 1024, // 첨부파일 최대 용량 설정(bite) / 3mb / 용량 초과 시 예외 발생
					"utf-8", // 인코딩 방식 지정
					new DefaultFileRenamePolicy() // 중복 파일 처리(동일한 파일명이 업로드되면 뒤에 숫자 등을 붙여 중복 회피)
			);
			
		//파라미터 받아오기	
		id = multi.getParameter("id");
		int ID;
		
		title = multi.getParameter("title"); 
		content = multi.getParameter("content");
		//multi는 한글처리 안해줘도 된다. new String(.getBytes("8859_1"),"UTF-8");
		fileName1 = multi.getFilesystemName("file1"); // name=file1의 업로드된 시스템 파일명을 구함(중복된 파일이 있으면, 중복 처리 후 파일 이름)
		orgfileName1 = multi.getOriginalFileName("file1"); // name=file1의 업로드된 원본파일 이름을 구함(중복 처리 전 이름)
		//fileName2 = multi.getFilesystemName("file2"); // name=file2의 업로드된 시스템 파일명을 구함(중복된 파일이 있으면, 중복 처리 후 파일 이름)
		//orgfileName2 = multi.getOriginalFileName("file2"); // name=file2의 업로드된 원본파일 이름을 구함(중복 처리 전 이름)
			
		}catch(Exception e){
			out.print(e.toString());
		}//종료
		
		//DB연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
		Statement stmt = conn.createStatement();	
		
		//값 받아오기
		//String id = request.getParameter("id");
		//int ID;
		//String gTitle = request.getParameter("title");
		//String title = new String(gTitle.getBytes("8859_1"),"UTF-8");
		//String gContent = request.getParameter("content");
		//String content = new String(gContent.getBytes("8859_1"),"UTF-8");
		
		//실행
		ResultSet rset = null;
		ResultSet rset2 = null;
		
		//입력처리
		stmt.execute("insert into gongjee (title, date, content, relevel, url1) values ('"+title+"', '"+sdt.format(cal.getTime())+"','"+content+"','','"+fileName1+"');");
		stmt.execute("UPDATE gongjee SET rootid = LAST_INSERT_ID() WHERE id = LAST_INSERT_ID();");
		rset = stmt.executeQuery("select * from gongjee where id = (select max(id) from gongjee);");
	
	%>
	<script>
	$(document).ready(function() {
	     $('#summernote').summernote({
	             height: 300,                 // set editor height
	             minHeight: 200,             // set minimum height of editor
	             maxHeight: 300,             // set maximum height of editor
	             width: 750,
	             lang:'ko-KR',
	             focus: true                  // set focus to editable area after initializing summernote
	     });
	});
	</script>
	<%!String title;
	   String content;
	   String img;%>
	</head>
	
	<body>
		<br>
		<h3 align=center>-*-*-*-*-*-*-　　입력완료!　　-*-*-*-*-*-*-</h3>
		<table class=mytable align=center>
		<%
			int newID = 0;
			while(rset.next()){
				out.println("<tr><th width=50px bgcolor=#babaff name=id>번호</th>");
				out.println("<td>"+rset.getInt(1)+"</td></tr>");
				newID = rset.getInt(1);
				
				out.println("<tr><th width=50px bgcolor=#babaff>제목</th>");
				out.println("<td>"+rset.getString(2)+"</td></tr>");
				
				out.println("<tr><th width=50px bgcolor=#babaff>날짜</th>");
				out.println("<td>"+rset.getDate(3)+"</td></tr>");
			
				out.println("<tr><th width=70px height=200px bgcolor=#babaff>내용</th>");
				out.println("<td>"+rset.getString(4)+"");
				if (rset.getString(8) == null || rset.getString(8).equals("null")){
					out.println("");
				}else{
					out.println("<img height=300px src='"+rset.getString(8)+"'>");
				}
				out.println("</td></tr>");
			}
		%>
		</table>
		<table align=center style=margin-top:10px>
			<tr>
				<td width=550px></td>
				<td align=right ><button type="button" onclick="location.href='gongjee_list.jsp'">목록</button></td>
				<!--<td align=right >
				<button type="button" onclick="location.href='gongjee_update.jsp?key=<%=newID %>&title=<%=title %>&content=<%=content %>&img=<%=img %>'">수정</button></td>  -->
			</tr>		
		</table>	
		<%
			rset.close();
			stmt.close();
			conn.close();
		//}catch(Exception e){
		//	out.println("<p align=center>오류가 발생하였습니다.</p>");
		//}
		%>		
	</body>
</html>