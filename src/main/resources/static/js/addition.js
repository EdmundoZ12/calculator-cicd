const form = document.getElementById("addition-form");
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
            `/api/add?a=${encodeURIComponent(firstNumber)}&b=${encodeURIComponent(secondNumber)}`
        );

        if (!response.ok) {
            throw new Error("No se pudo realizar la operación.");
        }

        const data = await response.json();

        resultElement.textContent = data.result;
        resultContainer.classList.remove("hidden");

    } catch (error) {
        errorElement.textContent =
            "Ocurrió un error al realizar la suma.";
    }
});