module Wallaby
  class ActiveRecord
    # Pundit provider for ActiveRecord
    class PunditProvider < PunditAuthorizationProvider
      # Filter a scope
      # @param _action [Symbol, String]
      # @param scope [Object]
      # @return [Object]
      def accessible_for(_action, scope)
        Pundit.policy_scope! user, scope
      rescue Pundit::NotDefinedError
        Rails.logger.warn I18n.t('errors.pundit.not_found.scope_policy', scope: scope)
        scope
      end
    end
  end
end
