require 'rails_helper'

field_name = 'uuid'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '814865cd-5a1d-4771-9306-4268f188fe9e'
end
