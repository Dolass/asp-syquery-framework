﻿<%;var syQuery=function(a){this.data={event:{},keep:{}};var b;if(a!=undefined&&$.isFunction(a)){b=a}if(b!=undefined){b()}};$.mix(syQuery,{regExpress:{includeExp:/\<\!\-\-\#include\sfile\=\"(.+?)\"\s?\-\->/g,includeFileExp:/file\=\"(.+)\"/,includeContentForLeftExp:/^[\r\t\s\n]+/,includeContentForRightExp:/[\r\t\s\n]+$/},version:"2.0",mark:"F9A7KH02DA4",path:"",catchFile:function(c,e){if(e==undefined){e=$.stream()}var a=c.split("/"),d=a.slice(0,-1).join("/");var b=$.load(c,e,2);return syQuery.catchContent(b,e,d)},catchContent:function(d,h,b){var f=0,a=0,i="",c="",g,k,j;if(syQuery.regExpress.includeExp.test(d)){while(f>-1){f=d.indexOf("<!--#include");if(f>-1){i+=d.substring(0,f);d=d.substring(f+12);a=d.indexOf("-->");c=d.substring(0,a);g=$.trim(c.replace(' file="',"").replace('"',""));if(b.length==0){k=g}else{k=b+"/"+g}d=d.substring(a+3);j=syQuery.catchFile(k,h);i+=syQuery.catchContent(j,h,k.split("/").slice(0,-1).join("/"))}else{i+=d;d=""}}return i}else{return d}},filterContent:function(d){d=d.replace(syQuery.regExpress.includeContentForLeftExp,"").replace(syQuery.regExpress.includeContentForRightExp,"");function g(h){if(h.length>0){return';Response.Write("'+h.replace(/\\/g,"\\\\").replace(/\"/g,'\\"').replace(/\r/g,"\\r").replace(/\n/g,"\\n").replace(/\s/g," ").replace(/\t/g,"\\t")+'");'}else{return""}}var b=d.split("<%"),e=0,f="",a;for(var c=0;c<b.length;c++){e=b[c].indexOf("%>");if(e>-1){a=g(b[c].substring(e+2));f+=(/^\=/.test(b[c])?";Response.Write("+b[c].substring(1,e)+");":b[c].substring(0,e))+a}else{f+=g(b[c])}}return f},include:function(f){if($.isArray(f)){for(var i=0;i<f.length;i++){syQuery.include(f[i])}}else{eval(syQuery.filterContent(syQuery.catchFile(f)))}},augment:function(){var b=arguments,a=b.length-2,e=b[0],d=b[a],f=b[a+1],c=1;if(!$.isArray(f)){d=f;f=undefined;a++}if(!$.isBoolean(d)){d=undefined;a++}for(;c<a;c++){$.mix(e.prototype,b[c].prototype||b[c],d,f)}return e},add:function(b,c,a){syQuery[b]=function(){};if(a!=undefined){c(syQuery[b],a())}else{c(syQuery[b])}},timer:function(){return new Date().getTime()}});(function(){var a=Server.MapPath("/"),c=Server.MapPath(".");function b(){if(a!=c){return(function(){var e=c.replace(new RegExp("^"+a.replace(/\\/g,"\\\\")),"").substring(1).split("\\").length,d="";for(var f=0;f<e;f++){d+="../"}return d})()}else{return""}}syQuery.root=b()})();syQuery.augment(syQuery,{add:function(a,b){this.data.event[a]=b},use:function(b,a){if(a==undefined){a=[]}if(!$.isArray(a)){a=[a]}if(this.data.event[b]==undefined){return}return this.data.event[b].apply(undefined,a)},run:function(a,e){var d=this;if(e!=undefined){for(var b in e){d.data.keep[b]=d.use(b,e[b]||[])||null}}a.call(d.data.keep,d)}});syQuery.add("application",function(a){syQuery.augment(a,{flag:"pjblog",root:"cache",conn:null,set:function(d,e){var b=this.flag;if(e==undefined){if($.isJson(d)){Application.Lock();for(var c in d){Application.StaticObjects(b).Item(c)=d[c]}Application.UnLock()}}else{Application.Lock();Application.StaticObjects(b).Item(d)=e;Application.UnLock()}},get:function(b){return Application.StaticObjects(this.flag).Item(b)||null},load:function(d){var b=[],e=0,f;if(d.isapp){b.push("app")}if(d.isfile){b.push("file")}if(d.isdb){b.push("db")}if(d.path==undefined){d.path=d.key+".cache"}while(b[e]!=undefined){f=this["_load_"+b[e]](d);if(f==null){e++}else{if(e>0){for(var c=0;c<e;c++){if(b[c]!="db"){this["_write_"+b[c]](d,f)}}}e=10;return f}}return[]},write:function(d){if(d.path==undefined){d.path=d.key+".cache"}var b=[],e=null,c=false;if(d.isdb){e=this._load_db(d)}else{if(d.isfile){e=this._load_file(d);c=true}}if(e!=null){if(d.isapp){if(_app==true){this._write_app(d,e)}}if(d.isfile){if(c!=true){this._write_file(d,e)}}}},_load_app:function(b){var c=this.get(b.key);if(c!=null&&$.isObject(c)&&c.length){return $.toArray(c)}else{return null}},_load_file:function(b){if($(this.root+"/"+b.path,$.fso()).exsit()){return $.parseJSON($(this.root+"/"+b.path,$.stream()).load(2).get(0)||"")||null}else{return null}},_load_db:function(b){var c=null;$({sql:b.sql,type:1,callback:function(d){try{c=$.rows(d)}catch(f){}}}).select(this.conn);return c},_write_app:function(c,b){this.set(c.key,b)},_write_file:function(d,b){var f=[];for(var e=0;e<b.length;e++){var c=b[e];c=$.map(c,function(h,g){return encodeURIComponent(g)});c="["+c.join(",")+"]";f.push(c)}f="["+f.join(",")+"]";$.echo(this.root+"/"+d.path);$(f,$.stream()).save(this.root+"/"+d.path,2)}})});syQuery.add("package",function(b,a){syQuery.augment(b,{pack:function(h,d,m){var f='<?xml version="1.0"?><package xmlns:dt="urn:schemas-microsoft-com:datatypes"><count><foldercount></foldercount><filecount></filecount></count><content><folders></folders><files></files></content></package>',c=this.allFolder(h),i=$.xml(f),k=i[0],g=i[1],l=this;if(c.length>0){if(k!=null){try{$(k,g).find("count foldercount").text(c.length);$.arrEach(c,function(n,e){e=e.replace(/\.\.\//g,"");$(k,g).find("content folders").append("item").html(m!=undefined&&m.repFolder!=undefined&&$.isFunction(m.repFolder)?m.repFolder(e+""):e+"");if(m!=undefined&&m.packFolder!=undefined&&$.isFunction(m.packFolder)){m.packFolder(e)}});$(c,a.fso).collect("f",true).each(function(o,e){var p=l._t2b($(e,$.stream()).load(1).get(0));e=e.replace(/\.\.\//g,"");var n=$(k,g).find("content files").append("item").html(p+"").attrs({path:(m!=undefined&&m.repFile!=undefined&&$.isFunction(m.repFile)?m.repFile(e+""):e+""),filename:(e.split("/").slice(-1).join(""))});if(m!=undefined&&m.packFile!=undefined&&$.isFunction(m.packFile)){m.packFile(e)}});$(k,g).saveXML(d);if(m!=undefined&&m.success!=undefined&&$.isFunction(m.success)){m.success(d)}}catch(j){if(m!=undefined&&m.error!=undefined&&$.isFunction(m.error)){m.error(j.message)}}}}},unpack:function(f,c,m){var g=$.xml(f),j=g[0],d=g[1],l=this;if(j!=null){try{var i=$(j,d).find("content folders item").map(function(n,e){var o=c+"/"+$(e,d).text();if(m!=undefined&&m.packFolder!=undefined&&$.isFunction(m.packFolder)){m.packFolder(o)}if(m!=undefined&&m.repFolder!=undefined&&$.isFunction(m.repFolder)){o=m.repFolder(o)}return o}).toArray();$(i,a.fso).create();var k=$(j,d).find("content files item").each(function(o,n){var p=c+"/"+$(n,d).attr("path"),e=$(n,d).attr("filename"),q=l._b2t($(n,d).text());if(m!=undefined&&m.repFile!=undefined&&$.isFunction(m.repFile)){p=m.repFile(p)}$.save(q,p,$.stream(),1);if(m!=undefined&&m.packFile!=undefined&&$.isFunction(m.packFile)){m.packFile(p,e)}});if(m!=undefined&&m.success!=undefined&&$.isFunction(m.success)){m.success(c)}}catch(h){if(m!=undefined&&m.error!=undefined&&$.isFunction(m.error)){m.error(h.message)}}}},allFolder:function(g){var e=a.fso,d=[],f=$(g,e).collect("o",true),c=this;d=c._addArray(d,f.toArray());if(f.size()>0){d=c._addArray(d,f.map(function(j,h){return c.allFolder(h)}).toArray())}return d},_t2b:function(d){if(d==null){return""}var c=a.xml.createElement("file");c.dataType="bin.base64";c.nodeTypedValue=d;return c.text},_b2t:function(c){var d=a.xml.createElement("file");d.dataType="bin.base64";d.text=c;return d.nodeTypedValue},_addArray:function(c,d){for(var e=0;e<d.length;e++){c.push(d[e])}return c}})},function(){var a,b=$.fso();try{a=$.active("Microsoft.XMLDOM")}catch(c){a=$.active("Msxml2.DOMDocument.5.0")}return{xml:a,fso:b}});syQuery.add("page",function(a){syQuery.augment(a,{init:function(n,d,j,l){var o={total:0,pagesize:0,absolutePage:0,pageCount:0},g=this;if($.isArray(n)){o.total=n.length;if(j>o.total){j=o.total}o.pagesize=j;o.pageCount=Math.ceil(o.total/o.pagesize);if(d>o.pageCount){d=o.pageCount}o.absolutePage=d;if(o.pagesize<0){o.pagesize=0}if(o.absolutePage<1){o.absolutePage=1}var h=(o.absolutePage-1)<0?0:(o.absolutePage-1);var b=h*o.pagesize,c=o.absolutePage*o.pagesize-1;var k=b;while(b<=c){if(l!=undefined){l.call(n[b],n[b],k-b+1)}b++}}else{if($.isJson(n)){if(d!=undefined){n.absolutePage=d}if(j!=undefined){n.pagesize=j}if(l!=undefined){n.callback=l}n=$.extend({table:"",area:[],key:"",absolutePage:1,pagesize:10,where:null,order:null,conn:null,callback:null},n||{});if(n.conn==null){return o}if(n.where==null){n.where=""}else{n.where=" Where "+n.where+" "}if(n.order==null){n.order=""}else{n.order=" Order By "+n.order+" "}$.record({conn:n.conn,hook:[{sql:"Select "+n.area.join(",")+" From "+n.table+n.where+n.order,type:1,callback:function(i){o=g.init(i,n.absolutePage,n.pagesize,n.callback)}}]})}else{if($.isObject(n)){var f=n.recordcount,e=1;if(j>f){j=f}var m=Math.ceil(f/j);if(d>m){d=m}n.PageSize=j;n.AbsolutePage=d;o.total=f;o.pagesize=j;o.absolutePage=d;o.pageCount=m;if(o.pagesize<0){o.pagesize=0}if(o.absolutePage<1){o.absolutePage=1}while(!n.Eof&&e<=n.PageSize){if(l!=undefined){l.call(n,n,e)}e++;n.MoveNext()}}}}return o},pagebar:function(f,d,c,e){if(e==undefined){e=Math.ceil(f/d)}var h=c,b=c,g=0;while((h>1)&&(b<e)&&((c-h)<4)){h--;b++}g=c-h;h=c-g,b=c+g;if(h==1){b=4-g+b}else{if(b==e){h=h-(4-g)}}if(h<1){h=1}if(b>e){b=e}return{start:h,end:b}}})});%>