# frozen_string_literal: true

module Backend
  class CustomGrandChildrenController < Backend::CustomsController
    merge_prefix_options index: 'grand'
  end
end
