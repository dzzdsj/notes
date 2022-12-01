# 大纲-day01
## 初识Nodejs
- JavaScript是什么？ 
- JavaScript可以运行在哪里？ 

浏览器 | 内核    
-------|---------
IE     | Trident 
FireFox| Gecko   
Chrome | WebKit  
Safari | WebKit  
Opera  | Presto  
Edge   | Chakra  

## Node.js的诞生
- 作者Ryan Dahl 瑞恩·达尔
    + 2004 纽约 读数学博士 
    + 2006 退学到智利 转向开发 
    + 2009.5对外宣布node项目，年底js大会发表演讲 
    + 2010 加入Joyent云计算公司 
    + 2012 退居幕后

> Node.js 是一种建立在Google Chrome’s v8 engine上的 non-blocking (非阻塞）, event-driven （基于事件的） I/O平台. 
Node.js平台使用的开发语言是JavaScript，平台提供了操作系统低层的API，方便做服务器端编程，具体包括文件操作、进程操作、通信操作等系统模块

## Node.js可以用来做什么？

- 具有复杂逻辑的动态网站 
- WebSocket服务器 
- 命令行工具 
- 带有图形界面的本地应用程序 
- ......

## 终端基本使用
### 打开应用
- notepad 打开记事本
- mspaint 打开画图
- calc 打开计算机
- write 写字板
- sysdm.cpl 打开环境变量设置窗口
### 常用命令
- md 创建目录
- rmdir(rd) 删除目录，目录内没有文档。
- echo on a.txt 创建空文件
- del 删除文件
- rm 文件名 删除文件
- cat 文件名 查看文件内容
- cat > 文件名 向文件中写上内容。

## Node.js开发环境准备

1. 普通安装方式[官方网站](https://nodejs.org/zh-cn/)

2. 多版本安装方式
    - 卸载已有的Node.js
    - 下载[nvm](https://github.com/coreybutler/nvm-windows)
    - 在C盘创建目录dev
    - 在dev目中中创建两个子目录nvm和nodejs
    - 并且把nvm包解压进去nvm目录中
    - 在install.cmd文件上面右键选择【以管理员身份运行】
    - 打开的cmd窗口直接回车会生成一个settings.txt文件，修改文件中配置信息
    - 配置nvm和Node.js环境变量
        + NVM_HOME:C:\dev\nvm
        + NVM_SYMLINK:C:\dev\nodejs
    - 把配置好的两个环境变量加到Path中
## nvm常用的命令
- nvm list 查看当前安装的Node.js所有版本
- nvm install 版本号 安装指定版本的Node.js
- nvm uninstall 版本号 卸载指定版本的Node.js
- nvm use 版本号 选择指定版本的Node.js

## Node.js之HelloWorld
- 命令行方式REPL(read-eval-print-loop 读取代码-执行-打印结果-循环这个过程)

  ```
  打开cmd
  输入node
  输入代码
  打印
  
      1、javascript本质上是什么？就是一门编程语言，解释执行的
  
      2、浏览器的内核包括两部分核心：1、DOM渲染引擎；2、js解析器（js引擎）
  
      3、js运行在浏览器中的内核中的js引擎内部
      
      4、是否js只能运行在浏览器中？不是的
  
      5、实现动态网站的技术：java php .net python nodejs......
  
      6、基于Node.js和第三方工具electron可以开发桌面应用程序
  
      7、REPL read-eval-print-loop 读取代码-执行-打印结果-循环这个过程
  
      8、在REPL环境中，_表示最后一次执行结果; .exit 可以退出REPL环境
  ```

  

- 运行文件方式

  ```
  node  xxx.js
  ```

  

- 全局对象概览(globals)

  ```
  nodeapi:    https://nodejs.org/dist/latest-v18.x/docs/api/   
  
  /*
      全局成员概述
  */
  
  // 包含文件名称的全路径
  console.log(__filename);
  // 文件的路径（不包含文件名称）
  console.log(__dirname);
  
  // 定时函数，用法与浏览器中的定时函数类似
  var timer = setTimeout(function(){
      console.log(123);
  },1000);
  
  setTimeout(function(){
      clearTimeout(timer);
  },2000);
  
  // 在Node.js中没有window对象，但是有一个类似的对象global，访问全局成员的时候可以省略global
  global.console.log(123456);
  
  // argv是一个数组，默认情况下，前两项数据分别是：Node.js环境的路径；当前执行的js文件的全路径
  // 从第三个参数开始表示命令行参数
  console.log(process.argv);
  // 打印当前系统的架构（64位或者32位）
  console.log(process.arch);
  
  ```

  

## 服务器端模块化

- 服务器端模块化规范CommonJS与实现Node.js

    ```
    模块化开发
    
        传统非模块化开发有如下的缺点：
        1、命名冲突
        2、文件依赖
    
        前端标准的模块化规范：
        1、AMD - requirejs
        2、CMD - seajs
    
        服务器端的模块化规范：
        1、CommonJS - Node.js
    
        模块化相关的规则：
        1、如何定义模块：一个js文件就是一个模块，模块内部的成员都是相互独立
        2、模块成员的导出和引入
    
        模块成员的导出最终以module.exports为准
    
        如果要导出单个的成员或者比较少的成员，一般我们使用exports导出；
        如果要导出的成员比较多，一般我们使用module.exports的方式
        这两种方式不能同时使用
    
        exports与module的关系：
        module.exports = exports = {};
    ```

    

### 模块导出与引入

#### 方式一 exports.

导出

```js
var sum = function(a,b){
    return parseInt(a) + parseInt(b);
}
console.log(sum(1,3));
/*导出模块成员,export.后面的名称是引入时使用的名称*/
exports.new_sum = sum;

/*导出多个的示例*/
var sum = function(a,b){
    return parseInt(a) + parseInt(b);
}
var subtract = function(a,b){
    return parseInt(a) - parseInt(b);
}
var multiply = function(a,b){
    return parseInt(a) * parseInt(b);
}
var divide = function(a,b){
    return parseInt(a) / parseInt(b);
}
exports.sum = sum;
exports.subtract = subtract;

```

导入

```js
/*引入模块*/
var module = require('./export.js');
var ret = module.new_sum(12,13);
console.log(ret);

/*使用多个引入模块*/
var module = require('./export.js');
console.log(module.sum(12,13));
console.log(module.subtract(13,12));
console.log(module);
```

#### 方式二  module.exports

导出

```js
var sum = function(a,b){
    return parseInt(a) + parseInt(b);
}
console.log(sum(1,3));
module.exports = sum;

/*导出多个的示例*/
module.exports = {
    /*前面这个是引入时新的名称*/
    new_sum : sum,
    subtract : subtract,
    multiply : multiply,
    divide : divide
}
```

导入

```js
var module = require('./export.js');
var ret = module(12,13);
console.log(ret);

console.log(module.new_sum(12,13));
console.log(module.subtract(13,12));
```

#### 方式三 （基本不用）

使用global对象

导出

```js
var sum = function(a,b){
    return parseInt(a) + parseInt(b);
}
console.log(sum(1,3));
module.exports = sum;

global.sum = sum;
```

导入

```js
//var module = require('./export.js'); 不需要，直接使用global对象
console.log(global.sum(12,13));
```



###  模块导出机制分析

####  已经加载的模块会缓存

```
 已经加载的模块会缓存
 var module = require('./export.js');
 var module = require('./export.js');
 var module = require('./export.js');
 如上，引入了三次，但只会加载一次。
 
```

#### 模块加载规则

     模块查找如果不加扩展名，也能引入
      var module = require('./export');
     不加扩展名的时候会按照如下后缀顺序进行查找 .js .json .node
     .node一般是c++编译的二进制文件

 ###  模块分类
     自定义模块
     系统核心模块
         fs 文件操作
         http 网络操作
         path 路径操作
         querystring 查询参数解析
         url url解析

## ES6常用语法
### 变量声明let与const

```js
/*
    声明变量let和const
*/

// let声明的变量不存在预解析
// console.log(flag);
// var flag = 123;
// let flag = 456;
// ------------------------
// let声明的变量不允许重复（在同一个作用域内）
// let flag = 123;
// let flag = 456;
// console.log(flag);
// --------------------------
// ES6引入了块级作用域
// 块内部定义的变量，在外部是不可以访问的
// if(true){
//     // var flag = 123;
//     let flag = 123;
// }

// {
//     // 这里是块级作用域
//     let flag = 111;
//     console.log(flag);
// }
// console.log(flag);

// for (let i = 0; i < 3; i++) {
//     // for循环括号中声明的变量只能在循环体中使用
//     console.log(i);
// }
// console.log(i);
// ---------------------------------------
// 在块级作用域内部，变量只能先声明再使用
// if(true){
//     console.log(flag);
//     let flag = 123;
// }
// ========================================
// const用来声明常量
// const声明的常量不允许重新赋值
// const n = 1;
// n = 2;
// --------------------------------
// const声明的常量必须初始化
const abc;
```



### 变量的解构赋值

```js
/*
    变量的解构赋值
*/
// var a = 1;
// var b = 2;
// var c = 3;

// var a = 1,b = 2,c = 3;
```

### 数组解构赋值

```js
// 数组的解构赋值
// let [a,b,c] = [1,2,3];
// let [a,b,c] = [,123,];
// let [a=111,b,c] = [,123,];
// console.log(a,b,c);
```

### 对象解构赋值

```js
// 对象的解构赋值
// let {foo,bar} = {foo : 'hello',bar : 'hi'};
// let {foo,bar} = {bar : 'hi',foo : 'hello'};

// 对象属性别名(如果有了别名，那么原来的名字就无效了)
// let {foo:abc,bar} = {bar : 'hi',foo : 'nihao'};
// console.log(foo,bar);

// 对象的解构赋值指定默认值
let {foo:abc='hello',bar} = {bar : 'hi'};
console.log(abc,bar);

// let {cos,sin,random} = Math;
// console.log(typeof cos);
// console.log(typeof sin);
// console.log(typeof random);
```

### 字符串解构赋值

```js
// 字符串的解构赋值
// let [a,b,c,d,e,length] = "hello";
// console.log(a,b,c,d,e);
// console.log(length);

// console.log("hello".length);

// let {length} = "hi";
// console.log(length);
```



### 字符串扩展

```js
/*
    字符串相关扩展
    includes() 判断字符串中是否包含指定的字串（有的话返回true，否则返回false）
               参数一：匹配的字串；参数二：从第几个开始匹配
    startsWith()  判断字符串是否以特定的字串开始
    endsWith()  判断字符串是否以特定的字串结束

    模板字符串
*/
// console.log('hello world'.includes('world',7));

// let url = 'admin/index.php';
// console.log(url.startsWith('aadmin'));
// console.log(url.endsWith('phph'));

// ----------------------------------
let obj = {
    username : 'lisi',
    age : '12',
    gender : 'male'
}

let tag = '<div><span>'+obj.username+'</span><span>'+obj.age+'</span><span>'+obj.gender+'</span></div>';
console.log(tag);
// 反引号表示模板，模板中的内容可以有格式，通过${}方式填充数据
let fn = function(info){
    return info;
}
let tpl = `
    <div>
        <span>${obj.username}</span>
        <span>${obj.age}</span>
        <span>${obj.gender}</span>
        <span>${1+1}</span>
        <span>${fn('nihao')}</span>
    </div>
`;
console.log(tpl);
```

- 函数扩展
    + 参数默认值
    
    + 参数结构赋值
    
    + rest参数
    
    + 扩展运算符
    
    + 箭头函数
    
```js
/*
    函数扩展
    1、参数默认值
    2、参数解构赋值
    3、rest参数
    4、...扩展运算符
*/

// 参数默认值
// function foo(param){
//     let p = param || 'hello';
//     console.log(p);
// }
// foo('hi');

// function foo(param = 'nihao'){
//     console.log(param);
// }
// foo('hello kitty');
// ----------------------------------
// function foo(uname='lisi',age=12){
//     console.log(uname,age);
// }
// // foo('zhangsan',13);
// foo();
// 参数解构赋值
// function foo({uname='lisi',age=13}={}){
//     console.log(uname,age);
// }
// foo({uname:'zhangsan',age:15});
// --------------------------------------
// rest参数（剩余参数）
// function foo(a,b,...param){
//     console.log(a);
//     console.log(b);
//     console.log(param);
// }
// foo(1,2,3,4,5);

// 扩展运算符 ...
function foo(a,b,c,d,e,f,g){
    console.log(a + b + c + d + e + f + g);
}
// foo(1,2,3,4,5);
let arr = [1,2,3,4,5,6,7];
// foo.apply(null,arr);
foo(...arr);

// 合并数组
let arr1 = [1,2,3];
let arr2 = [4,5,6];
let arr3 = [...arr1,...arr2];
console.log(arr3);


/*
    箭头函数
*/
// function foo(){
//     console.log('hello');
// }
// foo();

// let foo = () => console.log('hello');
// foo();

// function foo(v){
//     return v;
// }
// let foo = v => v;
// let ret = foo(111);
// console.log(ret);

// 多个参数必须用小括号包住
// let foo = (a,b) => {let c = 1; console.log(a + b + c);}
// foo(1,2);

// let arr = [123,456,789];
// arr.forEach(function(element,index){
//     console.log(element,index);
// });
// arr.forEach((element,index)=>{
//     console.log(element,index);
// });

// 箭头函数的注意事项：
// 1、箭头函数中this取决于函数的定义，而不是调用
// function foo(){
//     // 使用call调用foo时，这里的this其实就是call的第一个参数
//     // console.log(this);
//     setTimeout(()=>{
//         console.log(this.num);
//     },100);
// }
// foo.call({num:1});
// ----------------------------------
// 2、箭头函数不可以new
// let foo = () => { this.num = 123;};
// new foo();
// ------------------------------------
// 3、箭头函数不可以使用arguments获取参数列表，可以使用rest参数代替
// let foo = (a,b) => {
//     // console.log(a,b);
//     console.log(arguments);//这种方式获取不到实参列表
// }
// foo(123,456);
let foo = (...param) => {
    console.log(param);
}
foo(123,456 );
```
### 类与继承

```js
/*
    类与继承
*/
// function Animal(name){
//     this.name = name;
// }
// Animal.abc = function(){};
// $.ajax = function(){};
// Animal.prototype.showName = function(){
//     console.log(this.name);
// }
// var a = new Animal('Tom');
// a.showName();
// var a1 = new Animal('Jerry');
// a1.showName();
// -------------------------
class Animal{
    // 静态方法(静态方法只能通过类名调用，不可以使用实例对象调用)
    static showInfo(){
        console.log('hi');
    }
    // 构造函数
    constructor(name){
        this.name = name;
    }

    showName(){
        console.log(this.name);
    }
}
// let a = new Animal('spike');
// a.showName();
// a.showInfo();
// Animal.showInfo();
// ------------------------------
// 类的继承extends
class Dog extends Animal{
    constructor(name,color){
        super(name);//super用来调用父类
        this.color = color;
    }

    showColor(){
        console.log(this.color);
    }
}

let d = new Dog('doudou','yellow');
d.showName();
d.showColor();
// d.showInfo();
Dog.showInfo();
```

# 大纲-day02
## Buffer基本操作
> Buffer对象是Node处理二进制数据的一个接口。它是Node原生提供的全局对象，可以直接使用，不需要require(‘buffer’)。

- 实例化
    + Buffer.from(array)
    + Buffer.from(string)
    + Buffer.alloc(size)
- 功能方法
    + Buffer.isEncoding() 判断是否支持该编码
    + Buffer.isBuffer() 判断是否为Buffer
    + Buffer.byteLength() 返回指定编码的字节长度，默认utf8
    + Buffer.concat() 将一组Buffer对象合并为一个Buffer对象
- 实例方法
    + write() 向buffer对象中写入内容
    + slice() 截取新的buffer对象
    + toString() 把buf对象转成字符串
    + toJson() 把buf对象转成json形式的字符串

## 核心模块API
### 路径操作
- 路径基本操作API

### 文件操作
- 文件信息获取
- 读文件操作
- 写文件操作
- 目录操作

### 文件操作案例

## 包
> 多个模块可以形成包，不过要满足特定的规则才能形成规范的包

### NPM （node.js package management）
> 全球最大的模块生态系统，里面所有的模块都是开源免费的；也是Node.js的包管理工具。

- [官方网站](https://www.npmjs.com/ )

### npm包安装方式
- 本地安装
- 全局安装

### 解决npm安装包被墙的问题
- --registry
    + npm config set registry=https//registry.npm.taobao.org 
- cnpm
    + 淘宝NPM镜像,与官方NPM的同步频率目前为10分钟一次 
    + 官网: http://npm.taobao.org/ 
    + npm install -g cnpm –registry=https//registry.npm.taobao.org 
    + 使用cnpm安装包: cnpm install 包名
- nrm
    + 作用：修改镜像源 
    + 项目地址：https://www.npmjs.com/package/nrm 
    + 安装：npm install -g nrm

### npm常用命令
- 安装包
- 更新包
- 卸载包

### yarn基本使用
- 类比npm基本使用

## 自定义包
### 包的规范
- package.json必须在包的顶层目录下
- 二进制文件应该在bin目录下
- JavaScript代码应该在lib目录下
- 文档应该在doc目录下
- 单元测试应该在test目录下

### package.json字段分析
- name：包的名称，必须是唯一的，由小写英文字母、数字和下划线组成，不能包含空格
- description：包的简要说明
- version：符合语义化版本识别规范的版本字符串
- keywords：关键字数组，通常用于搜索
- maintainers：维护者数组，每个元素要包含name、email（可选）、web（可选）字段
- contributors：贡献者数组，格式与maintainers相同。包的作者应该是贡献者数组的第一- 个元素
- bugs：提交bug的地址，可以是网站或者电子邮件地址
- licenses：许可证数组，每个元素要包含type（许可证名称）和url（链接到许可证文本的- 地址）字段
- repositories：仓库托管地址数组，每个元素要包含type（仓库类型，如git）、url（仓- 库的地址）和path（相对于仓库的路径，可选）字段
- dependencies：生产环境包的依赖，一个关联数组，由包的名称和版本号组成
- devDependencies：开发环境包的依赖，一个关联数组，由包的名称和版本号组成

### 自定义包案例