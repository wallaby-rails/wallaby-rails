require 'rails_helper'

field_name = 'date'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: Date.new(2014, 2, 11),
    expected_value: '2014-02-11' do

    context 'when value is a string' do
      let(:value) { 'Tue, 11 Feb 2014 23:59:59 +0000' }

      it 'renders the date' do
        expect(rendered).to include '2014-02-11'
      end
    end

    context 'when value is a time' do
      let(:value) { Time.parse 'Tue, 11 Feb 2014 23:59:59 +0000' }

      it 'renders the date' do
        expect(rendered).to include '2014-02-11'
      end
    end
  end
end
