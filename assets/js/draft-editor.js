import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

document.addEventListener("alpine:init", () => {
  Alpine.data("draftEditor", (content) => {
    let editor;

    return {
      isActive(type, opts = {}, updatedAt) {
        return editor.isActive(type, opts);
      },
      toggleBold() {
        editor.chain().toggleBold().focus().run();
      },
      toggleHeading(level) {
        editor.chain().toggleHeading({ level: level }).focus().run();
      },
      updatedAt: Date.now(),
      init() {
        const _this = this;

        editor = new Editor({
          element: this.$refs.editorReference,
          extensions: [StarterKit],
          content: content,
          onCreate({ editor }) {
            _this.updatedAt = Date.now();
          },
          onUpdate({ editor }) {
            _this.updatedAt = Date.now();
          },
          onSelectionUpdate({ editor }) {
            _this.updatedAt = Date.now();
          },
        });
      },
    };
  });
});
