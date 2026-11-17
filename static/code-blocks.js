for (const code of document.querySelectorAll(".content pre > code")) {
    const pre = code.parentElement;
    const block = document.createElement("div");
    block.className = "code-block";
    block.style.backgroundColor = pre.style.backgroundColor;
    block.style.color = pre.style.color;

    const header = document.createElement("div");
    header.className = "code-header";

    const title = document.createElement("span");
    title.className = "min-w-0 break-all";
    title.textContent = code.dataset.title || code.dataset.lang;

    const button = document.createElement("button");
    button.type = "button";
    button.className = "shrink-0 cursor-pointer hover:underline";
    button.textContent = "Copy";

    button.addEventListener("click", () => {
        const content = code.cloneNode(true);
        content.querySelectorAll(".giallo-ln").forEach((number) => number.remove());
        navigator.clipboard.writeText(content.textContent).catch(console.error);
    });

    header.append(title, button);
    pre.before(block);
    block.append(header, pre);
}
