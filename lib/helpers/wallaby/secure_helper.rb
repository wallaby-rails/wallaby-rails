module Wallaby
  # Secure helper
  module SecureHelper
    # Image portrait for given user
    # @param user [Object]
    # @return [String] IMG or I element
    def user_portrait(user = current_user)
      email_method = Wallaby.configuration.security.email_method || :email
      email = user.respond_to?(email_method) && user.public_send(email_method)
      if email.present?
        https = "http#{request.ssl? ? 's' : EMPTY_STRING}"
        email_md5 = ::Digest::MD5.hexdigest email.downcase
        image_source = "#{https}://www.gravatar.com/avatar/#{email_md5}"
        image_tag image_source, class: 'hidden-xs user-portrait'
      else
        content_tag :i, nil, class: 'fa fa-user user-portrait'
      end
    end

    # Logout path for given user
    # @param user [Object]
    # @param app [Object]
    # @return [String] HTML anchor element
    def logout_path(user = current_user, app = main_app)
      path = Wallaby.configuration.security.logout_path
      path ||= if defined? ::Devise
                 scope = ::Devise::Mapping.find_scope! user
                 "destroy_#{scope}_session_path"
               end
      app.public_send path if path && app.respond_to?(path)
    end

    # Logout method for given user
    # @return [String, Symbol]
    def logout_method(user = current_user)
      http_method = Wallaby.configuration.security.logout_method
      http_method || if defined? ::Devise
                       scope = ::Devise::Mapping.find_scope! user
                       mapping = ::Devise.mappings[scope]
                       mapping.sign_out_via
                     end
    end
  end
end
