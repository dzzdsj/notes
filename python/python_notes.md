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







