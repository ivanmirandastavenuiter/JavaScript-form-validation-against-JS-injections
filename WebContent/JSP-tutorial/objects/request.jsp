
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
<title>Request object</title>
</head>
<body>

	<h1>This is the page for request object</h1>
	
	<h2>Info</h2>
	
	<p>Instance of <%= request.getClass().getName()%></p>
	<p><b>It implements interfaces HttpServletRequest and ServletRequest</b></p>
	
	<ul>
		<li><%=HttpServletRequest.BASIC_AUTH%></li>
		<li><%=HttpServletRequest.CLIENT_CERT_AUTH%></li>
		<li><%=HttpServletRequest.DIGEST_AUTH%></li>
		<li><%=HttpServletRequest.FORM_AUTH%></li>
	</ul>	
	
	<%
		Logger logger = Logger.getLogger(JspLogger.class.getName());
	%>
	
	<p><b>getAuthType(): </b> <%= request.getAuthType() %></p>
	<p><b>getContextPath(): </b> <%= request.getContextPath() %></p>
	<p><b>getCookies(): </b></p>
	
		<ul>
		
		<%
		
		Cookie[] cookies = request.getCookies();
		
		for (Cookie cookie : cookies) {
			%><li><%
			out.println("Name: " + cookie.getName() + " | Value: " + cookie.getValue());
			%></li><%
		}
		
		%>
		
		</ul>
	
	<p><b>getDateHeader(String name): </b> <%= request.getDateHeader("headerhere") %></p>
	
	<p style="color: red;">This method returns fucking exception if you pass as argument a non-convertible to date header name. <b>IllegalArgumentException.</b></p>
	
	<p><b>getHeader(): </b> <%= request.getHeader("cookie") %></p>
	<p><b>getHeaderNames(): </b></p>
	
		<ul>
		
		<% 
		
		// Iteration over Enumerations
		
		Enumeration<String> headers = request.getHeaderNames();	 
		while (headers.hasMoreElements()) { 
			%><li><% 
			out.println(headers.nextElement());
			%></li><%
		}
		
		%>
		
		</ul>
		
	<p><b>getHeaders(): </b></p>
	
		<ul>
		
		<% 
		
		// Iteration over Enumerations
		
		Enumeration<String> headersValues = request.getHeaders("user-agent");	 
		while (headersValues.hasMoreElements()) { 
			%><li><% 
			out.println(headersValues.nextElement());
			%></li><%
		}
		
		%>
		
		</ul>
		
	<p><b>getIntHeader(): </b> <%= request.getIntHeader("upgrade-insecure-requests") %></p>
	
	<p style="color: red;">This method returns fucking exception if the header value cannot be converted to int. <b>NumberFormatException.</b></p>
	
	<p><b>getMethod(): </b> <%= request.getMethod() %></p>
	<p><b>getPathInfo(): </b> <%= request.getPathInfo() %></p>
	<p><b>getPathTranslated(): </b> <%= request.getPathTranslated() %></p>
	<p><b>getQueryString(): </b> <%= request.getQueryString() %></p>
	<p><b>getRemoteUser(): </b> <%= request.getRemoteUser() %></p>
	<p><b>getRequestedSessionId(): </b> <%= request.getRequestedSessionId() %></p>
	<p><b>getRequestURI(): </b> <%= request.getRequestURI() %></p>
	<p><b>getRequestURL(): </b> <%= request.getRequestURL() %>. <span style="color: red;">This method is useful for creating redirect messages and for reporting errors.</span></p>
	<p><b>getServletPath(): </b> <%= request.getServletPath() %></p>
	<p><b>getSession(): </b> This method returns an HttpSession object.</p>
	<p><b>getSession(boolean create): </b> This method returns an HttpSession object if there is no session and create is true.</p>
	<p><b>getUserPrincipal(): </b> <%= request.getUserPrincipal() %>. Devuelve java.security.Principal. </p>
	<p><b>isRequestedSessionIdFromCookie(): </b> <%= request.isRequestedSessionIdFromCookie() %></p>
	<p><b>isRequestedSessionIdFromURL(): </b> <%= request.isRequestedSessionIdFromURL() %></p>
	<p><b>isRequestedSessionIdValid(): </b> <%= request.isRequestedSessionIdValid() %></p>
	
	<h2>Most relevant methods inherited from ServletRequest</h2>
	
	<p><b>getAttribute(String name): </b> <%= request.getAttribute("name") %></p>
	<p><b>getAttributeNames(): </b></p>
	
		<ul>
		
		<% 
		
		// Iteration over Enumerations
		
		Enumeration<String> attributeNames = request.getAttributeNames();	 
		while (attributeNames.hasMoreElements()) { 
			%><li><% 
			out.println(attributeNames.nextElement());
			%></li><%
		}
		
		%>
		
		</ul>
	
	<p><b>getCharacterEncoding(): </b> <%= request.getCharacterEncoding() %></p>
	<p><b>getInputStream(): </b>This method returns an ServletInputStream object.</p>
	<p><b>getParameter(String name): </b> Most important method. Returns the parameter that matches string name or null if it does not find anything.</p>
	<p><b>getParameterMap(): </b> Returns a map with the parameters of this request</p>
	<p><b>getParameterNames(): </b> Returns a list with the parameter names.</p>
	<p><b>getReader(): </b> Returns the body of request as character data using BuffererReader object</p>
	<p><b>getScheme(): </b><%= request.getScheme() %></p>
	<p><b>getServerName(): </b><%= request.getServerName() %></p>
	<p><b>isSecure(): </b><%= request.isSecure() %></p>
	<p><b>removeAttribute(): </b> Removes the attribute from the request.</p>
	<p><b>setAttribute(String name, object attribute): </b> Sets an attribute for the request.</p>
	
	<h2>To extend</h2>
	
	<ul>
		<li>ServletInputStream(javax.servlet.ServletInputStream) - InputStream(java.io.InputStream)</li>
		<li>HttpSession</li>
		<li>Authentication through request. Method authenticate?</li>
	</ul>
	
</body>
</html>