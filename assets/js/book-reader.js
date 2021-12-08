import StarterKit from "@tiptap/starter-kit";
import { generateHTML } from "@tiptap/html";

export function generateHtmlFromContentJson(contentJson) {
  return generateHTML(contentJson, [StarterKit]);
}
