class ActiveRecord::SchemaMigrationDecorator < Wallaby::ResourceDecorator
  def self.find_or_initialize id
    model_class.where(version: id).first_or_initialize
  end

  def to_param
    resource.version
  end
end