import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

document.addEventListener("alpine:init", () => {
  Alpine.data("bookLongDescriptionHtmlEditor", () => {
    let editor;

    return {
      longDescriptionHtml: "",
      isActive(type, opts = {}, updatedAt) {
        return editor.isActive(type, opts);
      },
      toggleItalic() {
        editor.chain().toggleItalic().focus().run();
      },
      toggleBold() {
        editor.chain().toggleBold().focus().run();
      },
      toggleHeading(level) {
        editor.chain().toggleHeading({ level: level }).focus().run();
      },
      updatedAt: Date.now(),
      updateContentHtml(contentHtml) {
        this.longDescriptionHtml = contentHtml;
      },
      init() {
        const _this = this;

        _this.longDescriptionHtml =
          this.$refs.longDescriptionHtmlReference.value;

        editor = new Editor({
          element: this.$refs.editorReference,
          content: _this.longDescriptionHtml,
          extensions: [
            StarterKit.configure({
              heading: {
                levels: [2, 3],
              },
            }),
          ],
          onCreate({ editor }) {
            _this.updatedAt = Date.now();
          },
          onUpdate: ({ editor }) => {
            _this.updatedAt = Date.now();
            const contentHtml = editor.getHTML();
            _this.longDescriptionHtml = contentHtml;
          },
          onSelectionUpdate({ editor }) {
            _this.updatedAt = Date.now();
          },
          editorProps: {
            attributes: {
              class: "focus:outline-none font-normal",
            },
          },
        });
      },
    };
  });
});
