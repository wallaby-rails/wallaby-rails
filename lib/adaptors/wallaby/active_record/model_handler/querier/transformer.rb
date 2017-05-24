module Wallaby
  class ActiveRecord
    class ModelHandler
      class Querier
        # Build up query using the results
        class Transformer < Parslet::Transform
          SIMPLE_OPERATORS = {
            ':' => :eq,
            ':=' => :eq,
            ':!' => :not_eq,
            ':!=' => :not_eq,
            ':~' => :matches,
            ':^' => :matches,
            ':$' => :matches,
            ':!~' => :does_not_match,
            ':!^' => :does_not_match,
            ':!$' => :does_not_match,
            ':>' => :gt,
            ':>=' => :gteq,
            ':<' => :lt,
            ':<=' => :lteq
          }.freeze

          SEQUENCE_OPERATORS = {
            ':' => :in,
            ':=' => :in,
            ':!' => :not_in,
            ':!=' => :not_in,
            ':<>' => :not_in,
            ':()' => :between,
            ':!()' => :not_between
          }.freeze

          rule keyword: simple(:value) do
            value
          end

          rule keyword: sequence(:value) do
            value.presence
          end

          rule left: simple(:left), op: simple(:op), right: simple(:right) do
            next unless operator = SIMPLE_OPERATORS[op]
            convert = case op
                      when ':~', ':!~' then "%#{right}%"
                      when ':^', ':!^' then "#{right}%"
                      when ':$', ':!$' then "%#{right}"
                      end
            { left: left, op: operator || :eq, right: convert || right }
          end

          rule left: simple(:left), op: simple(:op), right: sequence(:right) do
            next unless operator = SEQUENCE_OPERATORS[op]
            convert = if %w[:() :!()].include? op
              Range.new right.try(:first), right.try(:last)
            end
            { left: left, op: operator || :in, right: convert || right }
          end
        end
      end
    end
  end
end
