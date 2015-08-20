require 'rails_helper'

describe Wallaby::ResourcesConstraints do
  describe '#matches?' do
    let(:request) do
      double 'Request', env: { 'action_dispatch.request.path_parameters' => params }
    end
    let(:params) { { } }

    it 'returns false when params are blank' do
      params[:id] = nil
      expect(subject.matches? request).to be_falsy
      params[:id] = ''
      expect(subject.matches? request).to be_falsy
    end

    context 'when id has digits' do
      it 'returns true' do
        params[:id] = 'this-is-a-uuid-1'
        expect(subject.matches? request).to be_truthy
      end
    end

    context 'when id has no digits' do
      it 'returns false' do
        params[:id] = 'this-is-a-string'
        expect(subject.matches? request).to be_falsy
      end
    end
  end
end