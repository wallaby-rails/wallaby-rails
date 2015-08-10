require 'rails_helper'

describe Wallaby::ResourcesController::PrefixesBuilder do
  let(:controller) do
    double 'Controller',
      class: klass,
      action_name: action_name,
      resources_name: resources_name
  end
  let(:action_name) { 'show' }
  let(:resources_name) { nil }

  describe '#build' do
    let(:subject) { described_class.new(controller).build }
    context 'when controller is resources controller' do
      let(:klass) { Wallaby::ResourcesController }
      it 'returns new prefixes' do
        expect(subject).to eq [
          "wallaby/resources/show",
          "wallaby/resources",
          "wallaby/core/show",
          "wallaby/core",
          "wallaby/secure/show",
          "wallaby/secure",
          "wallaby/application/show",
          "wallaby/application",
          ""
        ]
      end

      context 'and resources_name is given' do
        let(:resources_name) { 'reinteractive::posts' }

        it 'returns new prefixes' do
          expect(subject).to eq [
            "reinteractive/posts/show",
            "reinteractive/posts",
            "wallaby/resources/show",
            "wallaby/resources",
            "wallaby/core/show",
            "wallaby/core",
            "wallaby/secure/show",
            "wallaby/secure",
            "wallaby/application/show",
            "wallaby/application",
            ""
          ]
        end
      end
    end

    context 'when controller is not resources controller' do
      let(:klass) do
        module Reinteractive
          class PostsController < Wallaby::ResourcesController
          end
        end
        Reinteractive::PostsController
      end

      it 'returns new prefixes' do
        expect(subject).to eq [
          "reinteractive/posts/show",
          "reinteractive/posts",
          "wallaby/resources/show",
          "wallaby/resources",
          "wallaby/core/show",
          "wallaby/core",
          "wallaby/secure/show",
          "wallaby/secure",
          "wallaby/application/show",
          "wallaby/application",
          ""
        ]
      end

      context 'and resources_name is given' do
        let(:resources_name) { 'reinteractive::posts' }

        it 'returns new prefixes' do
          expect(subject).to eq [
            "reinteractive/posts/show",
            "reinteractive/posts",
            "wallaby/resources/show",
            "wallaby/resources",
            "wallaby/core/show",
            "wallaby/core",
            "wallaby/secure/show",
            "wallaby/secure",
            "wallaby/application/show",
            "wallaby/application",
            ""
          ]
        end
      end
    end
  end
end