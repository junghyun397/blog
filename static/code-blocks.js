for (const button of document.querySelectorAll(".code-header button")) {
    button.addEventListener("click", () => {
        const code = button.closest("pre").querySelector("code").cloneNode(true);
        code.querySelectorAll(".giallo-ln").forEach((number) => number.remove());
        navigator.clipboard.writeText(code.textContent)
            .then(() => {
                button.textContent = button.textContent === "Copy"
                    ? "Copied"
                    : button.textContent + " again";
            })
            .catch(console.error);
    });
}
