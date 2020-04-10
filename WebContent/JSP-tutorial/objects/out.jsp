
<%@ page 
	contentType="text/html; charset=UTF-8"
	language="java" 
    pageEncoding="UTF-8"
    import = "java.util.logging.*, dummy.JspLogger, java.util.Enumeration, javax.servlet.*"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Out object</title>
</head>
<body>

	<h1>This is the page for output object</h1>
	
	<h2>Info</h2>
	
	<p>Instance of <%= out.getClass().getName()%></p>
	<p><b>This class inherits/extends class Writer.</b></p>
	
	<h3>Properties</h3>
	
	<p><b>autoFlush: </b> If it is autoflushing or not. Protected.</p>
	<p><b>bufferSize: </b>Protected.</p>
	<p><b>DEFAULT_BUFFER: </b> autoflushing true and using default buffer size. <%=JspWriter.DEFAULT_BUFFER%></p>
	<p><b>NO_BUFFER</b>. <%=JspWriter.NO_BUFFER%></p>
	<p><b>UNBOUNDED_BUFFER</b>. <%=JspWriter.UNBOUNDED_BUFFER%></p>
	
	<h3>Methods</h3>
	
	<p><b>clear(): </b> Cleans the buffer. It leaves the screen blank.</p>
	<p><b>close(): </b> finish the out object cleaning the flush before.</p>
	<p><b>getBufferSize(): </b> <%=out.getBufferSize()%></p>
	<p><b>flush(): </b> flush the stream. <% out.flush(); %></p>
	<p><b>println(): </b> it just prints. <% out.println("Printing here"); %></p>s
	
</body>
</html>