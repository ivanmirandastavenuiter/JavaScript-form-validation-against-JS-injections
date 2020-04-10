<%@ page 
	contentType="text/html; charset=UTF-8"
	language="java" 
    pageEncoding="UTF-8"
    import = "java.util.logging.*, dummy.JspLogger, java.util.Enumeration, javax.servlet.*, java.util.Date"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Session object</title>
</head>
<body>

	<h1>This is the page for session object</h1>
	
	<h2>Info</h2>
	
	<p>Instance of <%= session.getClass().getName()%></p>
	<p><b>It implements interfaces HttpSession interface.</b></p>
	
	<p><b>getAttribute(String name): </b> gets the named attribute.</p>
	<p><b>getAttributes(): </b></p>
	
		<ul>
	
		<% 
		
		// Iteration over Enumerations
		
		Enumeration<String> attributes = session.getAttributeNames();	 
		while (attributes.hasMoreElements()) { 
			%><li><% 
			out.println(attributes.nextElement());
			%></li><%
		}
		
		%>
		
		</ul>
		
	<p><b>getCreationTime(): </b> 
	
		<%
		
			Date date = new Date(session.getCreationTime());
			out.println(date);
			
		%>
	
	</p>
	
	<p><b>getId(): </b><%=session.getId()%></p>
	<p><b>getLastAccessedTime(): </b>
	
	<%
		
		Date lastSessionDate = new Date(session.getLastAccessedTime());
		out.println(lastSessionDate);
		
	%>
		
	</p>
	
	<p><b>getLastAccessedTime(): </b> Maximum inactive time in seconds: <%=session.getMaxInactiveInterval() %></p>
	
	<p><b>getServletContext(): </b> returns a ServletContext object. In JSP, it is an implicit object, called application.</p>
	<p><b>invalidate(): </b> breaks the session.</p>
	<p><b>isNew(): </b> True if it is the first time the server sees the user.<%=session.isNew() %></p>
	<p><b>setAttribute(String key, Object value): </b> to create the attributes.</p>
	<p><b>setMaxInactiveInterval(int interval): </b> sets whatever maximum time session exists while inactive.</p>
	
</body>
</html>