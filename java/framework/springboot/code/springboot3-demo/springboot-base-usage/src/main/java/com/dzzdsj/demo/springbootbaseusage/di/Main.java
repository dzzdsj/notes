package com.dzzdsj.demo.springbootbaseusage.di;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Main {
    public static void main(String[] args) {
        ApplicationContext applicationContext =
                new AnnotationConfigApplicationContext(Conf.class);
        FooService fooService = applicationContext.getBean(FooService.class);
        fooService.hello();
    }

}
