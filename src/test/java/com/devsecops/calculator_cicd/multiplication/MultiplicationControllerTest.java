package com.devsecops.calculator_cicd.multiplication;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import org.springframework.test.web.servlet.assertj.MockMvcTester;

import static org.assertj.core.api.Assertions.assertThat;

@WebMvcTest(MultiplicationController.class)
@Import(MultiplicationService.class)
class MultiplicationControllerTest {

    @Autowired
    private MockMvcTester mockMvc;

    @Test
    void shouldReturnMultiplicationResult() {
        assertThat(
                mockMvc.get()
                        .uri("/api/multiply?a=6&b=7")
        )
                .hasStatusOk()
                .bodyJson()
                .extractingPath("$.result")
                .isEqualTo(42.0);
    }

    @Test
    void shouldRejectMissingParameter() {
        assertThat(
                mockMvc.get()
                        .uri("/api/multiply?a=6")
        )
                .hasStatus(HttpStatus.BAD_REQUEST);
    }

    @Test
    void shouldRejectInvalidParameter() {
        assertThat(
                mockMvc.get()
                        .uri("/api/multiply?a=texto&b=7")
        )
                .hasStatus(HttpStatus.BAD_REQUEST);
    }
}