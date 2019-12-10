require 'rails_helper'

describe Wallaby::CustomLookupContext, type: :helper do
  subject { described_class.new view_paths, {}, [] }

  let(:view_paths) { [file_path] }

  describe '#view_paths' do
    let(:file_path) { '/file_path' }

    it 'sets view paths' do
      expect(subject.view_paths.first).to be_a Wallaby::CellResolver
      expect(subject.view_paths.first.to_s).to eq file_path
    end

    context 'when view paths are not resolvers' do
      let(:file_path) { File.new __FILE__, 'r' }

      it 'does not change the view paths' do
        expect(subject.view_paths.first).to eq file_path
      end
    end
  end
end
