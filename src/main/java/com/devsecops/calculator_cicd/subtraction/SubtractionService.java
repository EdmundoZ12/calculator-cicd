package com.devsecops.calculator_cicd.subtraction;

import org.springframework.stereotype.Service;

@Service
public class SubtractionService {

    public double subtract(double firstNumber, double secondNumber) {
        return firstNumber - secondNumber;
    }
}
