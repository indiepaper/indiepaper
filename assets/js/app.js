// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

import Alpine from "alpinejs";
window.Alpine = Alpine;
Alpine.start();

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};
Hooks.SimpleTipTapHtmlEditor = {
  mounted() {
    const contentHTMLElementId = this.el.dataset.contentHtmlElementId;
    const editorElementId = this.el.dataset.editorElementId;
    import("./simple_tip_tap_html_editor").then(
      ({ setupSimpleTipTapHtmlEditor }) => {
        setupSimpleTipTapHtmlEditor(contentHTMLElementId, editorElementId);
      }
    );
  },
};

Hooks.BookLongDescriptionEditor = {
  mounted() {
    const contentHTMLElementId = this.el.dataset.contentHtmlElementId;
    const editorElementId = this.el.dataset.editorElementId;
    const context = this;

    import("./book_description_editor").then(
      ({ setupBookDescriptionEditor }) => {
        setupBookDescriptionEditor(
          context,
          contentHTMLElementId,
          editorElementId
        );
      }
    );
  },
};

Hooks.DraftEditor = {
  mounted() {
    const chapterContentJson = JSON.parse(this.el.dataset.chapterContentJson);
    const editorElementId = this.el.dataset.editorElementId;
    const context = this;

    import("./draft_editor").then(({ setupDraftEditor }) => {
      setupDraftEditor(context, editorElementId, chapterContentJson);
    });
  },
  updated() {
    const chapterContentJson = JSON.parse(this.el.dataset.chapterContentJson);
    import("./draft_editor").then(({ updateDraftEditor }) => {
      updateDraftEditor(chapterContentJson);
    });
  },
  reconnected() {
    // Send the entire json on reconnect
    const contentJson = window.draftEditor.getJSON();
    this.pushEvent("editor_reconnected", { content_json: contentJson });
    window.persistedContent = {};
    import("./draft_editor").then(({ sendPersistSuccess }) => {
      sendPersistSuccess(this);
    });
  },
  disconnected() {
    import("./draft_editor").then(({ sendPersistError }) => {
      sendPersistError(this);
    });
  },
};

Hooks.BookReaderHook = {
  mounted() {
    const readerElement = document.getElementById(
      this.el.dataset.readerElementId
    );
    const initialChapterContentJson = JSON.parse(
      this.el.dataset.chapterContentJson
    );
    const context = this;

    this.loadAndSetContent(context, readerElement, initialChapterContentJson);
  },
  updated() {
    const readerElement = document.getElementById(
      this.el.dataset.readerElementId
    );
    const context = this;
    const chapterContentJson = JSON.parse(this.el.dataset.chapterContentJson);
    this.loadAndSetContent(context, readerElement, chapterContentJson);
  },

  loadAndSetContent(context, readerElement, contentJson) {
    import("./book_reader").then(({ generateHtmlFromContentJson }) => {
      readerElement.innerHTML = generateHtmlFromContentJson(contentJson);
      let event = new CustomEvent("reader-loaded");
      context.el.dispatchEvent(event);
    });
  },
};

let Uploaders = {};
Uploaders.S3 = function(entries, onViewError) {
  entries.forEach((entry) => {
    let formData = new FormData();
    let { url, fields } = entry.meta;
    Object.entries(fields).forEach(([key, val]) => formData.append(key, val));
    formData.append("file", entry.file);
    let xhr = new XMLHttpRequest();
    onViewError(() => xhr.abort());
    xhr.onload = () =>
      xhr.status === 204 ? entry.progress(100) : entry.error();
    xhr.onerror = () => entry.error();
    xhr.upload.addEventListener("progress", (event) => {
      if (event.lengthComputable) {
        let percent = Math.round((event.loaded / event.total) * 100);
        if (percent < 100) {
          entry.progress(percent);
        }
      }
    });

    xhr.open("POST", url, true);
    xhr.send(formData);
  });
};

const host = window.location.host;
let liveHost = "";

if (host === "indiepaper.co") {
  liveHost = "wss://app.indiepaper.co";
} else if (host === "indiepaper.me") {
  liveHost = "wss://app.indiepaper.me";
}
const socketHost = `${liveHost}/live`


let liveSocket = new LiveSocket(socketHost, Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  uploaders: Uploaders,
  dom: {
    onBeforeElUpdated(from, to) {
      if (!window.Alpine) return;

      if (from.nodeType !== 1) return;

      // If the element we are updating is an Alpine component...
      if (from._x_dataStack) {
        // Then temporarily clone it (with it's data) to the "to" element.
        // This should simulate LiveView being aware of Alpine changes.
        window.Alpine.clone(from, to);
      }
    },
  },
});

// Show progress bar on live navigation and form submits
let progressTimeout = null;
topbar.config({ barColors: { 0: "#FB923C" } });

window.addEventListener("phx:page-loading-start", () => {
  clearTimeout(progressTimeout);
  progressTimeout = setTimeout(topbar.show, 0);
});

window.addEventListener("phx:page-loading-stop", () => {
  clearTimeout(progressTimeout);
  progressTimeout = setTimeout(topbar.hide, 0);
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
//liveSocket.enableDebug();
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
