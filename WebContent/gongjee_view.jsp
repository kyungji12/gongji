<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*" %>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
	<head>
		<title>글 하나보기</title>
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
		<%
		try{
			//DB연결
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
			Statement stmt = conn.createStatement();	
			
			//gongjee_list.jsp에서 값 받아오기
			String gKey = request.getParameter("key");
			int viewKey = Integer.parseInt(gKey);
			
			String srootid = request.getParameter("rootid");
			
			//글 조회수
			stmt.execute("update gongjee set viewcnt=(viewcnt+1) where id = "+viewKey+";");
						
			//값 읽어오기
			ResultSet rset = stmt.executeQuery("select * from gongjee where id ="+viewKey+";");
		
		%>
		
		<%! // 전역변수 선언 (값 넘겨줄 때 사용)
		   String title;
		   String content;
		   String relevel;
		   String img;
		   int viewcnt;
		   int rootid;%>
	</head>
	<body>
	<br>
	<h3 align=center>-*-*-*-*-*-*-　　글 보기　　-*-*-*-*-*-*-</h3>
			<table class=mytable align=center>
				<%
					while(rset.next()){
						
						out.println("<tr><th width=70px bgcolor=#babaff name=id>번호</th>");
						out.println("<td>"+rset.getInt(1)+"</td></tr>"); //글 번호는 name=id로 넘기기
						
						out.println("<tr><th width=70px bgcolor=#babaff>제목</th>");
						out.println("<td>"+rset.getString(2)+"</td></tr>");
						title=rset.getString(2); //글 수정할 때 넘겨줄 글 제목
						
						out.println("<tr><th width=70px bgcolor=#babaff>날짜</th>");
						out.println("<td>"+rset.getDate(3)+"</td></tr>");
						
						out.println("<tr><th width=70px bgcolor=#babaff>조회수</th>");
						out.println("<td>"+rset.getInt(5)+"</td></tr>");
						viewcnt=rset.getInt(5); //조회수 넘기기
						
						out.println("<tr><th width=70px height=200px bgcolor=#babaff>내용</th>");
						out.println("<td>"+rset.getString(4)+"");
						if (rset.getString(8) == null || rset.getString(8).equals("null")){
							out.println(" ");
						}else{
							out.println("<img height=300px src='"+rset.getString(8)+"'>");
						}
						out.println("</td></tr>");
						content=rset.getString(4); //글 내용 넘기기
						img=rset.getString(8); //사진 내용 넘기기
						
						out.println("<tr><th width=70px bgcolor=#babaff>원글 번호</th>");
						out.println("<td>"+rset.getInt(6)+"번</td></tr>");
						rootid=rset.getInt(6); //답글 달았을 때의 원글 번호 넘기기
						
						out.println("<tr><th width=70px bgcolor=#babaff>답글 수준</th>");
						out.println("<td>"+rset.getString(7).length()+"</td></tr>");
						relevel = rset.getString(7); //글의 Depth (원글:0, 답글:1, 답답글:2...)
					}
				%>
			</table>
			<table align=center style=margin-top:10px>
				<tr>
				<td width=500px></td>
				<td align=right ><button type="button" onclick="location.href='gongjee_list.jsp'">목록</button></td>
				<td align=right >
				<button type="button" 
				onclick="location.href='gongjee_update.jsp?key=<%=viewKey %>&title=<%=title %>&content=<%=content %>&img=<%=img%>'">수정
				</button></td>
				<td>
				<button type="button" 
				onclick="location.href='gongjee_reinsert.jsp?key=<%=viewKey %>&rootid=<%=rootid %>&relevel=<%=relevel %>'">답글
				</button></td>
				</tr>		
			</table>				
	<%
		rset.close();
		stmt.close();
		conn.close(); 
	}catch(Exception e){
		out.println("<p align=center>글이 없습니다.</p>");
	}
	%>		
	</body>
</html>