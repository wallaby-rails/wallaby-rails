## Write Test for the Customization

In some way, Wallaby is just an app that autocomplete the controller actions and utilise the Template Inheritance to render type partials based on the metadata from decorators. Therefore, testing the customization will be possible and simple. However, there are still a few things that should be aware of before writing the test:

### Test Controller

Because Wallaby delegates the request dispatching to a router instance, there is no named route generated. Therefore, it is required to draw routes before testing the actions and clear the routes after the test as below:

```ruby
describe Admin::ProductsController do
  before do
    get ':resources', to: 'admin/products#index', as: :resources
    get ':resources/:id', to: 'admin/products#show', as: :resource
    get ':resources/new', to: 'admin/products#new'
    get ':resources/:id/edit', to: 'admin/products#edit'
    post ':resources', to: 'admin/products#create'
    patch ':resources/:id', to: 'admin/products#update'
    delete ':resources/:id', to: 'admin/products#destroy'
  end

  after do
    Rails.application.reload_routes!
  end

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

### Test Decorator

Decorator is simply a wrapper that holds metadata. Therefore, it is as simple as below:

```ruby
describe ProductDecorator do
  subject { described_class.new resource }
  let(:resource) { Product.new }

  it 'behaves like a product'
end
```

### Test Servicer

Servicer implements the persistence logics. The only thing to be aware of is the intiailization:

```ruby
describe ProductServicer do
  subject { described_class.new Product, authorizer }
  let(:authorizer) { Ability.new user }

  it 'performs actions'
end
```

### Test Type Partials

- for `index`/`show` partials

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

- for `form` partials

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
