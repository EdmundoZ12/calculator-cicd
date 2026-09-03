package com.devsecops.calculator_cicd.addition;

import com.devsecops.calculator_cicd.adition.AdditionService;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class AdditionServiceTest {

    private final AdditionService additionService = new AdditionService();

    @Test
    void shouldAddTwoPositiveNumbers() {
        double result = additionService.add(2, 3);

        assertEquals(5, result);
    }

    @Test
    void shouldAddPositiveAndNegativeNumbers() {
        double result = additionService.add(-5, 10);

        assertEquals(5, result);
    }

    @Test
    void shouldAddTwoZeroValues() {
        double result = additionService.add(0, 0);

        assertEquals(0, result);
    }

    @Test
    void shouldAddDecimalNumbers() {
        double result = additionService.add(2.5, 3.5);

        assertEquals(6.0, result);
    }
}
