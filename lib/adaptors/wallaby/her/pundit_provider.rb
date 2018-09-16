module Wallaby
  class Her
    # Pundit provider for Her
    class PunditProvider < PunditAuthorizationProvider
      # Find out the class and filter scope.
      # @param _action [Symbol, String]
      # @param scope [Object]
      # @return [Object]
      def accessible_for(_action, scope)
        klass =
          if scope.is_a? ::Her::Model::Relation
            scope.instance_variable_get :@parent
          else
            scope
          end
        scope_policy = Pundit::PolicyFinder.new(klass).scope
        scope_policy ? scope_policy.new(current_user, scope).resolve : scope
      end
    end
  end
end
