package com.devsecops.calculator_cicd.division;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class DivisionServiceTest {

    private final DivisionService divisionService = new DivisionService();

    @Test
    void shouldDivideTwoPositiveNumbers() {
        double result = divisionService.divide(10, 2);

        assertEquals(5, result);
    }

    @Test
    void shouldDividePositiveAndNegativeNumbers() {
        double result = divisionService.divide(-20, 4);

        assertEquals(-5, result);
    }

    @Test
    void shouldDivideDecimalNumbers() {
        double result = divisionService.divide(7.5, 2.5);

        assertEquals(3.0, result);
    }

    @Test
    void shouldReturnZeroWhenDividendIsZero() {
        double result = divisionService.divide(0, 5);

        assertEquals(0, result);
    }

    @Test
    void shouldRejectDivisionByZero() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> divisionService.divide(10, 0)
        );

        assertEquals(
                "No es posible dividir entre cero.",
                exception.getMessage()
        );
    }

    @Test
    void shouldRejectDivisionByNegativeZero() {
        assertThrows(
                IllegalArgumentException.class,
                () -> divisionService.divide(10, -0.0)
        );
    }
}
