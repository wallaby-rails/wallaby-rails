require 'rails_helper'

describe Wallaby::CachedCompiledErb do
  it 'caches the compiled erb' do
    view = ActionView::Base.new Wallaby::Engine.root
    template = view.lookup_context.find_template 'app/views/layouts/wallaby/application.html.erb'
    expect(Rails.cache).to receive(:fetch).with("wallaby/#{ template.inspect }")

    subject.call template
  end
end
