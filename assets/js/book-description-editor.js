import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";
import Link from "@tiptap/extension-link";

export function setupBookDescriptionEditor(
  context,
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
      Link,
    ],
    onUpdate({ editor }) {
      contentHtmlElement.value = editor.getHTML();
      sendUpdate();
    },
    onSelectionUpdate() {
      sendUpdate();
    },
    editorProps: {
      attributes: {
        class: "focus:outline-none font-normal",
      },
    },
  });

  function sendUpdate() {
    let event = new CustomEvent("selection-updated", {});
    context.el.dispatchEvent(event);
  }

  window.toggleHeading = (level) => {
    window.bookDescriptionEditor
      .chain()
      .toggleHeading({ level: level })
      .focus()
      .run();
  };

  window.isActiveSelection = (type, opts = {}) => {
    return window.bookDescriptionEditor.isActive(type, opts);
  };

  window.toggleBold = () => {
    window.bookDescriptionEditor.chain().toggleBold().focus().run();
  };

  window.toggleItalic = () => {
    window.bookDescriptionEditor.chain().toggleItalic().focus().run();
  };
}
