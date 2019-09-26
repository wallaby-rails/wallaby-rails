module Wallaby
  # Secure helper
  module SecureHelper
    # Image portrait for given user.
    #
    # - if email is present, a gravatar image tag will be returned
    # - otherwise, an user icon will be returned
    # @param user [Object]
    # @return [String] IMG or I element
    def user_portrait(user = current_user)
      email_method = security.email_method || :email
      email = try_to user, email_method
      if email.present?
        https = "http#{request.ssl? ? 's' : EMPTY_STRING}"
        email_md5 = ::Digest::MD5.hexdigest email.downcase
        image_source = "#{https}://www.gravatar.com/avatar/#{email_md5}"
        image_tag image_source, class: 'user'
      else
        fa_icon 'user'
      end
    end

    # Logout path for given user
    # @see Wallaby::Configuration::Security#logout_path
    # @param user [Object]
    # @param app [Object]
    # @return [String] URL to log out
    def logout_path(user = current_user, app = main_app)
      path = security.logout_path
      path ||=
        if defined? ::Devise
          scope = ::Devise::Mapping.find_scope! user
          "destroy_#{scope}_session_path"
        end
      try_to app, path
    end

    # Logout method for given user
    # @see Wallaby::Configuration::Security#logout_method
    # @param user [Object]
    # @return [String, Symbol] http method to log out
    def logout_method(user = current_user)
      http_method = security.logout_method
      http_method ||
        if defined? ::Devise
          scope = ::Devise::Mapping.find_scope! user
          mapping = ::Devise.mappings[scope]
          mapping.sign_out_via
        end
    end
  end
end
