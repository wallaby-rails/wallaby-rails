// CodeMirror 6 integration.
//
// Wallaby's form templates are plain `<textarea data-init="codemirror"
// data-mode="...">` elements that expect a `WallabyCodeMirror.fromTextArea(el,
// opts)` helper. This module implements that helper (mirroring the CodeMirror
// 5 template-level API) on top of CodeMirror 6.
//
// Hosts can customise the editors through `window.WallabyCodeMirror.config`
// (published by globals.js; see docs/frontend.md), for example:
//
//   const { EditorView, config } = window.WallabyCodeMirror;
//   config.base.push(EditorView.lineWrapping);                   // all editors
//   config.extensions.markdown = [EditorView.theme({ '&': { backgroundColor: '#eee' } })];
//   config.languages.yaml = () => StreamLanguage.define(/* a legacy mode */);
import { basicSetup, EditorView } from 'codemirror';
import { EditorState } from '@codemirror/state';
import { javascript } from '@codemirror/lang-javascript';
import { json } from '@codemirror/lang-json';
import { markdown, markdownLanguage } from '@codemirror/lang-markdown';
import { xml } from '@codemirror/lang-xml';
import { StreamLanguage } from '@codemirror/language';
import { ruby } from '@codemirror/legacy-modes/mode/ruby';

// Map the `data-mode` values used by the templates to CodeMirror 6 languages.
const languages = {
  // `gfm` mirrors the CodeMirror 5 `gfm` mode: GFM extensions (tables, ...) on
  // top of CommonMark. The plain `markdown` mode stays CommonMark-only.
  gfm: () => markdown({ base: markdownLanguage }),
  markdown: () => markdown(),
  javascript: () => javascript(),
  json: () => json(),
  ruby: () => StreamLanguage.define(ruby),
  xml: () => xml()
};

// Host-overridable editor configuration, published as
// `window.WallabyCodeMirror.config`:
// - `base`: extensions applied to every editor (defaults to basicSetup)
// - `extensions`: extra extensions per `data-mode`
// - `languages`: language factories per `data-mode`; a value may also be a
//   ready LanguageSupport (e.g. from StreamLanguage.define)
const config = {
  base: [basicSetup],
  extensions: {},
  languages
};

function languageFor(mode) {
  const language = config.languages[mode] || config.languages.javascript;
  return typeof language === 'function' ? language() : language;
}

// Mirror the CodeMirror 5 `fromTextArea` behaviour: keep the original
// `<textarea>` (so the form still submits its value), hide it, and render a
// CodeMirror 6 editor next to it, syncing edits back to the textarea.
function fromTextArea(textArea, options = {}) {
  const mode = options.mode || textArea.dataset.mode;

  const view = new EditorView({
    state: EditorState.create({
      doc: textArea.value,
      extensions: [
        ...config.base,
        ...(config.extensions[mode] || []),
        ...(options.extensions || []),
        languageFor(mode),
        EditorView.updateListener.of((update) => {
          if (update.docChanged) {
            textArea.value = update.state.doc.toString();
          }
        })
      ]
    })
  });

  textArea.style.display = 'none';
  textArea.parentNode.insertBefore(view.dom, textArea.nextSibling);

  return {
    view,
    getValue() {
      return view.state.doc.toString();
    },
    setValue(value) {
      view.dispatch({ changes: { from: 0, to: view.state.doc.length, insert: value } });
    }
  };
}

// The primitives are re-exported from the bundle's single CodeMirror 6
// instance so host extensions share it (mixing a separately installed copy of
// `@codemirror/*` can cause duplicated-instance errors).
export default {
  fromTextArea,
  config,
  basicSetup,
  EditorState,
  EditorView,
  StreamLanguage,
  javascript,
  markdown,
  ruby,
  xml
};