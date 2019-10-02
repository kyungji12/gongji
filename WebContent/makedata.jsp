<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*" %>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>데이터값 넣기</title>
	<% 
		//DB연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
		Statement stmt = conn.createStatement();	
	%>
	</head>
	
	<body>
	<%
	try{
		//테이블 삭제
		//stmt.execute("drop table gongjee");
		//out.print("drop table gongji OK<br>");
		
		//테이블 생성
		//stmt.execute(" create table gongjee"+
		//"(id int not null primary key auto_increment, title varchar(70), date date, content text) "+
		//"DEFAULT CHARSET=UTF8;");
		
		//데이터 입력
		//String sql="";
		//sql="insert into gongjee(title, date, content) values('공지사항1',date(now()),'공지사항내용1')";
		//stmt.execute(sql);
		//sql="insert into gongjee(title, date, content) values('공지사항2',date(now()),'공지사항내용2')";
		//stmt.execute(sql);
		//sql="insert into gongjee(title, date, content) values('공지사항3',date(now()),'공지사항내용3')";
		//stmt.execute(sql);
		//sql="insert into gongjee(title, date, content) values('공지사항4',date(now()),'공지사항내용4')";
		//stmt.execute(sql);
		//sql="insert into gongjee(title, date, content) values('공지사항5',date(now()),'공지사항내용5')";
		//stmt.execute(sql);
		
		//테이블 수정
		//String sql="";
		//sql="alter table gongjee add rootid int;";
		//stmt.execute(sql);
		//sql="alter table gongjee add relevel int;";
		//stmt.execute(sql);
		//sql="alter table gongjee add recnt int;";
		//stmt.execute(sql);
		//sql="alter table gongjee add viewcnt int;";
		//stmt.execute(sql);
		
		
		stmt.close();
		conn.close();
	}catch(Exception e){
		out.println("오류");
		out.println(e.toString());
	}
	%>
	
	</body>
</html>