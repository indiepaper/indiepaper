import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

window.setupSimpleTipTapHtmlEditor = (
  contentHTMLElementId,
  editorElementId
) => {
  const contentHTMLElement = document.getElementById(contentHTMLElementId);
  const editorElement = document.getElementById(editorElementId);

  window.tipTapHtmlEditor = new Editor({
    element: editorElement,
    content: contentHTMLElement.value,
    extensions: [
      StarterKit.configure({
        blockquote: false,
        codeBlock: false,
        heading: false,
        horizontalRule: false,
        bold: false,
        code: false,
        italic: false,
        strike: false,
      }),
    ],
    onUpdate({ editor }) {
      contentHTMLElement.value = editor.getHTML();
    },
    editorProps: {
      attributes: {
        class: "focus:outline-none font-normal",
      },
    },
  });
};
