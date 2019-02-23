require 'rails_helper'

describe Wallaby::CustomLookupContext, type: :helper do
  subject { described_class.new [], {}, [] }

  describe '#view_paths=' do
    it 'sets view paths' do
      file_path = '/file_path'
      subject.view_paths = [file_path]
      expect(subject.view_paths.first).to be_a Wallaby::CellResolver
      expect(subject.view_paths.first.to_s).to eq file_path
    end

    context 'when view paths are not resolvers' do
      it 'does not change the view paths' do
        file = File.new __FILE__, 'r'
        subject.view_paths = [file]
        expect(subject.view_paths.first).to eq file
      end
    end
  end
end
