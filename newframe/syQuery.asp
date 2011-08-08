﻿<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
/**
 *	@ function source module
 *	@ param selector 	<object> data object
 *	@ param context  	<object> limited context
 *	@ param QueryRoot 	<object> 
 *	@ return <syQuery object>
 */
var $ = (function(){
	/**
	  *	@ function source module
 	  *	@ param selector 	<object> data object
 	  *	@ param context  	<object> limited context
 	  *	@ param QueryRoot 	<object> 
 	  *	@ return <syQuery object>
	 */
	var limitedKey = ["config", "ready", "error", "root", "charset", "createQuery", "merge", "mix", "augment", "type", "echo", "fn", "die", "isFunction", "isString", "isArray", "isObject", "isBoolean", "isNumber", "isDate", "isJson", "isQuery", "include", "add", "use", "execute"];
	var _Query = function( key, fn ){
		if ( _Query.isString( key ) ){
			if ( limitedKey.indexOf(key) == -1 )
			{
				// create syQuery object
				_Query[key] = function( selector, context ){
					return new _Query.fn.init( selector, context, fn );
				};
				limitedKey.push(key);
				// return the created object
				return _Query[key];
			}else{
				// add to error eqment
				_Query.error.push("syQuery error : key[" + key + "] exsit.");
			}
		}else if ( _Query.isFunction( key ) ) {
			// add to ready eqment
			_Query.ready.push( key );
		}
	}
	push = Array.prototype.push;
	
	_Query.addKey = function(key){
		if ( limitedKey.indexOf( key ) === -1 ) limitedKey.push( key );
	}
	
	/**
	  *	@ json for syQuery module setting
	 */
	_Query.config = {
		ActivexObject : {
			conn : "ADODB.CONNECTION",
			record : "ADODB.RECORDSET",
			fso : "Scripting.FileSystemObject",
			stream : "Adodb" + "." + "Stream",
			xmlhttp : "Microsoft.XMLHTTP",
			xml : "Microsoft.XMLDOM",
			winhttp : "WinHttp.WinHttpRequest.5.1"
		}
	}; // 框架设置
	_Query.ready = []; // 框架全局运行绑定代码列表
	_Query.error = []; // 框架全局错误绑定代码列表
	_Query.root = ""; // 框架运行物理地址相对于根地址偏移的位置
	_Query.charset = "utf-8"; // 框架编码
	_Query.plugin = "newframe"; // 相对于网站跟目录的地址，不带/ （只填文件夹）
	_Query.loaded = []; // 系统已经加载的其他模块名
	
	// syQuery 对象构造函数
	_Query.fn = _Query.prototype = {
		init : function( selector, context, fn ){
			var ret = _Query.createQuery( selector, this, context );
			if ( fn != undefined ) {
				var callback = fn.call(ret);
				if ( callback ) return callback;
			};
			return ret;
		}, // 初始化方法
		constructor : _Query, // 原型构造
		syQuery : "3.0", // 版本号
		length : 0, // 内容数量
		object : null, // 指针对象
		size : function(){ return this.length; } // 内容长度
	}
	
	_Query.createQuery = function( selector, ret, context ){

		if ( selector == undefined ) return ret;
		if ( this.isArray(selector) ){
			// 数组转化为syQuery对象
			return selector.toQuery( ret, context );
		}else if ( this.isObject(selector) ){
			var isBinary ;
			try{ selector.constructor; isBinary = true; }catch(e){ isBinary = false; }
			
			if ( this.isNumber( selector.length ) && (isBinary === true)  ){
				// 使用数组方法来转化为syQuery对象
				return Array.prototype.toQuery.call(selector, ret, context);
			}else{
				push.call(ret, selector);
				ret.object = context || null;
				return ret;
			}
		}else{
			push.call(ret, selector);
			ret.object = context || null;
			return ret;
		}
		
	}
	
	/**
	 * 为syQuery对象增加子项的方法
	 * ret <syQuery object> syQuery对象
	 * selector <anyObject> 数据
	 * object <object | null> 范围对象
	 */
	_Query.merge = function( ret, selector, object )
	{
		var i = ret.length, j = 0;
		if ( typeof selector.length === "number" )
		{
			for ( var l = selector.length; j < l; j++ ) 
			{ 
				ret[ i++ ] = selector[ j ]; 
			} 
		}else{
			while ( selector[j] !== undefined ) 
			{
				ret[ i++ ] = selector[ j++ ]; 
			} 
		}
		ret.length = i;
		ret.object = object || null;
		return ret;
	}
	
	/**
	  *	@ function <object for extend>
 	  *	@ param source 	<object> source object
 	  *	@ param target  <object> target object
 	  *	@ param over	<object> allow to cover
	  *	@ param args	<object> cover limited
 	  *	@ return <object>
	 */
	_Query.mix = function( source, target, over, args ){
		
		if ( !source || !target ) return source;
		if ( over == undefined ) over = true;
		var len, i, p;
		
		if ( args && ( len = args.length ) )
		{
			for ( i = 0 ; i < len ; i++ )
			{
				p = args[i];
				if ( p in target )
				{
					_mix( p, source, target, over );
				}
			}
		}else{
			 for ( p in target ) {
				_mix( p, source, target, over );
			 }
		}
		
		return source;
	}
	
	/**
	  *	@ function <new function for extend>
 	  *	@ param r 	<object> target object
 	  *	@ param s(n)  <item's params>
 	  *	@ param ov	<object> allow to cover
	  *	@ param wl	<object> cover limited
 	  *	@ return <object>
	 */
	_Query.augment = function(/*r, s1, s2, ..., ov, wl*/){
		var args = arguments, len = args.length - 2,
			r = args[0], ov = args[len], wl = args[len + 1],
			i = 1;

		if ( this.type(wl) != "array") {
			ov = wl;
			wl = undefined;
			len++;
		}
		if (this.type(ov) != "boolean") {
			ov = undefined;
			len++;
		}

		for (; i < len; i++) {
			this.mix(r.prototype, args[i].prototype || args[i], ov, wl);
		}

		return r;
	}
	
	/**
	 * 获取数据类型具体方法
	 */
	_Query.type = function( D ){
		return Object.prototype.toString.apply( D ).split(" ")[1].toLowerCase().replace("]", "");
	}
	
	/**
	 * 输出内容的方法
	 * 参数：S, callback, args
	 * S : 数据 , callback : 回调方法 , args : 附加参数
	 * 返回值 ： 无
	 */
	_Query.echo = function( S, callback, args )
	{
		if ( callback == undefined )
		{
			Response.Write( S );
			return;
		}
		if ( args == undefined )
		{
			Response.Write( callback.call( S ) );
			return;
		}
		Response.Write( callback.apply( S, args ) );
	}
	
	/**
	 * 终止输出的方法
	 * @param 继承自$.echo方法
	 * @return 无
	 */
	_Query.die = function(){
		this.echo.apply(undefined, arguments);
		Response.End();
	}
	
//	_jsonConstructor.prototype.each = function(callback, args){
//		var i, json = this;
//		if ( args == undefined ){
//			for ( i in json ) { if ( callback.call( json[ i ], i, json[ i ] ) === false ) { break; } }
//		}else{
//			for ( i in json ) { if ( callback.apply( json[ i ], args ) === false ) { break; } }
//		}
//		return json;
//	}
	
	var _mix = function( p, r, s, ov ){
		if (ov || !(p in r)) {
			r[p] = s[p];
		}
	};
	
	_Query.fn.init.prototype = _Query.fn;
	return _Query;
	
})();

/**
 * String prototype method
 * useing String.medthod <function>
 * return <String>
 */
$.augment( String, {
	trim : function(){
		return this.replace(/^\s+/, "").replace(/\s+$/, "");
	}
} );

/**
 * Array prototype method
 * useing Array.medthod <function>
 * return <Array>
 */
$.augment( Array, {
	
	// 数组遍历循环的方法
	each : function(callback, args){
		var i = 0, array = this;
		
		if ( args == undefined ){
			for ( 
				var value = array[0] ; 
				i < array.length && callback.call( array, i, value ) !== false ;
				value = array[++i] 
			){}
		}else{
			for ( ; i < length; ) { 
				if ( callback.apply( array[ i++ ], args ) === false ) 
				{ break; }
			}
		}
		
		return array;
	},
	
	// 数组遍历赋值的方法
	map : function( callback ){
		var ret = [], value, _this = this;
		
		for ( var i = 0, length = _this.length; i < length; i++ ) {
			value = callback.call( _this, i, _this[ i ] );
			
			if ( value !== null ) 
			{
				ret[ ret.length ] = value;
			}
			
		}
		
		return ret.concat.apply( [], ret );
	},
	
	// 数组遍历搜索的方法
	indexOf : function( value ){
		var j = -1, i = 0, _this = this;
		
		for ( ; i < _this.length ; i++ )
		{
			if ( _this[i] === value )
			{
				j = i;
				break;
			}
		}
		
		return j;
	},
	
	// 形成syQuery对象主方法
	toQuery : function( ret, context ){
		var i = ret.length, j = 0, selector = this;

		for ( var l = selector.length; j < l; j++ ) 
		{ 
			ret[ i++ ] = selector[ j ]; 
		} 

		ret.length = i;
		ret.object = context || null;
		return ret;
	},
	
	// 数组去除两端空格
	trim : function(){
		return this.map(function( i, k ){
			return k.trim();
		});
	}
} );

// 创建每个 is前缀的判断数据类型的方法
$.config.type = ["Function", "String", "Array", "Object", "Boolean", "Number"];
$.config.type.each(function( i, k ){
	$[ "is" + k ] = function( value ){
		return $.type( value ) === k.toLowerCase();
	}
});

(function(){
	
	$.mix( $, {
		
		// 创建判断日期类型的数据方法
		isDate : function( value ){
			if ( $.type( value ) === "date" ){
				return true;
			}else{
				try{
					var date = Date.parse(value);
					return isNaN(date) ? false : true;
				}catch(e){
					return false;
				}
			}
		},
		
		// 创建是否为标准JSON格式的数据方法
		isJson : function( value ){
			return value.constructor === {}.constructor ? true : false;
		},
		
		// 创建是否为syQuery格式的方法
		isQuery : function( value ){
			return value.constructor === $.fn.constructor ? true : false;
		},
		
		// 动态获取include文件夹内容并加载对应位置运行
		include : function( URI ){
			if ( $.isArray(URI) ){
				URI.each(function(i, _item){
					$.include(_item);
				});
			}else{
				var o = new ActiveXObject($.config.ActivexObject.stream);
				eval(filterContent(catchFile(URI, o)));
				o = null;
			}
		}
		
	});
	
	function catchFile( URI, stream ){
		var o = stream ? stream : new ActiveXObject($.config.ActivexObject.stream),
			lens = URI.split("/"),
			localFo = lens.slice(0, -1).join("/"),
			Text = "";
		o.Type = 2; o.Mode = 3; 
		o.Open(); 
			o.Charset = $.charset; 
			o.Position = o.Size; 
			o.LoadFromFile(Server.MapPath( URI ));
			Text = o.ReadText;
		o.Close;
		return catchContent(Text, o, localFo);
	}
	
	function catchContent(context, stream, localFo){
		var l = 0, r = 0, text = "", p = "", e, t, tempText;
		if ( regExpress.includeExp.test(context) ){
			while ( l > -1 ){
				l = context.indexOf("<" + "!--#include");
				if ( l > -1 ){
					text += context.substring(0, l);
					context = context.substring(l + 12);
					r = context.indexOf("-->");
					p = context.substring(0, r);
					e = p.replace(" file=\"", "").replace("\"", "").trim();
					if ( localFo.length == 0 ){
						t = e;
					}else{
						t = localFo + "/" + e;
					}
					context = context.substring(r + 3);
					tempText = catchFile(t, stream);
					text += catchContent(tempText, stream, t.split("/").slice(0, -1).join("/"));
				}else{
					text += context;
					context = "";
				}
			}
			return text;
		}else{
			return context;
		}
	}
	
	function filterContent( context ){
		context = context.replace(regExpress.includeContentForLeftExp, "").replace(regExpress.includeContentForRightExp, "");
		function textformat(t){
			if ( t.length > 0 ){
				return ";Response.Write(\"" + t.replace(/\\/g, "\\\\").replace(/\"/g, "\\\"").replace(/\r/g, "\\r").replace(/\n/g, "\\n").replace(/\s/g, " ").replace(/\t/g, "\\t") + "\");";
			}else{
				return "";
			}
		}
		var blank = "", conSplit = context.split("<" + blank + "%"), r = 0, text = "", temp;
		for ( var i = 0 ; i < conSplit.length ; i++ )
		{
			r = conSplit[i].indexOf("%" + blank + ">");
			if ( r > -1 ){
				temp = textformat(conSplit[i].substring(r + 2));
				text += (/^\=/.test(conSplit[i]) ? ";Response.Write(" + conSplit[i].substring(1, r) + ");" : conSplit[i].substring(0, r)) + temp;
			}else{
				text += textformat(conSplit[i]);
			}
		}
		return text;
	}
	var regExpress = {
		includeExp : /\<\!\-\-\#include\sfile\=\"(.+?)\"\s?\-\->/g,
		includeFileExp : /file\=\"(.+)\"/,
		includeContentForLeftExp : /^[\r\t\s\n]+/,
		includeContentForRightExp : /[\r\t\s\n]+$/
	}
	
})(); (function(){
	
	var root = Server.MapPath("/"), local = Server.MapPath(".");
	
	// 循环获得路径
	function getLocalPath(){
		if ( root != local ){
			return (function(){
				var j = local.replace(new RegExp("^" + root.replace(/\\/g, "\\\\")), "").substring(1).split("\\").length, temp = "";
				for ( var i = 0 ; i < j ; i++ )
				{
					temp += "../";
				}
				return temp;
			})();
		}else{
			return "";
		}
	}
	
	$.root = getLocalPath(); // 本框架相当于于网站根目录的上级位置集合字符串。
	
})();

(function(){
	
	/**
	 * @ 需要配置$.plugin路径
	 */
	$.mix($, {
		/**
		 * @为框架添加新的模块
		 * @param key <string> 模块名称 标识
		 * @param fn <function> 详细回调方法
		 * @param eqment <json> 配置参数
		 * @return new function
		 */
		add : function(key, fn, eqment){
			if ( $[key] == undefined ){
				dealEqMent(eqment); // 尝试加载前置环境
				$[key] = fn(); // 内置方法
				$.addKey(key); // 防止重复
			}else{
				$.error.push("syQuery error : key[" + key + "] exsit.");
			}
		},
		
		/**
		 * @运行框架模块
		 * @param key <string> 模块名称 标识
		 * @param fn <function> 详细回调方法 其中第一个参数为该模块的返回值
		 * @return anyObject
		 */
		use : function( key, fn ){
			if ( $[key] != undefined ){
				return fn( $[key]() );
			}
		},
		
		/**
		 * @页面执行函数
		 * @param key <string> 模块名称 标识
		 * @param fn <function> 详细回调方法 参数为这些模块的返回值
		 * @return anyObject
		 */
		execute : function( key, fn ){
			if ( $.isFunction(key) ){
				fn = key;
				key = "";
			}
			
			var tmpArr = [];
			key.split(",").each(function( i, k ){
				tmpArr.push($[k.trim()]);
			});

			fn.apply(undefined, tmpArr);
		},
		
		/**
		 * @输出错误的方法
		 * @param fn <string | undefined | string> 输出分割符
		 * @return string
		 */
		echoError : function( fn ){
			if ( $.isFunction(fn) ){
				$.echo( $.error, function(){
					return this.map(function( i, k ){
						return fn(k);
					}).join("");
				} );
			}else{
				$.echo( $.error.join( fn == undefined ? "<br />" : fn ) );
			}
		}
	});
	
	function dealEqMent( eq ){
		if ( eq != undefined ){
			if ( eq.reqiure ){
				var root = $.root, path = $.plugin, _p = "";
				_p = root + path;
				_p = _p.length === 0 ? "" : _p + "/";
				
				for ( var i = 0 ; i < eq.reqiure.length ; i++ )
				{
					if ( $.loaded.indexOf(eq.reqiure[i]) == -1 ){
						$.include(_p + eq.reqiure[i] + "-min.asp");
						$.loaded.push(eq.reqiure[i]);
					}
				}
			}
		}
	}
	
})();
%>