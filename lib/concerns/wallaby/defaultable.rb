module Wallaby
  # Defaults related methods
  module Defaultable
    protected

    # Set default options for create action
    # @param options [Hash]
    # @return [Hash] updated options with default values
    def set_defaults_for(action, options)
      case action.try(:to_sym)
      when :create, :update
        options[:params] ||= resource_params
        options[:location] ||= -> { helpers.show_path(resource) }
      when :destroy
        options[:params] ||= params
        options[:location] ||= helpers.index_path(current_model_class)
      end
      options
    end
  end
end
