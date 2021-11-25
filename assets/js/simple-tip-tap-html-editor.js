import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

export function setupSimpleTipTapHtmlEditor(
  contentHTMLElementId,
  editorElementId
) {
  const contentHTMLElement = document.getElementById(contentHTMLElementId);
  const editorElement = document.getElementById(editorElementId);

  window.tipTapHtmlEditor = new Editor({
    element: editorElement,
    content: contentHTMLElement.value,
    extensions: [StarterKit],
    onUpdate({ editor }) {
      contentHTMLElement.value = editor.getHTML();
    },
    editorProps: {
      attributes: {
        class: "focus:outline-none font-normal",
      },
    },
  });
}
