Rails.application.routes.draw do

  mount Wallaby::Engine => "/admin"
end
