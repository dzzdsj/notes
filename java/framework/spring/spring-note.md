

# AOP

### AOP术语

**连接点（Joinpoint）**

程序执行的某个特定位置，如类开始初始化前、类初始化后、类某个方法调用前和调用后、方法抛出异常后。一个类或一段程序代码拥有一些具有边界性质的特定点，这些代码中的特定点就称为“连接点”。

Spring 仅支持方法的连接点，即仅能在方法调用前、方法调用后、方法抛出异常时以及方法调用前后这些程序执行点织入增强。

**切点（Pointcut）**

每个程序类都拥有多个连接点，如一个拥有两个方法的类，这两个方法都是连接点，即连接点是程序类中客观存在的事物。但在这为数众多的连接点中，如何定位到某个感兴趣的连接点上呢?AOP通过“切点”定位特定接连点。通过数据库查询的概念来理解切点和连接点的关系再适合不过了:连接点相当于数据库中的记录，而切点相当于查询条件。切点和连接点不是一对一的关系，一个切点可以匹配多个连接点。

Spring通过org.springframework.aop.Pointcut 接口描述切点，Pointcut由ClassFilter和MethodMatcher构成,它通过ClassFilter定位到某些特定类上,通过MethodMatcher定位到某些特定方法上，这样 Pointcut 就拥有了描述某些类的某些特定方法的能力。

ClassFilter只定义了一个方法matches(Class clazz),其参数代表一个被检测类,该方法判别被检测的类是否匹配过滤条件。

Spring支持两种方法匹配器:静态方法匹配器和动态方法匹配器

静态方法匹配器仅对方法名签名(包括方法名和入参类型及顺序)进行匹配;而动态方法匹配器会在运行期检查方法入参的值。静态匹配仅会判别一次;

而动态匹配因为每次调用方法的入参都可能不一样，所以每次调用方法都必须判断,因此，动态匹配对性能的影响很大。一般情况下，动态匹配不常使用。

**增强（Advice）**

增强是织入目标类连接点上的一段程序代码。

**目标对象（Target）**

增强逻辑的织入目标类。

**引介（Introduction）**

引介是一种特殊的增强,它为类添加一些属性和方法。这样,即使一个业务类原本没有实现某个接口，通过AOP 的引介功能，也可以动态地为该业务类添加接口的实现逻辑，让业务类成为这个接口的实现类。

**织入（Weaving）**
织入是将增强添加到目标类具体连接点上的过程。

根据不同的实现技术,AOP有3种织入的方式。

1. 编译期织入,这要求使用特殊的Java编译器。
2. 类装载期织入,这要求使用特殊的类装载器。
3. 动态代理织入,在运行期为目标类添加增强生成子类的方式。

Spring采用动态代理织入，而 AspectJ采用编译期织入和类装载期织入。

**代理（Proxy）**

一个类被AOP织入增强后，就产出了一个结果类，它是融合了原类和增强逻辑的代理类。根据不同的代理方式，代理类既可能是和原类具有相同接口的类，也可以是原类的子类，所以可以采用与调用原类相同的方式调用代理类。

**切面（Aspect）**

切面由切点和增强(引介)组成,它既包括了横切逻辑的定义，也包括了连接点的定义,SpringAOP就是负责实施切面的框架，它将切面所定义的横切逻辑织人切面所指定的连接点中。

 AOP的工作重心在于如何将增强应用于目标对象的连接点上，这里首先包括两个工作:第一，如何通过切点和增强定位到连接点上;第二，如何在增强中编写切面的代码。









