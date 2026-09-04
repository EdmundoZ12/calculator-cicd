package com.devsecops.calculator_cicd.subtraction;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SubtractionController {

    private final SubtractionService subtractionService;

    public SubtractionController(SubtractionService subtractionService) {
        this.subtractionService = subtractionService;
    }

    @GetMapping("/subtract")
    public SubtractionResponse subtract(
            @RequestParam double a,
            @RequestParam double b) {

        double result = subtractionService.subtract(a, b);

        return new SubtractionResponse(a, b, result);
    }
}
