# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 0..100,
    skip_general: true do
    it 'renders the int4range' do
      expect(rendered).to include '<span class="from">0</span>'
      expect(rendered).to include '<span class="to">100</span>'
    end
  end
end
