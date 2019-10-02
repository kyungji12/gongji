<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*" %>
<html>
	<head>
	<title>글 삭제</title>
	<%try{
		//DB연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
		Statement stmt = conn.createStatement();	
		
		String keyNo = request.getParameter("key");
		
		stmt.execute("DELETE FROM gongjee WHERE id ="+ keyNo +";");
		
	}catch(Exception e){
		out.println("<p align=center>오류가 발생하였습니다.</p>");
	}
	%>
	</head>
	<body>
		<br>
		<h3 align=center>-*-*-*-*-*-*-　삭제완료　　-*-*-*-*-*-*-</h3>
		
		
		<table align=center style=margin-top:10px>
			<tr>
				<br>
				<td align=right ><button type="button" onclick="location.href='gongjee_list.jsp'">목록</button></td>
			</tr>		
		</table>
	</body>
</html>