<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="java.sql.*"%>  

<html>
<HEAD><TITLE>Let's eat DB inside Firewall!!!!</TITLE></HEAD>
  
<STYLE>  
        TD {font-size:9pt;font-family:����;}
        TH {font-size:9pt;font-family:����;}     
</STYLE>

<body> 
<H3><center>Let's eat DB inside Firewall!!!!</center></H3><br>

<% 
//�Ѱܹ޴� Parameter
  String query = request.getParameter("query");
  String url = request.getParameter("url");
  String id  = request.getParameter("id");
  String pass = request.getParameter("pass");


//�ʱ�ε��� �����ִ� ȭ�� - url,id,password��  �Էµ��� �ʾ���  

if( (url==null || url.equals("")) || (id==null || id.equals("")) )
  {  
  
 %>
 <SCRIPT LANGUAGE='JavaScript'>
	function check_form(){
		if(document.db_form.url.value==''){
			alert('Connection String�� �Է��ϼ���.');
			document.db_form.url.focus();
			return false;
	         	}
		if(document.db_form.id.value==''){
			alert('id�� �Է��ϼ���');
			document.db_form.id.focus();
			return false;
	         	}
	           if(document.db_form.pass.value==''){
	 		alert('�н����带 �Է��ϼ���');
	  		document.db_form.pass.focus();
			return false;
                   }
  
	    }
</SCRIPT>
 <form  name=db_form method=post onsubmit="return check_form()">
   Connection String:<input type=text name=url size=60><br>
   ex)jdbc:oracle:thin:@DB����IP:�����Ʈ:SID----> ��:jdbc:oracle:thin:@11.4.8.116:1521:CERT<br><br>
   �����ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=text name=id size=15><br>
   �н�����:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=password name=pass size=15> <input type=submit value="����!!!!!">&nbsp;<INPUT type=reset value='reset'>     

 </form> 
    
 <%

   
 }   //if������ ��
   
   
else{   

//�ʱ�ε� �Ǵ� query���� ���� ���  ���̺� ����� �����ش�.  

   if( query == null || query.equals(""))
    {
	   query= "select * from tab";
    }


  
   int column_num=0;    //Query�� Result set�� Column ����
   int num=0;           //Query �� Resultset�� Record ��


// DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
//-- �������
//	 Class.forName("com.sybase.jdbc2.jdbc.SybDriver");			//sybase ����̹�
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
    ����� ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp<input type=text name=id value=<%=id%> size=15><br>
    �н�����:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp<input type=password name=pass value=<%=pass%> size=15><br><br>
    Query: <input type=text name=query size=100> 
           <input type=submit value=Query����>          

   
  </form><hr>    
<%   
   try{
          stmt = conn.createStatement();  
          rs = stmt.executeQuery(query); 
          out.println("<b>Executed Query:</b>" + query);       
          out.println("<hr>"); 
          
//ResultSet�� Table�� ǥ���ϱ� ���� table�� �׸���.   
      
          out.println("<table border=1 cellspacing=0  bordercolordark=white bordercolorlight=black bgcolor=white >");


//Query����� ������ ResultSet�� Resultset Metadata�� ��ȯ
      
        if( rs.next()){
         RS_META = rs.getMetaData();
         column_num = RS_META.getColumnCount();
         
//ResultSet Column ������ ��´�.
          out.println("<tr bgcolor=#999999>");
           for(int i=1;i<= column_num;i++)
               { 
                out.print("<td >");
                out.print(RS_META.getColumnName(i)); 
                out.println("</td>"); 
               }
          out.println("</tr>");   
            
 //ResultSet �� ù��° ���� ��´�.        
         out.println("<tr>");           
             
              for(int i=1;i<= column_num;i++)
                { 
                  out.print("<td >");
                  
            //�ѱ� Encoding�� ���� ó��      
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


 //ResultSet�� ������ ����� �� ��´�.      
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
       
      } //try������ ��
      
      catch( Exception e)
		{
		  out.println(e);
	    }
	finally
		{              
               conn.close();
	} 
      
}  //else������ ��.   
%> 

</body></html>
