# frozen_string_literal: true

module Wallaby
  # All URL helpers for {Engine}
  module Urlable
    # Override original method to handle URL generation **when Wallaby is mounted as Rails Engine**.
    # @param params [String, Hash, ActionController::Parameters, nil]
    # @param options [Hash] options only used by {EngineUrlFor}
    # @return [String] URL string
    # @see EngineUrlFor.execute
    # @see https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for
    #   ActionView::RoutingUrlFor#url_for
    def url_for(params = nil, options = {})
      (!options[:super] &&
        EngineUrlFor.execute(context: self, params: params, options: options)) ||
        super(params)
    end

    # Generate the resourceful index path for given model class.
    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] index page path
    def index_path(model_class, url_params: {})
      with_query = url_params.delete :with_query
      url_for(
        { action: :index }.merge(url_params),
        { model_class: model_class, with_query: with_query }
      )
    end

    # Generate the resourceful new path for given model class.
    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] new page path
    def new_path(model_class, url_params: {})
      with_query = url_params.delete :with_query
      url_for(
        { action: :new }.merge(url_params),
        { model_class: model_class, with_query: with_query }
      )
    end

    # Generate the resourceful show path for given resource.
    # @param resource [Object]
    # @param url_params [Hash]
    # @return [String] show page path
    def show_path(resource, url_params: {})
      decorated = decorate resource
      with_query = url_params.delete :with_query
      url_for(
        ParamsUtils.presence(action: :show, id: decorated.try(:primary_key_value)).merge(url_params),
        { model_class: decorated.model_class, with_query: with_query }
      )
    end

    # Generate the resourceful edit path for given resource.
    # @param resource [Object]
    # @param url_params [Hash]
    # @return [String] edit page path
    def edit_path(resource, url_params: {})
      decorated = decorate resource
      with_query = url_params.delete :with_query
      url_for(
        { action: :edit, id: decorated.primary_key_value }.merge(url_params),
        { model_class: decorated.model_class, with_query: with_query }
      )
    end
  end
end
