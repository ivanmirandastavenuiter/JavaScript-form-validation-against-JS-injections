<%@ page 
	contentType="text/html; charset=UTF-8"
	language="java" 
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Include directive</title>
</head>
<body>

	<h1>This is the include directive</h1>
	
	<p>Similar to other includes, like php ones. What this tag does is merging the content in the indicated files with the current page.
	This way, include tags can be located in any part of the code.</p>
	
	<%@ include file = "page.jsp" %>
	
</body>
</html>