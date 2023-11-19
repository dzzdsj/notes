package com.dzzdsj.note.aop.springInterface;

import org.springframework.aop.ClassFilter;
import org.springframework.aop.support.StaticMethodMatcherPointcutAdvisor;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.lang.reflect.Method;

/**
 * 演示静态方法匹配切面
 */
public class GreetingMatcherAdvice extends StaticMethodMatcherPointcutAdvisor {
    @Override
    public boolean matches(Method method, Class<?> targetClass) {
        return "greetTo".equals(method.getName());
        //这么写就不需要定义下面的getClassFilter()方法
//        return "greetTo".equals(method.getName()) && Waiter.class.isAssignableFrom(targetClass);

//        return "greetTo".equals(method.getName()) &&
//                (Waiter.class.isAssignableFrom(targetClass) || Seller.class.isAssignableFrom(targetClass));
    }


    /**
     * 自定义切点类的匹配规则
     * @return
     */
    public ClassFilter getClassFilter() {
        return new ClassFilter() {
            @Override
            public boolean matches(Class<?> clazz) {
                return Waiter.class.isAssignableFrom(clazz);
//                return Waiter.class.isAssignableFrom(clazz) || Seller.class.isAssignableFrom(clazz);
            }
        };
    }

    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:aopConfig.xml");
//       静态方法匹配
        Waiter waiter = (Waiter) context.getBean("adviceWaiter");
        Seller seller = (Seller) context.getBean("adviceSeller");
        waiter.greetTo("Tom");
        waiter.serveTo("Tom");
//        waiter.beatTo("Tom");
        seller.greetTo("Tom");

//正则匹配
        Waiter regexpWaiter = (Waiter) context.getBean("regexpAdviceWaiter");
        regexpWaiter.greetTo("Tom");
        regexpWaiter.serveTo("Tom");
    }

}
