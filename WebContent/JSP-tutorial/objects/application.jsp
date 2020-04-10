
<%@ page 
	contentType="text/html; charset=UTF-8"
	language="java" 
    pageEncoding="UTF-8"
    import = "java.util.logging.*, 
		      dummy.*,
		      java.util.Enumeration,
		      javax.servlet.*,
		      javax.servlet.Filter,
		      org.apache.catalina.core.ApplicationContextFacade"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Application object</title>
</head>
<body>

	<h1>This is the page for application object</h1>
	
	<h2>Info</h2>
	
	<p>Instance of <%=application.getClass().getName()%></p>
	<p><b>It implements interfaces ServletContext</b></p>
	
	<p><b>addFilter(): </b> it adds a filter to the context.</p>
	<span style="color: red; font-weight: bold;">This class accepts and returns a class type Filter.</span>
	<p>More information on this: it returns FilterRegistration.Dynamic interface, which is a subclass of FilterRegistration interface.
	</p>
	<span style="color: red; font-weight: bold;">And it has 3 overloads: with a class inherited from Filter, a Filter, and a class name.</span>
	<p>It does filtering tasks on response or request.</p>

	<%
	
		// out.println(new NFilter().getClass().getName());

		// application.addListener(new NListener());
		
		out.println(application.getFilterRegistrations());
		
		// This throws an exception saying filters cannot be added to context if this one is initialized
	%>
	
	<p><b>addListener(): </b> it adds a listener to the context.</p>
	<p><b>addServlet(): </b> it adds a listener to the context.</p>
	<p><b>createFilter()</b></p>
	<p><b>createListener()</b></p>
	<p><b>createSerlet()</b></p>
	
	
	
</body>
</html>