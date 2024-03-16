# frozen_string_literal: true

module Admin
  class ApplicationController < Wallaby::ResourcesController
    base_class!
    add_mapping_actions(action_name: 'form')
  end
end
