require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = field_name_from __FILE__
  type = type_from __FILE__
  klass = cell_class_from __FILE__
  describe klass, type: :view do
    it_behaves_like \
      "#{type} cell", field_name,
      value: [3, 4],
      skip_general: true do
      it 'renders the point' do
        expect(rendered).to eq '(<span class="x">3</span>, <span class="y">4</span>)'
      end
    end
  end
end
