require 'rails_helper'

describe Wallaby::ResourcesController do
  describe '.resources_name' do
    it 'returns nil' do
      expect(described_class.resources_name).to be_nil
    end
  end

  describe '.model_class' do
    it 'returns nil' do
      expect(described_class.model_class).to be_nil
    end
  end

  describe 'subclass' do
    let!(:subclass1) { stub_const 'ApplesController', Class.new(Wallaby::ResourcesController) }
    let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
    let!(:application_servicer) { stub_const 'ApplicationServicer', Class.new(Wallaby::ModelServicer) }
    let!(:application_paginator) { stub_const 'ApplicationPaginator', Class.new(Wallaby::ResourcePaginator) }
    let!(:application_authorizer) { stub_const 'ApplicationAuthorizer', Class.new(Wallaby::ModelAuthorizer) }

    before do
      subclass1.engine_name = 'engine_name'
      subclass1.application_servicer = application_servicer
      subclass1.application_paginator = application_paginator
      subclass1.application_authorizer = application_authorizer
    end

    it 'inherits the configuration' do
      expect(described_class.resources_name).to be_nil
      expect(described_class.engine_name).to be_nil
      expect(described_class.application_servicer).to be_nil
      expect(described_class.application_paginator).to be_nil
      expect(described_class.application_authorizer).to be_nil

      expect(subclass1.resources_name).to eq 'apples'
      expect(subclass1.engine_name).to eq 'engine_name'
      expect(subclass1.application_servicer).to eq application_servicer
      expect(subclass1.application_paginator).to eq application_paginator
      expect(subclass1.application_authorizer).to eq application_authorizer

      expect(subclass2.resources_name).to eq 'things'
      expect(subclass2.engine_name).to eq 'engine_name'
      expect(subclass2.application_servicer).to eq application_servicer
      expect(subclass2.application_paginator).to eq application_paginator
      expect(subclass2.application_authorizer).to eq application_authorizer
    end
  end
end
