require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.model_paginator && .application_paginator' do
    it 'returns nil' do
      expect(described_class.model_paginator).to be_nil
      expect(described_class.application_paginator).to be_nil
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_paginator) { stub_const 'ApplicationPaginator', Class.new(Wallaby::ModelPaginator) }
      let!(:another_paginator) { stub_const 'AnotherPaginator', Class.new(Wallaby::ModelPaginator) }
      let!(:apple_paginator) { stub_const 'ApplePaginator', Class.new(application_paginator) }
      let!(:thing_paginator) { stub_const 'ThingPaginator', Class.new(apple_paginator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'is nil' do
        expect(subclass1.model_paginator).to be_nil
        expect(subclass1.application_paginator).to be_nil
        expect(subclass2.model_paginator).to be_nil
        expect(subclass2.application_paginator).to be_nil
      end

      it 'returns paginator classes' do
        subclass1.model_paginator = apple_paginator
        expect(subclass1.model_paginator).to eq apple_paginator
        expect(subclass2.model_paginator).to be_nil

        subclass1.application_paginator = application_paginator
        expect(subclass1.application_paginator).to eq application_paginator
        expect(subclass2.application_paginator).to eq application_paginator

        expect { subclass1.application_paginator = another_paginator }.to raise_error ArgumentError, 'ApplePaginator does not inherit from AnotherPaginator.'
      end
    end
  end
end
