import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

document.addEventListener("alpine:init", () => {
  Alpine.data("draftEditor", (content, draftId, selectedChapterId) => {
    let editor;

    return {
      isEditorLoading: false,
      selectedChapterId: selectedChapterId,
      draftId: draftId,
      selectChapter(chapterId) {
        this.isLoading = true;
        this.selectedChapterId = chapterId;

        fetch(`/drafts/${this.draftId}/chapters/${chapterId}/edit`)
          .then((res) => res.json())
          .then((content_json) => editor.commands.setContent(content_json));
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
