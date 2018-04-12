module Wallaby
  # Utils for test
  module TestUtils
    class << self
      # @param context
      # @param controller_class [Class]
      def around_crud(context, controller_class = nil)
        context.before do
          controller_class ||= described_class
          controller_path = controller_class.controller_path
          Wallaby::TestUtils.draw(routes, controller_path)
        end

        context.after { Rails.application.reload_routes! }
      end

      # @param routes
      # @param controller_path [String]
      def draw(routes, controller_path)
        routes.draw do
          get ':resources', to: "#{controller_path}#index", as: :resources
          get ':resources/:id', to: "#{controller_path}#show", as: :resource
          get ':resources/new', to: "#{controller_path}#new"
          get ':resources/:id/edit', to: "#{controller_path}#edit"
          post ':resources', to: "#{controller_path}#create"
          patch ':resources/:id', to: "#{controller_path}#update"
          delete ':resources/:id', to: "#{controller_path}#destroy"
        end
      end
    end
  end
end
