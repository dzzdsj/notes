package com.dzzdsj.demo.springbootbaseusage.di;

import org.springframework.stereotype.Service;

@Service
public class FooService {
    public void hello() {
        System.out.println("hello,I'm Foo");
    }
}
