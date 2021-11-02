# Vim技巧

## 基础命令

### 操作类

- 重复上一个命令：. （点号）

- 撤销命令：u

- 移动光标：h(左) j(下) k(上) l(右) 行首(^) 行尾($) 

  ​			      b(上一个单词)  w(下一个单词)
  
- 

  
### 复合命令

  复合命令    等效的长命令
  C 	c$
  s 	cl
  S 	^C
  I 	  ^i
  A 	$a
  o 	A
  O	 ko



### 编辑类

- 删除一个字符：x
- 删除一个词并进入插入模式:cw
- 删除一行：dd 
- 删除多行：ndd  
- 插入：当前光标处(a)  行尾插入(A) 行首插入(I) 另起下行(o)  另起上行(O)

### 格式类

- 调整从当前行到文档末尾处的缩进层级:>G(右缩进)，<G(左缩进)

### 查找类

- f{char} ：查找当前行下一处指定字符出现的位置，并移动光标，使用(;)查找下一处 ,使用(,)反向查。
- F{char} ：查找当前行上一处指定字符出现的位置，并移动光标，使用(;)查找上一处 ,使用(,)反向查。
- /:正向查文档  ？反向查文档   n 下一处  N上一处
- *: 查找当前光标所在的单词

### 操作符+动作指令 = 操作

c{motion}、y{motion} 以及其他一些命令也类似，它们被统称为
操作符（operator），使用 :h operator查阅完整列表

        c       c       change
        d       d       delete
        y       y       yank into register (does not change the text)
        ~       ~       swap case (only if 'tildeop' is set)
        g~      g~      swap case
        gu      gu      make lowercase
        gU      gU      make uppercase
        !       !       filter through an external program
        =       =       filter through 'equalprg' or C-indenting if empty
        gq      gq      text formatting
        g?      g?      ROT13 encoding
        >       >       shift right
        <       <       shift left
        zf      zf      define a fold
        g@      g@      call function set with the 'operatorfunc' option
motion:

- l:一个字
- aw:一个词
- ap:一个段落

常用：

- dl :删除一个字
- daw ：删除一个词
- dap ： 删除一个段落

### 规则

- 当一个操作符命令被连续调用两次时，它会作用于当前行；如 dd、yy

## 插入模式

### 修正错误

- ctrl+h: 删除前一个字符

- ctrl+w：删除前一个单词

- ctrl+u:删除至行首

  

### 快捷操作

- 返回普通模式：<ESC> <C-[>
- 进入插入-普通模式（执行完一次普通模式命令后马上切回插入模式）：<C-o>
- 

### 插入不可显字符

- <C-v>{code}: code最大为3位数字  或  <C-v>u {code},这里code为4位16进制编码。
- ga：查看当前光标下字符的编码