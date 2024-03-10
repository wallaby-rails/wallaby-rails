# frozen_string_literal: true

module Wallaby
  # base generator
  class ApplicationGenerator < Rails::Generators::NamedBase
    argument :name, type: :string
    argument :parent_name, type: :string, default: nil, required: false

    def install
      template "#{base_name}.rb.erb", "app/#{base_name}s/#{name}_#{base_name}.rb"
    end

    protected

    def base_class
      "#{class_name}#{base_name.classify}"
    end

    def parent_base_class
      return "#{parent_name.classify}#{base_name.classify}" if parent_name

      application_class
    end

    def application_class
      Wallaby.configuration.resources_controller.try "application_#{base_name}"
    end

    def model_name
      class_name.singularize
    end
  end
end
