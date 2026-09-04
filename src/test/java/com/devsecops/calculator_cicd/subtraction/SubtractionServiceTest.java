package com.devsecops.calculator_cicd.subtraction;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class SubtractionServiceTest {

    private final SubtractionService subtractionService = new SubtractionService();

    @Test
    void shouldSubtractTwoPositiveNumbers() {
        double result = subtractionService.subtract(10, 4);

        assertEquals(6, result);
    }

    @Test
    void shouldReturnNegativeResultWhenSubtrahendIsGreater() {
        double result = subtractionService.subtract(3, 8);

        assertEquals(-5, result);
    }

    @Test
    void shouldSubtractNegativeNumber() {
        double result = subtractionService.subtract(5, -3);

        assertEquals(8, result);
    }

    @Test
    void shouldSubtractDecimalNumbers() {
        double result = subtractionService.subtract(7.5, 2.5);

        assertEquals(5.0, result);
    }

    @Test
    void shouldSubtractTwoZeroValues() {
        double result = subtractionService.subtract(0, 0);

        assertEquals(0, result);
    }
}
