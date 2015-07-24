module Wallaby
  module Services
    class ClassFinder
      def self.find full_class_name
        all.find do |klass|
          klass.name == full_class_name
        end
      end

      def self.all
        ObjectSpace.each_object(Class)
      end
    end
  end
end