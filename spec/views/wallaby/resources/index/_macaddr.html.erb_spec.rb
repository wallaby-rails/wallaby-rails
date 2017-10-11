require 'rails_helper'

field_name = 'inet'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '32:01:16:6d:05:ef',
    code_value: true,
    skip_general: true
end
