package com.dzzdsj.note.aop.springInterface;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@Configuration
@ComponentScan(basePackages = "com.dzzdsj.note.aop")
public class AOPConfig {
}
