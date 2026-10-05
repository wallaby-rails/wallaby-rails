# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for CSS class generation.
#
# Covers OWASP A03: request-derived values must not break out of the `class`
# attribute. See the audit findings L3/L4.
describe Wallaby::BaseHelper, type: :helper do
  describe '#safe_class_token' do
    it 'keeps valid class characters' do
      expect(helper.safe_class_token('order__item-1')).to eq 'order__item-1'
    end

    it 'strips characters that could break out of the attribute' do
      expect(helper.safe_class_token('x" onmouseover="alert(1)')).to eq 'xonmouseoveralert1'
      expect(helper.safe_class_token('a b')).to eq 'ab'
    end
  end

  describe '#body_class' do
    it 'does not emit unsafe characters from the resources param' do
      allow(helper).to receive_messages(
        params: ActionController::Parameters.new(action: 'index', resources: 'evil" onload="x'),
        controller_path: 'wallaby/resources',
        current_resources_name: 'evil" onload="x',
        content_for: nil
      )

      body_class = helper.body_class
      expect(body_class).not_to include '"'
      expect(body_class).to match(/\A[a-zA-Z0-9_\- ]+\z/)
    end
  end
end
