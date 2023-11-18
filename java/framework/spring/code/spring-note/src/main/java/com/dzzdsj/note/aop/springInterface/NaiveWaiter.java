package com.dzzdsj.note.aop.springInterface;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;

@Component
public class NaiveWaiter implements Waiter{
    @Override
    public void greetTo(String name) {
        System.out.println("greet to " + name + "...");
    }

    @Override
    public void serveTo(String name) {
        System.out.println("serve to " + name + "...");
    }

    @Override
    public void beatTo(String name) {
        System.out.println("beating!!!!!!!!!!!!!!!");
        throw new RuntimeException("============beat exception==========");
    }

    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:aopConfig.xml");
        Waiter waiter = (Waiter) context.getBean("waiter");
        waiter.greetTo("Tom");
        waiter.serveTo("Tom");
        waiter.beatTo("Tom");
    }
}
