import StarterKit from "@tiptap/starter-kit";
import { generateHTML } from "@tiptap/html";
import { getEnabledExtensions } from "./draft_editor";

export function generateHtmlFromContentJson(contentJson) {
  return generateHTML(contentJson, getEnabledExtensions());
}
