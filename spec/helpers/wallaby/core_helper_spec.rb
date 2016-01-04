require 'rails_helper'

describe Wallaby::CoreHelper do
  describe '#body_class' do
    context 'when resources name is blank' do
      it 'returns body class' do
        allow(helper).to receive :resources_name
        expect(helper.body_class).to eq ''
      end
    end

    context 'when resources name is present' do
      it 'returns body class' do
        allow(helper).to receive(:resources_name).and_return('posts')
        expect(helper.body_class).to eq 'posts'
      end
    end

    context 'when custom_body_class is present' do
      it 'returns body class' do
        allow(helper).to receive :resources_name
        helper.content_for :custom_body_class, 'body'
        expect(helper.body_class).to eq 'body'
      end
    end
  end

  describe '#page_title' do
    it 'returns page title' do
      expect(helper.page_title).to eq 'Wallaby::Admin'
    end
  end

  describe '#current_model_label' do
    it 'returns current model label' do
      allow(helper).to receive :resources_name
      expect(helper.current_model_label).to eq 'Resources'
    end

    context 'when resources_name is given' do
      it 'returns current model label' do
        allow(helper).to receive(:resources_name).and_return('posts')
        expect(helper.current_model_label).to eq 'Resources: <strong>Post</strong>'
      end
    end
  end
end