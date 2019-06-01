require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: 'tian@reinteractive.net',
    skip_general: true do
    it 'renders the email' do
      expect(rendered).to include "mailto:#{value}"
    end
  end
end
