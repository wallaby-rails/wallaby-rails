require 'rails_helper'

describe Wallaby::ResourcesConstraints do
  describe '#matches?' do
    let(:request) do
      double 'request', env: {
        'action_dispatch.request.path_parameters' => {
          id: id
        }
      }
    end
    let(:id) { nil }

    it 'returns false when params are blank' do
      expect(subject.matches? request).to be_falsy
      request.env[:id] = ''
      expect(subject.matches? request).to be_falsy
    end

    context 'when id has digits' do
      let(:id) { 'this-is-a-uuid-1' }

      it 'returns true' do
        expect(subject.matches? request).to be_truthy
      end
    end

    context 'when id has no digits' do
      let(:id) { 'this-is-a-string' }

      it 'returns false regardless what action is' do
        expect(subject.matches? request).to be_falsy
      end
    end
  end
end