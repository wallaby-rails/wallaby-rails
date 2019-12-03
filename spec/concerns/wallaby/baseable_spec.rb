require 'rails_helper'

[
  Wallaby::ModelServicer,
  Wallaby::ModelAuthorizer,
  Wallaby::ResourceDecorator,
  Wallaby::ResourcesController,
  Wallaby::ModelPaginator
].each do |klass|
  describe klass do
    describe '.base_class!' do
      it 'marks base class to true' do
        expect(described_class).not_to be_base_class
        described_class.base_class!
        expect(described_class).to be_base_class
      end
    end
  end
end
