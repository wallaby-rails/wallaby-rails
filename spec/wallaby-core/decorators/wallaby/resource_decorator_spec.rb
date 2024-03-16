# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourceDecorator do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end

    describe '.model_decorator' do
      it 'returns nil' do
        expect(described_class.model_decorator).to be_nil
      end
    end

    ['', 'index_', 'show_', 'form_'].each do |prefix|
      title = prefix.delete '_'
      describe "for #{title}" do
        describe ".#{prefix}fields" do
          it 'returns nil' do
            expect(described_class.send(:"#{prefix}fields")).to be_nil
          end
        end

        describe ".#{prefix}field_names" do
          it 'returns nil' do
            next if prefix == ''

            expect(described_class.send(:"#{prefix}field_names")).to be_nil
          end
        end

        describe ".#{prefix}metadata_of" do
          it 'returns nil' do
            expect(described_class.send(:"#{prefix}metadata_of")).to be_nil
          end
        end

        describe ".#{prefix}label_of" do
          it 'returns nil' do
            expect(described_class.send(:"#{prefix}label_of", '')).to be_nil
          end
        end

        describe ".#{prefix}type_of" do
          it 'returns nil' do
            expect(described_class.send(:"#{prefix}type_of", '')).to be_nil
          end
        end
      end
    end

    ['action_'].each do |prefix|
      title = prefix.delete '_'
      describe "for #{title}" do
        describe ".#{prefix}fields" do
          it do
            expect(described_class.send(:"#{prefix}fields")).to be_nil
          end
        end

        describe ".#{prefix}field_names" do
          it do
            expect(described_class.send(:"#{prefix}field_names")).to be_nil
          end
        end
      end
    end

    describe '.readonly' do
      specify do
        expect(described_class.readonly?).to be_nil
      end

      context 'when readonly is set' do
        specify do
          described_class.readonly = true
          expect(described_class.readonly?).to eq(true)
          described_class.readonly = nil
        end
      end
    end
  end

  describe 'instance methods' do
    subject { described_class.new resource }

    let(:resource) { model_class.new }
    let(:model_class) { Product }

    describe '#model_class' do
      it 'returns model class' do
        expect(subject.model_class).to eq model_class
      end
    end

    describe '#h' do
      it 'returns helpers' do
        expect(subject.h).to be_a ActionView::Base
        expect(subject.h.extract(subject)).to eq resource
      end
    end

    describe '#errors' do
      it 'returns errors' do
        resource.errors.add :name, 'cannot be nil'
        resource.errors.add :base, 'has error'
        expect(subject.errors).to be_a ActiveModel::Errors
        expect(subject.errors.messages).to eq(
          name: ['cannot be nil'],
          base: ['has error']
        )
      end
    end

    describe '#model_decorator' do
      it 'returns model decorator' do
        expect(subject.model_decorator).to be_a Wallaby::ModelDecorator
      end
    end

    describe 'fields' do
      let(:model_fields) do
        {
          'id' => { 'type' => 'integer', 'label' => 'fake title' },
          'title' => { 'type' => 'string', 'label' => 'fake title' },
          'published_at' => { 'type' => 'datetime', 'label' => 'fake title' },
          'updated_at' => { 'type' => 'datetime', 'label' => 'fake title' }
        }
      end

      before do
        ['', 'index_', 'show_', 'form_', 'action_'].each do |prefix|
          subject.model_decorator.send :"#{prefix}fields=", model_fields
        end
      end

      ['', 'index_', 'show_', 'form_', 'action_'].each do |prefix|
        title = prefix.delete '_'
        describe "for #{title}" do
          describe "##{prefix}fields" do
            it 'returns fields hash' do
              expect(subject.send(:"#{prefix}fields")).to eq model_fields
            end
          end

          describe "##{prefix}field_names" do
            it 'returns field names array' do
              next if prefix == ''

              if prefix == 'form_'
                expect(subject.send(:"#{prefix}field_names")).to eq(%w[title published_at])
              else
                expect(subject.send(:"#{prefix}field_names")).to eq(%w[id title published_at updated_at])
              end
            end
          end

          if prefix != 'action_'
            describe "##{prefix}metadata_of" do
              it 'returns metadata' do
                expect(subject.send(:"#{prefix}metadata_of", 'id')).to eq(
                  'type' => 'integer',
                  'label' => 'fake title'
                )
              end
            end

            describe "##{prefix}label_of" do
              it 'returns label' do
                expect(subject.send(:"#{prefix}label_of", 'id')).to eq 'fake title'
              end
            end

            describe "##{prefix}type_of" do
              it 'returns type' do
                expect(subject.send(:"#{prefix}type_of", 'id')).to eq 'integer'
              end
            end
          end
        end
      end
    end

    describe '#to_label' do
      it 'returns name' do
        resource.id = 1
        resource.name = 'Bed Frame'
        expect(subject.to_label).to eq 'Bed Frame'
      end

      context 'when name does not exist' do
        it 'returns id' do
          resource.id = 1
          resource.name = nil
          expect(subject.to_label).to eq '1'
        end
      end
    end

    describe '#to_s' do
      let(:resource) { 'A String' }

      it 'returns resource string' do
        expect(subject.to_s).to eq 'A String'
      end
    end

    describe '#to_param' do
      let(:resource) { { key: 'value' } }

      it 'returns resource string' do
        expect(subject.to_param).to eq 'key=value'
      end
    end

    describe '#model_name' do
      let(:resource) { [] }

      it 'returns model name' do
        expect(subject.model_name).to be_a ActiveModel::Name
        expect(subject.model_name.plural).to eq 'arrays'
      end
    end

    describe '#to_key' do
      let(:resource) { Product.new(id: 111) }

      it 'returns key' do
        expect(subject.to_key).to eq [111]
      end
    end

    describe '#readonly?' do
      let(:resource) { Product.new(id: 111) }

      specify do
        expect(subject.readonly?).to be_nil
      end
    end

    describe 'missing methods' do
      let(:resource) { Picture.new(id: 111) }

      it 'calls the missing method from decorator' do
        expect(subject.some_field_names).to eq %w[id imageable name file created_at updated_at]
      end

      it 'raises error when missing' do
        expect { subject.abc }.to raise_error NoMethodError
      end
    end
  end

  context 'with descendants' do
    let(:model_class) { Product }
    let(:application_decorator) { stub_const 'ApplicationDecorator', base_class_from(described_class) }
    let(:klass) { stub_const 'ProductDecorator', Class.new(application_decorator) }
    let(:model_fields) do
      {
        'id' => { 'type' => 'integer', 'label' => 'fake title' },
        'title' => { 'type' => 'string', 'label' => 'fake title' },
        'published_at' => { 'type' => 'datetime', 'label' => 'fake title' },
        'updated_at' => { 'type' => 'datetime', 'label' => 'fake title' }
      }
    end

    before do
      ['', 'index_', 'show_', 'form_'].each do |prefix|
        klass.model_decorator.send :"#{prefix}fields=", model_fields
        klass.model_decorator.instance_variable_set :"@#{prefix}field_names", nil
      end
    end

    describe 'class methods' do
      describe '.model_decorator' do
        it 'returns model class' do
          expect(klass.model_decorator).not_to be_nil
          decorator = klass.model_decorator
          expect(klass.model_decorator).to eq decorator
        end
      end

      describe 'fields' do
        ['', 'index_', 'show_', 'form_'].each do |prefix|
          title = prefix.delete '_'
          describe "for #{title}" do
            describe ".#{prefix}fields" do
              after do
                klass.model_decorator.instance_variable_set :"@#{prefix}fields", nil
              end

              it 'returns fields hash' do
                expect(klass.send(:"#{prefix}fields")).to eq(
                  'title' => { 'type' => 'string', 'label' => 'fake title' },
                  'published_at' => { 'type' => 'datetime', 'label' => 'fake title' },
                  'updated_at' => { 'type' => 'datetime', 'label' => 'fake title' },
                  'id' => { 'type' => 'integer', 'label' => 'fake title' }
                )
              end

              it 'caches the fields hash' do
                expect { klass.send(:"#{prefix}fields").delete 'title' }.to change { klass.send :"#{prefix}fields" }.from(
                  'title' => { 'type' => 'string', 'label' => 'fake title' },
                  'published_at' => { 'type' => 'datetime', 'label' => 'fake title' },
                  'updated_at' => { 'type' => 'datetime', 'label' => 'fake title' },
                  'id' => { 'type' => 'integer', 'label' => 'fake title' }
                ).to(
                  'published_at' => { 'type' => 'datetime', 'label' => 'fake title' },
                  'updated_at' => { 'type' => 'datetime', 'label' => 'fake title' },
                  'id' => { 'type' => 'integer', 'label' => 'fake title' }
                )
              end
            end

            describe ".#{prefix}field_names" do
              after do
                klass.model_decorator.instance_variable_set :"@#{prefix}field_names", nil
              end

              it 'returns field names array' do
                next if prefix == ''

                if prefix == 'form_'
                  expect(klass.send(:"#{prefix}field_names")).to eq(%w[title published_at])
                else
                  expect(klass.send(:"#{prefix}field_names")).to eq(%w[id title published_at updated_at])
                end
              end

              it 'caches the field names array' do
                next if prefix == ''

                if prefix == 'form_'
                  expect { klass.send(:"#{prefix}field_names").delete 'title' }.to change { klass.send :"#{prefix}field_names" }.from(%w[title published_at]).to(['published_at'])
                else
                  expect { klass.send(:"#{prefix}field_names").delete 'title' }.to change { klass.send :"#{prefix}field_names" }.from(%w[id title published_at updated_at]).to(%w[id published_at updated_at])
                end
              end
            end

            describe ".#{prefix}metadata_of" do
              it 'returns metadata' do
                expect(klass.send(:"#{prefix}metadata_of", 'id')).to eq(
                  'type' => 'integer',
                  'label' => 'fake title'
                )
              end
            end

            describe ".#{prefix}label_of" do
              it 'returns label' do
                expect(klass.send(:"#{prefix}label_of", 'id')).to eq 'fake title'
              end
            end

            describe ".#{prefix}type_of" do
              it 'returns type' do
                expect(klass.send(:"#{prefix}type_of", 'id')).to eq 'integer'
              end
            end
          end
        end
      end

      describe 'missing methods' do
        it 'calls the missing method from decorator' do
          expect(klass.some_field_names).to eq %w[id title published_at updated_at]
        end
      end
    end
  end
end
