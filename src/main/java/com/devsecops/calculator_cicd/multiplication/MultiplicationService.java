package com.devsecops.calculator_cicd.multiplication;

import org.springframework.stereotype.Service;

@Service
public class MultiplicationService {

    public double multiply(double firstNumber, double secondNumber) {
        return firstNumber * secondNumber;
    }
}