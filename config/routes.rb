Wallaby::Engine.routes.draw do
  root to: 'wallaby/resources#home'

  get 'status', to: 'wallaby/resources#healthy'

  Wallaby::ERRORS.each do |status|
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    get status, to: "wallaby/resources##{status}"
    get code.to_s, to: "wallaby/resources##{status}"
  end

  scope path: ':resources' do
    with_options to: Wallaby::ResourcesRouter.new do |route|
      route.get '', defaults: { action: 'index' }, as: :resources
      route.get 'new', defaults: { action: 'new' }, as: :new_resource
      route.get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
      route.get ':id', defaults: { action: 'show' }, as: :resource

      route.post '', defaults: { action: 'create' }
      route.match ':id', via: %i(patch put), defaults: { action: 'update' }
      route.delete ':id', defaults: { action: 'destroy' }
    end
  end
end
