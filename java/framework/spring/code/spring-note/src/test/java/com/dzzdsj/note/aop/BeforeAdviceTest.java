package com.dzzdsj.note.aop;

import com.dzzdsj.note.aop.springInterface.GreetingBeforeAdvice;
import com.dzzdsj.note.aop.springInterface.NaiveWaiter;
import com.dzzdsj.note.aop.springInterface.Waiter;
import org.springframework.aop.BeforeAdvice;
import org.springframework.aop.framework.ProxyFactory;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

public class BeforeAdviceTest {
    private Waiter target;
    private BeforeAdvice beforeAdvice;
    private ProxyFactory proxyFactory;

    @BeforeTest
    public void init() {
        target = new NaiveWaiter();
        beforeAdvice = new GreetingBeforeAdvice();
        proxyFactory = new ProxyFactory();
        proxyFactory.setTarget(target);
        proxyFactory.addAdvice(beforeAdvice);
    }

    @Test
    public void beforeAdvie() {
        Waiter proxy = (Waiter) proxyFactory.getProxy();
        proxy.greetTo("Tom");
        proxy.serveTo("Tom");

    }
}
