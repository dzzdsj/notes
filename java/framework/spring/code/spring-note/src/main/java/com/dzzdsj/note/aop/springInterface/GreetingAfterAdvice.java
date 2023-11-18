package com.dzzdsj.note.aop.springInterface;

import org.springframework.aop.AfterReturningAdvice;
import org.springframework.aop.MethodBeforeAdvice;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * AfterReturningAdvice 后置增强
 */
@Component
public class GreetingAfterAdvice implements AfterReturningAdvice {
    @Override
    public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
        String clientName = (String) args[0];
        System.out.println("Please enjoy yourself! Mr." + clientName + ".");
    }
}
