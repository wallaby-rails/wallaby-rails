require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder::StiBuilder do
  subject { described_class.new model_class }

  context 'when not sti' do
    let(:model_class) do
      Class.new(ActiveRecord::Base) do
        def self.name; 'Product'; end
        self.table_name = 'products'
      end
    end

    it 'does not change metadata' do
      metadata = {}
      id_column = model_class.columns.find { |c| c.name == 'id' }
      expect { subject.update(metadata, id_column) }.not_to(change { metadata })
    end

    context 'when or not the sti column' do
      let(:model_class) do
        Class.new(ActiveRecord::Base) do
          def self.name; 'Person'; end
          self.table_name = 'people'
        end
      end

      it 'does not change metadata' do
        metadata = {}
        id_column = model_class.columns.find { |c| c.name == 'id' }
        expect { subject.update(metadata, id_column) }.not_to(change { metadata })
      end
    end
  end

  context 'when sti column' do
    let(:model_class) do
      Class.new(ActiveRecord::Base) do
        def self.name; 'Person'; end
        self.table_name = 'people'
      end
    end

    before { allow(model_class).to receive(:descendants).and_return([Staff, HumanResource::Manager]) }

    it 'does not change metadata' do
      metadata = {}
      sti_column = model_class.columns.find { |c| c.name == model_class.inheritance_column }
      subject.update(metadata, sti_column)
      expect(metadata).to eq(type: 'sti', sti_class_list: [HumanResource::Manager, model_class, Staff])
    end

    context 'when sti column is different' do
      let(:model_class) do
        Class.new(ActiveRecord::Base) do
          def self.name; 'Thing'; end
          self.table_name = 'things'
          self.inheritance_column = 'sti_type'
        end
      end

      before { allow(model_class).to receive(:descendants).and_return([Apple]) }

      it 'does not change metadata' do
        metadata = {}
        sti_column = model_class.columns.find { |c| c.name == model_class.inheritance_column }
        subject.update(metadata, sti_column)
        expect(metadata).to eq(type: 'sti', sti_class_list: [Apple, model_class])
      end
    end

    context 'with descendants' do
      let(:model_class) { Staff }

      it 'does not change metadata' do
        Customer.name
        Person.name
        HumanResource::Manager.name
        metadata = {}
        sti_column = model_class.columns.find { |c| c.name == model_class.inheritance_column }
        subject.update(metadata, sti_column)
        expect(metadata).to eq(type: 'sti', sti_class_list: [Customer, HumanResource::Manager, Person, Staff])
      end
    end
  end
end
