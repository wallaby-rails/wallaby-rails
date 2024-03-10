# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Wrapper for the {Wallaby::ActiveRecord::ModelServiceProvider::Querier::Transformer} result.
        # It's only used by {Wallaby::ActiveRecord::ModelServiceProvider::Querier} to tell it apart
        # with non-{Wallaby::ActiveRecord::ModelServiceProvider::Querier::Transformer} result
        class Wrapper
          attr_reader :list

          delegate :push, to: :list
          delegate :each, to: :list
          delegate :last, to: :list
          delegate :[], to: :last

          # @param list [Array]
          def initialize(list = [])
            @list = list
          end
        end
      end
    end
  end
end
