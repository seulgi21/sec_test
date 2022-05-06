<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="java.sql.*"%>  

<html>
<HEAD><TITLE>Let's eat DB inside Firewall!!!!</TITLE></HEAD>
  
<STYLE>  
        TD {font-size:9pt;font-family:돋움;}
        TH {font-size:9pt;font-family:돋움;}     
</STYLE>

<body> 
<H3><center>Let's eat DB inside Firewall!!!!</center></H3><br>

<% 
//넘겨받는 Parameter
  String query = request.getParameter("query");
  String url = request.getParameter("url");
  String id  = request.getParameter("id");
  String pass = request.getParameter("pass");


//초기로딩시 보여주는 화면 - url,id,password가  입력되지 않았음  

if( (url==null || url.equals("")) || (id==null || id.equals("")) )
  {  
  
 %>
 <SCRIPT LANGUAGE='JavaScript'>
	function check_form(){
		if(document.db_form.url.value==''){
			alert('Connection String을 입력하세요.');
			document.db_form.url.focus();
			return false;
	         	}
		if(document.db_form.id.value==''){
			alert('id를 입력하세요');
			document.db_form.id.focus();
			return false;
	         	}
	           if(document.db_form.pass.value==''){
	 		alert('패스워드를 입력하세요');
	  		document.db_form.pass.focus();
			return false;
                   }
  
	    }
</SCRIPT>
 <form  name=db_form method=post onsubmit="return check_form()">
   Connection String:<input type=text name=url size=60><br>
   ex)jdbc:oracle:thin:@DB서버IP:사용포트:SID----> 예:jdbc:oracle:thin:@11.4.8.116:1521:CERT<br><br>
   사용자ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=text name=id size=15><br>
   패스워드:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=password name=pass size=15> <input type=submit value="가자!!!!!">&nbsp;<INPUT type=reset value='reset'>     

 </form> 
    
 <%

   
 }   //if문장의 끝
   
   
else{   

//초기로딩 또는 query값이 없는 경우  테이블 목록을 보여준다.  

   if( query == null || query.equals(""))
    {
	   query= "select * from tab";
    }


  
   int column_num=0;    //Query한 Result set의 Column 개수
   int num=0;           //Query 한 Resultset의 Record 수


// DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
//-- 여기까지
//	 Class.forName("com.sybase.jdbc2.jdbc.SybDriver");			//sybase 드라이버
//     Class.forName("oracle.jdbc.driver.OracleDriver"); 
//   Class.forName("com.inet.tds.TdsDriver");
   Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
//   Class.forName("org.gjt.mm.mysql.Driver");
   
   Connection conn = DriverManager.getConnection(url,id,pass);  
   Statement stmt=null;
   ResultSet rs=null;
   ResultSetMetaData RS_META=null;
  
%>

  <form  method=post>
    Connection String:<input type=text name=url value=<%=url%> size=60><br>
    사용자 ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp<input type=text name=id value=<%=id%> size=15><br>
    패스워드:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp<input type=password name=pass value=<%=pass%> size=15><br><br>
    Query: <input type=text name=query size=100> 
           <input type=submit value=Query실행>          

   
  </form><hr>    
<%   
   try{
          stmt = conn.createStatement();  
          rs = stmt.executeQuery(query); 
          out.println("<b>Executed Query:</b>" + query);       
          out.println("<hr>"); 
          
//ResultSet을 Table로 표시하기 위해 table을 그린다.   
      
          out.println("<table border=1 cellspacing=0  bordercolordark=white bordercolorlight=black bgcolor=white >");


//Query결과가 있으면 ResultSet을 Resultset Metadata로 변환
      
        if( rs.next()){
         RS_META = rs.getMetaData();
         column_num = RS_META.getColumnCount();
         
//ResultSet Column 제목을 찍는다.
          out.println("<tr bgcolor=#999999>");
           for(int i=1;i<= column_num;i++)
               { 
                out.print("<td >");
                out.print(RS_META.getColumnName(i)); 
                out.println("</td>"); 
               }
          out.println("</tr>");   
            
 //ResultSet 의 첫번째 행을 찍는다.        
         out.println("<tr>");           
             
              for(int i=1;i<= column_num;i++)
                { 
                  out.print("<td >");
                  
            //한글 Encoding을 위한 처리      
                  String str1=rs.getString(i);
                    if(str1==null)
                      { str1="-";}
                  String str2= new String(str1.getBytes("8859_1"),"euc-kr");
                  out.print(str2);
                  out.println("</td>"); 
                } 
                                    
             out.println("</tr >");       
             num++;         
            
        }
        else{ out.println("No Record was Found!!!");
        }


 //ResultSet의 나머지 행들을 다 찍는다.      
        while(rs.next()){            
             out.println("<tr >");            
              for(int i=1;i<= column_num;i++)
                { 
                  out.print("<td >");
                 String str1=rs.getString(i);
                    if(str1==null)
                      { str1="-";}
                  //String str2= new String(str1.getBytes("8859_1"),"KSC5601");
		  String str2= new String(str1.getBytes("8859_1"),"euc-kr");
                  out.print(str2);
                  out.println("</td>"); 
                 } 
                                     
             out.println("</tr >");        
                            
             num ++;           
         }
       
       out.println("</table>"); 
       out.println("<HR>"); 
       out.println("<h3> total  "+ num + " records</h3>"); 
       rs.close();  
       
      } //try문장의 끝
      
      catch( Exception e)
		{
		  out.println(e);
	    }
	finally
		{              
               conn.close();
	} 
      
}  //else문장의 끝.   
%> 

</body></html>
