# frozen_string_literal: true

require 'rails_helper'

describe 'Database active check' do
  let(:model_class) { Blog }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }

  context 'when database does not exist' do
    it 'returns empty hash' do
      allow(model_class).to receive(:connection).and_raise(::ActiveRecord::NoDatabaseError, 'database not exist')
      expect(model_decorator.index_fields).to eq({})
      expect(model_decorator.index_fields[:any_field]).to eq({})
    end
  end

  context 'when table does not exist' do
    let(:model_class) { stub_const 'NotFoundTable', Class.new(ActiveRecord::Base) }

    it 'returns empty hash' do
      expect(::ActiveRecord::Base).to be_connected
      expect(model_class).not_to be_table_exists
      expect(model_decorator.index_fields).to eq({})
      expect(model_decorator.index_fields[:any_field]).to eq({})
    end
  end
end
