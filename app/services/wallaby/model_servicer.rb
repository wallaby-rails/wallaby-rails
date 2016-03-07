class Wallaby::ModelServicer
  def self.model_class
    if self < Wallaby::ModelServicer
      class_name = name.gsub('Servicer', '')
      class_name.constantize rescue fail Wallaby::ModelNotFound, class_name
    end
  end

  def initialize(model_class = nil, servicer = nil)
    @model_class  = model_class || self.class.model_class
    @servicer     = servicer || Wallaby.adaptor.model_seriver.new(@model_class)
  end

  def create(params)
    @servicer.create params
  end

  def update(id, params)
    @servicer.update id, params
  end

  def destroy(id)
    @servicer.destroy id
  end
end
