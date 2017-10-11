require 'rails_helper'

field_name = 'datetime'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: Time.parse('Tue, 11 Feb 2014 23:59:59 +0000'),
    skip_general: true do

    it 'renders the datetime' do
      expect(rendered).to include '<span>11 Feb 23:59</span>'
      expect(rendered).to include 'title="Tue, 11 Feb 2014 23:59:59 +0000"'
    end

    context 'when value is a string' do
      let(:value) { 'Tue, 11 Feb 2014 23:59:59 +0000' }

      it 'renders the datetime' do
        expect(rendered).to include '<span>11 Feb 23:59</span>'
        expect(rendered).to include 'title="Tue, 11 Feb 2014 23:59:59 +0000"'
      end
    end
  end
end
