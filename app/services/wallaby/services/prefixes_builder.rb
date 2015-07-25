module Wallaby
  module Services
    class PrefixesBuilder
      delegate :lookup_context, :params, :env, to: :@controller

      def initialize controller
        @controller = controller
        @old_prefixes = lookup_context.prefixes
      end

      def rebuild
        lookup_context.prefixes = new_prefixes
      end

      def new_prefixes
        prefixes = []
        if current_namespace?
          if resources?
            prefixes << "#{ current_namespace }/#{ resources_name }"
          end
          prefixes.concat current_namespace_prefixes
        end
        if resources?
          prefixes << "#{ wallaby_namespace }/#{ resources_name }"
        end
        prefixes.concat @old_prefixes
        prefixes << ''
      end

      protected
      def current_namespace_prefixes
        @old_prefixes.select do |prefix|
          prefix.start_with? wallaby_namespace
        end.map do |prefix|
          prefix.gsub wallaby_namespace, current_namespace
        end
      end

      private
      def current_namespace?
        current_namespace != wallaby_namespace
      end

      def resources?
        resources_name.present?
      end

      def current_namespace
        env['SCRIPT_NAME'].gsub %r(\A/), ''
      end

      def wallaby_namespace
        Wallaby::NAMESPACE
      end

      def resources_name
        params[:resources].try :gsub, '::', '/'
      end
    end
  end
end