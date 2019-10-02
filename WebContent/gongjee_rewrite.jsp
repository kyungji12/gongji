<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.text.SimpleDateFormat,java.util.Calendar" %>
<%@ page import="java.net.URLEncoder"%>
<%@page import="java.util.Enumeration"%>
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
				String uploadPath = request.getRealPath("");
				String id = "";
				String title = "";
				String content = "";
				String fileName1 = "";
				String orgfileName1 = "";
				String rootid = "";
				String relevel = "";
				String refile1 = "";
				
		MultipartRequest multi = new MultipartRequest( // MultipartRequest 인스턴스 생성(cos.jar의 라이브러리)
				request, 
				uploadPath, // 파일을 저장할 디렉토리 지정
				12 * 1024 * 1024, // 첨부파일 최대 용량 설정(bite) / 3mb / 용량 초과 시 예외 발생
				"utf-8", // 인코딩 방식 지정
				new DefaultFileRenamePolicy() // 중복 파일 처리(동일한 파일명이 업로드되면 뒤에 숫자 등을 붙여 중복 회피)
		);
		
		//DB연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
		Statement stmt = conn.createStatement();	
		
		//값 받아오기
		id = multi.getParameter("id");
		int ID;
		
		title = multi.getParameter("title"); 
		content = multi.getParameter("content");
		//multi는 한글처리 안해줘도 된다. new String(.getBytes("8859_1"),"UTF-8");
		fileName1 = multi.getFilesystemName("refile1"); // name=file1의 업로드된 시스템 파일명을 구함(중복된 파일이 있으면, 중복 처리 후 파일 이름)
		orgfileName1 = multi.getOriginalFileName("refile1"); // name=file1의 업로드된 원본파일 이름을 구함(중복 처리 전 이름)
		//fileName2 = multi.getFilesystemName("file2"); // name=file2의 업로드된 시스템 파일명을 구함(중복된 파일이 있으면, 중복 처리 후 파일 이름)
		//orgfileName2 = multi.getOriginalFileName("file2"); // name=file2의 업로드된 원본파일 이름을 구함(중복 처리 전 이름)
		
		rootid = multi.getParameter("rootid");//원글 번호
		relevel = multi.getParameter("relevel");//답글 수준
		refile1 = multi.getParameter("refile1");//원래 첨부파일
		String imgurl = request.getParameter("img");
	 
		int relevellength;
		relevellength = relevel.length(); //길이 
		
		//답글의 relevel구하기
		String newrelevel = null; //a, aa, ab, aaa, aab, aac...
		ResultSet rset = null;
		rset = stmt.executeQuery("select id, rootid, relevel from gongjee where rootid = "+rootid+" "+
		"and length(relevel) = "+(relevellength+1)+" and relevel like '"+relevel+"%' order by relevel;");
				//rootid가 rootid이고, relevel의 길이는 relevellength+1이고 relevel**인 문구 select
		while(rset.next()){
			newrelevel = rset.getString(3);
		}
		if (newrelevel == null){ //원글에서 첫번째 수준 답글을 달았을 경우에는 그냥 a붙여주기
			newrelevel = relevel + 'a';
		} else {
			newrelevel = newrelevel.substring(relevellength, relevellength+1); //0자리부터 시작하므로 제일 끝자리를 구하고싶으면 길이+1
			char alpha = newrelevel.charAt(0); //index로 주어진 값에 해당하는 문자를 리턴, 0=제일 첫 번째문자
			int ialpha = (int)alpha; //알파벳의 아스키코드 (ex: a=97, b=98, ~ , z=122)
			
			int ialpha2 = ialpha+1; //그 다음 알파벳을 구해야하므로 아스키코드숫자 +1
			char rerelevel = (char)ialpha2; //그 숫자를 다시 문자로 변환
			
			newrelevel = relevel + rerelevel; //ex: a+a=aa, 
		}	
		//실행
		ResultSet rset2 = null;
		
		//입력처리
		if( id == null && rootid != null ){
		stmt.execute("insert into gongjee (title, date, content, rootid, relevel, url1) "+
					"values ('"+title+"', '"+sdt.format(cal.getTime())+"','"+content+"', "+rootid+", '"+newrelevel+"','"+fileName1+"');");
		rset2 = stmt.executeQuery("select * from gongjee where id = (select max(id) from gongjee);");
		}else//수정처리
		if( id != null && rootid != null ){
		ID = Integer.parseInt(id);
			if(fileName1 == null){
				fileName1 = refile1;
			}
		stmt.execute("update gongjee set title = '"+title+"', content='"+content+"', url1='"+fileName1+"' where id = "+ID+";");
		rset2 = stmt.executeQuery("select * from gongjee where id = "+ID+";");
		}
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
		<%!String title;
	   String content;
	   String img;%>
	</head>
	
	<body>
		<br>
		<h3 align=center>-*-*-*-*-*-*-　　답글 완료!　　-*-*-*-*-*-*-</h3>
		<table class=mytable align=center>
		<%
			int newID = 0;
			while(rset2.next()){
				out.println("<tr><th width=70px bgcolor=#babaff name=id>번호</th>");
				out.println("<td>"+rset2.getInt(1)+"</td></tr>");
				newID = rset2.getInt(1);
				
				out.println("<tr><th width=70px bgcolor=#babaff>제목</th>");
				out.println("<td>"+rset2.getString(2)+"</td></tr>");
				
				out.println("<tr><th width=70px bgcolor=#babaff>날짜</th>");
				out.println("<td>"+rset2.getDate(3)+"</td></tr>");
				
				out.println("<tr><th width=70px height=200px bgcolor=#babaff>내용</th>");
				out.println("<td>"+rset2.getString(4)+"");
				if (rset2.getString(8) == null || rset2.getString(8).equals("null")){
					out.println("");
				}else{
					out.println("<img height=300px src='"+rset2.getString(8)+"'>");
				}
				out.println("</td></tr>");
			
				out.println("<tr><th width=70px bgcolor=#babaff>원글 번호</th>");
				out.println("<td>"+rset2.getInt(6)+"</td></tr>");
				
				out.println("<tr><th width=70px bgcolor=#babaff>댓글 수준</th>");
				out.println("<td>"+rset2.getString(7).length()+"</td></tr>");
			}
			rset.close();
			rset2.close();
			stmt.close();
			conn.close();
		%>
		</table>
		<table align=center style=margin-top:10px>
			<tr>
				<td width=500px></td>
				<td align=right ><button type="button" onclick="location.href='gongjee_list.jsp'">목록</button></td>
				<!--<td align=right >
				<button type="button" onclick="location.href='gongjee_update.jsp?key=<%=newID %>&title=<%=title %>&content=<%=content %>&img=<%=img %>'">수정  -->
				</button></td>
			</tr>		
		</table>	
		<%
		//}catch(Exception e){
		//	out.println("<p align=center>답글 등록 오류가 발생하였습니다.</p>");
		//}
		%>		
	</body>
</html>