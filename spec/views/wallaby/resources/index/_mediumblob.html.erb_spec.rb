require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '010111',
    model_class: AllMysqlType,
    skip_general: true do

    it 'renders the mediumblob' do
      expect(rendered).to include view.muted('mediumblob')
    end
  end
end
