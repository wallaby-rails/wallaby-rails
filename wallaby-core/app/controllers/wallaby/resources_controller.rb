# frozen_string_literal: true

module Wallaby
  # define {ResourcesController}'s parent
  ResourcesController = Class.new configuration.base_controller

  # Resources controller is the superclass for all customization controllers.
  # It can be used for both Admin Interface and general purpose.
  #
  # It contains typical resourceful action template methods
  # that can be overridden by subclasses when customizing:
  #
  # - {ResourcesConcern#index #index}
  # - {ResourcesConcern#new #new}
  # - {ResourcesConcern#create #create}
  # - {ResourcesConcern#edit #edit}
  # - {ResourcesConcern#update #update}
  # - {ResourcesConcern#destroy #destroy}
  #
  # And it also contains resource related helper methods, e.g.:
  #
  # - {Resourcable#collection #collection}
  # - {Resourcable#resource #resource}
  # - {Resourcable#resource_params #resource_params}
  #
  # For better practice, please create an application controller class  (see example)
  # to better control the functions shared between different resource controllers.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationController < Wallaby::ResourcesController
  #     base_class!
  #   end
  class ResourcesController
    include ResourcesConcern
  end
end
