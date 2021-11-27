import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

export function setupBookDescriptionEditor(
  contentHtmlElementId,
  editorElementId
) {
  const contentHtmlElement = document.getElementById(contentHtmlElementId);
  const editorElement = document.getElementById(editorElementId);

  window.bookDescriptionEditor = new Editor({
    element: editorElement,
    content: contentHtmlElement.value,
    extensions: [
      StarterKit.configure({
        heading: {
          levels: [2, 3],
        },
      }),
    ],
    onUpdate({ editor }) {
      contentHtmlElement.value = editor.getHTML();
    },
    editorProps: {
      attributes: {
        class: "focus:outline-none font-normal",
      },
    },
  });

  window.toggleHeading = (level) => {
    window.bookDescriptionEditor
      .chain()
      .toggleHeading({ level: level })
      .focus()
      .run();
  };

  window.isActive = (type, opts = {}) => {
    return window.bookDescriptionEditor.isActive(type, opts);
  };

  window.toggleBold = () => {
    window.bookDescriptionEditor.chain().toggleBold().focus().run();
  };

  window.toggleItalic = () => {
    window.bookDescriptionEditor.chain().toggleItalic().focus().run();
  };
}
