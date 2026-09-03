package com.devsecops.calculator_cicd.adition;

import org.springframework.stereotype.Service;

@Service
public class AdditionService {

    public double add(double firstNumber, double secondNumber) {
        return firstNumber + secondNumber;
    }
}
