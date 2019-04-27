require 'rails_helper'

describe Wallaby::FieldUtils do
  describe '.first_field_by' do
    let(:fields) do
      {
        'id' => { 'type' => 'integer', 'label' => 'Id' },
        'title' => { 'type' => 'string', 'label' => 'Title' },
        'author_name' => { 'type' => 'string', 'label' => 'Author Name' },
        'page_name' => { 'type' => 'integer', 'label' => 'Page Name' },
        'file' => { 'type' => 'binary', 'label' => 'File' },
        'summary' => { 'type' => 'text', 'label' => 'Summary' },
        'body' => { 'type' => 'text', 'label' => 'Body' },
        'created_at' => { 'type' => 'datetime', 'label' => 'Created at' },
        'updated_at' => { 'type' => 'datetime', 'label' => 'Updated at' },
        'imageable' => { 'type' => 'belongs_to', 'label' => 'Imageable', 'is_association' => true, 'sort_disabled' => true, 'is_polymorphic' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'imageable_id', 'polymorphic_type' => 'imageable_type', 'polymorphic_list' => [Product] }
      }
    end

    it 'returns filter name' do
      expect(described_class.first_field_by(fields)).to be_nil
      expect(described_class.first_field_by({ type: 'string' }, fields)).to eq 'title'
      expect(described_class.first_field_by({ name: /name/ }, fields)).to eq 'author_name'
      expect(described_class.first_field_by({ name: /name/, type: 'integer' }, fields)).to eq 'page_name'
      expect(described_class.first_field_by({ name: /name/ }, { type: 'string' }, fields)).to eq 'author_name'
      expect(described_class.first_field_by({ is_association: true }, fields)).to eq 'imageable'
    end
  end
end
