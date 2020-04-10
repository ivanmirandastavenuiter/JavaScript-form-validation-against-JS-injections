
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
<title>Response object</title>
</head>
<body>

	<h1>This is the page for response object</h1>
	
	<h2>Info</h2>
	
	<p>Instance of <%= response.getClass().getName()%></p>
	<p><b>It implements interfaces HttpServletResponse and ServletResponse</b></p>
	
	<p><b>Static methods on HttpServletResponse: </b> returns error codes.</p>
	
	<p><b>addCookie(Cookie cookie): </b> adds specified cookie to the response.</p>
	<p><b>addHeader(String name, String value): </b> adds specified header to the response with name and value.</p>
	<p><b>encodeUrl(): </b> encodes URL with session id or unchanged if encoding is not needed.</p>
	<p><b>getHeader(String name), getHeaderNames(), getHeaders(): </b> they return a certain header, all header keys, and all header values, respectively.</p>
	<p><b>getStatus(): </b> <%= response.getStatus() %>. Status for the response.</p>
	<p><b>sendError(int sc): </b>Sends an error to the client using the specified status code and clears the buffer.</p>
	
	<%-- 	
	
		<%
		
		// To send an error with response 
		
		Logger logger = Logger.getLogger(JspLogger.class.getName());
		
		try {
			response.sendError(HttpServletResponse.SC_EXPECTATION_FAILED);
		} catch (Exception e) {
			logger.info(e.getMessage());
		}
		
		%> 
	
	--%>
	
	<p>Important note here: <span style="color: red;"><b>this method throws exception if used with expression tags. It must be used like normal java code.</b></span></p>
	<p>A little scheme to understand it better: </p>
	<ul>
		<li><\%=request.sendError(HttpServletResponse.SC_EXPECTATION_FAILED)%><span style="color: red;"><b>BAD!!!</b></span></li>
		<li>
			<\%
			<br>
			&emsp;request.sendError(HttpServletResponse.SC_EXPECTATION_FAILED);
			<br>
			%>
			<br>
			<span style="color: GREEN;"><b>GOOD!!!</b></span>
		</li>
	</ul>
	
	<p><b>sendError(int sc, String message): </b>same as before, but with sending additional message parameter.</p>
	<p><b>sendRedirect(String location): </b>sends a temporary redirect response to the client using the specified redirect location URL and clears the buffer</p>
	<p><b>setHeader(String name, String value): </b>sets a response header with the given name and value.</p>
	<p><b>setHeader(int sc): </b>sets the satus code for the response.</p>
	
	<h2>Most relevant methods inherited from ServletRequest</h2>
	
	<p><b>flushBuffer():</b> forces any content in the buffer to be written to the client.</p>
	<p><b>getBufferSize():</b> returns actual buffer size used for the response.</p>
	<p>Output would be: <%=response.getBufferSize()%>.</p>
	<p><b>getCharacterEncoding():</b> <%=response.getCharacterEncoding()%>. Returns character encoding set for the response.</p>
	<p><b>getContentType():</b> <%=response.getContentType()%>. Returns content type the response has.</p>
	<p><b>getOutputStream():</b> Returns a ServletOutputStream suitable for writing binary data in the response.</p>
	<p><b>getWriter():</b> Returns a PrintWriter object that can send characters to the client.</p>
	<p><b>isCommitted():</b> So important. It tells you if response has already been committed. Result: <%=response.isCommitted()%>.</p> 
	<p><b>reset():</b> Cleans any data that exists in the buffer as well as the status code and headers.</p> 
	<p><b>resetBuffer():</b> The same but only clearing the buffer.</p> 
	<p><b>setBufferSize(), setCharacterEncoding(), setContentType()...</b></p>
	
</body>
</html>