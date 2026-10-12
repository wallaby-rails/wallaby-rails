import jquery from 'jquery';
import moment from 'moment';
import Bloodhound from 'typeahead.js/dist/bloodhound';
import WallabyCodeMirror from './codemirror';

window.jQuery = window.$ = jquery
window.moment = moment
window.Bloodhound = Bloodhound

// NOTE: published as `WallabyCodeMirror`, not `CodeMirror`. Summernote's Code
// View reads `window.CodeMirror` and still speaks the CodeMirror 5 API
// (`fromTextArea`, `.on`, `.getDoc`, `.save`, `.toTextArea`, `.setSize`); this
// v6 shim does not implement that surface. Leaving `window.CodeMirror`
// untouched lets Summernote fall back to its plain-textarea code view instead
// of throwing, and avoids clobbering a host-provided CodeMirror.
window.WallabyCodeMirror = WallabyCodeMirror
