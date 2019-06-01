require 'rails_helper'

field_name = 'type'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Staff.name,
    metadata: {
      sti_class_list: [Customer, Staff]
    },
    model_class: Person,
    partial_name: 'sti',
    skip_general: true,
    skip_nil: true do
    it 'allows user to select sti models from the list' do
      options = page.css('select option')
      values = options.map { |opt| opt['value'] }
      expect(values).to eq metadata[:sti_class_list].map(&:sti_name)
      expect(options[0]['value']).to eq 'Customer'
      expect(options[0]['selected']).to be_nil
      expect(options[1]['value']).to eq 'Staff'
      expect(options[1]['selected']).to eq 'selected'
    end

    context 'when nil' do
      let(:value) { nil }

      it 'allows user to select sti models from the list' do
        options = page.css('select option')
        values = options.map { |opt| opt['value'] }
        expect(values).to eq metadata[:sti_class_list].map(&:sti_name)
        expect(options[0]['selected']).to be_nil
        expect(options[1]['selected']).to be_nil
      end
    end
  end
end
