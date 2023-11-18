package com.dzzdsj.note.aop.springInterface;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

/**
 * 环绕增强示例
 */
public class GreetingAroundAdvice implements MethodInterceptor {
    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        Object args[] = invocation.getArguments();//目标方法入参
        String clientName = (String) args[0];
        System.out.println("Nice to meet you! Mr." + clientName + ".");

        Object object = invocation.proceed();

        System.out.println("You are beautiful! Mr." + clientName + ".");
        return object;
    }
}
