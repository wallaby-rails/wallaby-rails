module Custom
  module Index
    class IntegerHtml < Wallaby::Cell
      def render
        number_to_human value
      end
    end
  end
end
