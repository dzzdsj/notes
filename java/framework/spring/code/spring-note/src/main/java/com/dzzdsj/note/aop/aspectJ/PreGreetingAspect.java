package com.dzzdsj.note.aop.aspectJ;

import com.dzzdsj.note.aop.springInterface.NaiveWaiter;
import com.dzzdsj.note.aop.springInterface.Waiter;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.aop.aspectj.annotation.AspectJProxyFactory;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

@Aspect
public class PreGreetingAspect {
    @Before("execution( * greetTo(..))")
    public void before()  {
        System.out.println("How are you! " );
    }

    public static void main(String[] args) {
        Waiter waiterTarget = new NaiveWaiter();
        AspectJProxyFactory aspectJProxyFactory = new AspectJProxyFactory();
        aspectJProxyFactory.setTarget(waiterTarget);
        aspectJProxyFactory.addAspect(PreGreetingAspect.class);
        Waiter proxy = aspectJProxyFactory.getProxy();
        proxy.greetTo("Jerry");
    }
}
