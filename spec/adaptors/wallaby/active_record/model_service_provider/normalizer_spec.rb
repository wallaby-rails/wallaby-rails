require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider::Normalizer do
  subject { described_class.new model_decorator }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new AllPostgresType }

  describe '#normalize' do
    before do
      model_decorator.form_fields[:point] = { type: 'point' }
    end

    describe 'range types' do
      describe 'daterange' do
        it 'turns array into range' do
          expect(subject.normalize(parameters(daterange: %w(2016-04-01 2016-04-03)))[:daterange]).to eq '2016-04-01'...'2016-04-03'
          expect(subject.normalize(parameters(daterange: ['', '2016-04-03']))[:daterange]).to eq ''...'2016-04-03'
          expect(subject.normalize(parameters(daterange: ['2016-04-01', '']))[:daterange]).to eq '2016-04-01'...''
        end

        context 'when value is invalid' do
          it 'returns nil' do
            expect(subject.normalize(parameters(daterange: ['', '']))[:daterange]).to be_nil
            expect(subject.normalize(parameters(daterange: ['2016-04-03']))[:daterange]).to be_nil
          end
        end
      end

      describe 'numrange' do
        it 'turns array into range' do
          expect(subject.normalize(parameters(numrange: %w(88 999)))[:numrange]).to eq '88'...'999'
          expect(subject.normalize(parameters(numrange: ['', '999']))[:numrange]).to eq ''...'999'
          expect(subject.normalize(parameters(numrange: ['88', '']))[:numrange]).to eq '88'...''
        end

        context 'when value is invalid' do
          it 'returns nil' do
            expect(subject.normalize(parameters(numrange: ['', '']))[:numrange]).to be_nil
            expect(subject.normalize(parameters(numrange: ['100']))[:numrange]).to be_nil
          end
        end
      end

      describe 'int4range' do
        it 'turns array into range' do
          expect(subject.normalize(parameters(int4range: %w(88 999)))[:int4range]).to eq '88'...'999'
          expect(subject.normalize(parameters(int4range: ['', '999']))[:int4range]).to eq ''...'999'
          expect(subject.normalize(parameters(int4range: ['88', '']))[:int4range]).to eq '88'...''
        end

        context 'when value is invalid' do
          it 'returns nil' do
            expect(subject.normalize(parameters(int4range: ['', '']))[:int4range]).to be_nil
            expect(subject.normalize(parameters(int4range: ['100']))[:int4range]).to be_nil
          end
        end
      end

      describe 'int8range' do
        it 'turns array into range' do
          expect(subject.normalize(parameters(int8range: %w(88 999)))[:int8range]).to eq '88'...'999'
          expect(subject.normalize(parameters(int8range: ['', '999']))[:int8range]).to eq ''...'999'
          expect(subject.normalize(parameters(int8range: ['88', '']))[:int8range]).to eq '88'...''
        end

        context 'when value is invalid' do
          it 'returns nil' do
            expect(subject.normalize(parameters(int8range: ['', '']))[:int8range]).to be_nil
            expect(subject.normalize(parameters(int8range: ['100']))[:int8range]).to be_nil
          end
        end
      end

      describe 'tsrange' do
        it 'turns array into range' do
          expect(subject.normalize(parameters(tsrange: ['2016-04-01 00:12', '2016-04-03 12:23']))[:tsrange]).to eq '2016-04-01 00:12'...'2016-04-03 12:23'
          expect(subject.normalize(parameters(tsrange: ['', '2016-04-03 12:23']))[:tsrange]).to eq ''...'2016-04-03 12:23'
          expect(subject.normalize(parameters(tsrange: ['2016-04-01 00:12', '']))[:tsrange]).to eq '2016-04-01 00:12'...''
        end

        context 'when value is invalid' do
          it 'returns nil' do
            expect(subject.normalize(parameters(tsrange: ['', '']))[:tsrange]).to be_nil
            expect(subject.normalize(parameters(tsrange: ['2016-04-03 12:23']))[:tsrange]).to be_nil
          end
        end
      end

      describe 'tstzrange' do
        it 'turns array into range' do
          expect(subject.normalize(parameters(tstzrange: ['2016-04-01 00:12 +00:00', '2016-04-03 12:23 +00:00']))[:tstzrange]).to eq '2016-04-01 00:12 +00:00'...'2016-04-03 12:23 +00:00'
          expect(subject.normalize(parameters(tstzrange: ['', '2016-04-03 12:23 +00:00']))[:tstzrange]).to eq ''...'2016-04-03 12:23 +00:00'
          expect(subject.normalize(parameters(tstzrange: ['2016-04-01 00:12 +00:00', '']))[:tstzrange]).to eq '2016-04-01 00:12 +00:00'...''
        end

        context 'when value is invalid' do
          it 'returns nil' do
            expect(subject.normalize(parameters(tstzrange: ['', '']))[:tstzrange]).to be_nil
            expect(subject.normalize(parameters(tstzrange: ['2016-04-03 12:23 +00:00']))[:tstzrange]).to be_nil
          end
        end
      end
    end

    describe 'point types' do
      it 'turns array into range' do
        expect(subject.normalize(parameters(point: %w(3 4)))[:point]).to eq [3.0, 4.0]
        expect(subject.normalize(parameters(point: ['', '4']))[:point]).to eq [0.0, 4.0]
        expect(subject.normalize(parameters(point: ['3', '']))[:point]).to eq [3.0, 0.0]
      end

      context 'when value is invalid' do
        it 'returns nil' do
          expect(subject.normalize(parameters(point: ['', '']))[:point]).to be_nil
          expect(subject.normalize(parameters(point: ['']))[:point]).to be_nil
        end
      end
    end

    describe 'binary types' do
      it 'reads the uploaded file' do
        file = ActionDispatch::Http::UploadedFile.new tempfile: 'a_file', filename: 'file_name', type: 'jpg', head: {}
        expect(file).to receive(:read) { 'file_content' }
        expect(subject.normalize(parameters(binary: file))[:binary]).to eq 'file_content'
      end
    end
  end
end
