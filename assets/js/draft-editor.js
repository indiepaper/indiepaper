import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

function debounce(func, wait, immediate) {
  var timeout;
  return function () {
    var context = this,
      args = arguments;
    var later = function () {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
}

document.addEventListener("alpine:init", () => {
  Alpine.data(
    "draftEditor",
    (content, draftId, selectedChapterId, csrfToken) => {
      let editor;

      return {
        isEditorLoading: false,
        selectedChapterId: selectedChapterId,
        draftId: draftId,
        selectChapter(chapterId) {
          this.isEditorLoading = true;

          const contentJson = editor.getJSON();
          this.updateContentJson(contentJson);

          this.selectedChapterId = chapterId;

          fetch(`/drafts/${this.draftId}/chapters/${chapterId}/edit`)
            .then((res) => res.json())
            .then((content_json) => {
              editor.commands.setContent(content_json);
              this.isEditorLoading = false;
            });
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
        updateContentJson(contentJson) {
          this.isEditorLoading = true;

          fetch(`/drafts/${this.draftId}/chapters/${this.selectedChapterId}`, {
            method: "PATCH",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-TOKEN": csrfToken,
            },
            body: JSON.stringify({ content_json: contentJson }),
          })
            .then((res) => res.json())
            .then((data) => (this.isEditorLoading = false));
        },
        init() {
          const _this = this;

          editor = new Editor({
            element: this.$refs.editorReference,
            extensions: [StarterKit],
            content: content,
            onCreate({ editor }) {
              _this.updatedAt = Date.now();
            },
            onUpdate: debounce(({ editor }) => {
              console.log("Hello");
              _this.updatedAt = Date.now();
              const contentJson = editor.getJSON();
              _this.updateContentJson(contentJson);
            }, 480),
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
    }
  );
});
