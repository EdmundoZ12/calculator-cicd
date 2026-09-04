const form = document.getElementById("multiplication-form");
const resultContainer = document.getElementById("result-container");
const resultElement = document.getElementById("result");
const errorElement = document.getElementById("error-message");

form.addEventListener("submit", async (event) => {
    event.preventDefault();

    resultContainer.classList.add("hidden");
    errorElement.textContent = "";

    const a = document.getElementById("firstNumber").value;
    const b = document.getElementById("secondNumber").value;

    try {
        const response = await fetch(
            `/api/multiply?a=${encodeURIComponent(a)}&b=${encodeURIComponent(b)}`
        );

        if (!response.ok) {
            throw new Error("Error al multiplicar");
        }

        const data = await response.json();
        resultElement.textContent = data.result;
        resultContainer.classList.remove("hidden");
    } catch (error) {
        errorElement.textContent =
            "No se pudo realizar la multiplicación.";
    }
});