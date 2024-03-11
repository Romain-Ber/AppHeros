import e from"global/window";import r from"is-function";import t from"parse-headers";import n from"xtend";var o={};var a=e;var s=r;var u=t;var i=n;o=createXHR;o.default=createXHR;createXHR.XMLHttpRequest=a.XMLHttpRequest||noop;createXHR.XDomainRequest="withCredentials"in new createXHR.XMLHttpRequest?createXHR.XMLHttpRequest:a.XDomainRequest;forEachArray(["get","put","post","patch","head","delete"],(function(e){createXHR["delete"===e?"del":e]=function(r,t,n){t=initParams(r,t,n);t.method=e.toUpperCase();return _createXHR(t)}}));function forEachArray(e,r){for(var t=0;t<e.length;t++)r(e[t])}function isEmpty(e){for(var r in e)if(e.hasOwnProperty(r))return false;return true}function initParams(e,r,t){var n=e;if(s(r)){t=r;"string"===typeof e&&(n={uri:e})}else n=i(r,{uri:e});n.callback=t;return n}function createXHR(e,r,t){r=initParams(e,r,t);return _createXHR(r)}function _createXHR(e){if("undefined"===typeof e.callback)throw new Error("callback argument missing");var r=false;var t=function cbOnce(t,n,o){if(!r){r=true;e.callback(t,n,o)}};function readystatechange(){4===n.readyState&&setTimeout(loadFunc,0)}function getBody(){var e=void 0;e=n.response?n.response:n.responseText||getXml(n);if(f)try{e=JSON.parse(e)}catch(e){}return e}function errorFunc(e){clearTimeout(l);e instanceof Error||(e=new Error(""+(e||"Unknown XMLHttpRequest Error")));e.statusCode=0;return t(e,m)}function loadFunc(){if(!a){var r;clearTimeout(l);r=e.useXDR&&void 0===n.status?200:1223===n.status?204:n.status;var o=m;var c=null;if(0!==r){o={body:getBody(),statusCode:r,method:i,headers:{},url:s,rawRequest:n};n.getAllResponseHeaders&&(o.headers=u(n.getAllResponseHeaders()))}else c=new Error("Internal XMLHttpRequest Error");return t(c,o,o.body)}}var n=e.xhr||null;n||(n=e.cors||e.useXDR?new createXHR.XDomainRequest:new createXHR.XMLHttpRequest);var o;var a;var s=n.url=e.uri||e.url;var i=n.method=e.method||"GET";var c=e.body||e.data;var p=n.headers=e.headers||{};var d=!!e.sync;var f=false;var l;var m={body:void 0,headers:{},statusCode:0,method:i,url:s,rawRequest:n};if("json"in e&&false!==e.json){f=true;p.accept||p.Accept||(p.Accept="application/json");if("GET"!==i&&"HEAD"!==i){p["content-type"]||p["Content-Type"]||(p["Content-Type"]="application/json");c=JSON.stringify(true===e.json?c:e.json)}}n.onreadystatechange=readystatechange;n.onload=loadFunc;n.onerror=errorFunc;n.onprogress=function(){};n.onabort=function(){a=true};n.ontimeout=errorFunc;n.open(i,s,!d,e.username,e.password);d||(n.withCredentials=!!e.withCredentials);!d&&e.timeout>0&&(l=setTimeout((function(){if(!a){a=true;n.abort("timeout");var e=new Error("XMLHttpRequest timeout");e.code="ETIMEDOUT";errorFunc(e)}}),e.timeout));if(n.setRequestHeader)for(o in p)p.hasOwnProperty(o)&&n.setRequestHeader(o,p[o]);else if(e.headers&&!isEmpty(e.headers))throw new Error("Headers cannot be set on an XDomainRequest object");"responseType"in e&&(n.responseType=e.responseType);"beforeSend"in e&&"function"===typeof e.beforeSend&&e.beforeSend(n);n.send(c||null);return n}function getXml(e){try{if("document"===e.responseType)return e.responseXML;var r=e.responseXML&&"parsererror"===e.responseXML.documentElement.nodeName;if(""===e.responseType&&!r)return e.responseXML}catch(e){}return null}function noop(){}var c=o;export default c;

