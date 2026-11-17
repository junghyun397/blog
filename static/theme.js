(() => {
    const preference = window.matchMedia("(prefers-color-scheme: dark)");
    let saved;

    try {
        saved = localStorage.getItem("theme");
    } catch {}

    function applyTheme(dark) {
        document.documentElement.classList.toggle("dark", dark);
        document.getElementById("theme-toggle")?.setAttribute("aria-pressed", String(dark));
    }

    applyTheme(saved ? saved === "dark" : preference.matches);

    document.addEventListener("DOMContentLoaded", () => {
        applyTheme(document.documentElement.classList.contains("dark"));
        document.getElementById("theme-toggle").addEventListener("click", () => {
            saved = document.documentElement.classList.contains("dark") ? "light" : "dark";
            applyTheme(saved === "dark");

            try {
                localStorage.setItem("theme", saved);
            } catch {}
        });
    });

    preference.addEventListener("change", (event) => {
        if (!saved) applyTheme(event.matches);
    });
})();
