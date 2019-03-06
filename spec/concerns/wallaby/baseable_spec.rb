require 'rails_helper'

[
  Wallaby::AbstractModelServicer,
  Wallaby::AbstractModelAuthorizer,
  Wallaby::AbstractResourceDecorator,
  Wallaby::AbstractResourcesController,
  Wallaby::AbstractModelPaginator
].each do |klass|
  describe klass do
    describe '.base_class!' do
      it 'marks base class to true' do
        expect(described_class.base_class?).to be_falsy
        described_class.base_class!
        expect(described_class.base_class?).to be_truthy
      end
    end
  end
end
