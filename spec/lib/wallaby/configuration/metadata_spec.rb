require 'rails_helper'

describe Wallaby::Configuration::Metadata do
  it_behaves_like \
    'has attribute with default value',
    :max, Wallaby::DEFAULT_MAX
end
