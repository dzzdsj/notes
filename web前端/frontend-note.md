## 初始化
➜  ~ node -v
v26.3.0
➜  ~ npm -v
11.16.0

Node.js = 让 JavaScript 可以在浏览器之外运行的运行时
npm 可以类比你熟悉的 Maven
Vite 可以简单理解为：现代前端项目的开发服务器 + 构建工具。

npm create vite@latest 
cd frontend && npm create vite@latest .  # 这种写法不会创建子目录
npm install
npm run dev

## js
const → 变量不能重新赋值
let   → 变量可以重新赋值

javaScript 里的 const：
不能重新给变量赋值，但对象内部的内容可以修改。

例如：
const user = {
    name: "Tom",
    age: 20
}

user.age = 21

JavaScript 不要求声明变量类型 
TypeScript，就是为了解决大型项目中 JavaScript 类型约束不足的问题

JavaScript 对象
这是以后 Vue 中非常重要的东西。
const user = {
    id: 1,
    name: "Tom",
    age: 20
}
访问：
console.log(user.name)
或者：
console.log(user["name"])
Java 开发者可以暂时把它理解成：
一个非常灵活的对象/Map 混合体。

但是它和 Java Bean 并不一样。

数组：
const users = [
    {
        id: 1,
        name: "Tom"
    },
    {
        id: 2,
        name: "Jerry"
    }
]

const users = [
    { id: 1, name: "Tom" },
    { id: 2, name: "Jerry" },
    { id: 3, name: "Bob" }
]

const names = users.map(user => user.name)
得到
[
    "Tom",
    "Jerry",
    "Bob"
]

const adults = users.filter(user => user.age >= 18)
const user = users.find(user => user.id === 2)

1 === 1       // true
1 === "1"     // false
1 == "1"      // true
JavaScript 的 == 会进行类型转换。优先使用 === 和 !==

普通函数：
function add(a, b) {
    return a + b
}
箭头函数：
const add = (a, b) => {
    return a + b
}
如果只有一个表达式：
const add = (a, b) => a + b

解构 —— Vue 中非常常见
假设：
const user = {
    id: 1,
    name: "Tom",
    age: 20
}
传统写法：
const name = user.name
const age = user.age
解构：
const { name, age } = user
一次把属性取出来。
以后你会经常看到：
const { data, error } = response
不要觉得奇怪。
就是：
response.data
response.error
的简写形式。


展开运算符 ...
也是 Vue 中非常高频的语法。
例如：
const user = {
    name: "Tom",
    age: 20
}
复制并修改：
const newUser = {
    ...user,
    age: 21
}
结果：
{
    name: "Tom",
    age: 21
}
可以暂时理解成：
把原对象的属性展开到新对象里面。

数组也可以：
const a = [1, 2, 3]
const b = [...a, 4]
结果：
[1, 2, 3, 4]


Promise 是什么？
你可以先把 Promise 理解成：
一个代表“未来某个时间会得到结果”的对象。

例如：
const promise = getUser()
此时：
promise
   │
   └── 未来
       ├── 成功 → 得到用户
       └── 失败 → 得到错误
Promise 有三种状态：
Pending
  ↓
┌──────────────┐
↓              ↓
Fulfilled    Rejected
成功           失败
也就是：
pending   → 进行中
fulfilled → 成功
rejected  → 失败

const promise = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve("Hello")
    }, 2000)
})

promise.then(result => {
    console.log(result)
})
但是 .then() 写多了会比较难读
例如：
getUser()
    .then(user => {
        return getOrders(user.id)
    })
    .then(orders => {
        return getProducts(orders)
    })
    .then(products => {
        console.log(products)
    })
如果异步逻辑越来越复杂，就会很难看。
所以现代 JavaScript 大量使用：
async / await
async function main() {
    const user = await getUser()

    console.log(user)
}

main()

async function main() {
    try {
        const user = await getUser()

        console.log(user)
    } catch (error) {
        console.error(error)
    }
}

async function loadUsers() {
    const response = await fetch("/api/users")

    const users = await response.json()

    console.log(users)
}

async function loadData() {
    const usersPromise = getUsers()
    const productsPromise = getProducts()

    const users = await usersPromise
    const products = await productsPromise
}

async function loadData() {
    const [users, products] = await Promise.all([
        getUsers(),
        getProducts()
    ])

    console.log(users)
    console.log(products)
}

普通导出
export function add() {}
export function subtract() {}
引入：
import { add, subtract } from "./math.js"
默认导出
export default function add() {}
引入：
import add from "./math.js"
这是你现在必须掌握的区别。
一个文件可以有多个普通导出，默认导出和普通导出可以同时存在

package.json
    ↓
“我需要什么”

package-lock.json
    ↓
“这次安装具体用了什么版本”

npm install
可以理解成：
读取 package.json
       ↓
解析项目依赖
       ↓
下载依赖
       ↓
安装到 node_modules
       ↓
更新/使用 package-lock.json

npm scripts
现在来看现代前端项目最重要的一个东西：
{
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  }
}
于是：
npm run dev
实际上执行：
vite
而：
npm run build
执行：
vite build
所以：
npm run xxx 本质上是在执行 package.json 中 scripts 定义的命令。

Vite 是现代前端项目的开发/构建工具。

它负责很多事情，例如：
开发服务器
模块加载
TypeScript处理
Vue文件处理
代码构建
生产环境打包
npm run dev
启动的通常是：
Vite Dev Server
而不是 Node.js 后端服务器。

一个完整项目启动过程
假设：
my-vue-app/
├── package.json
├── package-lock.json
├── index.html
└── src/
    ├── main.ts
    └── App.vue
第一次拿到项目：
cd my-vue-app
第一步：
npm install
得到：
node_modules/
然后：
npm run dev
实际：
npm
 ↓
读取 package.json
 ↓
执行 vite
 ↓
Vite 启动
 ↓
加载 src/main.ts
 ↓
加载 App.vue
 ↓
浏览器


npm create vite@latest
npx 可以先简单理解为：
帮你执行 npm 包提供的命令

## vue项目结构
index.html 是浏览器入口，main.ts 是 Vue 入口，App.vue 是 Vue 应用的根组件。

Vue 有一个非常重要的概念：
单文件组件（Single-File Component，SFC）。

一个：
App.vue
里面可以同时包含：
<script>
<template>
<style>

template 可以理解成：
这个组件最终要显示什么。

<script setup>
理解成：
这里写这个组件的 JavaScript / TypeScript 逻辑。
这些东西可以被 <template> 使用。

Vue 的核心能力之一，就是：
数据发生变化 → Vue 自动更新对应的页面。

这就是今天要理解的 响应式（Reactive）。
1. ref() 是什么？
Vue 3 中最常用的响应式 API 之一就是：
import { ref } from 'vue'

const count = ref(0)
你可以先把它理解成：
const count = {
    value: 0
}
所以我们可以把 ref() 理解成：
告诉 Vue：这个数据是需要被 Vue 追踪的响应式数据。

数组
const users = ref<string[]>([])
添加：
users.value.push('Tom')
users.value.push('Jerry')
对象
const user = ref({
  name: 'Tom',
  age: 20
})
修改：
user.value.name = 'Jerry'
user.value.age = 21

简单值 → ref()
对象/表单状态 → reactive()
<script setup lang="ts">
import { reactive } from 'vue'

const user = reactive({
  name: 'Tom',
  age: 20
})

function changeUser() {
  user.name = 'Jerry'
  user.age++
}
</script>

<template>
  <div>
    <p>姓名：{{ user.name }}</p>
    <p>年龄：{{ user.age }}</p>

    <button @click="changeUser">
      修改用户
    </button>
  </div>
</template>


ref
const user = ref({
  name: 'Tom',
  age: 20
})
访问：
user.value.name

reactive
const user = reactive({
  name: 'Tom',
  age: 20
})
访问：
user.name


const user = ref(...)
可以方便地整体替换：
user.value = {
  name: 'Jerry',
  age: 30
}

## 模版指令
{{ }}：把数据放到页面，这叫做插值表达式。
而且里面可以进行简单表达式计算：
v-bind：动态绑定 HTML 属性
缩写 <img :src="imageUrl">
这个 HTML 属性不是固定值，而是来自 JavaScript 数据。

v-if：条件渲染
<p v-if="status === 'loading'">
  加载中...
</p>

<p v-else-if="status === 'success'">
  加载成功
</p>

<p v-else>
  加载失败
</p>

v-for：循环渲染
const users = ref([
  'Tom',
  'Jerry',
  'Jack'
])

<ul>
  <li v-for="user in users" :key="user">
    {{ user }}
  </li>
</ul>

Vue 可以通过 key 更准确地知道：
Bob → 新增
Jerry → 原来的 Jerry
Jack → 原来的 Jack
而不是把整个列表重新当成完全不同的东西。
初学阶段你可以先记：
v-for 通常要配合唯一的 :key。

如果数据有 ID：
<li v-for="user in users" :key="user.id">
这是最常见的写法。

v-model：表单双向绑定

v-on:click的简写 @click

### Vue 3 computed() —— 计算属性
computed() 用来根据已有状态，计算出一个新的响应式值。

它有点像 Java 里的“派生属性 / getter”，但 Vue 的 computed 还会自动追踪依赖并缓存结果，不需要每次都计算。用于派生数据。

### watch() 
watch() 的基本语法
记住这个结构：
watch(
    监听的数据,
    (newValue, oldValue) => {
        // 数据发生变化后执行
    }
)

<script setup lang="ts">
import { ref, watch } from 'vue'

const count = ref(0)

watch(count, (newValue, oldValue) => {
    console.log("count发生变化")
    console.log("旧值:", oldValue)
    console.log("新值:", newValue)
})

function increment() {
    count.value++
}
</script>

<template>
    <div>
        <p>当前值：{{ count }}</p>

        <button @click="increment">
            +1
        </button>
    </div>
</template>

watch() 最重要的用途：副作用
这里出现一个 Vue 非常重要的概念：
副作用（Side Effect）
所谓副作用，可以简单理解成：
除了计算一个值之外，还对外部世界产生影响的操作。

atch() 可以监听多个数据
例如：
const firstName = ref("Tom")
const lastName = ref("Smith")

watch(
    [firstName, lastName],
    ([newFirstName, newLastName]) => {
        console.log(newFirstName)
        console.log(newLastName)
    }
)
任意一个变化，都可能触发回调。

watch() 默认组件加载时不执行。
immediate：组件一加载就执行一次
deep：希望对象任何属性发生变化，都能知道
监听对象、数组

watch(
    keyword,
    (newValue, oldValue) => {
        console.log("执行了")
    },
    {
        immediate: true
    }
)

watch(
    user,
    (newValue, oldValue) => {
        console.log("user发生变化")
    },
    {
        deep: true
    }
)

### watchEffect() 自动追踪依赖
watchEffect() 不需要告诉它监听谁
const count = ref(0)

watchEffect(() => {
    console.log(count.value)
})
watchEffect() 最大的特点：第一次会立即执行

什么时候用 watch()我明确知道我要监听谁，而且我需要知道新旧值。
什么时候用 watchEffect()这段代码依赖哪些响应式数据，我不想手动一个个列出来


## router
Vue 是一个 SPA
Vue 项目通常采用：
SPA（Single Page Application，单页面应用）

意思不是：
整个应用真的只有一个页面。

而是：
浏览器通常只加载一次应用，然后通过 JavaScript 根据 URL 切换页面内容
后端 Router / Controller 处理 HTTP 请求。
Vue Router 主要处理浏览器端页面导航。

npm install vue-router

  history: createWebHashHistory(),   =》url带# ，
    history: createWebHistory(), 不带# 


普通 <a> 是怎么工作的？浏览器会真正发起一次新的页面请求：
RouterLink 不一样Vue Router 会接管这个操作不会重新加载整个网页。

## pinia
npm install pinia

import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({
    count: 0
  })
})

注册
app.use(createPinia())

Actions 就是 Store 中负责执行操作的方法
Action 可以是异步的
actions: {
  async loadUsers() {
    // 调 API
  }
}

actions: {
  async login(username: string, password: string) {
    const response = await api.login(username, password)

    this.token = response.token
    this.user = response.user
  }
}

Getter 是根据 Store 中已有 State 计算出新数据的东西。

## axios
Axios 是一个用于发送 HTTP 请求的 JavaScript/TypeScript 库。

from fastapi import FastAPI

app = FastAPI()


@app.get("/api/users")
def get_users():
    return [
        {"id": 1, "name": "Tom"},
        {"id": 2, "name": "Jerry"},
        {"id": 3, "name": "Alice"}
    ]

npm install axios

import axios from "axios"

const response = await axios.get("/api/users")

console.log(response.data)

创建一个 Axios 实例
import axios from "axios"

const api = axios.create({
    baseURL: "http://localhost:8000",
    timeout: 10000
})

export default api

然后
import axios from "axios"

const api = axios.create({
    baseURL: "http://localhost:8000",
    timeout: 10000
})

export default api


Axios 可以使用：
api.interceptors.request.use(...)
统一添加 Token。
另外还可以：
api.interceptors.response.use(...)
统一处理：
200
401
403
404
500
所以你以后看到：
interceptors.request.use()
interceptors.response.use()

## element plus
npm install element-plus

import ElementPlus from 'element-plus'

app.use(ElementPlus)

<template>

    <el-button>
        普通按钮
    </el-button>

    <el-button type="primary">
        主要按钮
    </el-button>

    <el-button type="success">
        成功
    </el-button>

    <el-button type="danger">
        删除
    </el-button>

</template>

el
就是 Element Plus 组件的命名空间。


