﻿<!--#include file="../src/syQuery.asp" -->
<!--#include file="../src/syQuery.xmlhttp.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../../jQueryFrameWork/jQuery.1.6.2.js" ></script>
<script src="../../jQueryFrameWork/jQuery.loader.js" ></script>
<title>无标题文档</title>
</head>
<body>
<%
	$.execute("xmlhttp", function(X){
		var ajax = new X();
		ajax.url("http://syquery.cn/syQuery3.0/docs/api.asp").data({
			a : "123",
			b : "456",
			c : "789"
		}).subCore("onSuccess", function(xhr){
			$.echo(xhr.responseBody);
		}).send().abort();
	});
%>
</body>
</html>