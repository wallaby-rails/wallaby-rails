// CodeMirror 6 integration.
//
// Wallaby's form templates are plain `<textarea data-init="codemirror"
// data-mode="...">` elements that expect a `WallabyCodeMirror.fromTextArea(el,
// opts)` helper. This module implements that helper (mirroring the CodeMirror
// 5 template-level API) on top of CodeMirror 6.
import { basicSetup, EditorView } from 'codemirror';
import { EditorState } from '@codemirror/state';
import { javascript } from '@codemirror/lang-javascript';
import { markdown } from '@codemirror/lang-markdown';
import { xml } from '@codemirror/lang-xml';
import { StreamLanguage } from '@codemirror/language';
import { ruby } from '@codemirror/legacy-modes/mode/ruby';

// Map the `data-mode` values used by the templates to CodeMirror 6 languages.
const LANGUAGES = {
  gfm: () => markdown(),
  markdown: () => markdown(),
  javascript: () => javascript(),
  json: () => javascript(),
  ruby: () => StreamLanguage.define(ruby),
  xml: () => xml()
};

function languageFor(mode) {
  const factory = LANGUAGES[mode] || LANGUAGES.javascript;
  return factory();
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
        basicSetup,
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

export default { fromTextArea };
