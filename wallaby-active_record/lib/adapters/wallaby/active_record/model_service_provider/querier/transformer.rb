# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Build up query using the results
        class Transformer < Parslet::Transform
          SIMPLE_OPERATORS = { # :nodoc:
            ':' => :eq,
            ':=' => :eq,
            ':!' => :not_eq,
            ':!=' => :not_eq,
            ':<>' => :not_eq,
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

          SEQUENCE_OPERATORS = { # :nodoc:
            ':' => :in,
            ':=' => :in,
            ':!' => :not_in,
            ':!=' => :not_in,
            ':<>' => :not_in,
            ':()' => :between,
            ':!()' => :not_between
          }.freeze

          SEQUENCE_JOIN_OPERATORS = { # :nodoc:
            ':' => :or,
            ':=' => :or,
            ':!' => :and,
            ':!=' => :and,
            ':<>' => :and
          }.freeze

          BETWEEN_OPERATORS = { # :nodoc:
            ':()' => true,
            ':!()' => true
          }.freeze

          # For single null
          rule null: simple(:value)

          # For single boolean
          rule(boolean: simple(:value)) { /true/i.match? value }

          # For single string
          rule(string: simple(:value)) { value.try :to_str }

          # For multiple strings
          rule(string: sequence(:value)) { EMPTY_STRING }

          # For operators
          rule left: simple(:left), op: simple(:op), right: simple(:right) do
            oped = op.try :to_str
            operator = SIMPLE_OPERATORS[oped]
            next Transformer.warn "Unknown operator #{oped} for %<exp>s", instance_values unless operator

            lefted = left.try :to_str
            convert =
              case oped
              when ':~', ':!~' then "%#{right}%"
              when ':^', ':!^' then "#{right}%"
              when ':$', ':!$' then "%#{right}"
              end
            Wrapper.new [{ left: lefted, op: operator, right: convert || right }]
          end

          # For operators that have multiple items
          rule left: simple(:left), op: simple(:op), right: sequence(:right) do
            oped = op.try :to_str
            operator = SEQUENCE_OPERATORS[oped]
            next Transformer.warn "Unknown operator #{oped} for %<exp>s", instance_values unless operator

            exps = Wrapper.new
            lefted = left.try :to_str
            if BETWEEN_OPERATORS[oped] # BETWEEN related operators
              next Transformer.warn 'Invalid values for %<exp>s', instance_values unless right.first && right.second

              convert = Range.new right.first, right.second
              exps.push left: lefted, op: operator, right: convert
            else
              join = SEQUENCE_JOIN_OPERATORS[oped]
              if right.include? nil
                exps.push left: lefted, op: SIMPLE_OPERATORS[oped], right: right.delete(nil), join: join
              end

              exps.push left: lefted, op: operator, right: right, join: join
            end

            exps
          end

          class << self
            # @param query_string [String]
            # @return [Array]
            def execute(query_string)
              result = new.apply Parser.new.parse(query_string || EMPTY_STRING)
              result.is_a?(Array) ? result : [result]
            end

            # @param message [String]
            # @param exp [Hash,nil] transformed expression
            # @return [nil]
            def warn(message, exp = nil)
              Logger.warn message, exp: to_origin(exp), sourcing: 2
            end

            # @param exp [Hash,nil] transformed expression
            # @return [String] origin expression
            def to_origin(exp)
              "'#{exp['left']}#{exp['op']}#{exp['right']}'"
            end
          end
        end
      end
    end
  end
end
