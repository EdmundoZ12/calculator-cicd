package com.devsecops.calculator_cicd.division;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DivisionController {

    private final DivisionService divisionService;

    public DivisionController(DivisionService divisionService) {
        this.divisionService = divisionService;
    }

    @GetMapping("/divide")
    public DivisionResponse divide(
            @RequestParam double a,
            @RequestParam double b) {

        double result = divisionService.divide(a, b);

        return new DivisionResponse(a, b, result);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public DivisionErrorResponse handleInvalidDivision(
            IllegalArgumentException exception) {

        return new DivisionErrorResponse(exception.getMessage());
    }
}
