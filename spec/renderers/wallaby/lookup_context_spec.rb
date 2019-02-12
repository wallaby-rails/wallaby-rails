require 'rails_helper'

describe Wallaby::LookupContext, type: :helper do
  subject { described_class.new [], {}, [] }

  describe '#view_paths=' do
    it 'sets view paths' do
      file_path = '/file_path'
      subject.view_paths = [file_path]
      expect(subject.view_paths.first).to be_a Wallaby::RendererResolver
      expect(subject.view_paths.first.to_s).to eq file_path

      file = File.new __FILE__, 'r'
      subject.view_paths = [file]
      expect(subject.view_paths.first).to eq file
    end
  end
end
