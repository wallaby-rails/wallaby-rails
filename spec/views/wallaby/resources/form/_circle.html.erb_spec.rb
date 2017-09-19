require 'rails_helper'

field_name = 'circle'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '<(1,2),5>'
end
