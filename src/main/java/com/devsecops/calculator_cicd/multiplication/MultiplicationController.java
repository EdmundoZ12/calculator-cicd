package com.devsecops.calculator_cicd.multiplication;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class MultiplicationController {

    private final MultiplicationService multiplicationService;

    public MultiplicationController(
            MultiplicationService multiplicationService) {
        this.multiplicationService = multiplicationService;
    }

    @GetMapping("/multiply")
    public MultiplicationResponse multiply(
            @RequestParam double a,
            @RequestParam double b) {

        double result = multiplicationService.multiply(a, b);

        return new MultiplicationResponse(a, b, result);
    }
}