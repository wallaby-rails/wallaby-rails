require 'rails_helper'

describe Wallaby::Configuration::Features do
  it_behaves_like \
    'has attribute with default value',
    :turbolinks_enabled, false
end
