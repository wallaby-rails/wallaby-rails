class Wallaby::ActiveRecord::ModelDecorator::TitleFieldFinder
  def initialize(model_class, fields)
    @model_class  = model_class
    @fields       = fields
  end

  def find
    possible_title_fields = @fields.select do |field_name, metadata|
      %w( string ).include? metadata[:type]
    end
    target_field = possible_title_fields.values.find do |metadata|
      %w( name title string text ).any?{ |v| metadata[:name].index v }
    end
    target_field ||= possible_title_fields.values.first
    target_field ||= { name: @model_class.primary_key }
    target_field[:name]
  end
end
