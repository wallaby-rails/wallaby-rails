require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = field_name_from __FILE__
  type = type_from __FILE__
  describe field_name do
    it_behaves_like \
      "#{type} partial", field_name,
      value: '010111',
      model_class: AllMysqlType,
      skip_general: true do

      it 'renders the blob' do
        expect(rendered).to include view.muted('blob')
      end
    end
  end
end
