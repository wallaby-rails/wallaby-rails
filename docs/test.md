# Rspec Test

Every customization deserves a test.

In general, Wallaby itself is a typical Rails application. Therefore, writing specs for customization is similar to the way how general Rails spec is written with a few extra setups:

- [Request](#request) - writing request specs.
- [Controller](#controller) - writing controller specs.
- [Decorator](#decorator) - writing specs for decorator.
- [Servicer](#servicer) - writing specs for servicer.
- [Authorizer](#authorizer) (since 5.2.0) - writing specs for authorizer.
- [Paginator](#paginator) (since 5.2.0) - writing specs for paginator.
- [Type Partial](#type-partial) - writing specs for partials (e.g. `index`/`show`).
  - [Form Type Partial](#form-type-partial) - writing specs for form partials (e.g. `new`/`create`/`edit`/`update`).

## Request

For request specs, there is no need to do the same routing setup like controller specs. So it goes as usual:

```ruby
describe 'Request spec for Wallaby customization' do
  it 'performs index' do
    get '/admin/products'
    # testify against expectation and etc.
  end

  it 'performs show' do
    get "/admin/products/#{product.id}"
    # testify against expectation and etc.
  end

  it 'performs new' do
    get '/admin/products/new'
    # testify against expectation and etc.
  end

  it 'performs create' do
    post '/admin/products', params: { products: { name: 'iPhone' } }
    # testify against expectation and etc.
  end

  it 'performs edit' do
    get "/admin/products/#{product.id}/edit"
    # testify against expectation and etc.
  end

  it 'performs update' do
    patch "/admin/products/#{product.id}", params: { products: { name: 'iPhone' } }
    # testify against expectation and etc.
  end

  it 'performs destroy' do
    destroy "/admin/products/#{product.id}"
    # testify against expectation and etc.
  end
end
```

## Controller

Because Wallaby delegates the request dispatching to a router instance, there is no named route generated. Therefore, it is required to draw routes before testing the actions and clear the routes after the test as below:

```ruby
describe Admin::ProductsController do
  # Since 5.1.6 : begin
  Wallaby::TestUtils.around_crud(self)
  # Since 5.1.6 : end

  # Before 5.1.6 : begin
  before do
    routes.draw do
      get ':resources', to: 'admin/products#index', as: :resources
      get ':resources/:id', to: 'admin/products#show', as: :resource
      get ':resources/new', to: 'admin/products#new'
      get ':resources/:id/edit', to: 'admin/products#edit'
      post ':resources', to: 'admin/products#create'
      patch ':resources/:id', to: 'admin/products#update'
      delete ':resources/:id', to: 'admin/products#destroy'
    end
  end

  after do
    Rails.application.reload_routes!
  end
  # Before 5.1.6 : end

  it 'performs index' do
    get :index, params: { resources: 'products' }
    # testify against expectation and etc.
  end

  it 'performs show' do
    get :show, params: { resources: 'products', id: product.id }
    # testify against expectation and etc.
  end

  it 'performs new' do
    get :new, params: { resources: 'products' }
    # testify against expectation and etc.
  end

  it 'performs create' do
    post :create, params: { resources: 'products', products: { name: 'iPhone' } }
    # testify against expectation and etc.
  end

  it 'performs edit' do
    get :edit, params: { resources: 'products', id: product.id }
    # testify against expectation and etc.
  end

  it 'performs update' do
    patch :update, params: { resources: 'products', products: { name: 'iPhone' } }
    # testify against expectation and etc.
  end

  it 'performs destroy' do
    delete :destroy, params: { resources: 'products' }
    # testify against expectation and etc.
  end
end
```

## Decorator

Decorator is simply a wrapper that holds metadata. Therefore, spec is as simple as below:

```ruby
describe ProductDecorator do
  subject { described_class.new resource }
  let(:resource) { Product.new }

  it 'behaves like a product'
end
```

## Servicer

Servicer implements the persistence logics. The only thing to be set up is the intiailization:

```ruby
describe ProductServicer, type: :helper do
  subject { described_class.new model_class, authorizer }
  let(:model_class) { Product }
  let(:user) { User.new }
  let(:ability) { Ability.new }
  let(:authorizer) do
    # When no authorization
    Admin::ApplicationAuthorizer.new model_class, :default
    # For Cancancan
    Admin::ApplicationAuthorizer.new model_class, :cancancan, ability: ability
    # For Pundit
    Admin::ApplicationAuthorizer.new model_class, :pundit, user: user
  end

  it 'performs actions'
end
```

> NOTE: helper is needed to provide the context for authorizer

For version 5.2 below:

```ruby
describe ProductServicer do
  subject { described_class.new Product, authorizer }
  let(:authorizer) { Ability.new user }

  it 'performs actions'
end
```

## Authorizer

> since 5.2.0

Authorizer can be tested when it's customized for other authorization framework. The only thing to be set up is the intiailization:

```ruby
describe Admin::ApplicationAuthorizer, type: :helper do
  subject do
    # When no authorization
    described_class.new model_class, :default
    # For Cancancan
    described_class.new model_class, :cancancan, ability: ability
    # For Pundit
    described_class.new model_class, :pundit, user: user
  end
  let(:model_class) { Product }
  let(:user) { User.new }
  let(:ability) { Ability.new }

  it 'performs authorization tests'
end
```

> NOTE: helper is needed to provide the context for authorizer

## Paginator

> since 5.2.0

Paginator can be tested when it's customized for the models. The only thing to be set up is the intiailization:

```ruby
describe Admin::ApplicationPaginator do
  subject { described_class.new model_class, collection, params }
  let(:model_class) { Product }
  let(:collection) { Product.active }
  let(:params) { ActionController::Parameters.new page: 8, per: 100 }

  it 'performs pagination tests'
end
```

## Type Partial

For `index`/`show` partials:

```ruby
describe 'admin/products/index/_markdown.html.erb', type: :view do
  let(:object) { Product.new description: 'Laptop' }
  let(:decorated) { ProductDecorator.new object }
  let(:page) { Nokogiri::HTML rendered }

  before do
    render 'admin/products/index/_markdown.html.erb',
      object: decorated
      field_name: 'description'
      value: decorated.description,
      metadata: { type: 'markdown', label: 'Markdown' }
  end

  it 'renders the partial'
end
```

### Form Type Partial

For `form` partials:

```ruby
describe 'admin/products/form/_markdown.html.erb', type: :view do
  let(:object) { Product.new description: 'Laptop' }
  let(:decorated) { ProductDecorator.new object }
  let(:page) { Nokogiri::HTML rendered }
  let(:form) { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }

  before do
    render 'admin/products/form/_markdown.html.erb',
      object: decorated
      field_name: 'description'
      value: decorated.description,
      form: form,
      metadata: { type: 'markdown', label: 'Markdown' }
  end

  it 'renders the partial'
end
```
