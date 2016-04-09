class Wallaby::ActiveRecord::ModelServicer
  def initialize(model_class, model_decorator = nil)
    fail ArgumentError, 'model class required' unless model_class
    @model_class      = model_class
    @model_decorator  = model_decorator || Wallaby::DecoratorFinder.find_model(@model_class)
  end

  def collection(params, ability)
    query = querier.search params
    query = query.order params[:sort] if params[:sort].present?
    query.accessible_by ability
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

  def create(params, ability)
    resource = @model_class.new
    resource.assign_attributes normalize permit(params)
    ensure_attributes_for ability, :create, resource
    resource.save if valid? resource
    [ resource, resource.errors.blank? ]
  rescue ActiveRecord::StatementInvalid => e
    resource.errors.add :base, e.message
    [ resource, false ]
  end

  def update(resource, params, ability)
    resource.assign_attributes normalize permit(params)
    ensure_attributes_for ability, :update, resource
    resource.save if valid? resource
    [ resource, resource.errors.blank? ]
  rescue ActiveRecord::StatementInvalid => e
    resource.errors.add :base, e.message
    [ resource, false ]
  end

  def destroy(resource, params)
    resource.destroy
  end

  protected
  def permit(params)
    params.require(param_key).permit(permitter.simple_field_names << permitter.compound_hashed_fields)
  end

  def normalize(params)
    normalizer.normalize params
  end

  def valid?(resource)
    validator.valid? resource
  end

  def ensure_attributes_for(ability, action, resource)
    return if ability.blank?
    restricted_conditions = ability.attributes_for action, resource
    resource.assign_attributes restricted_conditions
  end

  def param_key
    @model_class.model_name.param_key
  end

  def permitter
    @permitter ||= Wallaby::ActiveRecord::ModelServicer::Permitter.new @model_decorator
  end

  def querier
    @querier ||= Wallaby::ActiveRecord::ModelServicer::Querier.new @model_decorator
  end

  def normalizer
    @normalizer ||= Wallaby::ActiveRecord::ModelServicer::Normalizer.new @model_decorator
  end

  def validator
    @validator ||= Wallaby::ActiveRecord::ModelServicer::Validator.new @model_decorator
  end
end
