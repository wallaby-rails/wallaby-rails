module Wallaby::SecureHelper
  def user_portrait(user = current_user)
    if user.respond_to? :email
      image_source = "http#{ request.ssl? ? 's' : '' }://www.gravatar.com/avatar/#{ Digest::MD5.hexdigest user.email.downcase }"
      image_tag image_source, class: 'hidden-xs user-portrait'
    else
      content_tag :i, nil, class: 'glyphicon glyphicon-user user-portrait'
    end
  end

  def logout_path(user = current_user)
    path = if defined? Devise
      scope = Devise::Mapping.find_scope! user
      "destroy_#{ scope }_session_path"
    else
      'logout_path'
    end
    main_app.send path if main_app.respond_to? path
  end

  def logout_method
    method = Array(Devise.sign_out_via).first if defined? Devise
    method || :delete
  end
end
