require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Date.new(2014, 2, 11)..Date.new(2014, 3, 14),
    content_for: true,
    skip_general: true,
    skip_nil: true do
    it 'checks the dates' do
      first_input = page.at_css('.row > div:first .form-control')
      last_input = page.at_css('.row > div:last .form-control')
      expect(first_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(first_input['type']).to eq 'text'
      expect(first_input['value']).to eq '2014-02-11'
      expect(last_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(last_input['type']).to eq 'text'
      expect(last_input['value']).to eq '2014-03-14'
    end
  end

  it_behaves_like \
    "#{type} partial", field_name,
    value: [],
    skip_all: true do
    it 'renders empty range' do
      first_input = page.at_css('.row > div:first .form-control')
      last_input = page.at_css('.row > div:last .form-control')
      expect(first_input['value']).to be_nil
      expect(last_input['value']).to be_nil
    end
  end
end
