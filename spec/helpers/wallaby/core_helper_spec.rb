require 'rails_helper'

describe Wallaby::CoreHelper do
  describe '#body_class' do
    before do
      # @see Wallaby::CoreController#current_resources_name
      def helper.current_resources_name
        params[:resources]
      end
    end

    it 'returns body class' do
      helper.params[:action] = 'index'
      expect(helper.body_class).to eq 'index'
    end

    context 'when resources name is blank' do
      it 'returns body class' do
        expect(helper.body_class).to eq ''
      end
    end

    context 'when resources name is present' do
      it 'returns body class' do
        helper.params[:resources] = 'wallaby::posts'
        expect(helper.body_class).to eq 'wallaby__posts'
      end
    end

    context 'when custom_body_class is present' do
      it 'returns body class' do
        helper.content_for :custom_body_class, 'body'
        expect(helper.body_class).to eq 'body'
      end
    end
  end
end
