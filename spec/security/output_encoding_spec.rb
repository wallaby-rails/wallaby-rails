# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for stored/reflected XSS in Wallaby views.
#
# Covers OWASP A03: model content and flash/error messages must not be rendered
# as raw HTML. See the audit finding H1.
describe 'Wallaby output encoding', type: :view do
  describe 'show/_raw partial' do
    let(:partial) { 'wallaby/resources/show/raw' }
    let(:value) { '<script>alert(1)</script>' }

    before do
      render partial: partial, locals: { value: value, metadata: {}, object: nil, field_name: 'body' }
    end

    it 'does not render an executable script tag' do
      expect(rendered).not_to include '<script>'
    end
  end

  describe 'index/_raw partial' do
    let(:partial) { 'wallaby/resources/index/raw' }
    let(:value) { '<img src=x onerror=alert(1)>' }

    before do
      render partial: partial, locals: { value: value, metadata: {}, object: nil, field_name: 'body' }
    end

    it 'strips the event handler attribute' do
      expect(rendered).not_to include 'onerror'
    end
  end

  describe 'flash messages partial' do
    let(:partial) { 'wallaby/resources/flash_messages' }

    it 'escapes an attacker-controlled flash message' do
      msg = '<script>alert(1)</script>'
      allow(view).to receive(:flash).and_return(alert: msg)

      render partial: partial

      expect(rendered).not_to include '<script>'
      expect(rendered).to include '&lt;script&gt;'
    end
  end

  describe 'form base errors' do
    let(:partial) { 'wallaby/resources/form' }
    let(:error_message) { '<script>alert(1)</script>' }
    let(:decorated) do
      instance_double(
        Wallaby::ResourceDecorator,
        errors: { base: [error_message] },
        form_field_names: []
      )
    end

    let(:object) { AllPostgresType.new }
    let(:form) { Wallaby::FormBuilder.new(object.model_name.param_key, object, view, {}) }

    before do
      allow(view).to receive(:decorate).and_return(decorated)

      render(
        partial: partial,
        locals: { form: form, decorated: decorated, field_name: 'base', value: nil, metadata: {} }
      )
    end

    it 'escapes validation error messages' do
      expect(rendered).not_to include '<script>'
      expect(rendered).to include '&lt;script&gt;'
    end
  end
end
