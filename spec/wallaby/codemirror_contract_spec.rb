# frozen_string_literal: true

require 'rails_helper'

# Guards the CodeMirror 6 integration contract (PR #257 review).
#
# Wallaby's own form editors must go through the `WallabyCodeMirror` global,
# while `window.CodeMirror` must stay free for Summernote's Code View, which
# only understands the CodeMirror 5 API.
#
# These are source/grep assertions: there is no JS test harness in this repo,
# so they lock the published-global contract instead of observing runtime
# behaviour (e.g. the Summernote `cmEditor.on is not a function` throw). They
# are asserted against both the sources and the generated bundle so that a
# `window.CodeMirror =` added anywhere in the pipeline fails the suite.
describe 'CodeMirror integration' do
  repo_root = File.expand_path('../..', __dir__)
  forms = File.join(repo_root, 'wallaby/app/views/wallaby/resources/form')
  bundle = File.join(repo_root, 'wallaby/app/assets/javascripts/wallaby/core.js')

  codemirror_partials = %w[json jsonb hstore xml markdown].map { |name| File.join(forms, "_#{name}.html.erb") }
  summernote_partials = %w[text longtext mediumtext tinytext citext].map { |name| File.join(forms, "_#{name}.html.erb") }
  globals = File.join(repo_root, 'wallaby/app/javascript/wallaby/globals.js')

  it 'initialises Wallaby editors through the WallabyCodeMirror global' do
    codemirror_partials.each do |path|
      expect(File.read(path)).to match(/WallabyCodeMirror\.fromTextArea/)
    end
  end

  it 'does not call the CodeMirror 5 global from the partials' do
    codemirror_partials.each do |path|
      source = File.read(path)
      expect(source).not_to include('CodeMirror.defaults')
      expect(source).not_to match(/(?<!Wallaby)CodeMirror\.fromTextArea/)
    end
  end

  it 'does not pass a Summernote CodeMirror option' do
    summernote_partials.each do |path|
      expect(File.read(path)).not_to include('codemirror:')
    end
  end

  it 'publishes the shim as WallabyCodeMirror and leaves window.CodeMirror unset in the sources' do
    source = File.read(globals)
    expect(source).to include('window.WallabyCodeMirror = WallabyCodeMirror')
    expect(source).not_to match(/window\.CodeMirror\s*=/)
  end

  it 'ships a bundle that publishes WallabyCodeMirror and never assigns window.CodeMirror' do
    bundle_text = File.read(bundle)
    expect(bundle_text).to include('window.WallabyCodeMirror = ')
    expect(bundle_text).not_to match(/window\.CodeMirror\s*=/)
  end
end
