﻿<!--#include file="../src/syQuery.asp" -->
<!--#include file="../src/syQuery.md5.asp" -->
<!--#include file="../src/syQuery.sha1.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
</head>
<body>
<ul>
<%
$.execute("md5,sha1", function(md5, sha1){
	$.echo(md5("123456adsfds") + " : " + md5("123456adsfds").length);
	$.echo("<br />")
	$.echo(sha1("123456adsfds") + " : " + sha1("123456adsfds").length);
})
%>
</ul>
</body>
</html>