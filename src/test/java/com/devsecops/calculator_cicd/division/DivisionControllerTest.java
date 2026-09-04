package com.devsecops.calculator_cicd.division;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import org.springframework.test.web.servlet.assertj.MockMvcTester;

import static org.assertj.core.api.Assertions.assertThat;

@WebMvcTest(DivisionController.class)
@Import(DivisionService.class)
class DivisionControllerTest {

    @Autowired
    private MockMvcTester mockMvc;

    @Test
    void shouldReturnDivisionResult() {

        assertThat(
                mockMvc.get()
                        .uri("/api/divide?a=10&b=2")
        )
                .hasStatusOk()
                .bodyJson()
                .extractingPath("$.result")
                .isEqualTo(5.0);
    }

    @Test
    void shouldReturnBadRequestWhenDividingByZero() {

        assertThat(
                mockMvc.get()
                        .uri("/api/divide?a=10&b=0")
        )
                .hasStatus(HttpStatus.BAD_REQUEST)
                .bodyJson()
                .extractingPath("$.error")
                .isEqualTo("No es posible dividir entre cero.");
    }
}
