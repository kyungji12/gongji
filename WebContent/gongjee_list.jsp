<meta http-equiv="Content-Type" content="text/8html; charset=utf-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.text.SimpleDateFormat,java.util.Calendar" %>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>글 리스트</title>
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
		
	//DB연결
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo14","root","ykj0112");
	Statement stmt = conn.createStatement();	
	
	//자료 읽어오기용 변수
	int LineCnt = 0;
	int fromNum = 0;
	int toNum = 0;
	int toCnt = 0; 
	String fromTemp;
	String toTemp;
	
	//값 받기
    fromTemp = request.getParameter("from"); //from이라는 이름은 내가 지정해준 것 
	toTemp = request.getParameter("cnt"); //몇개까지 값을 받았는지.
	
  	//최초에 받은 값이 없을 때
    if(fromTemp == null && toTemp == null){
        fromNum = 1; //제일 처음 값
        toCnt = 10;
    }else{  //(만약 받은 값이 있다면)페이지 이동 번호를 눌렀다면 그 값을 페이지 이동 값으로 보내줘야함
        fromNum = Integer.parseInt(fromTemp); //받은 String값을 Int값으로
    	toCnt = Integer.parseInt(toTemp);
    }toNum = fromNum + toCnt;
	
	//페이징용 변수
	final int firstPage_firstNum = 1; //맨 첫 페이지의 번호 
    int firstNum = 1; //각 페이지의 첫 항목의 번호 
    int prevPage_firstNum = 0; //이전 페이지용 
    int nextPage_firstNum = 0; //다음 페이지용
    int lastPage_firstNum = 0; //마지막 페이지용
    int totalLineCnt = 0; //데이터의 전체 라인 수 (마지막 페이지용)
	
    ResultSet rset2 = stmt.executeQuery("select * from gongjee;");
	while(rset2.next()){
		totalLineCnt++;
	}
	
	//각 페이지의 첫 번째 링크 숫자
    String getFirstLink = request.getParameter("sendFirstLink");
    if(getFirstLink != null){
        firstNum = Integer.parseInt(getFirstLink);
    }
    //마지막p 첫 링크 번호 구하기 (총라인 몇개 산정하고 식을 도출해내는 식으로 구함)
    lastPage_firstNum = ((int)(totalLineCnt/100)*10)+1;
    if (totalLineCnt == 100) lastPage_firstNum = 1; //위의 식에서 나올 오류의 예외처리용

    //이전 페이지 이동
    prevPage_firstNum = firstNum-10; 

    //다음 페이지 이동
    nextPage_firstNum = firstNum+10; 

  	//값 읽어오기
  	ResultSet rset = stmt.executeQuery("select id, relevel, title, date, viewcnt, rootid from gongjee order by rootid desc, relevel asc;");
	
	%>
	</head>
	<body>
	<br>
	<h3 align=center>-*-*-*-*-*-*-　　전체 글 목록　　-*-*-*-*-*-*-</h3>
		<table class=mytable align=center>
			<tr>
				<td width=50 bgcolor=#babaff><p align=center>번호</p></td>
				<td width=400 bgcolor=#babaff><p align=center>제목</p></td>
				<td width=50 bgcolor=#babaff><p align=center>조회수</p></td>
				<td width=100 bgcolor=#babaff><p align=center>등록일</p></td>
			</tr>
	
		<%
		while(rset.next()){
            LineCnt++;
              if(LineCnt < fromNum){continue;}
              if(LineCnt >= toNum){break;}
            out.println("<tr>");
            out.println("<td width=40 align=center>"+rset.getInt(1)+"</td>");
            out.println("<td>"); //제목시작
            String relevel = rset.getString(2);
            int relevellength = relevel.length() ; //relevellength=0 : 원글
            if(relevellength != 0){ //원글이 아니라면
               while(relevellength != 0) {
                  out.print("　"); 	//한칸씩 밀려서 답글의 제목이 달린다. 
                  relevellength --;
               }
               out.print("[RE] "); //답글이 달렸을 경우에는 제목 앞에 [RE]로 표시한다.
            }
            
			out.println("<a class=no_line href=gongjee_view.jsp?key="+rset.getInt(1)+">"+rset.getString(3)+"</a>");
			
			if(sdt.format(cal.getTime()).equals(rset.getString(4))){
				//오늘날짜를 구해와서 그것이 rset.getString(4)인 column 'date'와 일치할 경우
				out.println("<img src='new.JPG'>"); //새 글이 올라왔을 경우에는 'new'image를 제목 뒤에 붙인다. 
			}
			out.println("</td>"); //제목 끝
			out.println("<td width=50><p align=center>"+rset.getInt(5)+"</p></td> "); //조회수
			out.println("<td width=100><p align=center>"+rset.getDate(4)+"</p></td>"); //등록일
			out.println("</tr>");
		}
		rset.close();
		stmt.close();
		conn.close();	
		%>
		</table>
		<table align=center style=margin-top:10px>
			<tr>
				<td width=640></td>
				<td align=right ><button type="button" onclick="location.href='gongjee_insert.jsp'">쓰기</button></td>
			</tr>		
		</table>
		
		<%--페이지 수 만들기--%>
        <table  align="center">
            <tr id="Ltr">
                <%if(firstNum != 1){%>
             <%-- 제일 첫 페이지로 이동 --%>
                <td>
                    <a class=no_line href ="gongjee_list?sendFirstLink=<%=firstPage_firstNum%>">≪</a>
                </td>
                <%-- 이전 페이지로 이동 --%>
                <td>
                    <a class=no_line href ="gongjee_list?sendFirstLink=<%=prevPage_firstNum%>&from=<%=prevPage_firstNum*10-9%>&cnt=10">＜</a>
                </td>
                <%}%>
                
                <%-- 10쪽씩만 보이도록 처리 --%>
                <%
                    for(int i=firstNum; i<firstNum+10; i++){
                        //더이상 나올 데이터가 없을 경우 페이지 번호도 보이지 않는다
                        if((i*10)-9 > totalLineCnt) break;
                        out.print("<td>");
                        out.print("<a class=no_line href=gongjee_list.jsp?sendFirstLink="+firstNum+"&from="+((i*10)-9)+"&cnt=10>"+i+"</a>");
                        out.print("</td>");
                    }
                %>
                <%if((firstNum+9)*10 < totalLineCnt){%>
                        
                <%-- 다음 페이지로 이동 --%>
                <td>
                    <a class=no_line href ="gongjee_list?sendFirstLink=<%=nextPage_firstNum%>&from=<%=nextPage_firstNum*10-9%>&cnt=10">＞</a>
                </td>
                <%-- 제일 마지막 페이지로 이동 --%>
                <td>
                    <a class=no_line href ="gongjee_list?sendFirstLink=<%=lastPage_firstNum%>&from=<%=lastPage_firstNum*10-9%>&cnt=10">≫</a>
                </td>

                <%}%>
            </tr>
            </table>
		
		<%
		}catch(Exception e){
			out.println("<p align=center>등록된 글이 없습니다.</p>");
		}
		%>		
	</body>
</html>