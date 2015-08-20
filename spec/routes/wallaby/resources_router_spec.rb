require 'rails_helper'

describe Wallaby::ResourcesRouter do
  describe '#call' do
    let(:env) do
      {
        'action_dispatch.request.path_parameters' => {
          resources: resources
        }
      }
    end
    let(:action) { double 'Action', call: nil }

    context 'when Wallaby::ResourcesController has no subclasses' do
      let(:resources) { 'post' }

      it 'dispatches the request to Wallaby::ResourcesController' do
        expect(Wallaby::ResourcesController).to receive(:action).and_return(action)
        subject.call env
      end
    end

    context 'when Wallaby::ResourcesController has subclasses' do
      before do
        class AliensController < Wallaby::ResourcesController; end
      end

      context "and subclass's resources name matches" do
        let(:resources) { 'aliens' }

        it 'dispatches the request to AliensController' do
          expect(AliensController).to receive(:action).and_return(action)
          subject.call env
        end
      end

      context "and subclass's resources name doesn't match" do
        let(:resources) { 'post' }

        it 'dispatches the request to Wallaby::ResourcesController' do
          expect(Wallaby::ResourcesController).to receive(:action).and_return(action)
          subject.call env
        end
      end
    end
  end
end