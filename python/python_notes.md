## 基础

### 运行

```
Use quit() or Ctrl-Z plus Return to exit
EOF文件字符 win:Ctrl-Z   unix:Ctrl-D
```

### 变量

标识变量类型(仅是标识作用，不强制)

```python
>>> a: int = 'string'
>>> print(a)
string
>>> a: int = 42
>>> print(a)
42
```

### 字符串

'ab'
"ab"
'''abc'''  ###三引号可以横跨多行，其他两个则不行

```python
>>> print('''abcd
... edfg''')
abcd
edfg
>>> print('ab
  File "<stdin>", line 1
    print('ab
            ^
SyntaxError: EOL while scanning string literal
```

相邻的字符串字面量可以被连接成一个字符串

```python
>>> print('a'
... 'b'
... 'c')
abc
```

字符串以Unicode字符序列的形式存储。以整数为索引，从0开始。负索引则是从末尾开始的索引。

切片操作符 s[i:j],提取字符串s中 i<=k<j的子串。 省略索引则表示开头/结尾。

```python
>>> a = '012345'
>>> a[0]
'0'
>>> a[1]
'1'
>>> a[-1]
'5'
>>> a[-2]
'4'
#左闭右开
>>> a[0:2]
'01'
>>> a[:2]
'01'
>>> a[1:]
'12345'
```



### 运算符

```python
#向下取整除法
>>> 9//2
4
#求商和余数
>>> divmod(9,2)
(4, 1)
#逻辑运算
or 
and
not
>>> True and False
False
#幂运算
>>> 2 ** 3
8

```

字符串转数值

```python
>>> x='1'
>>> y='2'
>>> x+y
'12'
>>> int(x)+int(y)
3
>>> float(x)+float(y)
3.0

```

### 文件输入输出

with open 支持文件自动关闭

```python
with open('data.txt') as file:
    for line in file:
        print(line,end='')  #end='' 用''替换print默认的换行\n,即不默认换行
```

open  以下方式不要忘了关闭文件

```python
file = open('data.txt')
for line in file:
    print(line,end='')
file.close()
```

 #将整个文件读入内存

```
with open ("data.txt") as file:
    data = file.read() #将整个文件读入内存
    print(data)
```

#以块的形式读取一个文件

```python
with open ("data.txt",encoding='utf-8') as file:
    while(trunk:= file.read(1024)): # read 1024 bytes at a time, :=运算符给一个变量赋值并返回它的值
        print(trunk,end='')
```

#交换方式input()函数

```python
>>> name=input('aaa')
 aaaabcd
>>> print(name)
abcd
```

### 列表

列表是任意对象的有序集合

```python
>>> a=['abc',1,'def',2]   #定义列表
>>> print(a[1])
1
>>> a.append(3)     # 追加
>>> print(a)
['abc', 1, 'def', 2, 3]
>>> a.insert(1,'add')  # 在索引1处插入
>>> print(a)
['abc', 'add', 1, 'def', 2, 3]

```

### 元组(Tuple)
它和列表（list）类似，但最大的区别是：元组一旦创建，就不能修改其内容（不能添加、删除或修改元素）
元组是不可变对象

```python
a=('abc',1,'def',2) # 初始化一个元组
print (a)
```

### Set

set是唯一对象的无序集合。set的元素通常局限于不可变对象。不能创建包含列表的set。

```python
a={'abc',1,'def',2} # 初始化一个set
print (a)
b=set([1,2,3,4]) # 初始化一个set
print (b)
```

set支持的操作。

```python
a={1,2,3,4} 
b={3,4,5,6}
print (a & b) #{3, 4} 交集
print (a | b) #{1, 2, 3, 4, 5, 6} 并集
print (a - b) #{1, 2} 差集
print (a ^ b) #{1, 2, 5, 6} 对称差集
```

set增删改。

```python
a={1,2,3,4} 
a.add(5) # add single element
a.update({6,7}) # add multiple elements
a.discard(3) # remove if present
a.remove(8) # throw error if not present
```

### 字典

键值映射

```python
a={
    "name":"sachin",
    "age":20,
    "city":"pune",
    "state":"maharashtra"
} 
print(a)
print(a["name"])
```

### 函数

定义

```python
def test_add(a,b):
    return a+b
print(test_add(1,2))

def test(a: int,b: int) -> int:
    '''
    注解
    :param a:
    :param b:
    :return:
    '''
    return a+b
print(test(1,2))
```

### 异常

try:
except:
finally:

抛出异常
raise  Exception

### 类和对象
class 父类:
    def 方法(self):
        ...

class 子类(父类):
    def 新方法(self):
        ...

支持多继承
class C(A, B):
    pass

通常约定带单下划线的为私有属性，不带下划线的为共有属性。（仅约定，实际无任何强制约束）

###模块
模块是python源代码文件，通常以.py为后缀。
import 模块名
调用时使用模块名.模块对象

from 模块名 import 模块对象
调用时使用模块对象

### 内置变量
__name__ 模块名
__file__ 模块文件名
__package__ 模块所在包名
__doc__ 模块文档字符串
__all__ 模块对象


### 包管理
`__init__.py` 是 Python 中用于将一个普通文件夹变成 **Python 包（package）** 的特殊文件。

当你在一个文件夹中创建了 `__init__.py` 文件后，Python 就会把这个文件夹当作一个“包”来处理。这样你就可以使用 `import` 来导入该包下的模块或子包。

#### 主要用途：

1. **标记为 Python 包**
   - 没有这个文件，Python 不会认为该目录是包（在 Python 3.3 之前尤为重要）。
2. **初始化代码**
   - 当导入包时，`__init__.py` 中的代码会被自动执行。
3. **控制导入行为**
   - 可以在其中定义 `__all__` 来指定 `from package import *` 会导入哪些模块。
4. **暴露包级变量或函数**
   - 可以在里面定义变量、函数或类，供整个包使用。

- 在 Python 3.3 及以后版本中，即使没有 `__init__.py`，也可以通过 `import` 导入子模块（称为 **namespace packages**），但在很多项目和工具链中仍广泛使用 `__init__.py` 来显式声明包结构。
- 如果你想兼容旧版本 Python 或者希望明确控制包的行为，建议始终保留 `__init__.py`。

#### 第三方包管理&虚拟环境
python3 -m venv env
python3 -m pip install somepackaage

# 在项目目录中创建隔离环境
python3 -m venv venv
# 激活虚拟环境
source venv/bin/activate
# 安装你需要的包
pip install whisper openai ffmpeg-python
# 使用 pip freeze 查看仅当前环境下的依赖
pip freeze

#!/usr/bin/env python3
pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
pip install pandas -i https://mirrors.aliyun.com/pypi/simple/

打包
pip install pyinstaller -i https://mirrors.aliyun.com/pypi/simple/
pyinstaller --onefile compare.py

调试
import pdb

def compute():
    x = 10
    pdb.set_trace()   # 在这里设置断点
    y = x + 5
    print(y)

compute()

===============================================================================
f-string 

