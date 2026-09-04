package com.devsecops.calculator_cicd.multiplication;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class MultiplicationServiceTest {

    private final MultiplicationService service =
            new MultiplicationService();

    @Test
    void shouldMultiplyPositiveNumbers() {
        assertEquals(42.0, service.multiply(6, 7));
    }

    @Test
    void shouldMultiplyPositiveAndNegativeNumbers() {
        assertEquals(-12.0, service.multiply(-3, 4));
    }

    @Test
    void shouldMultiplyTwoNegativeNumbers() {
        assertEquals(12.0, service.multiply(-3, -4));
    }

    @Test
    void shouldReturnZeroWhenMultiplyingByZero() {
        assertEquals(0.0, service.multiply(5, 0));
        assertEquals(0.0, service.multiply(0, 5));
    }

    @Test
    void shouldMultiplyDecimals() {
        assertEquals(0.02, service.multiply(0.1, 0.2), 0.000000001);
    }
}