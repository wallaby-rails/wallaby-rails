require 'rails_helper'
require 'wallaby/active_record'

describe Wallaby::ResourceDecorator do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end

    describe '.model_decorator' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end

    [ '', 'index_', 'show_', 'form_' ].each do |prefix|
      title = prefix.gsub '_', ''
      describe "for #{ title }" do
        describe ".#{ prefix }field_names" do
          it 'returns empty array' do
            expect(described_class.send "#{ prefix }field_names").to be_nil
          end
        end

        describe ".#{ prefix }field_labels" do
          it 'returns empty hash' do
            expect(described_class.send "#{ prefix }field_labels").to be_nil
          end
        end

        describe ".#{ prefix }field_types" do
          it 'returns empty hash' do
            expect(described_class.send "#{ prefix }field_types").to be_nil
          end
        end

        describe ".#{ prefix }label_of" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }label_of", '').to be_nil
          end
        end

        describe ".#{ prefix }type_of" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }type_of", '').to be_nil
          end
        end
      end
    end
  end

  describe 'instance methods' do
    let(:subject) { Wallaby::ResourceDecorator.new resource }
    let(:resource) { AbstractPost.new }

    before do
      class AbstractPost
        def self.columns; end
        def self.primary_key; end
        def self.human_attribute_name field; end
      end
      allow(AbstractPost).to receive(:columns).and_return([
        double('ID', name: 'id', type: :integer),
        double('Title', name: 'title', type: :string),
        double('Published at', name: 'published_at', type: :datetime),
        double('Updated at', name: 'updated_at', type: :datetime)
      ])

      allow(AbstractPost).to receive(:primary_key).and_return('id')

      allow(AbstractPost).to receive(:human_attribute_name)
    end

    describe '#model_class' do
      it 'returns model class' do
        expect(subject.model_class).to eq AbstractPost
      end
    end

    describe '.model_decorator' do
      it 'returns model class' do
        expect(subject.model_decorator).not_to be_nil
        expect(subject.model_decorator.model_class).to eq AbstractPost
      end
    end

    [ '', 'index_', 'show_', 'form_' ].each do |prefix|
      title = prefix.gsub '_', ''
      describe "for #{ title }" do
        describe "##{ prefix }field_names" do
          it 'returns field names array' do
            if prefix == 'form_'
              expect(subject.send "#{ prefix }field_names").to eq(["title", "published_at"])
            else
              expect(subject.send "#{ prefix }field_names").to eq(["id", "title", "published_at", "updated_at"])
            end
          end

          it 'is not allowed to modify the field names array' do
            expect{ subject.send("#{ prefix }field_names").delete 'title' }.to raise_error "can't modify frozen Array"
          end
        end

        describe "##{ prefix }field_labels" do
          it 'returns empty hash' do
            expect(subject.send "#{ prefix }field_labels").to eq({ "id" => nil, "title" => nil, "published_at" => nil, "updated_at" => nil })
          end

          it 'is not allowed to modify the field labels' do
            expect{ subject.send("#{ prefix }field_labels")['title'] = 'Title' }.to raise_error "can't modify frozen Hash"
          end
        end

        describe "##{ prefix }field_types" do
          after do
            subject.model_decorator.instance_variable_set "@#{ prefix }field_types", nil
          end

          it 'returns empty hash' do
            expect(subject.send "#{ prefix }field_types").to eq({ "id" => :integer, "title" => :string, "published_at" => :datetime, "updated_at" => :datetime })
          end

          it 'is not allowed the field types' do
            expect{ subject.send("#{ prefix }field_types")['title'] = :rich_text }.to raise_error "can't modify frozen Hash"
          end
        end

        describe "##{ prefix }label_of" do
          it 'returns nil' do
            expect(subject.send "#{ prefix }label_of", '').to be_nil
          end
        end

        describe "##{ prefix }type_of" do
          it 'returns nil' do
            expect(subject.send "#{ prefix }type_of", '').to be_nil
          end
        end
      end
    end
  end

  context 'subclasses' do
    let(:klass) do
      class AbstractPostDecorator < Wallaby::ResourceDecorator; end
      AbstractPostDecorator
    end

    before do
      class AbstractPost
        def self.columns; end
        def self.primary_key; end
        def self.human_attribute_name field; end
      end
      allow(AbstractPost).to receive(:columns).and_return([
        double('ID', name: 'id', type: :integer),
        double('Title', name: 'title', type: :string),
        double('Published at', name: 'published_at', type: :datetime),
        double('Updated at', name: 'updated_at', type: :datetime)
      ])

      allow(AbstractPost).to receive(:primary_key).and_return('id')

      allow(AbstractPost).to receive(:human_attribute_name)
    end

    describe 'class methods' do
      describe '.model_class' do
        it 'returns model class' do
          expect(klass.model_class).to eq AbstractPost
        end
      end

      describe '.model_decorator' do
        it 'returns model class' do
          expect(klass.model_decorator).not_to be_nil
          expect(klass.model_decorator.model_class).to eq AbstractPost
        end
      end

      [ '', 'index_', 'show_', 'form_' ].each do |prefix|
        title = prefix.gsub '_', ''
        describe "for #{ title }" do
          describe ".#{ prefix }field_names" do
            after do
              klass.model_decorator.instance_variable_set "@#{ prefix }field_names", nil
            end

            it 'returns field names array' do
              if prefix == 'form_'
                expect(klass.send "#{ prefix }field_names").to eq(["title", "published_at"])
              else
                expect(klass.send "#{ prefix }field_names").to eq(["id", "title", "published_at", "updated_at"])
              end
            end

            it 'caches the field names array' do
              if prefix == 'form_'
                expect{ klass.send("#{ prefix }field_names").delete 'title' }.to change{ klass.send "#{ prefix }field_names" }.from(["title", "published_at"]).to(["published_at"])
              else
                expect{ klass.send("#{ prefix }field_names").delete 'title' }.to change{ klass.send "#{ prefix }field_names" }.from(["id", "title", "published_at", "updated_at"]).to(["id", "published_at", "updated_at"])
              end
            end
          end

          describe ".#{ prefix }field_labels" do
            after do
              klass.model_decorator.instance_variable_set "@#{ prefix }field_labels", nil
            end

            it 'returns empty hash' do
              expect(klass.send "#{ prefix }field_labels").to eq({ "id" => nil, "title" => nil, "published_at" => nil, "updated_at" => nil })
            end

            it 'caches the field labels' do
              expect{ klass.send("#{ prefix }field_labels")['title'] = 'Title' }.to change{ klass.send("#{ prefix }field_labels")['title'] }.from(nil).to('Title')
            end
          end

          describe ".#{ prefix }field_types" do
            after do
              klass.model_decorator.instance_variable_set "@#{ prefix }field_types", nil
            end

            it 'returns empty hash' do
              expect(klass.send "#{ prefix }field_types").to eq({ "id" => :integer, "title" => :string, "published_at" => :datetime, "updated_at" => :datetime })
            end

            it 'caches the field types' do
              expect{ klass.send("#{ prefix }field_types")['title'] = :rich_text }.to change{ klass.send("#{ prefix }field_types")['title'] }.from(:string).to(:rich_text)
            end
          end

          describe ".#{ prefix }label_of" do
            it 'returns nil' do
              expect(klass.send "#{ prefix }label_of", '').to be_nil
            end
          end

          describe ".#{ prefix }type_of" do
            it 'returns nil' do
              expect(klass.send "#{ prefix }type_of", '').to be_nil
            end
          end
        end
      end
    end
  end
end