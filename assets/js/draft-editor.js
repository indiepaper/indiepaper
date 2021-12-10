import { Editor, EditorContent } from "@tiptap/vue-2";
import Document from "@tiptap/extension-document";
import StarterKit from "@tiptap/starter-kit";
import Vue from "vue/dist/vue.common.prod";
import axios from "axios";
import jp from "jsonpath";
import throttle from "lodash.throttle";
import * as fastjsonpatch from "fast-json-patch";

function truncateWords(str, num) {
  return str.split(" ").slice(0, num).join(" ");
}

const CustomDocument = Document.extend({
  content: "heading block*",
});

function getRawJSON(obj) {
  return JSON.parse(JSON.stringify(obj));
}

const app = new Vue({
  el: "#draft-editor",
  components: {
    EditorContent,
  },
  data: {
    editor: null,
    isEditorError: false,
    selectedChapterId: initialChapterId,
    isEditingSelectedChapter: false,
    editedChapterTitle: "",
    isDraftChapterLoading: false,
    draftChapters: draftChapters,
    isDraftLoading: false,
    draftId: draftId,
    bookId: bookId,
    csrfToken: csrfToken,
    content: {},
    persistedContent: {},
    isActive(type, opts = {}) {
      return this.editor?.isActive(type, opts);
    },
    updatedAt: Date.now(),
  },
  computed: {
    sortedDraftChapters() {
      return this.draftChapters.sort((dc) => dc.chapter_index);
    },
  },
  watch: {
    selectedChapterId(value) {
      this.isEditingSelectedChapter = false;
    },
    content(contentJSON) {
      const title = getChapterTitle(contentJSON);

      if (title) {
        this.draftChapters.forEach((c, index) => {
          if (c.id === this.selectedChapterId) {
            c.title = truncateWords(title, 8);
          }
        });
      }

      this.persistContent(contentJSON);
    },
  },
  methods: {
    persistContent: throttle(function (contentJSON) {
      const delta = fastjsonpatch.compare(this.persistedContent, contentJSON);

      axios
        .patch(`/drafts/${this.draftId}/chapters/${this.selectedChapterId}`, {
          delta: delta,
        })
        .then((res) => {
          this.persistedContent = contentJSON;
          this.isEditorError = false;
        })
        .catch(() => (this.isEditorError = true));
    }, 160),
    selectChapter(chapter) {
      this.isDraftLoading = true;
      this.selectedChapterId = chapter.id;

      axios
        .get(`/drafts/${this.draftId}/chapters/${this.selectedChapterId}`)
        .then((res) => {
          this.persistedContent = this.content = res.data.contentJSON;
          this.editor.commands.setContent(res.data.contentJSON);
        })
        .finally(() => (this.isDraftLoading = false));
    },
    addDraftChapter() {
      this.isDraftChapterLoading = true;
      axios
        .post(`/drafts/${this.draftId}/chapters/`)
        .then((res) => this.draftChapters.push(res.data.chapter))
        .finally(() => (this.isDraftChapterLoading = false));
    },
  },
  mounted() {
    axios.defaults.withCredentials = true;
    axios.defaults.headers["X-CSRF-TOKEN"] = this.csrfToken;

    this.presistedContent = this.content = chapterContentJSON;

    this.editor = new Editor({
      content: chapterContentJSON,
      extensions: [
        CustomDocument,
        StarterKit.configure({
          document: false,
        }),
      ],
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

function getChapterTitle(contentJSON) {
  const title = jp.value(contentJSON, "$.content[0].content[0].text");
  return title;
}
