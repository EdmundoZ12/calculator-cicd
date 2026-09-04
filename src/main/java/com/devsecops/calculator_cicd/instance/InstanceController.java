package com.devsecops.calculator_cicd.instance;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class InstanceController {

    @Value("${spring.application.name}")
    private String application;

    @Value("${app.version}")
    private String version;

    @Value("${app.instance}")
    private String instance;

    @Value("${server.port:8080}")
    private String port;

    @GetMapping("/instance")
    public InstanceResponse getInstance() {
        return new InstanceResponse(
                application,
                version,
                instance,
                port
        );
    }
}