const form = document.getElementById("division-form");
const resultContainer = document.getElementById("result-container");
const resultElement = document.getElementById("result");
const errorElement = document.getElementById("error-message");

form.addEventListener("submit", async (event) => {
    event.preventDefault();

    resultContainer.classList.add("hidden");
    errorElement.textContent = "";

    const firstNumber = document.getElementById("firstNumber").value;
    const secondNumber = document.getElementById("secondNumber").value;

    try {
        const response = await fetch(
            `/api/divide?a=${encodeURIComponent(firstNumber)}&b=${encodeURIComponent(secondNumber)}`
        );

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || "No se pudo realizar la operación.");
        }

        resultElement.textContent = data.result;
        resultContainer.classList.remove("hidden");

    } catch (error) {
        errorElement.textContent =
            error.message || "Ocurrió un error al realizar la división.";
    }
});
