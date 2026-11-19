import { readFile } from "node:fs/promises";
import * as pagefind from "pagefind";

const outputPath = process.argv[2] ?? "public/pagefind";
const documents = JSON.parse(await readFile("public/search_index.ko.json", "utf8"));

function checked(result) {
    if (result.errors.length) {
        throw new Error(result.errors.join("\n"));
    }
    return result;
}

try {
    const { index } = checked(await pagefind.createIndex());
    for (const { url, title, body } of documents) {
        if (!body) continue;

        checked(await index.addCustomRecord({
            url: new URL(url).pathname,
            language: "ko",
            content: `${title}\n${body}`,
            meta: { title },
        }));
    }
    checked(await index.writeFiles({ outputPath }));
} finally {
    await pagefind.close();
}
