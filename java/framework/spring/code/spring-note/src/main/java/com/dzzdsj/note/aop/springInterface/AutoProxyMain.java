package com.dzzdsj.note.aop.springInterface;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * DefaultAdvisorAutoProxyCreator 自动代理演示
 */
public class AutoProxyMain {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:aopConfig.xml");
//自动创建代理
        Waiter waiter = (Waiter) context.getBean("naiveWaiterTarget");
        waiter.greetTo("Tom");
        waiter.serveTo("Tom");

        Seller seller = (Seller) context.getBean("sellerTarget");
        seller.greetTo("Tom");
    }
}
