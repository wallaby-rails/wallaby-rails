class Wallaby::ActiveRecord::ModelServicer
  def initialize(model_class, model_decorator = nil)
    fail ArgumentError, 'model class required' unless model_class
    @model_class      = model_class
    @model_decorator  = model_decorator || Wallaby::DecoratorFinder.find_model(@model_class)
  end

  def collection(params)
    @model_decorator.collection params
  end

  def new(params)
    permitted = permit(params) rescue {}
    @model_class.new permitted
  end

  def find(id, params)
    @model_class.find id
  rescue ActiveRecord::RecordNotFound
    fail Wallaby::ResourceNotFound
  end

  def create(params)
    resource = @model_class.new
    resource.assign_attributes normalize permit(params)
    resource.save if valid? resource
    [ resource, resource.errors.blank? ]
  rescue ActiveRecord::StatementInvalid => e
    resource.errors.add :base, e.message
    [ resource, false ]
  end

  def update(id, params)
    resource = @model_class.find id
    resource.assign_attributes normalize permit(params)
    resource.save if valid? resource
    [ resource, resource.errors.blank? ]
  rescue ActiveRecord::RecordNotFound
    fail Wallaby::ResourceNotFound
  rescue ActiveRecord::StatementInvalid => e
    resource.errors.add :base, e.message
    [ resource, false ]
  end

  def destroy(id, params)
    @model_class.delete id
  end

  protected
  def permit(params)
    params.require(param_key).permit(simple_field_names << compound_hashed_fields)
  end

  def normalize(params)
    params.each do |field_name, values|
      metadata = @model_decorator.fields[field_name]
      next unless metadata
      type = metadata[:type]

      case type
      when /range/
        if values.is_a?(Array) && values.size == 2
          params[field_name] = values.first...values.last
        end
      when /point/
        params[field_name] = values.map &:to_f
      when /binary/
        if values.is_a?(ActionDispatch::Http::UploadedFile)
          params[field_name] = values.read
        end
      end
    end
  end

  def valid?(resource)
    resource.attributes.each do |field_name, values|
      metadata = @model_decorator.fields[field_name]
      if /(date|ts|tstz)range/ =~ metadata[:type] && values.try(:any?, &:blank?)
        resource.errors.add field_name, 'required for range data'
      end
    end
    resource.errors.blank?
  end

  def param_key
    @model_class.model_name.param_key
  end

  def simple_field_names
    non_range_fields.keys + belongs_to_fields.map do |_, metadata|
      [ metadata[:foreign_key], metadata[:polymorphic_type] ].compact
    end.flatten
  end

  def compound_hashed_fields
    field_names = range_fields.keys +
      point_fields.keys +
      many_association_fields.map{ |_, metadata| metadata[:foreign_key] }
    field_names.map{ |field_name| [ field_name, [] ] }.to_h
  end

  def non_association_fields
    @model_decorator.fields.select{ |_, metadata| !metadata[:is_association] }
  end

  def non_range_fields
    non_association_fields.select{ |_, metadata| !(/range|point/ =~ metadata[:type]) }
  end

  def range_fields
    non_association_fields.select do |_, metadata|
      /range|point/ =~ metadata[:type]
    end
  end

  def point_fields
    non_association_fields.select do |_, metadata|
      /point/ =~ metadata[:type]
    end
  end

  def association_fields
    @model_decorator.fields.select do |_, metadata|
      metadata[:is_association] && !metadata[:has_scope] && !metadata[:is_through]
    end
  end

  def many_association_fields
    association_fields.select{ |_, metadata| /many/ =~ metadata[:type] }
  end

  def belongs_to_fields
    association_fields.select do |field_name, metadata|
      'belongs_to' == metadata[:type]
    end
  end
end
