class Wallaby::PrefixesBuilder
  attr_reader :controller

  def initialize controller
    @controller = controller
  end

  def build
    [].tap do |prefixes|
      prefixes_combo prefixes, resources_basepath if resources?
      prefixes_combo prefixes, controller_basepaths
      prefixes << '' # current folder
    end
  end

  protected
  def resources?
    controller.class == Wallaby::ResourcesController \
    && resources_basepath.present?
  end

  def resources_basepath
    controller.send(:resources_name).try do |string|
      string.gsub '::', '/'
    end
  end

  def controller_basepaths
    controller.class.ancestors.select do |klass|
      klass <= ::Wallaby::ApplicationController
    end.map do |klass|
      klass.name.gsub('Controller', '').underscore
    end
  end

  def prefixes_combo prefixes, base_paths
    base_paths = [ base_paths ] unless base_paths.is_a? Array
    base_paths.each do |base_path|
      prefixes << "#{ base_path }/#{ controller.params[:action] }"
      prefixes << base_path
    end
  end
end
