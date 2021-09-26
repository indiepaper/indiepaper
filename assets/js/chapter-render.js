import StarterKit from "@tiptap/starter-kit";
import { generateHTML } from "@tiptap/html";

document.addEventListener("alpine:init", () => {
  Alpine.data("chapterRender", (contentJSON) => {
    return {
      renderedContentHtml: generateHTML(contentJSON, [StarterKit]),
    };
  });
});
