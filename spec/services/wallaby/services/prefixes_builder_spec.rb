require 'rails_helper'

describe Wallaby::Services::PrefixesBuilder do
  let(:controller) do
    double 'Controller',
      lookup_context: lookup_context,
      params: params,
      env: env
  end
  let(:lookup_context) { double 'LookupContext', prefixes: prefixes }
  let(:env) { { 'SCRIPT_NAME' => script_name } }

  let(:prefixes) { [ "wallaby/resources", "wallaby/core", "wallaby/secure", "wallaby/application", "application" ] }
  let(:params) { Hash.new }
  let(:script_name) { '/wallaby' }

  describe '#new_prefixes' do
    it 'returns new prefixes' do
      expect(described_class.new(controller).new_prefixes).to eq [ "wallaby/resources", "wallaby/core", "wallaby/secure", "wallaby/application", "application", "" ]
    end

    context 'when script_name is admin' do
      let(:script_name) { '/admin' }
      it 'returns new prefixes' do
        expect(described_class.new(controller).new_prefixes).to eq [ "admin/resources", "admin/core", "admin/secure", "admin/application", "wallaby/resources", "wallaby/core", "wallaby/secure", "wallaby/application", "application", "" ]
      end

      context 'and resources_name is given' do
        let(:params) { { resources: 'reinteractive::post' } }
        it 'returns new prefixes' do
          expect(described_class.new(controller).new_prefixes).to eq [ "admin/reinteractive/post", "admin/resources", "admin/core", "admin/secure", "admin/application", "wallaby/reinteractive/post", "wallaby/resources", "wallaby/core", "wallaby/secure", "wallaby/application", "application", "" ]
        end
      end
    end
  end
end