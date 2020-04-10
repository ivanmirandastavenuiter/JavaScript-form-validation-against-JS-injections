<%@ page 
	buffer="8kb" 
	autoFlush="true"
	contentType="text/html; charset=UTF-8"
	errorPage="whatever"
	isErrorPage="false"
	info="absolutely useless info"
	isThreadSafe="true"
	language="java" 
	session="true"
	isELIgnored="false"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Page directive</title>
</head>
<body>

	<h1>This is the page directive</h1>
	
	<p><b>buffer:</b> set to 8kb by default. The less the better. It is a temporay memory where data is stored. 
	It handles the data transferring from the jsp engine to the client. Exception will be thrown if autoflush is set to false. Value in Kb.</p>
	
	<p><b>autoFlush:</b> controls the behavior of the output stream buffer. Values: true/false.</p>
	
	<p><b>contentType:</b> Defines the character coding scheme. Values: </p>
	
	<ul>
		<li>For mime types: <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types">https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types</a></li>
		<li>For coding schemes: ISSO 8858 1 (ISO LATIN 1), US-ASCII and UTF-8 are widely used. Later ISSO 8859 1 is ISO 8859-15. More are: ISO 10646.</li>
	</ul>
	
	<p><b>errorPage:</b> Defines the url of another JSP that reports on Java unchecked runtime exceptions. Value: url of error page.</p>
	
	<p><b>isErrorPage:</b> defines if this page has been referenced by other jsp file as an error page file. Values: true/false.</p>
	
	<p><b>extends:</b>it specifies a superclass that generated servlet must extend. Value: the class name</p>
	
	<p><b>import:</b> equivalent to java import clause. Value: package and class name.</p>
	
	<p><b>info:</b> defines a string that can be accessed with the servlet getServletInfo() method. Value: whatever</p>
	
	<p><b>isThreadSafe</b> defines threading model for generated servlet. Value: true/false. </p>
	
	<p><b>language:</b> the programming language used in the jsp file. Value: name of the language.</p>
	
	<p><b>session:</b> defines whether the jsp file participates in http sessions. Values: true/false.</p>
	
	<p><b>isELIgnored:</b> defines if the EL expression will be ignored or not in JSP page. Values: true/false.</p>
	
	<p><b>pageEncoding: </b> defines the charset for the page. Value: charset.</p>

</body>
</html>