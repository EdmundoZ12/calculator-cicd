package com.devsecops.calculator_cicd.division;

import org.springframework.stereotype.Service;

@Service
public class DivisionService {

    public double divide(double firstNumber, double secondNumber) {

        if (secondNumber == 0) {
            throw new IllegalArgumentException(
                    "No es posible dividir entre cero."
            );
        }

        return firstNumber / secondNumber;
    }
}
