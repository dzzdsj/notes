# ajax
## 概念

AJAX(asynchronous javascript and xml)

它是表示一些技术的混合交互的一个术语，它使得我们可以获取和显示新的内容而不必载入一个新的web页面。

## 实现ajax请求的基本步骤

1. 创建XMLHttpRequest对象,即创建一个异步调用对象.

   ```js
   //在IE浏览器中创建XMLHttpRequest对象的方式为:
   var xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
       
   //在Netscape浏览器中创建XMLHttpRequest对象的方式为:
   var xmlHttpRequest = new XMLHttpRequest();
   
   //为了兼容，都加上
   var xmlHttpRequest;  //定义一个变量,用于存放XMLHttpRequest对象
   createXMLHttpRequst();   //调用创建对象的方法
   //创建XMLHttpRequest对象的方法 
   function createXMLHttpRequest(){                                                 
       if(window.ActiveXObject) {//判断是否是IE浏览器
           xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");//创建IE的XMLHttpRequest对象
       }else if(window.XMLHttpRequest){//判断是否是Netscape等其他支持XMLHttpRequest组件的浏览器
           xmlHttpRequest = new XMLHttpRequest();//创建其他浏览器上的XMLHttpRequest对象
       }
   }
   ```

2. 创建一个新的HTTP请求,并指定该HTTP请求的方法、URL及验证信息.

   ​		创建HTTP请求可以使用XMLHttpRequest对象的open()方法,其语法代码如下所示:

   ```js
   xmlHttpRequest.open(method,URL,flag,name,password);   
   ```


   method：该参数用于指定HTTP的请求方法，一共有get、post、head、put、delete五种方法，常用的方法为get和post。
   URL：该参数用于指定HTTP请求的URL地址，可以是绝对URL，也可以是相对URL。
   flag：该参数为可选，参数值为布尔型。该参数用于指定是否使用异步方式。true表示异步、false表示同步，默认为true。
   name：该参数为可选参数，用于输入用户名。如果服务器需要验证，则必须使用该参数。
   password：该参数为可选，用于输入密码。若服务器需要验证，则必须使用该参数。

3. 设置响应HTTP请求状态变化的函数.

   ​		从创建XMLHttpRequest对象开始，到发送数据、接收数据、XMLHttpRequest对象一共会经历以下5中状态。

   1. 未初始化状态。在创建完XMLHttpRequest对象时，该对象处于未初始化状态，此时XMLHttpRequest对象的readyState属性值为0。

   2. 初始化状态。在创建完XMLHttpRequest对象后使用open()方法创建了HTTP请求时，该对象处于初始化状态。此时XMLHttpRequest对象的readyState属性值为1。

   3. 发送数据状态。在初始化XMLHttpRequest对象后，使用send()方法发送数据时，该对象处于发送数据状态，此时XMLHttpRequest对象的readyState属性值为2。

   4. 接收数据状态。Web服务器接收完数据并进行处理完毕之后，向客户端传送返回的结果。此时，XMLHttpRequest对象处于接收数据状态，XMLHttpRequest对象的readyState属性值为3。

   5. 完成状态。XMLHttpRequest对象接收数据完毕后，进入完成状态，此时XMLHttpRequest对象的readyState属性值为4。此时接收完毕后的数据存入在客户端计算机的内存中，可以使用responseText属性或responseXml属性来获取数据。

      只有在XMLHttpRequest对象完成了以上5个步骤之后，才可以获取从服务器端返回的数据。因此，如果要获得从服务器端返回的数据，就必须要先判断XMLHttpRequest对象的状态。

      XMLHttpRequest对象可以响应readystatechange事件，该事件在XMLHttpRequest对象状态改变时（也就是readyState属性值改变时）激发。因此，可以通过该事件调用一个函数，并在该函数中判断XMLHttpRequest对象的readyState属性值。如果readyState属性值为4则使用responseText属性或responseXml属性来获取数据。

   ```js
   //设置当XMLHttpRequest对象状态改变时调用的函数，注意函数名后面不要添加小括号
   xmlHttpRequest.onreadystatechange = getData;
    
   //定义函数
   function getData(){
       //判断XMLHttpRequest对象的readyState属性值是否为4，如果为4表示异步调用完成
       if(xmlHttpRequest.readyState == 4) {
           //设置获取数据的语句
       }
   }
   ```

   

4. 发送HTTP请求.

    如果XMLHttpRequest对象的readyState属性值等于4，表示异步调用过程完毕，就可以通过XMLHttpRequest对象的responseText属性或responseXml属性来获取数据。

   但是，异步调用过程完毕，并不代表异步调用成功了，如果要判断异步调用是否成功，还要判断XMLHttpRequest对象的status属性值，只有该属性值为200，才表示异步调用成功，因此，要获取服务器返回数据的语句，还必须要先判断XMLHttpRequest对象的status属性值是否等于200

   ```js
   if(xmlHttpRequst.status == 200) {
       document.write(xmlHttpRequest.responseText);//将返回结果以字符串形式输出
       //document.write(xmlHttpRequest.responseXML);//或者将返回结果以XML形式输出
   }
   ```

   注意：如果HTML文件不是在Web服务器上运行，而是在本地运行，则xmlHttpRequest.status的返回值为0。因此，如果该文件在本地运行，则应该加上xmlHttpRequest.status == 0的判断。

   ```js
   //设置当XMLHttpRequest对象状态改变时调用的函数，注意函数名后面不要添加小括号
   xmlHttpRequest.onreadystatechange = getData;
    
   //定义函数
   function getData(){
       //判断XMLHttpRequest对象的readyState属性值是否为4，如果为4表示异步调用完成
       if(xmlHttpRequest.readyState==4){
           if(xmlHttpRequest.status == 200 || xmlHttpRequest.status == 0){//设置获取数据的语句
               document.write(xmlHttpRequest.responseText);//将返回结果以字符串形式输出
               //docunment.write(xmlHttpRequest.responseXML);//或者将返回结果以XML形式输出
           }
       }
   }
   ```
   

5. 获取异步调用返回的数据.

   在经过以上几个步骤的设置之后，就可以将HTTP请求发送到Web服务器上去了。发送HTTP请求可以使用XMLHttpRequest对象的send()方法，其语法代码如下所示：

   ```js
   XMLHttpRequest.send(data);
   ```


   ​       其中data是个可选参数，如果请求的数据不需要参数，即可以使用null来替代。data参数的格式与在URL中传递参数的格式类似，以下代码为一个send()方法中的data参数的示例：

   ```
   name=myName&value=myValue
   ```


   ​       只有在使用send()方法之后，XMLHttpRequest对象的readyState属性值才会开始改变，也才会激发readystatechange事件，并调用函数。

6. 使用JavaScript和DOM实现局部刷新.

   在通过Ajax的异步调用获得服务器端数据之后，可以使用JavaScript或DOM来将网页中的数据进行局部更新。

### 完整示例

直接运行可能会有跨域问题，可以复制出来跑

```html
<html>
<head>
<title>AJAX实例</title>
<script language="javascript" type="text/javascript">   
    function ajaxHttpRequestFunc(){
		let xmlHttpRequest;  // 创建XMLHttpRequest对象，即一个用于保存异步调用对象的变量
		if(window.ActiveXObject){ // IE浏览器的创建方式
            xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }else if(window.XMLHttpRequest){ // Netscape浏览器中的创建方式
            xmlHttpRequest = new XMLHttpRequest();
        }
		xmlHttpRequest.onreadystatechange=function(){ // 设置响应http请求状态变化的事件
            console.log('请求过程', xmlHttpRequest.readyState);
			if(xmlHttpRequest.readyState == 4){ // 判断异步调用是否成功,若成功开始局部更新数据
				console.log('状态码为', xmlHttpRequest.status);
				if(xmlHttpRequest.status == 200) {
					console.log('异步调用返回的数据为：', xmlHttpRequest .responseText);
					document.getElementById("myDiv").innerHTML = xmlHttpRequest .responseText; // 局部刷新数据到页面
				} else { // 如果异步调用未成功,弹出警告框,并显示错误状态码
					alert("error:HTTP状态码为:"+xmlHttpRequest.status);
				}
			}
		}
		xmlHttpRequest.open("GET","https://www.runoob.com/try/ajax/ajax_info.txt",true); // 创建http请求，并指定请求得方法（get）、url（https://www.runoob.com/try/ajax/ajax_info.txt）以及验证信息
		xmlHttpRequest.send(null); // 发送请求
    }
</script>
</head>
<body>
    <div id="myDiv">原数据</div>
    <input type = "button" value = "更新数据" onclick = "ajaxHttpRequestFunc()">
</body>
</html>
```

