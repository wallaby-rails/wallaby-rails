require 'rails_helper'

field_name = 'tstzrange'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC'),
    skip_general: true do

    it 'renders the tstzrange' do
      expect(rendered).to include '<span class="from">16 Mar 14:55</span>'
      expect(rendered).to include '<span class="to">18 Mar 14:55</span>'
      expect(rendered).to include 'title="Wed, 16 Mar 2016 14:55:10 +0000 ... Fri, 18 Mar 2016 14:55:10 +0000"'
    end
  end
end
