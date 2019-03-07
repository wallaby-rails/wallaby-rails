require 'rails_helper'

describe Wallaby::Configuration::Sorting do
  it_behaves_like \
    'has attribute with default value',
    :strategy, :multiple
end
