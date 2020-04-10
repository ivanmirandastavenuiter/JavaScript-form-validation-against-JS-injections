<%@ page 
	contentType="text/html; charset=UTF-8"
	language="java" 
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP actions</title>
</head>
<body>

	<h1>This is the JSP actions page</h1>
	
	<p>JSP actions have two attributes: id and scope</p>
	
	<ul>
		<li>Id: it uniquely identifies the Action element.</li>
		<li>Scope: it identifies the lifecycle of the action element. The scope attribute has four possible values:
		page, request, session and application.</li>
	</ul>
	
	<div class="action-container">
		<h2>jsp:include</h2>
		<p>Includes a file at the time the page is requested. It has two attributes: page and flush. Page is the relative path to 
		the file and flush is true or false for flushing the buffer.</p>
		<jsp:include page = "actions-resources/include.jsp" flush = "true" />
	</div>
	
	<div class="action-container">
		<h2>jsp:useBean</h2>
		<p>Beans are supposed to be objects containing other objects. This action searches an object for id and scope. If it does not
		get it, then it tries to create it. jsp:setProperty and jsp:getProperty can be used with these ones. At the end, it is like a normal
		import. Type, class, and beanName are really the same. It has three attributes:
		</p>
		
		<ul>
			<li>class: full name of the bean.</li>
			<li>type: type of the variable that will refer to the object.</li>
			<li>beanName: name of the bean.</li>
			
		</ul>
		
		<strong>Keep an eye on this: do not declare beanName and class. Both don't work...</strong>
		
		<jsp:useBean id = "obj" class = "java.util.Date" type="java.util.Date"/>
		
		<p>Current minutes: <%= obj.getMinutes() %></p>
		
	</div>
	
	<div class="action-container">
		<h2>jsp:setProperty</h2>
		<p>Sets the property of a bean. This can be done in two ways: </p>
		
		<ul>
			<li><b>Outside the useBean action:</b> here it is executed either if bean has been instantiated or just found.</li>
			<li><b>Inside the useBean action:</b> here it is executed only when the bean has been instantiated.</li>
		</ul>
		
		<%-- 
		<p>Outside the bean: </p>
		<jsp:setProperty name = "obj" property = "color" value = "red"/>
		<p>Inside the bean: </p>
		<jsp:useBean id = "obj2" class = "java.util.Date" type="java.util.Date">
		   <jsp:setProperty name = "obj2" property = "color" value = "red"/>
		</jsp:useBean> 
		--%>
		
		<p>Parameters are: </p>
			<ul>
				<li>Name: the name of the bean</li>
				<li>Property: the name of the property</li>
				<li>Value: the value that will be assigned previous property</li>
				<li>Parameter: the name of request parameter whose value the property is about to receive</li>
			</ul>
		
		<strong>Keep an eye on this: do not declare vale and parameter. Both don't work... It makes no sense...</strong>
		<strong>Also important: this works only if property is already set in the bean.</strong>
	</div>
	
	<div class="action-container">
		<h2>jsp:getProperty</h2>
		<p>The opposite of the setProperty: it returns the value of the property. It has only two attributes: name and property,
		being these ones the bean and the property.</p>
		
		<%-- <jsp:getProperty name = "myName" property = "someProperty" .../> --%>
	</div>
	
	<div class="action-container">
		<h2>jsp:forward</h2>
		<p>Terminates the action in the current page and makes a redirect to another. Only one attribute: page (url)</p>
		
		<%-- <jsp:forward page = "theage.jsp" /> --%>
	</div>
	
	<div class="action-container">
		<h2>jsp:pluging</h2>
		<p>It inserts java components into a JSP page. It determines the type of the browser and inserts object or embed tags
		as needed. If plugin is not present, it downloads it and executes the Java component. This component can be an Applet
		or a JavaBean.</p>
		<p>It has several attributes that correspond to HTML common tags used to format Java components. The param element can also
		be used to send params to the Applet or Bean.</p>
		
		<p>The attributes: </p>
		<ul>
			<li>type: tpye of component: applet or bean.</li>
			<li>code: class name of the applet or JavaBean.</li>
			<li>codebase: base url that contains files of the component</li>
			<li>align: alignment. Possible values: left, right, top, middle, bottom.</li>
			<li>archive: a list of JAR files which contain classes and resources required by the component.</li>
			<li>height, width</li>
			<li>hspace, vspace: horizontal/vertical space between components and rest of elements.</li>
			<li>jreversion</li>
			<li>name: name for the component.</li>
			<li>title: title for the component.</li>
			<li>nspluginurl, iepluginurl: jre downloads for netscape and ie.</li>
			<li>mayscript: true or false for scripting.</li>
		</ul>
		
		<p>Apart from these, it has also: </p>
		<ul>
			<li>Fallback: it sends error messages.</li>
			<li>jsp:element, jsp:attribute, jsp:body: they generate XML elements dynamically.</li>
		</ul>
		
		<%-- <jsp:plugin type = "applet" codebase = "dirname" code = "MyApplet.class"
		   width = "60" height = "80">
		   <jsp:param name = "fontcolor" value = "red" />
		   <jsp:param name = "background" value = "black" />
		 
		   <jsp:fallback>
		      Unable to initialize Java Plugin
		   </jsp:fallback>
		 
		</jsp:plugin> --%>
		
		<%-- <jsp:element name = "xmlElement">
	         <jsp:attribute name = "xmlElementAttr">
	            Value for the attribute
	         </jsp:attribute>
	         
	         <jsp:body>
	            Body for XML element
	         </jsp:body>
	      
	     </jsp:element> --%>
		
	</div>
	
	<div class="action-container">
		<h2>jsp:text</h2>
		<p>It can be used to write the template text in JSP pages and documents.</p>
	</div>
	
</body>
</html>