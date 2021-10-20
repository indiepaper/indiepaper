import { Editor, EditorContent } from "@tiptap/vue-2";
import StarterKit from "@tiptap/starter-kit";
import Vue from "vue/dist/vue.common.prod";

const app = new Vue({
  el: "#draft-editor",
  components: {
    EditorContent,
  },
  data: {
    editor: null,
    content: null,
    isActive(type, opts = {}) {
      return this.editor?.isActive(type, opts);
    },
    selectedChapterId: "",
    draftId: "",
    updatedAt: Date.now(),
  },
  mounted() {
    this.editor = new Editor({
      content: chapterContentJSON,
      extensions: [StarterKit],
      editorProps: {
        attributes: {
          class: "focus:outline-none",
        },
      },
      onUpdate: () => {
        this.content = this.editor.getJSON();
      },
    });
  },
  beforeDestroy() {
    this.editor.destroy();
  },
});

/*
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
        isThrottling: false,
        isEditorLoading: false,
        isEditorError: false,
        selectedChapterId: selectedChapterId,
        draftId: draftId,
        selectChapter(chapterId) {
          this.isEditorLoading = true;

          const contentJson = editor.getJSON();
          this.updateContentJson(contentJson);

          this.selectedChapterId = chapterId;

          fetch(`/drafts/${this.draftId}/chapters/${chapterId}`)
            .then((res) => res.json())
            .then((content_json) => {
              editor.commands.setContent(content_json);
              this.isEditorLoading = false;
            })
            .catch(() => (this.isEditorError = true));
        },
        saveCurrentChapterContentJson() {
          this.isEditorError = false;
          const contentJson = editor.getJSON();
          this.updateContentJson(contentJson);
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
          if (this.isThrottling) return;

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
            .then((data) => (this.isEditorLoading = false))
            .catch(() => (this.isEditorError = true));

          this.isThrottling = true;
          setTimeout(() => {
            this.isThrottling = false;
          }, 1280);
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
            onUpdate: ({ editor }) => {
              _this.updatedAt = Date.now();
              const contentJson = editor.getJSON();
              _this.updateContentJson(contentJson);
            },
            onBlur({ editor, event }) {
              const contentJson = editor.getJSON();
              _this.updateContentJson(contentJson);
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
    }
  );
});
*/
