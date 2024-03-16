# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.model_paginator && .application_paginator' do
    it 'returns nil' do
      expect(described_class.model_paginator).to be_nil
      expect(described_class.application_paginator).to eq Wallaby::ModelPaginator
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_paginator) { stub_const 'ApplicationPaginator', base_class_from(Wallaby::ModelPaginator) }
      let!(:another_paginator) { stub_const 'AnotherPaginator', base_class_from(application_paginator) }
      let!(:apple_paginator) { stub_const 'ApplePaginator', Class.new(application_paginator) }
      let!(:thing_paginator) { stub_const 'ThingPaginator', Class.new(apple_paginator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'returns paginator class' do
        expect(subclass1.model_paginator).to eq ApplePaginator
        expect(subclass1.application_paginator).to eq Wallaby::ModelPaginator
        expect(subclass2.model_paginator).to eq ThingPaginator
        expect(subclass2.application_paginator).to eq Wallaby::ModelPaginator
      end
    end
  end

  describe '#current_paginator' do
    let!(:paginator) { stub_const 'AllPostgresTypePaginator', Class.new(Wallaby::ModelPaginator) }

    it 'returns model paginator for existing resource paginator' do
      controller.params[:resources] = 'all_postgres_types'
      expect(controller.current_paginator).to be_a AllPostgresTypePaginator
    end

    it 'returns model paginator for non-existing resource paginator' do
      controller.params[:resources] = 'orders'
      expect(controller.current_paginator).to be_a Wallaby::ModelPaginator
    end
  end
end
