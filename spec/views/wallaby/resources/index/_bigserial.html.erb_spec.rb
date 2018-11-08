require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = field_name_from __FILE__
  type = type_from __FILE__
  describe field_name do
    it_behaves_like \
      "#{type} partial", field_name,
      value: BigDecimal(42)**20 do

      context 'when value is 0' do
        let(:value) { 0 }
        it 'renders the bigserial' do
          expect(rendered).to include value.to_s
        end
      end
    end
  end
end
