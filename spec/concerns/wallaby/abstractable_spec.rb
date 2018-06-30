require 'rails_helper'

[
  Wallaby::AbstractModelServicer,
  Wallaby::AbstractModelAuthorizer,
  Wallaby::AbstractResourceDecorator,
  Wallaby::AbstractResourcePaginator
].each do |klass|
  describe klass do
    describe '.abstract!' do
      it 'marks abstract to true' do
        expect(described_class.abstract).to be_falsy
        described_class.abstract!
        expect(described_class.abstract).to be_truthy
      end
    end
  end
end
