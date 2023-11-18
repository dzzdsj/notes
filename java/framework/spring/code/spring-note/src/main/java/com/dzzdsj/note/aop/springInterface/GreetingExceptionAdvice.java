package com.dzzdsj.note.aop.springInterface;

import org.springframework.aop.ThrowsAdvice;

import java.lang.reflect.Method;

public class GreetingExceptionAdvice implements ThrowsAdvice {
    //方法名必须为afterThrowing,前三个参数是可选的，但要么都提供，要么都不提供
    public void afterThrowing(Method method, Object[] args, Object target, Throwable exception) {
        System.out.println("---------------");
        System.out.println("method:" + method.getName());
        System.out.println("exception:" + exception.getMessage());
        System.out.println("===============");
    }
}
