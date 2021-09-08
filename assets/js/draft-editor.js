import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

document.addEventListener("alpine:init", () => {
  Alpine.data("draftEditor", (content, selectedChapterId) => {
    let editor;

    return {
      selectedChapterId: selectedChapterId,
      setSelectedChapterId(chapterId) {
        this.selectedChapterId = chapterId;
      },
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
          editorProps: {
            attributes: {
              class: "focus:outline-none",
            },
          },
        });
      },
    };
  });
});
