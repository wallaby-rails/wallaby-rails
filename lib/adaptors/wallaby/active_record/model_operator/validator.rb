class Wallaby::ActiveRecord::ModelOperator::Validator
  def initialize(model_decorator)
    @model_decorator = model_decorator
  end

  def valid?(resource)
    resource.attributes.each do |field_name, values|
      next unless metadata = @model_decorator.fields[field_name]
      if %w( daterange tsrange tstzrange ).include?(metadata[:type]) &&
        values.try(:any?, &:blank?)
        resource.errors.add field_name, 'required for range data'
      end
    end
    resource.errors.blank?
  end
end
