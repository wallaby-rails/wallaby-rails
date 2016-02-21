require 'rails_helper'

describe Wallaby::CoreHelper do
  describe '#body_class' do
    context 'when resources name is blank' do
      it 'returns body class' do
        allow(helper).to receive :current_resources_name
        expect(helper.body_class).to eq ''
      end
    end

    context 'when resources name is present' do
      it 'returns body class' do
        allow(helper).to receive(:current_resources_name) { 'wallaby::posts' }
        expect(helper.body_class).to eq 'wallaby__posts'
      end
    end

    context 'when custom_body_class is present' do
      it 'returns body class' do
        allow(helper).to receive :current_resources_name
        helper.content_for :custom_body_class, 'body'
        expect(helper.body_class).to eq 'body'
      end
    end
  end

  describe '#current_model_label' do
    it 'returns current model label' do
      allow(helper).to receive :current_resources_name
      expect(helper.current_model_label).to eq 'Resources'
    end

    context 'when resources_name is given' do
      it 'returns current model label' do
        allow(helper).to receive(:current_resources_name) { 'posts' }
        expect(helper.current_model_label).to eq 'Resource: Post'
      end
    end
  end
end
