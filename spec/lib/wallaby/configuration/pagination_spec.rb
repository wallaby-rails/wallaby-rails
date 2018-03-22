require 'rails_helper'

describe Wallaby::Configuration::Pagination do
  it_behaves_like \
    'has attribute with default value',
    :page_size, Wallaby::DEFAULT_PAGE_SIZE, 50
end
