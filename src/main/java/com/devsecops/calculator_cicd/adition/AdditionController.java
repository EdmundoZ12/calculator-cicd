package com.devsecops.calculator_cicd.adition;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class AdditionController {

    private final AdditionService additionService;

    public AdditionController(AdditionService additionService) {
        this.additionService = additionService;
    }

    @GetMapping("/add")
    public AdditionResponse add(
            @RequestParam double a,
            @RequestParam double b) {

        double result = additionService.add(a, b);

        return new AdditionResponse(a, b, result);
    }
}
