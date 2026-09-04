package com.devsecops.calculator_cicd.subtraction;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import org.springframework.test.web.servlet.assertj.MockMvcTester;

import static org.assertj.core.api.Assertions.assertThat;

@WebMvcTest(SubtractionController.class)
@Import(SubtractionService.class)
class SubtractionControllerTest {

    @Autowired
    private MockMvcTester mockMvc;

    @Test
    void shouldReturnSubtractionResult() {
        assertThat(
                mockMvc.get()
                        .uri("/api/subtract?a=10&b=4")
        )
                .hasStatusOk()
                .bodyJson()
                .extractingPath("$.result")
                .isEqualTo(6.0);
    }

    @Test
    void shouldRejectMissingParameter() {
        assertThat(
                mockMvc.get()
                        .uri("/api/subtract?a=10")
        )
                .hasStatus(HttpStatus.BAD_REQUEST);
    }

    @Test
    void shouldRejectInvalidParameter() {
        assertThat(
                mockMvc.get()
                        .uri("/api/subtract?a=texto&b=4")
        )
                .hasStatus(HttpStatus.BAD_REQUEST);
    }
}
