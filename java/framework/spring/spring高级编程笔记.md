spring 高级编程笔记

# 第3章 IOC和DI

通常， IoC可以分解为两种子类型： 依赖注入和依赖查找。

使用依赖查找时，组件必须获取对依赖项的引用，而使用依赖注入时，依赖项将通过IoC 容器注入组件。

依赖查找有两种类型： 依赖拉取（d巳pendency pull, DL）和上下文依赖查找（contextua liz刨出pendency lookup, CDυ 。依赖注入’也有两种常见的风格：构造函数和setter 依赖注入。